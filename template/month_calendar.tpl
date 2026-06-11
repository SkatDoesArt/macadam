<div class="macadam-calendar-wrapper">

  <div class="macadam-calendar-navigation">
    
    <div class="cal-sort-zone">
      <select class="cal-select-sort">
        <option>Sort by : post date</option>
      </select>
    </div>

    <div class="cal-date-picker-zone">
      {if !empty($chronology_navigation_bars)}
        {foreach from=$chronology_navigation_bars item=bar}
          {if isset($bar.previous)}
            <a href="{$bar.previous.URL}" class="cal-nav-arrow">&lt;</a>
          {/if}
          
          <span class="cal-current-date">
            {foreach from=$bar.items item=item}
              {if !isset($item.URL)}
                <strong>{$item.LABEL}</strong>
              {/if}
            {/foreach}
          </span>

          {if isset($bar.next)}
            <a href="{$bar.next.URL}" class="cal-nav-arrow">&gt;</a>
          {/if}
        {/foreach}
      {/if}
    </div>

    <div class="cal-view-modes">
      <span class="cal-btn-mode">Annual</span>
      <span class="cal-btn-mode active">Monthly</span>
    </div>
  </div>

  {if !empty($chronology_calendar.calendar_bars)}
    <div class="macadam-calendar-subbars">
      {foreach from=$chronology_calendar.calendar_bars item=bar}
        <div class="calendarCalBar">
          <span class="calCalHead"><a href="{$bar.U_HEAD}">{$bar.HEAD_LABEL}</a> ({$bar.NB_IMAGES})</span>
          <div class="calBarItems">
            {foreach from=$bar.items item=item}
              <span class="calCal{if !isset($item.URL)}Empty{/if}">
                {if isset($item.URL)}
                  <a href="{$item.URL}">{$item.LABEL}</a>
                {else}
                  {$item.LABEL}
                {/if}
                {if isset($item.NB_IMAGES)}<small>({$item.NB_IMAGES})</small>{/if}
              </span>
            {/foreach}
          </div>
        </div>
      {/foreach}
    </div>
  {/if}

  {if isset($chronology_calendar.month_view)}
    <table class="macadam-calendar-table">
      <thead>
        <tr>
          {foreach from=$chronology_calendar.month_view.wday_labels item=wday}
            <th>{$wday}</th>
          {/foreach}
        </tr>
      </thead>
      <tbody>
        {foreach from=$chronology_calendar.month_view.weeks item=week}
          <tr>
            {foreach from=$week item=day}
              {if !empty($day)}
                {if isset($day.IMAGE)}

                  <td class="cal-day-cell has-photos">
                    <div class="cell-header">
                      <span class="day-number">{$day.DAY}</span>
                      <a href="{$day.U_IMG_LINK}" class="photos-badge">
                        {$day.NB_ELEMENTS} photos
                      </a>
                    </div>
                    <div class="cell-content">
                      <a href="{$day.U_IMG_LINK}" class="calendar-thumb-link">

                        <div class="thumb-preview-stack">
                          <span class="color-block block-orange"></span>
                          <span class="color-block block-beige"></span>
                          <span class="color-block block-dark">
                            <span class="plus-icon">+</span>
                          </span>
                        </div>
                      </a>
                    </div>
                  </td>
                {else}

                  <td class="cal-day-cell is-empty">
                    <div class="cell-header">
                      <span class="day-number">{$day.DAY}</span>
                    </div>
                    <div class="cell-content"></div>
                  </td>
                {/if}
              {else}

                <td class="cal-day-cell outside-month"></td>
              {/if}
            {/foreach}
          </tr>
        {/foreach}
      </tbody>
    </table>
  {/if}

</div>