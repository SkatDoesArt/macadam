{strip}{html_style}
  .thumbnailCategory .illustration {ldelim}
    width: {$derivative_params->max_width()+5}px;
  }
  .content .thumbnailCategory .description {ldelim}
    height: {$derivative_params->max_height()+5}px;
  }
{/html_style}{/strip}

{footer_script}
  var error_icon = "{$ROOT_URL}{$themeconf.icon_dir}/errors_small.png", max_requests = {$maxRequests};
{/footer_script}

<div class="loader"><img src="{$ROOT_URL}{$themeconf.img_dir}/ajax_loader.gif"></div>

<div class="macadam-albums-container macadam-main-grid-active">
  {foreach from=$category_thumbnails item=cat name=cat_loop}

    {assign var=derivative value=$pwg->derivative($derivative_params, $cat.representative.src_image)}

    {if !$derivative->is_cached()}
      {combine_script id='jquery.ajaxmanager' path='themes/default/js/plugins/jquery.ajaxmanager.js' load='footer'}
      {combine_script id='thumbnails.loader' path='themes/default/js/thumbnails.loader.js' require='jquery.ajaxmanager' load='footer'}
    {/if}


    <div class="macadam-album-card" data-id="{$cat.id}" data-parent="{$cat.id_UP|default:0}">

      <a href="{$cat.URL}" class="macadam-album-thumbs">
        <div class="main-thumb-container">
          {if isset($derivative)}
            <img {if $derivative->is_cached()}src="{$derivative->get_url()}" {else}src="{$ROOT_URL}{$themeconf.icon_dir}/img_small.png" data-src="{$derivative->get_url()}" {/if} alt="{$cat.TN_ALT}" title="{$cat.NAME|@replace:'"':' '|@strip_tags:false} - {'display this album'|@translate}" class="main-thumb">
          {else}
            <div class="no-thumb-placeholder"></div>
          {/if}
        </div>

        <div class="sub-thumbs-container">
          <div class="thumb-sub-block sub-orange"></div>
          <div class="thumb-sub-block sub-beige"></div>
        </div>
      </a>

      <div class="macadam-album-infos">
        <div class="macadam-album-header">
          <div>
            <h3 class="album-title">
              <a href="{$cat.URL}">{$cat.NAME}</a>
            </h3>
            <span class="album-meta">
              {$cat.CAPTION_NB_IMAGES}
            </span>
          </div>

          <div class="album-actions-trigger">
            <span class="gallery-icon-ellipsis-vert">⋮</span>
          </div>
        </div>

        <div class="album-description-zone">
          {if !empty($cat.DESCRIPTION)}
            <p class="album-description">{$cat.DESCRIPTION}</p>
          {else}
            <p class="album-description empty-desc">Aucune description disponible pour cet album.</p>
          {/if}
        </div>

        {if isset($cat.count_categories) and $cat.count_categories > 0}
          <div class="album-footer-icon">
            <a href="{$cat.URL}" title="Contient des sous-albums" class="album-sitemap-link">
              <span class="gallery-icon-sitemap">🖇️</span>
            </a>
          </div>
        {/if}
      </div>

    </div>
  {/foreach}
</div>