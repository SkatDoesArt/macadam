
{include file='../../default/template/month_calendar.tpl'}

{if isset($chronology_calendar.month_view)}
{html_style}
.macadam-calendar-table th {
  max-width: {$chronology_calendar.month_view.CELL_WIDTH}px;
  overflow: hidden;
  text-overflow: ellipsis;
}

.macadam-calendar-table td {
  width: {$chronology_calendar.month_view.CELL_WIDTH}px;
}

{$crt_width=$chronology_calendar.month_view.CELL_WIDTH}
@media (max-width:{7*($crt_width+3)}px){
  {$crt_width=($crt_width/1.5)|intval}
  .macadam-calendar-table th {
    max-width: {$crt_width}px;
  }
  .macadam-calendar-table td {
    width: {$crt_width}px;
  }
}

@media (max-width:{7*($crt_width+3)}px){
  {$crt_width=($chronology_calendar.month_view.CELL_WIDTH/2)|intval}
  .macadam-calendar-table th {
    max-width: {$crt_width}px;
  }
  .macadam-calendar-table td {
    font-size: 16px;
    width: {$crt_width}px;
  }
}

{if 7*($crt_width+3)>320}
@media (max-width:360px){
  {$crt_width=(320/7-1)|intval}
  .macadam-calendar-table th {
    max-width: {$crt_width-2}px;
  }
  .macadam-calendar-table td {
    font-size: 12px;
    padding: 0;
    width: {$crt_width}px;
  }
}
{/if}
{/html_style}
{/if}