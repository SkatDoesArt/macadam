{if !empty($thumbnails)}
  {strip}
    {html_style}
    /* On conserve la compatibilité des tailles calculées si nécessaire */
    .thumbnails SPAN,
    .thumbnails .wrap2 A,
    .thumbnails LABEL {ldelim}
    width: {$derivative_params->max_width()+2}px;
    }
    .thumbnails .wrap2 {ldelim}
    height: {$derivative_params->max_height()+3}px;
    }
    {/html_style}

    {footer_script}
    var error_icon = "{$ROOT_URL}{$themeconf.icon_dir}/errors_small.png", max_requests = {$maxRequests};
    {/footer_script}

    {if !empty($category_thumbnails)}
      <p class="macadam-photos-grid-title">{'Photos'|@translate}</p>
    {/if}
    <div class="macadam-photos-grid">
      {foreach from=$thumbnails item=thumbnail}
        {assign var=derivative value=$pwg->derivative($derivative_params, $thumbnail.src_image)}
        {if !$derivative->is_cached()}
          {combine_script id='jquery.ajaxmanager' path='themes/default/js/plugins/jquery.ajaxmanager.js' load='footer'}
          {combine_script id='thumbnails.loader' path='themes/default/js/thumbnails.loader.js' require='jquery.ajaxmanager' load='footer'}
        {/if}

        <a href="{$thumbnail.URL}" class="macadam-photo-card">

          <div class="macadam-photo-link">
            <img class="photo-thumb-img" {if $derivative->is_cached()}src="{$derivative->get_url()}" {else}src="{$ROOT_URL}{$themeconf.icon_dir}/img_small.png" data-src="{$derivative->get_url()}" {/if}
            alt="{$thumbnail.TN_ALT}"
            title="{$thumbnail.TN_TITLE}">
          </div>

          <div class="macadam-photo-infos">
            <div class="macadam-photo-text">
              <h4 class="photo-title">
                {if !empty($thumbnail.NAME)}{$thumbnail.NAME}{else}Sans titre{/if}
              </h4>

              <span class="photo-meta">
                {if isset($thumbnail.FILE_EXT)}{$thumbnail.FILE_EXT|upper}{else}JPG{/if}
                {if isset($thumbnail.FILESIZE)} - {$thumbnail.FILESIZE}{/if}
              </span>
            </div>

            <div class="photo-actions-trigger">
              <i class="icon-three-dot"></i>
              {* <div class="pic-dropdown-menu">
                <a href="#" class="dropdown-item btn-share-pic">
                  <i class="icon-share"></i>
                  <span>{'Share picture'|@translate}</span>
                </a>
                <a href="#" class="dropdown-item btn-edit-pic">
                  <i class="icon-edit"></i>
                  <span>{'Edit picture'|@translate}</span>
                </a>
                <a href="#" class="dropdown-item btn-download-photos">
                  <i class="icon-add-drive"></i>
                  <span>{'Download the picture'|@translate}</span>
                </a>
              </div> *}
            </div>
          </div>

        </a>
      {/foreach}
    </div>
  {/strip}
{/if}

{* 
{footer_script}
jQuery(document).ready(function($) {
  
  $(document).on('click', '.photo-actions-trigger', function(e) {
    e.stopPropagation(); 
    
    var $currentMenu = $(this).children('.pic-dropdown-menu');
    $('.pic-dropdown-menu').not($currentMenu).removeClass('is-active');
    
    $currentMenu.toggleClass('is-active');
  });

  $(document).on('click', function() {
    $('.pic-dropdown-menu').removeClass('is-active');
  });

});
{/footer_script} *}