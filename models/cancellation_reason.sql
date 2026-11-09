{{ config(materialized='view') }}

select
  Flight_Year * 100 + Flight_Month as Year_Month_Key,
  Flight_Year,
  Flight_Month,
  case
    when CancellationCode in ('A', 'B', 'C', 'D') then CancellationCode
    else 'Unknown'
  end as Cancellation_Code,
  case CancellationCode
    when 'A' then 'Carrier'
    when 'B' then 'Weather'
    when 'C' then 'National Air System'
    when 'D' then 'Security'
    else 'Unknown'
  end as Cancellation_Reason,
  count(*) as Cancelled_Flights
from jetblue_capstone.views.flight_performance
where Cancelled = 1
group by
  Flight_Year,
  Flight_Month,
  case
    when CancellationCode in ('A', 'B', 'C', 'D') then CancellationCode
    else 'Unknown'
  end,
  case CancellationCode
    when 'A' then 'Carrier'
    when 'B' then 'Weather'
    when 'C' then 'National Air System'
    when 'D' then 'Security'
    else 'Unknown'
  end
