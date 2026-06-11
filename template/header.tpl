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

<link rel="start" title="{'Home'|translate}" href="{$U_HOME}" >
<link rel="search" title="{'Search'|translate}" href="{$ROOT_URL}search.php" >

{if isset($U_PREFETCH)    }<link rel="prefetch" href="{$U_PREFETCH}">{/if}
{if isset($U_CANONICAL)   }<link rel="canonical" href="{$U_CANONICAL}">{/if}

{if not empty($page_refresh)}<meta http-equiv="refresh" content="{$page_refresh.TIME};url={$page_refresh.U_REFRESH}">{/if}

{strip}
{foreach from=$themes item=theme}
  {if $theme.load_css}
    {* For the parent theme (e.g. 'default'), load its standard 'theme.css' file. *}
    {if $theme.id != 'macadam'}
      {combine_css path="themes/`$theme.id`/theme.css" order=-10}
    {* For our specific 'macadam' theme, load its CSS from the correct subfolder. *}
    {else}
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

<body id="{$BODY_ID}" class="{foreach from=$BODY_CLASSES item=class}{$class} {/foreach}"  data-infos='{$BODY_DATA}'>

<nav class="macadam-sidebar-nav">
  <div class="sidebar-menu-links">
    <a href="{$U_HOME}" class="sidebar-icon-link" title="{'Home'|translate}">🏠</a>
    <a href="{$ROOT_URL}search.php" class="sidebar-icon-link" title="{'Search'|translate}">🔍</a>
    <a href="{$U_HOME}" class="sidebar-icon-link" title="{'Albums'|translate}">📂</a>
    <a href="{$U_MODE_CREATED|default:"`$ROOT_URL`index.php?/created-monthly"}" class="sidebar-icon-link" title="{'Discovery'|translate}">🧭</a>
    <a href="{$U_TAGS|default:"`$ROOT_URL`tags.php"}" class="sidebar-icon-link" title="{'Tags'|translate}">🏷️</a>
    <a href="{$U_FAVORITES|default:"`$ROOT_URL`index.php?/favorites"}" class="sidebar-icon-link" title="{'Favorites'|translate}">⭐</a>
    {if isset($U_COMMENTS)}
    <a href="{$U_COMMENTS}" class="sidebar-icon-link" title="{'Comments'|translate}">💬</a>
    {/if}
    {if isset($U_FEED)}
    <a href="{$U_FEED}" class="sidebar-icon-link" title="{'Notification Feed'|translate}">🔔</a>
    {/if}
    {if isset($U_LOGIN_REGISTER)}
    <a href="{$U_LOGIN_REGISTER}" class="sidebar-icon-link" title="{'Login'|translate}">👤</a>
    {else if isset($U_PROFILE)}
    <a href="{$U_PROFILE}" class="sidebar-icon-link" title="{'Profile'|translate}">👤</a>
    {/if}
    {* {if isset($U_ADMIN)}
    <a href="{$U_ADMIN}" class="sidebar-icon-link" title="{'Administration'|translate}">⚙️</a>
    {/if} *}
  </div>
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
        <span class="search-icon">🔍</span>
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