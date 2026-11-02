{{ config(materialized='view') }}

select
  Day_of_Week,
  case Day_of_Week
    when 1 then 'Monday'
    when 2 then 'Tuesday'
    when 3 then 'Wednesday'
    when 4 then 'Thursday'
    when 5 then 'Friday'
    when 6 then 'Saturday'
    when 7 then 'Sunday'
  end as Day_Name,
  count(*) as Total_Flights,
  sum(case when Cancelled = 0 and Diverted = 0 then 1 else 0 end) as Operated_Flights,
  sum(case when Cancelled = 1 then 1 else 0 end) as Cancelled_Flights,
  sum(case when Diverted = 1 and Cancelled = 0 then 1 else 0 end) as Diverted_Flights,
  sum(case when Arrival_Delay_15_or_More = 1 then 1 else 0 end) as Late_Arrivals_15_Plus,
  sum(case when Arrival_Delay_15_or_More = 1 then 1 else 0 end)
    / nullif(sum(case when Cancelled = 0 and Diverted = 0 then 1 else 0 end), 0) as Late_Arrival_Rate,
  sum(case when Cancelled = 1 then 1 else 0 end) / count(*) as Cancellation_Rate,
  sum(case when Cancelled = 0 and Diverted = 0 then Arrival_Delay_Minutes end) as Arrival_Delay_Minutes,
  sum(case when Cancelled = 0 and Diverted = 0 then Arrival_Delay_Minutes end)
    / nullif(sum(case when Cancelled = 0 and Diverted = 0 then 1 else 0 end), 0) as Avg_Arrival_Delay_Minutes
from jetblue_capstone.views.flight_performance
group by Day_of_Week
