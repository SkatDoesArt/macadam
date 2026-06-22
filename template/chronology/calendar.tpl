{*
  Macadam - custom month calendar layout
  Overrides Piwigo chronology plugin default.
*}
{if isset($chronology_calendar.month_view)}
  <div class="macadam-calendar-wrapper">

    <div class="macadam-calendar-navigation">
      <form method="get" action="{$chronology_calendar.U_VIEW}">
        <input type="hidden" name="page" value="{$chronology_calendar.page|default:''}">
        <input type="hidden" name="year" value="{$chronology_calendar.year|default:''}">
        <input type="hidden" name="month" value="{$chronology_calendar.month|default:''}">

        <label class="sr-only" for="{$chronology_calendar.field_sort|default:'sort'}">{'Sort by'|translate}</label>
        <select id="{$chronology_calendar.field_sort|default:'sort'}" name="{$chronology_calendar.field_sort|default:'sort'}" class="cal-select-sort">
          <option value="post_date" selected>{$chronology_calendar.sort_label|default:'Sort by : post date'}</option>
          {if isset($chronology_calendar.U_SORT_LIST) && !empty($chronology_calendar.U_SORT_LIST)}
            {foreach from=$chronology_calendar.U_SORT_LIST item=s}
              <option value="{$s.value}" {if $s.selected}selected{/if}>{$s.label}</option>
            {/foreach}
          {/if}
        </select>
      </form>

      <div class="cal-date-picker-zone">
        <a class="cal-nav-arrow" href="{$chronology_calendar.U_PREV}" aria-label="{'Previous'|translate}"><</a>

        <div class="cal-current-date" aria-label="{'Selected date'|translate}">
          <div class="cal-date-dropdowns">
            <span class="cal-month">{$chronology_calendar.month_name|default:''}</span>
            <span class="cal-caret">▾</span>
          </div>
          <div class="cal-year">{$chronology_calendar.year|default:''}</div>
          <span class="cal-caret">▾</span>
        </div>

        <a class="cal-nav-arrow" href="{$chronology_calendar.U_NEXT}" aria-label="{'Next'|translate}">></a>
      </div>

      <div class="cal-view-modes" role="group" aria-label="{'View mode'|translate}">
        <a class="cal-btn-mode{if $chronology_calendar.month_mode == 'annual'} active{/if}" href="{$chronology_calendar.U_ANNUAL}">Annual</a>
        <a class="cal-btn-mode active{if $chronology_calendar.month_mode == 'monthly'} active{/if}" href="{$chronology_calendar.U_MONTHLY}">Monthly</a>
      </div>
    </div>

    <table class="macadam-calendar-table" role="grid">
      <thead>
        <tr>
          {foreach from=$chronology_calendar.days_of_week item=d}
            <th>{$d}</th>
          {/foreach}
        </tr>
      </thead>
      <tbody>
        {foreach from=$chronology_calendar.weeks item=week}
          <tr>
            {foreach from=$week item=day}
              {assign var="cell_outside" value=$day.outside_month|default:false}
              <td class="cal-day-cell{if $cell_outside} outside-month{/if}{if !empty($day.photos_count)} has-photos{/if}">

                <div class="cell-header">
                  <div class="day-number">{$day.day_number}</div>

                  {if isset($day.photos_count) && $day.photos_count|intval > 0}
                    {assign var="count" value=$day.photos_count|intval}
                    {assign var="label" value=($count==1?'photo':'photos')}
                    <a class="photos-badge" href="{$day.U_DAY}">{$count} {$label}</a>
                  {/if}
                </div>

                <div class="cell-content">
                  <div class="thumb-preview-stack" aria-hidden="true">
                    {if isset($day.preview_colors) && $day.preview_colors|@count > 0}
                      {assign var="shown" value=0}
                      {foreach from=$day.preview_colors item=c}
                        {if $shown < 3}
                          <span class="color-block {$c.class}"></span>
                          {$shown = $shown + 1}
                        {/if}
                      {/foreach}

                      {if isset($day.photos_count) && $day.photos_count|intval > 3}
                        <span class="color-block block-dark more-thumb">
                          <span class="more-circle">+ </span>
                        </span>
                      {/if}
                    {else}
                      <span class="color-block block-orange" style="opacity:.2"></span>
                      <span class="color-block block-beige" style="opacity:.2"></span>
                      <span class="color-block block-dark" style="opacity:.2"></span>
                    {/if}
                  </div>
                </div>

              </td>
            {/foreach}
          </tr>
        {/foreach}
      </tbody>
    </table>

  </div>
{/if}

