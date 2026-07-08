<?php

/*
Theme Name: macadam
Version: 0.1
Description: My very first theme
Theme URI: http://piwigo.org/ext/extension_view.php?eid=347
Author: SkatDoesCode
Author URI: http://piwigo.org/
*/

$themeconf = array(
  'parent' => 'default',
  'name' => 'macadam',
);

load_language('theme.lang', PHPWG_THEMES_PATH . 'macadam/');
add_event_handler('loc_begin_index', 'macadam_get_header_albums');
add_event_handler('loc_end_picture', 'macadam_get_picture_thumbnails');
add_event_handler('loc_begin_page_header', 'macadam_get_header_albums');
add_event_handler('loc_begin_index', 'macadam_register_smarty_functions');
add_event_handler('loc_begin_page_header', 'macadam_register_smarty_functions');
add_event_handler('loc_end_index_thumbnails', 'macadam_get_thumbnail_details');

add_event_handler('loc_begin_page_header', 'macadam_chronology_month_header_fallback');

add_event_handler('loc_begin_index', 'macadam_toc_section_init');
add_event_handler('loc_end_index', 'macadam_toc_page');

function macadam_chronology_month_header_fallback(){
  global $template, $page;

  // Only when we are on chronology month calendar context (smarty var is used in template/month_calendar.tpl)
  if (!isset($page['chronology']) && empty($page)) {
    return;
  }

  // Try to get month/year from GET (when provided)
  $month = isset($_GET['month']) ? intval($_GET['month']) : 0;
  $year  = isset($_GET['year']) ? intval($_GET['year']) : 0;

  // If not provided, fallback to current server month/year
  if ($month < 1 || $month > 12) {
    $month = intval(date('n'));
  }
  if ($year < 1) {
    $year = intval(date('Y'));
  }

  // Set only if Chronology didn't already provide them
  // (we don't have direct access to $chronology_calendar here, so we assign extra vars used by template fallbacks)
  $smarty = method_exists($template, 'get_smarty') ? $template->get_smarty() : $template->smarty;
  if (!$smarty) return;

  $month_name = date('F', mktime(0,0,0,$month,1,$year));

  $template->assign('macadam_cal_fallback_month_name', $month_name);
  $template->assign('macadam_cal_fallback_year', (string)$year);
}

function macadam_register_smarty_functions() {
  global $template;
  
  static $registered = false;
  if ($registered) return;
  
  $smarty = method_exists($template, 'get_smarty') ? $template->get_smarty() : $template->smarty;
  if (!$smarty) return;

  if (method_exists($smarty, 'registerPlugin')) {
    $smarty->registerPlugin('function', 'macadam_get_extra_images', 'macadam_smarty_get_extra_images');
    $smarty->registerPlugin('function', 'macadam_has_photos', 'macadam_smarty_has_photos');
  } else {
    $smarty->register_function('macadam_get_extra_images', 'macadam_smarty_get_extra_images');
    $smarty->register_function('macadam_has_photos', 'macadam_smarty_has_photos');
  }
  
  $registered = true;
}

function macadam_smarty_has_photos($params, $smarty) {
  global $page;
  $has_photos = !empty($page['items']);
  if (isset($params['assign'])) {
    $smarty->assign($params['assign'], $has_photos);
  }
}

function macadam_smarty_get_extra_images($params, $smarty) {
  global $user;

  $cat_id = isset($params['cat_id']) ? intval($params['cat_id']) : 0;
  $main_img_id = isset($params['main_img_id']) ? intval($params['main_img_id']) : 0;
  
  $extra_images = array();
  
  if ($cat_id > 0) {
    $query = '
SELECT DISTINCT i.id, i.path, i.representative_ext, i.date_available
  FROM '.IMAGE_CATEGORY_TABLE.' ic
    INNER JOIN '.IMAGES_TABLE.' i ON i.id = ic.image_id
    INNER JOIN '.CATEGORIES_TABLE.' c ON c.id = ic.category_id
    INNER JOIN '.USER_CACHE_CATEGORIES_TABLE.' uc ON c.id = uc.cat_id AND uc.user_id = '.$user['id'].'
  WHERE (c.id = '.$cat_id.' 
         OR c.uppercats LIKE "'.$cat_id.',%" 
         OR c.uppercats LIKE "%,'.$cat_id.',%" 
         OR c.uppercats LIKE "%,'.$cat_id.'")
    AND i.id != '.$main_img_id.'
  ORDER BY i.date_available DESC
  LIMIT 2
;';
    $result = pwg_query($query);
    while ($row = pwg_db_fetch_assoc($result)) {
      if (!empty($row['path']) && class_exists('SrcImage')) {
        $extra_images[] = array(
          'src_image' => new SrcImage(array(
            'id' => $row['id'],
            'path' => $row['path'],
            'representative_ext' => $row['representative_ext']
          ))
        );
      }
    }
  }
  
  if (isset($params['assign'])) {
    $smarty->assign($params['assign'], $extra_images);
  }
}

function macadam_get_header_albums() 
{
  global $template, $user, $conf, $pwg_loaded_plugins;

  if (isset($GLOBALS['macadam_albums_loaded']))
    return;
  $GLOBALS['macadam_albums_loaded'] = true;

  // --- ShareAlbum Plugin Verification ---
  $sharealbum_links = array();
  $sharealbum_active = false;

  if (isset($pwg_loaded_plugins['ShareAlbum'])) {
    $sharealbum_active = true;
    
    // Fetch all existing shareable links from ShareAlbum table
    $query_share = "SELECT cat, code FROM " . SHAREALBUM_TABLE;
    $result_share = pwg_query($query_share);
    
    if ($result_share) {
      while ($row_share = pwg_db_fetch_assoc($result_share)) {
        // Generate absolute link using the native plugin helper function
        $sharealbum_links[$row_share['cat']] = sharealbum_get_shareable_url($row_share['code']);
      }
    }
  }

  $template->assign(array(
    'SHAREALBUM_ACTIVE' => $sharealbum_active,
    'SHAREALBUM_LINKS'  => $sharealbum_links,
  ));

  // --- Contact Plugin Verification ---
  $header_contact = null;
  if (isset($pwg_loaded_plugins['ContactForm'])) {
    $header_contact = array(
      'TITLE' => l10n('Contact'),
      'NAME'  => l10n('Contact'),
      'URL'   => get_root_url() . 'index.php?/contact',
    );
  }
  $template->assign('MACADAM_HEADER_CONTACT', $header_contact);

  $display_empty = !empty($conf['display_empty_categories']);
  $empty_condition = $display_empty ? '' : ' AND uc.count_images > 0';

  // Fetch all categories the user has access to, ordered by their rank
  $query = '
SELECT c.id, c.name, c.permalink, c.id_uppercat, c.comment, uc.count_images, uc.count_categories,
       i.id AS img_id, i.path, i.representative_ext
  FROM ' . CATEGORIES_TABLE . ' c
    INNER JOIN ' . USER_CACHE_CATEGORIES_TABLE . ' uc ON c.id = uc.cat_id AND uc.user_id = ' . $user['id'] . '
    LEFT JOIN ' . IMAGES_TABLE . ' i ON i.id = c.representative_picture_id
  WHERE c.visible = \'true\'' . $empty_condition . '
  ORDER BY c.global_rank
;';
  $result = pwg_query($query);

  $albums_by_id = array();
  while ($row = pwg_db_fetch_assoc($result)) {
    $row['URL'] = make_index_url(array('category' => $row));

    $row['NAME'] = $row['name'];
    $row['DESCRIPTION'] = $row['comment'];
    $row['nb_images'] = $row['count_images'];
    $row['id_UP'] = $row['id_uppercat'];
    $row['TN_ALT'] = htmlspecialchars($row['name']);
    $row['representative_picture_id'] = $row['img_id'];
    
    if (!empty($row['path']) && class_exists('SrcImage')) {
      $row['representative'] = array(
        'src_image' => new SrcImage(array(
          'id' => $row['img_id'],
          'path' => $row['path'],
          'representative_ext' => $row['representative_ext']
        ))
      );
    }

    $row['sub_albums'] = array();
    $albums_by_id[$row['id']] = $row;
  }

  // Calculate totals
  $total_albums = count($albums_by_id);
  $total_images = 0;

  // Build a tree structure (root albums + sub-albums)
  $header_albums = array();
  foreach ($albums_by_id as $id => &$cat) {
    if (empty($cat['id_uppercat']) || !isset($albums_by_id[$cat['id_uppercat']])) {
      $header_albums[$id] = &$cat;
      // Sum up the cumulative image counts from root albums
      $total_images += $cat['count_images'];
    } else {
      $albums_by_id[$cat['id_uppercat']]['sub_albums'][] = &$cat;
    }
  }
  unset($cat);

  $template->assign('MACADAM_HEADER_ALBUMS', $header_albums);
  $template->assign('MACADAM_ALL_ALBUMS', $albums_by_id);
  $template->assign('MACADAM_TOTAL_ALBUMS', $total_albums);
  $template->assign('MACADAM_TOTAL_IMAGES', $total_images);

  // --- Fetch Tags ---
  $query_tags = 'SELECT id, name, url_name FROM ' . TAGS_TABLE . ' ORDER BY name ASC;';
  $result_tags = pwg_query($query_tags);
  $header_tags = array();
  while ($row = pwg_db_fetch_assoc($result_tags)) {
    $row['URL'] = make_index_url(array('tags' => array($row)));
    $header_tags[] = $row;
  }
  $template->assign('MACADAM_HEADER_TAGS', $header_tags);

  // --- Fetch Favorites ---
  // Fetch the user's favorite images (limit to 10 for the dropdown)
  $query_favs = '
SELECT i.id, i.name, i.file
  FROM ' . FAVORITES_TABLE . ' uf
    INNER JOIN ' . IMAGES_TABLE . ' i ON i.id = uf.image_id
  WHERE uf.user_id = ' . $user['id'] . '
  ORDER BY i.date_available DESC
  LIMIT 10
;';
  $result_favs = pwg_query($query_favs);
  $header_favorites = array();
  while ($row = pwg_db_fetch_assoc($result_favs)) {
    // Fallback to filename if the image has no specific name
    $name = !empty($row['name']) ? $row['name'] : $row['file'];
    $url = make_picture_url(array('image_id' => $row['id']));
    $header_favorites[] = array('name' => $name, 'URL' => $url);
  }
  $template->assign('MACADAM_HEADER_FAVORITES', $header_favorites);
}

function macadam_get_picture_thumbnails()
{
  global $template, $page;

  // Check if we are currently viewing an image page with an associated category
  if (empty($page['items']) || !isset($page['category']['id'])) {
    return;
  }

  include_once(PHPWG_ROOT_PATH . 'include/functions_picture.inc.php');

  $macadam_thumbs = array();

  // STEP 1: Fetch raw metadata for all images belonging to the current context ($page['items'])
  $query = '
SELECT id, name, file, path
  FROM ' . IMAGES_TABLE . '
  WHERE id IN (' . implode(',', $page['items']) . ')
;';
  $result = pwg_query($query);
  
  $images_data = array();
  while ($row = pwg_db_fetch_assoc($result)) {
    $images_data[$row['id']] = $row;
  }

  // STEP 2: Map and order derivative thumbnail objects matching Piwigo's native sorted stack
  foreach ($page['items'] as $img_id) {
    if (!isset($images_data[$img_id])) continue;

    $img = $images_data[$img_id];
    $url = make_picture_url(array('image_id' => $img['id'], 'category' => $page['category']));
    
    // Safely verify if SrcImage is loaded to prevent premature runtime script termination
    if (class_exists('SrcImage')) {
      $src_image = new SrcImage($img);
      $derivative = new DerivativeImage(IMG_SQUARE, $src_image);
      $src_url = $derivative->get_url();
    } else {
      // Fallback baseline image reference path mapping
      $src_url = preg_replace('#^./#', '', $img['path']); 
    }

    $macadam_thumbs[] = array(
      'id' => $img['id'],
      'TITLE' => !empty($img['name']) ? $img['name'] : $img['file'],
      'URL' => $url,
      'SRC' => $src_url,
    );
  }

  $template->assign('MACADAM_THUMBS', $macadam_thumbs);
}

function macadam_get_thumbnail_details($tpl_thumbnails) {
  if (!is_array($tpl_thumbnails) || empty($tpl_thumbnails)) return $tpl_thumbnails;

  $image_ids = array();
  foreach ($tpl_thumbnails as $thumb) {
    if (isset($thumb['id'])) {
      $image_ids[] = $thumb['id'];
    }
  }

  if (empty($image_ids)) return $tpl_thumbnails;

  $query = '
SELECT id, file, filesize
  FROM '.IMAGES_TABLE.'
  WHERE id IN ('.implode(',', $image_ids).')
;';
  $result = pwg_query($query);
  $details = array();
  while ($row = pwg_db_fetch_assoc($result)) {
    $details[$row['id']] = $row;
  }

  foreach ($tpl_thumbnails as &$thumb) {
    if (isset($thumb['id']) && isset($details[$thumb['id']])) {
      $file = $details[$thumb['id']]['file'];
      $thumb['FILE_EXT'] = pathinfo($file, PATHINFO_EXTENSION);
      
      $filesize = $details[$thumb['id']]['filesize'];
      if (is_numeric($filesize) && $filesize > 0) {
        // Piwigo stocke la taille en KB. On convertit en MB si c'est plus grand que 1024 KB.
        $thumb['FILESIZE'] = ($filesize > 1024) ? round($filesize / 1024, 1) . ' MB' : $filesize . ' KB';
      }
    }
  }
  unset($thumb);

  return $tpl_thumbnails;
}

function macadam_toc_section_init()
{
  global $tokens, $page;
  if (isset($tokens[0]) && $tokens[0] == 'table_of_content')
  {
    $page['section'] = 'table_of_content';
    $page['title'] = 'Table of content';
    $page['body_id'] = 'theTableOfContentPage';
    $page['is_external'] = true; 
    $page['is_homepage'] = false;
  }
}

function macadam_toc_page()
{
  global $template, $page;

  if (isset($page['section']) && $page['section'] == 'table_of_content')
  {
    if (!isset($template->get_template_vars()['MACADAM_HEADER_ALBUMS'])) {
      macadam_get_header_albums();
    }
    
    $template->assign(array(
      'CATEGORIES' => array(),
      'THUMBNAILS' => array(),
    ));

    $template->set_filename('tableofcontent', 'table_of_content.tpl');
    $template->assign_var_from_handle('CONTENT', 'tableofcontent');
  }
}
?>