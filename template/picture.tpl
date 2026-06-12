{combine_script id='core.switchbox' load='async' require='jquery' path='themes/default/js/switchbox.js'}
{if isset($MENUBAR)}{$MENUBAR}{/if}

<div id="content" {if isset($MENUBAR)} class="contentWithMenu" {/if}>

  {if isset($errors) or not empty($infos)}
    {include file='infos_errors.tpl'}
  {/if}

  {if !empty($PLUGIN_PICTURE_BEFORE)}{$PLUGIN_PICTURE_BEFORE}{/if}

  <div class="macadam-picture-container">

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
          <div class="actionButtons">

            {if isset($current.unique_derivatives) && count($current.unique_derivatives)>1}
              {footer_script require='jquery'}
              {literal}
                function changeImgSrc(url,typeSave,typeMap) {
                var theImg = document.getElementById("theMainImage");
                if (theImg) {
                theImg.removeAttribute("width"); theImg.removeAttribute("height");
                theImg.src = url;
                theImg.useMap = "#map"+typeMap;
                }
                jQuery('#derivativeSwitchBox .switchCheck').css('visibility','hidden');
                jQuery('#derivativeChecked'+typeMap).css('visibility','visible');
                document.cookie = 'picture_deriv='+typeSave+';path=
              {/literal}{$COOKIE_PATH}
              {literal}   ';
                }
                (window.SwitchBox=window.SwitchBox||[]).push("#derivativeSwitchLink", "#derivativeSwitchBox");
              {/literal}{/footer_script}

              {strip}
                <a id="derivativeSwitchLink" title="{'Photo sizes'|@translate}" class="pwg-state-default pwg-button" rel="nofollow">
                  <span class="pwg-icon pwg-icon-sizes"></span><span class="pwg-button-text">{'Photo sizes'|@translate}</span>
                </a>
                <div id="derivativeSwitchBox" class="switchBox">
                  <div class="switchBoxTitle">{'Photo sizes'|@translate}</div>
                  {foreach from=$current.unique_derivatives item=derivative key=derivative_type}
                    <span class="switchCheck" id="derivativeChecked{$derivative->get_type()}" {if $derivative->get_type() ne $current.selected_derivative->get_type()} style="visibility:hidden"
                {/if}>&#x2714; </span>
                <a href="javascript:changeImgSrc('{$derivative->get_url()|@escape:javascript}','{$derivative_type}','{$derivative->get_type()}')">
                {$derivative->get_type()|@translate}<span class="derivativeSizeDetails"> ({$derivative->get_size_hr()})</span>
                </a><br>
              {/foreach}
              {if isset($U_ORIGINAL)}
                {combine_script id='core.scripts' load='async' path='themes/default/js/scripts.js'}
                <a href="javascript:phpWGOpenWindow('{$U_ORIGINAL}','xxx','scrollbars=yes,toolbar=no,status=no,resizable=yes')" rel="nofollow">{'Original'|@translate}</a>
              {/if}
              </div>
          {/strip}
          {/if}

          {strip}
            {if isset($U_SLIDESHOW_START)}
              <a href="{$U_SLIDESHOW_START}" title="{'slideshow'|@translate}" class="pwg-state-default pwg-button" rel="nofollow">
                <span class="pwg-icon pwg-icon-slideshow"></span><span class="pwg-button-text">{'slideshow'|@translate}</span>
              </a>
            {/if}
          {/strip}

          {strip}
            {if isset($current.U_DOWNLOAD)}
              <a id="downloadSwitchLink" href="{$current.U_DOWNLOAD}" title="{'Download this file'|@translate}" class="pwg-state-default pwg-button" rel="nofollow">
                <span class="pwg-icon pwg-icon-save"></span><span class="pwg-button-text">{'Download'|@translate}</span>
              </a>
              {if !empty($current.formats)}
                {footer_script require='jquery'}
                {literal}
                  jQuery().ready(function() {
                  jQuery("#downloadSwitchLink").removeAttr("href");
                  (window.SwitchBox=window.SwitchBox||[]).push("#downloadSwitchLink", "#downloadSwitchBox");
                  });
                {/literal}{/footer_script}
                <div id="downloadSwitchBox" class="switchBox">
                  <div class="switchBoxTitle">{'Download'|translate} - {'Formats'|translate}</div>
                  <ul>
                    {foreach from=$current.formats item=format}
                      <li><a href="{$format.download_url}" rel="nofollow">{$format.label}<span class="downloadformatDetails"> ({$format.filesize})</span></a></li>
                    {/foreach}
                  </ul>
                </div>
              {/if}
            {/if}
          {/strip}

          {if isset($PLUGIN_PICTURE_BUTTONS)}
            {foreach from=$PLUGIN_PICTURE_BUTTONS item=button}{$button}{/foreach}
          {/if}
          {if isset($PLUGIN_PICTURE_ACTIONS)}{$PLUGIN_PICTURE_ACTIONS}{/if}
          {strip}
            {if isset($favorite)}
              <a href="{$favorite.U_FAVORITE}" title="{if $favorite.IS_FAVORITE}{'delete this photo from your favorites'|@translate}{else}{'add this photo to your favorites'|@translate}{/if}" class="pwg-state-default pwg-button" rel="nofollow">
                <span class="pwg-icon pwg-icon-favorite-{if $favorite.IS_FAVORITE}del{else}add{/if}"></span><span class="pwg-button-text">{'Favorites'|@translate}</span>
              </a>
            {/if}
          {/strip}

          {strip}
            {if isset($U_SET_AS_REPRESENTATIVE)}
              <a id="cmdSetRepresentative" href="{$U_SET_AS_REPRESENTATIVE}" title="{'set as album representative'|@translate}" class="pwg-state-default pwg-button" rel="nofollow">
                <span class="pwg-icon pwg-icon-representative"></span><span class="pwg-button-text">{'representative'|@translate}</span>
              </a>
            {/if}
          {/strip}

          {strip}
            {if isset($U_PHOTO_ADMIN)}
              <a id="cmdEditPhoto" href="{$U_PHOTO_ADMIN}" title="{'Edit photo'|@translate}" class="pwg-state-default pwg-button" rel="nofollow">
                <span class="sidebar-icon-link">⚙️</span><span class="pwg-button-text">{'Edit'|@translate}</span>
              </a>
            {/if}
          {/strip}

          {strip}
            {if isset($U_CADDIE)}
              {footer_script}
              {literal}   function addToCadie(aElement, rootUrl, id) {
                if (aElement.disabled) return;
                aElement.disabled=true;
                var y = new PwgWS(rootUrl);
                y.callService("pwg.caddie.add", {image_id: id}, {
                onFailure: function(num, text) { alert(num + " " + text); document.location=aElement.href; },
                onSuccess: function(result) { aElement.disabled = false; }
                });
                }
              {/literal}
              {/footer_script}
              <a href="{$U_CADDIE}" onclick="addToCadie(this, '{$ROOT_URL}', {$current.id}); return false;" title="{'Add to caddie'|@translate}" class="pwg-state-default pwg-button" rel="nofollow">
                <span class="pwg-icon pwg-icon-caddie-add"> </span><span class="pwg-button-text">{'Caddie'|@translate}</span>
              </a>
            {/if}
          {/strip}

        </div>
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
        <div id="theImage">
          {$ELEMENT_CONTENT}
          {if isset($U_SLIDESHOW_STOP)}
            <p>[ <a href="{$U_SLIDESHOW_STOP}">{'stop the slideshow'|@translate}</a> ]</p>
          {/if}
        </div>
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
            <img class="{if (isset($previous.path_ext) and $previous.path_ext == 'svg')}svgImg{/if}" src="{if (isset($previous.path_ext) and $previous.path_ext == 'svg')}{$previous.path}{else}{$previous.derivatives.square->get_url()}{/if}" alt="{$previous.TITLE_ESC}">
          </a>
        {else}
          <div class="strip-thumb-placeholder"></div>
        {/if}

        <div class="strip-thumb-item active">
          <img src="{$current.selected_derivative->get_url()}" alt="{$current.TITLE}">
        </div>

        {if isset($next)}
          <a class="strip-thumb-item" href="{$next.U_IMG}">
            <img class="{if (isset($next.path_ext) and $next.path_ext == 'svg')}svgImg{/if}" src="{if (isset($next.path_ext) and $next.path_ext == 'svg')}{$next.path}{else}{$next.derivatives.square->get_url()}{/if}" alt="{$next.TITLE_ESC}">
          </a>
        {else}
          <div class="strip-thumb-placeholder"></div>
        {/if}
      </div>
    {/if}

  </div>

  <aside class="macadam-picture-sidebar">

    <div class="sidebar-tabs">
      <button class="tab-btn active" id="tabInfoLink" title="Informations">ⓘ</button>
      <button class="tab-btn" id="tabCommentsLink" title="Commentaires">💬 {if isset($COMMENT_COUNT)}({$COMMENT_COUNT}){/if}</button>
    </div>

    <div class="sidebar-scrollable-content">

      <div id="macadam-sidebar-info-view">
        <div class="sidebar-meta-header">
          <h3 class="photo-title">{$current.TITLE}</h3>
          {* <div class="imageNumber">Image {$PHOTO}</div> *}
        </div>

        {if isset($COMMENT_IMG)}
          <p class="imageComment">{$COMMENT_IMG}</p>
        {/if}

        {if ($display_info.tags and isset($related_tags))}
          <div class="sidebar-section-tags">
            <div class="tag-badges-container">
              {foreach from=$related_tags item=tag}
                <i class="icon-tags"></i> <a href="{$tag.URL}" class="macadam-tag-badge">{$tag.name}</a>
              {/foreach}
            </div>
          </div>
        {/if}

        <div class="sidebar-section-details">
          <ul class="macadam-info-list">

            {if $display_info.created_on and isset($INFO_CREATION_DATE)}
              <li>
                <i class="icon-add-calendar"></i>
                <span class="info-value">{$INFO_CREATION_DATE}</span>
              </li>
            {/if}

            {if $display_info.posted_on}
              <li>
                <span class="info-icon">📤</span>
                <span class="info-value">{$INFO_POSTED_DATE}</span>
              </li>
            {/if}

            {if $display_info.filesize and isset($INFO_FILESIZE)}
              <li>
                <span class="info-icon">🖴</span>
                <span class="info-value">{$INFO_FILESIZE}</span>
              </li>
            {/if}

            {if $display_info.author and isset($INFO_AUTHOR)}
              <li>
                <i class="icon-person"></i>
                <span class="info-value">{$INFO_AUTHOR}</span>
              </li>
            {/if}

            {if $display_info.visits}
              <li>
                <i class="icon-eye"></i>
                <span class="info-value">{$INFO_VISITS}</span>
              </li>
            {/if}

            {if $display_info.rating_score and isset($rate_summary)}
              <li>
                <i class="icon-star"></i>
                <span class="info-value">
                  {if $rate_summary.count}
                    <span id="ratingScore">{$rate_summary.score}</span> <span id="ratingCount">({$rate_summary.count|@translate_dec:'%d rate':'%d rates'})</span>
                  {else}
                    <span id="ratingScore">{'no rate'|@translate}</span> <span id="ratingCount"></span>
                  {/if}
                </span>
                <span class="info-label">/5</span>
              </li>
            {/if}

            {if $display_info.file and isset($display_info.file)}
              <li>
                <i class="icon-folded-picture"></i>
                <span class="info-value">{$INFO_FILE}</span>
              </li>
            {/if}

            {if $display_info.categories and isset($related_categories)}

              {foreach from=$related_categories item=cat}
                <li>
                  <i class="icon-folder"></i>
                  <span class="info-value">
                    {$cat}
                  </span>
                </li>
              {/foreach}
            {/if}

            {* {if $display_info.dimensions and isset($INFO_DIMENSIONS)}
              <li>
                <span class="info-icon">📐</span>
                <span class="info-label">{'Dimensions'|@translate}:</span>
                <span class="info-value">{$INFO_DIMENSIONS}</span>
              </li>
            {/if} *}
          </ul>

        </div>

        {if isset($rating)}
          <div class="macadam-rating-box">
            <span id="updateRate" class="rating-title">
              {if isset($rating.USER_RATE)}{'Update your rating'|@translate}{else}{'Rate this photo'|@translate}{/if}
            </span>
            <form action="{$rating.F_ACTION}" method="post" id="rateForm">
              <div class="rating-buttons">
                {foreach from=$rating.marks item=mark}
                  {if isset($rating.USER_RATE) && $mark==$rating.USER_RATE}
                    <input type="button" name="rate" value="{$mark}" class="rateButtonSelected" title="{$mark}">
                  {else}
                    <input type="submit" name="rate" value="{$mark}" class="rateButton" title="{$mark}">
                  {/if}
                {/foreach}
              </div>
            </form>
            {combine_script id='core.scripts' load='async' path='themes/default/js/scripts.js'}
            {combine_script id='rating' load='async' require='core.scripts' path='themes/default/js/rating.js'}
            {footer_script}
            var _pwgRatingAutoQueue = _pwgRatingAutoQueue||[];
            _pwgRatingAutoQueue.push( {ldelim}rootUrl: '{$ROOT_URL}', image_id: {$current.id},
            onSuccess : function(rating) {ldelim}
            var e = document.getElementById("updateRate");
            if (e) e.innerHTML = "{'Update your rating'|@translate|@escape:'javascript'}";
            e = document.getElementById("ratingScore");
            if (e) e.innerHTML = rating.score;
            e = document.getElementById("ratingCount");
            if (e) {ldelim}
            if (rating.count == 1) {ldelim}
            e.innerHTML = "({'%d rate'|@translate|@escape:'javascript'})".replace( "%d", rating.count);
            {rdelim} else {ldelim}
            e.innerHTML = "({'%d rates'|@translate|@escape:'javascript'})".replace( "%d", rating.count);
            {rdelim}
            {rdelim}
            {rdelim}{rdelim} );
            {/footer_script}
          </div>
        {/if}

        {if isset($metadata)}
          <div class="macadam-metadata-box">
            {foreach from=$metadata item=meta}
              <h4>{$meta.TITLE}</h4>
              {foreach from=$meta.lines item=value key=label}
                <div class="meta-line"><strong>{$label}:</strong> {$value}</div>
              {/foreach}
            {/foreach}
          </div>
        {/if}
      </div>

      <div id="macadam-sidebar-comments-view" style="display: none;">
        {if isset($COMMENT_COUNT)}
          <div id="comments">
            <h3>{$COMMENT_COUNT|@translate_dec:'%d comment':'%d comments'}</h3>

            {if isset($comment_add)}
              <div id="commentAdd">
                <form method="post" action="{$comment_add.F_ACTION}" id="addComment">
                  {if $comment_add.SHOW_AUTHOR}
                    <p><label for="author">{'Author'|@translate}:</label>
                      <input type="text" name="author" id="author" value="{$comment_add.AUTHOR}">
                    </p>
                  {/if}
                  {if $comment_add.SHOW_EMAIL}
                    <p><label for="email">{'Email address'|@translate}:</label>
                      <input type="text" name="email" id="email" value="{$comment_add.EMAIL}">
                    </p>
                  {/if}
                  <p><label for="contentid">{'Comment'|@translate}:</label>
                    <textarea name="content" id="contentid" rows="4">{$comment_add.CONTENT}</textarea>
                  </p>
                  <p>
                    <input type="hidden" name="key" value="{$comment_add.KEY}">
                    <input type="submit" class="submit-comment-btn" value="{'Submit'|@translate}">
                  </p>
                </form>
              </div>
            {/if}

            {if isset($comments)}
              <div id="pictureCommentList">
                {if (($COMMENT_COUNT > 2) || !empty($navbar))}
                  <div id="pictureCommentNavBar">
                    {if $COMMENT_COUNT > 2}
                      <a href="{$COMMENTS_ORDER_URL}#comments" rel="nofollow" class="commentsOrder">{$COMMENTS_ORDER_TITLE}</a>
                    {/if}
                    {if !empty($navbar)}{include file='navigation_bar.tpl'|@get_extent:'navbar'}{/if}
                  </div>
                {/if}
                <div class="comments-list-wrapper">
                  {$COMMENT_LIST}
                </div>
              </div>
            {/if}
          </div>
        {/if}
      </div>

    </div>
  </aside>

</div>

{if !empty($PLUGIN_PICTURE_AFTER)}{$PLUGIN_PICTURE_AFTER}{/if}

</div>

{footer_script}
{literal}
  document.addEventListener('DOMContentLoaded', function() {
  const tabInfo = document.getElementById('tabInfoLink');
  const tabComments = document.getElementById('tabCommentsLink');
  const viewInfo = document.getElementById('macadam-sidebar-info-view');
  const viewComments = document.getElementById('macadam-sidebar-comments-view');

  if(tabInfo && tabComments) {
  tabInfo.addEventListener('click', function() {
  tabInfo.classList.add('active');
  tabComments.classList.remove('active');
  viewInfo.style.display = 'block';
  viewComments.style.display = 'none';
  });

  tabComments.addEventListener('click', function() {
  tabComments.classList.add('active');
  tabInfo.classList.remove('active');
  viewInfo.style.display = 'none';
  viewComments.style.display = 'block';
  });
  }
  });
{/literal}
{/footer_script}