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

add_event_handler('loc_end_page_header', 'macadam_get_header_albums');

function macadam_get_header_albums() {
  global $template, $user;
  
  // Fetch all categories the user has access to, ordered by their rank
  $query = '
SELECT id, name, permalink, id_uppercat, count_images, count_categories
  FROM '.CATEGORIES_TABLE.'
    INNER JOIN '.USER_CACHE_CATEGORIES_TABLE.' ON id = cat_id AND user_id = '.$user['id'].'
  ORDER BY global_rank
;';
  $result = pwg_query($query);
  
  $albums_by_id = array();
  while ($row = pwg_db_fetch_assoc($result)) {
    $row['URL'] = make_index_url(array('category' => $row));
    $row['sub_albums'] = array();
    $albums_by_id[$row['id']] = $row;
  }
  
  // Calculate totals
  $total_albums = count($albums_by_id);
  $total_images = 0;
  
  // Build a tree structure (root albums + sub-albums)
  $header_albums = array();
  foreach ($albums_by_id as $id => &$cat) {
    if (empty($cat['id_uppercat'])) {
      $header_albums[$id] = &$cat;
      // Sum up the cumulative image counts from root albums
      $total_images += $cat['count_images'];
    } else {
      if (isset($albums_by_id[$cat['id_uppercat']])) {
        $albums_by_id[$cat['id_uppercat']]['sub_albums'][] = &$cat;
      }
    }
  }
  unset($cat);
  
  $template->assign('MACADAM_HEADER_ALBUMS', $header_albums);
  $template->assign('MACADAM_TOTAL_ALBUMS', $total_albums);
  $template->assign('MACADAM_TOTAL_IMAGES', $total_images);

  // --- Fetch Tags ---
  $query_tags = 'SELECT id, name, url_name FROM '.TAGS_TABLE.' ORDER BY name ASC;';
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
  FROM '.FAVORITES_TABLE.' uf
    INNER JOIN '.IMAGES_TABLE.' i ON i.id = uf.image_id
  WHERE uf.user_id = '.$user['id'].'
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

?>