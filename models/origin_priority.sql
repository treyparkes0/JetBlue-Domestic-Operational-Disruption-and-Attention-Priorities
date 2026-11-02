{{ config(materialized='view') }}

with origin as (
  select
    Airport_ID,
    Airport,
    City,
    State,
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
  from {{ ref('airport_month') }}
  where Role = 'Origin'
  group by Airport_ID, Airport, City, State
),
cuts as (
  select
    percentile(Late_Arrival_Rate, 0.75) as Late_Rate_P75,
    percentile(Cancellation_Rate, 0.75) as Cancellation_Rate_P75
  from origin
  where Total_Flights >= 1000
),
ranked as (
  select
    Airport,
    row_number() over (order by Arrival_Delay_Minutes desc) as Minute_Rank
  from origin
  where Total_Flights >= 1000
)
select
  o.Airport_ID,
  o.Airport,
  o.City,
  o.State,
  o.Total_Flights,
  o.Operated_Flights,
  o.Late_Arrivals_15_Plus,
  o.Late_Arrival_Rate,
  o.Cancelled_Flights,
  o.Cancellation_Rate,
  o.Arrival_Delay_Minutes,
  o.Avg_Arrival_Delay_Minutes,
  o.Controllable_Delay_Minutes,
  o.Weather_Delay_Minutes,
  o.NAS_Delay_Minutes,
  o.Security_Delay_Minutes,
  o.Controllable_Share,
  r.Minute_Rank,
  c.Late_Rate_P75,
  c.Cancellation_Rate_P75,
  case when r.Minute_Rank <= 10 then 1 else 0 end as High_Accumulated_Impact,
  case
    when o.Total_Flights >= 1000 and o.Late_Arrival_Rate >= c.Late_Rate_P75 then 1
    else 0
  end as Elevated_Late_Arrival,
  case
    when o.Total_Flights >= 1000 and o.Cancellation_Rate >= c.Cancellation_Rate_P75 then 1
    else 0
  end as Elevated_Cancellation,
  case
    when o.Total_Flights >= 250
      and o.Total_Flights < 1000
      and o.Late_Arrival_Rate >= c.Late_Rate_P75 then 1
    else 0
  end as Monitoring
from origin o
cross join cuts c
left join ranked r
  on o.Airport = r.Airport
