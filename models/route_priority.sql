{{ config(materialized='view') }}

with route as (
  select
    Origin_Airport,
    Destination_Airport,
    sum(Total_Flights) as Total_Flights,
    sum(Operated_Flights) as Operated_Flights,
    sum(Late_Arrivals_15_Plus) as Late_Arrivals_15_Plus,
    sum(Late_Arrivals_15_Plus) / nullif(sum(Operated_Flights), 0) as Late_Arrival_Rate,
    sum(Cancelled_Flights) as Cancelled_Flights,
    sum(Cancelled_Flights) / nullif(sum(Total_Flights), 0) as Cancellation_Rate,
    sum(Arrival_Delay_Minutes) as Arrival_Delay_Minutes,
    sum(Arrival_Delay_Minutes) / nullif(sum(Operated_Flights), 0) as Avg_Arrival_Delay_Minutes,
    sum(Controllable_Delay_Minutes) as Controllable_Delay_Minutes,
    sum(Weather_Delay_Minutes) as Weather_Delay_Minutes,
    sum(NAS_Delay_Minutes) as NAS_Delay_Minutes,
    sum(Security_Delay_Minutes) as Security_Delay_Minutes,
    sum(Controllable_Delay_Minutes)
      / nullif(
        sum(Controllable_Delay_Minutes)
        + sum(Weather_Delay_Minutes)
        + sum(NAS_Delay_Minutes)
        + sum(Security_Delay_Minutes),
        0
      ) as Controllable_Share
  from {{ ref('route_month') }}
  group by Origin_Airport, Destination_Airport
),
cuts as (
  select
    percentile(Late_Arrival_Rate, 0.75) as Late_Rate_P75,
    percentile(Cancellation_Rate, 0.75) as Cancellation_Rate_P75
  from route
  where Total_Flights >= 500
),
ranked as (
  select
    Origin_Airport,
    Destination_Airport,
    row_number() over (order by Arrival_Delay_Minutes desc) as Minute_Rank
  from route
  where Total_Flights >= 500
)
select
  concat(r0.Origin_Airport, '-', r0.Destination_Airport) as Route_Key,
  r0.Origin_Airport,
  r0.Destination_Airport,
  r0.Total_Flights,
  r0.Operated_Flights,
  r0.Late_Arrivals_15_Plus,
  r0.Late_Arrival_Rate,
  r0.Cancelled_Flights,
  r0.Cancellation_Rate,
  r0.Arrival_Delay_Minutes,
  r0.Avg_Arrival_Delay_Minutes,
  r0.Controllable_Delay_Minutes,
  r0.Weather_Delay_Minutes,
  r0.NAS_Delay_Minutes,
  r0.Security_Delay_Minutes,
  r0.Controllable_Share,
  rk.Minute_Rank,
  c.Late_Rate_P75,
  c.Cancellation_Rate_P75,
  case when rk.Minute_Rank <= 10 then 1 else 0 end as High_Accumulated_Impact,
  case
    when r0.Total_Flights >= 500 and r0.Late_Arrival_Rate >= c.Late_Rate_P75 then 1
    else 0
  end as Elevated_Late_Arrival,
  case
    when r0.Total_Flights >= 500 and r0.Cancellation_Rate >= c.Cancellation_Rate_P75 then 1
    else 0
  end as Elevated_Cancellation,
  case
    when r0.Total_Flights >= 250
      and r0.Total_Flights < 500
      and r0.Late_Arrival_Rate >= c.Late_Rate_P75 then 1
    else 0
  end as Monitoring
from route r0
cross join cuts c
left join ranked rk
  on r0.Origin_Airport = rk.Origin_Airport
  and r0.Destination_Airport = rk.Destination_Airport
