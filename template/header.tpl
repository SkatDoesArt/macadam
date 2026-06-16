<!DOCTYPE html>
<html lang="{$lang_info.code}" dir="{$lang_info.direction}">

<head>
  {if $SHOW_MOBILE_APP_BANNER}
    <meta name="apple-itunes-app" content="app-id=472225196">
  {/if}
  <meta charset="{$CONTENT_ENCODING}">
  <meta name="generator" content="Piwigo (aka PWG), see piwigo.org">

  {if isset($meta_ref)}
    {if isset($INFO_AUTHOR)}
      <meta name="author" content="{$INFO_AUTHOR|strip_tags:false|replace:'"':' '}">
  {/if}
  {if isset($related_tags)}
  <meta name="keywords" content="{foreach from=$related_tags item=tag name=tag_loop}{if !$smarty.foreach.tag_loop.first}, {/if}{$tag.name}{/foreach}">
  {/if}
  {if isset($COMMENT_IMG)}
  <meta name="description" content="{$COMMENT_IMG|strip_tags:false|replace:'"':' '}{if isset($INFO_FILE)} - {$INFO_FILE}{/if}">
    {else}
      <meta name="description" content="{$PAGE_TITLE}{if isset($INFO_FILE)} - {$INFO_FILE}{/if}">
    {/if}
  {/if}

  <title>{if $PAGE_TITLE!=l10n('Home') && $PAGE_TITLE!=$GALLERY_TITLE}{$PAGE_TITLE} | {/if}{$GALLERY_TITLE}</title>
  <link rel="shortcut icon" type="image/x-icon" href="{$ROOT_URL}{$themeconf.icon_dir}/favicon.ico">

  <link rel="start" title="{'Home'|translate}" href="{$U_HOME}">
  <link rel="search" title="{'Search'|translate}" href="{$ROOT_URL}search.php">

  {if isset($U_PREFETCH)    }
  <link rel="prefetch" href="{$U_PREFETCH}">{/if}
  {if isset($U_CANONICAL)   }
  <link rel="canonical" href="{$U_CANONICAL}">{/if}

  {if not empty($page_refresh)}
  <meta http-equiv="refresh" content="{$page_refresh.TIME};url={$page_refresh.U_REFRESH}">{/if}

  {strip}
    {foreach from=$themes item=theme}
      {if $theme.load_css}
        {* For the parent theme (e.g. 'default'), load its standard 'theme.css' file. *}
        {if $theme.id != 'macadam'}
          {combine_css path="themes/`$theme.id`/theme.css" order=-10}
          {* For our specific 'macadam' theme, load its CSS from the correct subfolder. *}
        {else}
          {* Import Fontello CSS *}
          {combine_css path="themes/macadam/css/fontello/css/fontello.css" order=-11}
          {combine_css path="themes/macadam/css/macadam.css" order=-10}
        {/if}
      {/if}
      {if !empty($theme.local_head)}
        {include file=$theme.local_head load_css=$theme.load_css}
      {/if}
    {/foreach}

    {combine_css path="themes/macadam/css/header.css" order=-9}

    {combine_script id="jquery" load="footer"}
  {/strip}

  {get_combined_css}

  {get_combined_scripts load='header'}
  {if not empty($head_elements)}
    {foreach from=$head_elements item=elt}
      {$elt}
    {/foreach}
  {/if}
</head>

<body id="{$BODY_ID}" class="{foreach from=$BODY_CLASSES item=class}{$class} {/foreach}" data-infos='{$BODY_DATA}'>

  <nav class="macadam-sidebar-nav">
    <div class="sidebar-menu-links">
      <a href="{$U_HOME}" class="sidebar-icon-link" title="{'Home'|translate}"><i class="icon-home"></i></a>
      <a href="{$ROOT_URL}search.php" class="sidebar-icon-link" title="{'Search'|translate}"><i class="icon-lens"></i></a>

      {* Dropdown container for Albums *}
      <div class="sidebar-dropdown-container">
        <a href="#" onclick="return false;" class="sidebar-icon-link sidebar-icon-link-drop" title="{'Albums'|translate}"><i class="icon-structure"></i></a>

        <div class="sidebar-dropdown-menu">
          <div class="dropdown-menu-title">{'Albums'|translate}</div>
          <ul class="album-dropdown-list">
            {if isset($MACADAM_HEADER_ALBUMS) && !empty($MACADAM_HEADER_ALBUMS)}
              {* Define a recursive function to handle infinite album depth *}
              {function name=render_album_list depth=0}
                {foreach from=$albums item=album}
                  <li{if !empty($album.sub_albums)} class="has-sub-albums" {/if}>
                    <div class="album-item-row" style="padding-left: {$depth * 30 + 20}px;">
                      {if !empty($album.sub_albums)}
                        <span class="album-toggle"><i class="icon-arrow-right"></i></span>
                      {else}
                        <span class="album-toggle-disabled"><i class="icon-arrow-right"></i></span>
                      {/if}
                      <a href="{$album.URL}" title="{$album.name|escape}">{$album.name}</a>
                      <div class="album-counts">
                        {if $album.count_categories > 0}
                          <span class="album-count" title="{'Albums'|translate}">{$album.count_categories}<i class="icon-folder"></i></span>
                        {/if}
                        {if $album.count_images > 0}
                          <span class="album-count" title="{'Images'|translate}">{$album.count_images}<i class="icon-picture"></i></span>
                        {/if}
                      </div>
                    </div>
                    {if !empty($album.sub_albums)}
                      <ul class="sub-album-list">
                        {call name=render_album_list albums=$album.sub_albums depth=$depth+1}
                      </ul>
                    {/if}
                    </li>
                  {/foreach}
                {/function}

                {* Call the function with the root albums *}
                {call name=render_album_list albums=$MACADAM_HEADER_ALBUMS depth=0}
              {else}
                <li>
                  <div class="album-item-row"><a href="#">{'No albums'|translate}</a></div>
                </li>
              {/if}
          </ul>

          {if isset($MACADAM_TOTAL_ALBUMS) && $MACADAM_TOTAL_ALBUMS > 0}
            <div class="dropdown-menu-footer">
              <div class="album-item-row" style="gap: 35px;">
                <span class="" title="{'Total albums'|translate}">{$MACADAM_TOTAL_ALBUMS} <i class="icon-folder"></i></span>
                <span class="" title="{'Total images'|translate}">{$MACADAM_TOTAL_IMAGES} <i class="icon-picture"></i></span>
              </div>
            </div>
          {/if}
        </div>
      </div>

      <a href="{$U_MODE_CREATED|default:"`$ROOT_URL`index.php?/created-monthly"}" class="sidebar-icon-link" title="{'Discovery'|translate}"><i class="icon-add"></i></a>

      {* Dropdown container for Tags *}
      <div class="sidebar-dropdown-container">
        <a href="{$U_TAGS|default:"`$ROOT_URL`tags.php"}" class="sidebar-icon-link sidebar-icon-link-drop" title="{'Tags'|translate}"><i class="icon-tags"></i></a>
        <div class="sidebar-dropdown-menu">
          <div class="dropdown-menu-title">{'Tags'|translate}</div>
          <ul class="album-dropdown-list">
            {if isset($MACADAM_HEADER_TAGS) && !empty($MACADAM_HEADER_TAGS)}
              {foreach from=$MACADAM_HEADER_TAGS item=tag}
                <li>
                  <div class="tag-item-row"><a href="{$tag.URL}">{$tag.name}</a></div>
                </li>
              {/foreach}
            {else}
              <li>
                <div class="tag-item-row"><a href="#">{'No tags'|translate}</a></div>
              </li>
            {/if}
          </ul>
        </div>
      </div>

      {* Dropdown container for Collections / Favorites *}
      <div class="sidebar-dropdown-container">
        {if isset($user_collections)}
          <a href="{$U_USER_COLLECTIONS|default:"#"}" class="sidebar-icon-link-drop sidebar-icon-link" title="{'Collections'|translate}"><i class="icon-star"></i></a>
          <div class="sidebar-dropdown-menu">
            <div class="dropdown-menu-title">{'Collections'|translate}</div>
            <ul class="album-dropdown-list">
              {if !empty($user_collections)}
                {foreach from=$user_collections item=collection}
                  <li>
                    <div class="tag-item-row"><a href="{$collection.url}">{$collection.name}</a></div>
                  </li>
                {/foreach}
              {else}
                <li>
                  <div class="tag-item-row"><a href="#">{'No collections'|translate}</a></div>
                </li>
              {/if}
            </ul>
          </div>
        {else}
          <a href="{$U_FAVORITES|default:"`$ROOT_URL`index.php?/favorites"}" class="sidebar-icon-link-drop sidebar-icon-link" title="{'Favorites'|translate}"><i class="icon-star"></i></a>
          <div class="sidebar-dropdown-menu">
            <div class="dropdown-menu-title">{'Favorites'|translate}</div>
            <ul class="album-dropdown-list">
              {if isset($MACADAM_HEADER_FAVORITES) && !empty($MACADAM_HEADER_FAVORITES)}
                {foreach from=$MACADAM_HEADER_FAVORITES item=fav}
                  <li>
                    <div class="tag-item-row"><a href="{$fav.URL}">{$fav.name}</a></div>
                  </li>
                {/foreach}
              {else}
                <li>
                  <div class="tag-item-row"><a href="#">{'No favorites'|translate}</a></div>
                </li>
              {/if}
            </ul>
          </div>
        {/if}
      </div>

      {if isset($U_LOGIN_REGISTER)}
        <a href="{$U_LOGIN_REGISTER}" class="sidebar-icon-link" title="{'Login'|translate}"><i class="icon-person"></i></a>
      {else if isset($U_PROFILE)}
        <div class="sidebar-dropdown-container">
          <a href="{$U_PROFILE}" class="sidebar-icon-link" title="{'Profile'|translate}"><i class="icon-person"></i></a>
          <div class="sidebar-dropdown-menu">
            <div class="dropdown-menu-title">{'Account'|translate}</div>
            <ul class="album-dropdown-list">
              {if isset($U_ADMIN)}
              <li>
                <div class="tag-item-row"><a href="{$U_ADMIN}">{'Administration'|translate}</a></div>
              </li>
              {/if}
              <li>
                <div class="tag-item-row"><a href="{$U_PROFILE}">{'Customize'|translate}</a></div>
              </li>
              <li>
                <div class="tag-item-row"><a href="{$ROOT_URL}profile.php">{'Notifications'|translate}</a></div>
              </li>
              <li>
                <div class="tag-item-row"><a href="{$ROOT_URL}admin.php?page=photos_add">{'Add photos'|translate}</a></div>
              </li>
              <li>
                <div class="tag-item-row"><a href="{$ROOT_URL}admin.php?page=batch_manager">{'Edit photos'|translate}</a></div>
              </li>
            </ul>
            {if isset($U_LOGOUT)}
            <div class="dropdown-menu-footer" style="justify-content: start; padding-top: 20px;">
              <div class="tag-item-row" style="padding-bottom: 10px;">
                <a href="{$U_LOGOUT}">{'Logout'|translate}</a>
              </div>
            </div>
            {/if}
          </div>
        </div>
      {/if}
      {* {if isset($U_ADMIN)}
    <a href="{$U_ADMIN}" class="sidebar-icon-link" title="{'Administration'|translate}">⚙️</a>
    {/if} *}
    </div>

    {* Script to handle sub-albums toggle on click *}
    <script>
      document.addEventListener('DOMContentLoaded', function() { 
        /* Align dropdown menu top with the vertical position of the button */
        document.querySelectorAll('.sidebar-dropdown-container').forEach(function(container) {
          var menu = container.querySelector('.sidebar-dropdown-menu');
          if (menu) {
            container.addEventListener('mouseenter', function() {
              var rect = container.getBoundingClientRect();
              menu.style.top = rect.top - 10 + 'px';
            });
          }
        });
      });
    </script>
    {footer_script}
      jQuery(document).ready(function($) {
        $('.sidebar-dropdown-menu').on('click', '.album-toggle', function(e) {
          e.preventDefault();
          e.stopPropagation();
          $(this).toggleClass('open');
          $(this).closest('li').children('.sub-album-list').slideToggle(250);
        });
      });
    {/footer_script}
  </nav>

  <div id="the_page" class="macadam-main-container">

    {* {if not empty($header_msgs)}
    <div class="header_msgs">


      {foreach from=$header_msgs item=elt}
          {$elt}<br>


      {/foreach}
    </div>


    {/if} *}

    <div id="theHeader" class="macadam-header-banner">
      <div class="macadam-header-content">

        <h1 class="macadam-gallery-title">DEMO GALLERY</h1>

        <div class="macadam-header-search">
          <form action="{$ROOT_URL}search.php" method="get">
            <i class="search-icon icon-lens"></i>
            <input type="text" name="q" placeholder="Search" autocomplete="off">
          </form>
        </div>

      </div>
    </div>

    {if not empty($header_notes)}
      <div class="header_notes">
        {foreach from=$header_notes item=elt}
          <p>{$elt}</p>
        {/foreach}
      </div>
{/if}