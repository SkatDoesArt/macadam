{combine_script id='core.switchbox' load='async' require='jquery' path='themes/default/js/switchbox.js'}

{if isset($errors) or not empty($infos)}
  {include file='infos_errors.tpl'}
{/if}

{if !empty($PLUGIN_PICTURE_BEFORE)}{$PLUGIN_PICTURE_BEFORE}{/if}

<div class="macadam-picture-viewer">

  <div class="macadam-index-bar">
    <div class="macadam-breadcrumb-zone">
      <span class="macadam-home-badge">
        <a href="{$ROOT_URL}" class="sidebar-icon-link">🏠</a>
      </span>
      <div id="breadcrumb">
        <h2>{$SECTION_TITLE}<span class="browsePathSeparator"> {$LEVEL_SEPARATOR} </span>{$current.TITLE}</h2>
      </div>
    </div>

    <div class="macadam-actions-zone">
      <span class="macadam-action-emoji" title="Options">⚙️</span>
    </div>
  </div>

  <div class="macadam-main-photo-stage">
    
    {if isset($previous)}
      <a class="macadam-nav-arrow arrow-left" href="{$previous.U_IMG}" title="{'Previous'|@translate}">
        <span>‹</span>
      </a>
    {else}
      <div class="macadam-nav-arrow arrow-left disabled"><span>‹</span></div>
    {/if}

    <div class="macadam-photo-display">
      {$ELEMENT_CONTENT}
      
      {if isset($COMMENT_IMG)}
        <p class="imageComment">{$COMMENT_IMG}</p>
      {/if}
    </div>

    {if isset($next)}
      <a class="macadam-nav-arrow arrow-right" href="{$next.U_IMG}" title="{'Next'|@translate}">
        <span>›</span>
      </a>
    {else}
      <div class="macadam-nav-arrow arrow-right disabled"><span>›</span></div>
    {/if}

  </div>

  {if $DISPLAY_NAV_THUMB}
    <div class="macadam-carousel-strip">
      
      {if isset($previous)}
        <a class="strip-thumb-item" href="{$previous.U_IMG}">
          <img src="{$previous.derivatives.square->get_url()}" alt="{$previous.TITLE_ESC}">
        </a>
      {else}
        <div class="strip-thumb-placeholder"></div>
      {/if}

      <div class="strip-thumb-item active">
        <img src="{$current.selected_derivative->get_url()}" alt="{$current.TITLE}">
      </div>

      {if isset($next)}
        <a class="strip-thumb-item" href="{$next.U_IMG}">
          <img src="{$next.derivatives.square->get_url()}" alt="{$next.TITLE_ESC}">
        </a>
      {else}
        <div class="strip-thumb-placeholder"></div>
      {/if}

    </div>
  {/if}

</div>

{if !empty($PLUGIN_PICTURE_AFTER)}{$PLUGIN_PICTURE_AFTER}{/if}