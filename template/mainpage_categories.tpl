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

{function name=render_album_cards albums=$category_thumbnails depth=0 pwg=$pwg derivative_params=$derivative_params}
  {foreach from=$albums item=cat name=cat_loop}
    <div class="album-wrapper{if $depth > 0} is-sub-album{/if}">

      {assign var=derivative value=null}
      {if isset($cat.representative) && !empty($cat.representative.src_image)}
        {assign var=derivative value=$pwg->derivative($derivative_params, $cat.representative.src_image)}
      {/if}

      {if isset($derivative) && !$derivative->is_cached()}
        {combine_script id='jquery.ajaxmanager' path='themes/default/js/plugins/jquery.ajaxmanager.js' load='footer'}
        {combine_script id='thumbnails.loader' path='themes/default/js/thumbnails.loader.js' require='jquery.ajaxmanager' load='footer'}
      {/if}

      <div class="macadam-album-card" data-id="{$cat.id}" data-parent="{$cat.id_UP|default:0}" {if $depth > 0}style="margin-left: {$depth * 55}px; width: calc(100% - {$depth * 55}px); background: #F6F7FF;"{/if}>

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
              {$cat.nb_images|default:0} {if $cat.nb_images|default:0 > 1}{'photos'|translate}{else}{'photo'|translate}{/if}
                {if isset($cat.count_categories) and $cat.count_categories > 0}
                , {$cat.count_categories} {if $cat.count_categories > 1}{'albums'|translate}{else}{'album'|translate}{/if}
                {/if}
              </span>
            </div>

            <div class="album-actions-trigger">
              <i class="icon-three-dot"></i>
            </div>
          </div>

          <div class="album-description-zone">
            {if !empty($cat.DESCRIPTION)}
              <p class="album-description">{$cat.DESCRIPTION}</p>
            {else}
              <p class="album-description empty-desc">{'No description available for this album.'|translate}</p>
            {/if}
          </div>

          {if isset($cat.count_categories) and $cat.count_categories > 0}
            <div class="album-footer-icon">
              <a href="{$cat.URL}" title="{'Toggle sub-albums'|translate}" class="album-sub-toggle">
                <i class="icon-structure"></i>
              </a>
            </div>
          {/if}
        </div>
      </div>
      {if isset($cat.count_categories) and $cat.count_categories > 0}
        <div class="sub-albums-container">
          {if isset($MACADAM_ALL_ALBUMS[$cat.id].sub_albums) && !empty($MACADAM_ALL_ALBUMS[$cat.id].sub_albums)}
            {call name=render_album_cards albums=$MACADAM_ALL_ALBUMS[$cat.id].sub_albums depth=$depth+1 pwg=$pwg derivative_params=$derivative_params}
          {/if}
        </div>
      {/if}
    </div>
  {/foreach}
{/function}

<div class="macadam-albums-container macadam-main-grid-active">
  {call name=render_album_cards albums=$category_thumbnails depth=0 pwg=$pwg derivative_params=$derivative_params}
</div>

{footer_script}
jQuery(document).ready(function($) {
  $(document).on('click', '.album-sub-toggle', function(e) {
    e.preventDefault();
    e.stopPropagation();

    var $wrapper = $(this).closest('.album-wrapper');
    var $subContainer = $wrapper.children('.sub-albums-container');

    $(this).toggleClass('open');
    $subContainer.slideToggle(250);
  });
});
{/footer_script}