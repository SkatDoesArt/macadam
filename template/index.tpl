{combine_script id='core.switchbox' load='async' require='jquery' path='themes/default/js/switchbox.js'}
{combine_css path="themes/default/vendor/fontello/css/gallery-icon.css" order=-10}

{if isset($errors) or isset($infos)}
  <div class="content messages">
    {include file='infos_errors.tpl'}
  </div>
{/if}
{if !empty($PLUGIN_INDEX_CONTENT_BEFORE)}{$PLUGIN_INDEX_CONTENT_BEFORE}{/if}

<div id="content" class="content">
  <div class="macadam-index-bar">
    <div class="macadam-breadcrumb-zone">
      <a href="{$U_HOME}" class="macadam-home-icon gallery-icon-home">🏠</a>
      <div id="breadcrumb">
        <h2>
          {$TITLE}
          {if $NB_ITEMS > 0}<span class="badge nb_items">{$NB_ITEMS}</span>{/if}
        </h2>
        {$SELECTED_TAGS_TEMPLATE}
      </div>
    </div>

    <div class="macadam-actions-zone">
      <ul>
        {if isset($U_MODE_POSTED)}
          <li><a href="{$U_MODE_POSTED}" title="{'Calendar'|translate}">📅</a></li>
        {elseif isset($U_MODE_CREATED)}
          <li><a href="{$U_MODE_CREATED}" title="{'Calendar'|translate}">📅</a></li>
        {/if}

        <li>
          <a id="toggleLayoutLink" title="Changer la disposition" style="cursor: pointer;">📝</a>
        </li>

        {if !empty($image_orders)}
          <li>
            <a id="sortOrderLink" class="gallery-icon-th-large" title="{'Sort order'|@translate}" rel="nofollow">🔢</a>
            <div id="sortOrderBox" class="switchBox">
              <div class="switchBoxTitle">{'Sort order'|@translate}</div>
              {foreach from=$image_orders item=image_order name=loop}
                {if !$smarty.foreach.loop.first}<br>{/if}

                {if $image_order.SELECTED}
                  <span>&#x2714; </span>{$image_order.DISPLAY}
                  {else}
                  <span style="visibility:hidden">&#x2714; </span><a href="{$image_order.URL}" rel="nofollow">{$image_order.DISPLAY}</a>
                {/if}
              {/foreach}
            </div>
            {footer_script}(window.SwitchBox=window.SwitchBox||[]).push("#sortOrderLink", "#sortOrderBox");{/footer_script}
          </li>
        {/if}

        {if isset($U_EDIT)}
          <li><a href="{$U_EDIT}" class="gallery-icon-cog" title="{'Edit album'|translate}">⚙️</a></li>
        {elseif isset($U_ADMIN)}
          <li><a href="{$U_ADMIN}" class="gallery-icon-cog" title="{'Administration'|translate}">⚙️</a></li>
        {/if}

        {if !empty($PLUGIN_INDEX_BUTTONS)}
          {foreach from=$PLUGIN_INDEX_BUTTONS item=button}
            <li>{$button}</li>
          {/foreach}
        {/if}
      </ul>
    </div>
  </div>

  {if !empty($PLUGIN_INDEX_CONTENT_BEGIN)}{$PLUGIN_INDEX_CONTENT_BEGIN}{/if}

  {if !empty($no_search_results)}
    <p class="search_results">{'No results for'|@translate} :
      <em><strong>
          {foreach $no_search_results as $res}
            {if !$res@first} &mdash; {/if}{$res}
            {/foreach}
            </strong></em>
            </p>
    {/if}

    {if !empty($category_search_results)}
    <p class="search_results">{'Album results for'|@translate} <strong>{$QUERY_SEARCH}</strong> :
      <em><strong>
          {foreach from=$category_search_results item=res name=res_loop}
            {if !$smarty.foreach.res_loop.first} &mdash; {/if}{$res}
            {/foreach}
            </strong></em>
            </p>
      {/if}

      {if !empty($tag_search_results)}
    <p class="search_results">{'Tag results for'|@translate} <strong>{$QUERY_SEARCH}</strong> :
        <em><strong>
          {foreach from=$tag_search_results item=tag name=res_loop}
            {if !$smarty.foreach.res_loop.first} &mdash; {/if} <a href="{$tag.URL}">{$tag.name}</a>
          {/foreach}
        </strong></em>
        </p>
      {/if}

      {if isset($FILE_CHRONOLOGY_VIEW)}
        {include file=$FILE_CHRONOLOGY_VIEW}
      {/if}

      {if !empty($CONTENT_DESCRIPTION)}
        <div class="additional_info">
        {$CONTENT_DESCRIPTION}
        </div>
      {/if}

      {if !empty($CONTENT)}{$CONTENT}{/if}
      {if !empty($CATEGORIES)}{$CATEGORIES}{/if}

      {if !empty($cats_navbar)}
        {include file='navigation_bar.tpl'|@get_extent:'navbar' navbar=$cats_navbar}
      {/if}

      {if !empty($THUMBNAILS)}
        <div class="loader"><img src="{$ROOT_URL}{$themeconf.img_dir}/ajax_loader.gif"></div>
        <ul class="thumbnails" id="thumbnails">
        {$THUMBNAILS}
        </ul>
      {else if !empty($SEARCH_ID)}
        <div class="mcs-no-result">
        <div class="text">
        <span class="top">{'No results are available.'|@translate}</span>
        <span class="bot">{'You can try to edit your filters and perform a new search.'|translate}</span>
        </div>
        </div>
      {/if}

      {if !empty($thumb_navbar)}
        {include file='navigation_bar.tpl'|@get_extent:'navbar' navbar=$thumb_navbar}
      {/if}
      {if !empty($PLUGIN_INDEX_CONTENT_END)}{$PLUGIN_INDEX_CONTENT_END}{/if}
      </div>

      {footer_script}
      document.addEventListener('DOMContentLoaded', function() {
      const container = document.querySelector('.macadam-albums-container');
      const photosContainer = document.getElementById('thumbnails');
      const toggleBtn = document.getElementById('toggleLayoutLink');

      const currentLayout = localStorage.getItem('macadam-preferred-layout');

      if (currentLayout === 'grid') {
      if (container) container.classList.add('view-grid');
      if (photosContainer) photosContainer.classList.add('view-grid-thumbnails');
      }

      if (toggleBtn) {
      toggleBtn.addEventListener('click', function(e) {
      e.preventDefault();

      let isGrid = false;

      if (container) {
      container.classList.toggle('view-grid');
      isGrid = container.classList.contains('view-grid');
      }
      if (photosContainer) {
      photosContainer.classList.toggle('view-grid-thumbnails');
      }

      if (isGrid) {
      localStorage.setItem('macadam-preferred-layout', 'grid');
      } else {
      localStorage.setItem('macadam-preferred-layout', 'list');
      }
      });
      }
      });
      {/footer_script}

      {if !empty($PLUGIN_INDEX_CONTENT_AFTER)}{$PLUGIN_INDEX_CONTENT_AFTER}{/if}