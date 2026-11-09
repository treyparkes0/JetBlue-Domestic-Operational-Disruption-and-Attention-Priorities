{{ config(materialized='view') }}

with airport_flights as (
  select
    Flight_Year,
    Flight_Month,
    'Origin' as Role,
    Origin_Airport_ID as Airport_ID,
    Origin_Airport as Airport,
    Origin_City as City,
    Origin_State as State,
    Cancelled,
    Diverted,
    Arrival_Delay_15_or_More,
    Arrival_Delay_Minutes,
    Carrier_Delay,
    Late_Aircraft_Delay,
    Weather_Delay,
    National_Air_System_Delay,
    Security_Delay
  from jetblue_capstone.views.flight_performance
  union all
  select
    Flight_Year,
    Flight_Month,
    'Destination' as Role,
    Destination_Airport_ID as Airport_ID,
    Destination_Airport as Airport,
    Destination_City as City,
    Destination_State as State,
    Cancelled,
    Diverted,
    Arrival_Delay_15_or_More,
    Arrival_Delay_Minutes,
    Carrier_Delay,
    Late_Aircraft_Delay,
    Weather_Delay,
    National_Air_System_Delay,
    Security_Delay
  from jetblue_capstone.views.flight_performance
)
select
  Flight_Year * 100 + Flight_Month as Year_Month_Key,
  Flight_Year,
  Flight_Month,
  Role,
  Airport_ID,
  Airport,
  City,
  State,
  count(*) as Total_Flights,
  sum(case when Cancelled = 0 and Diverted = 0 then 1 else 0 end) as Operated_Flights,
  sum(case when Cancelled = 1 then 1 else 0 end) as Cancelled_Flights,
  sum(case when Diverted = 1 and Cancelled = 0 then 1 else 0 end) as Diverted_Flights,
  sum(case when Arrival_Delay_15_or_More = 1 then 1 else 0 end) as Late_Arrivals_15_Plus,
  sum(case when Arrival_Delay_15_or_More = 1 then 1 else 0 end)
    / nullif(sum(case when Cancelled = 0 and Diverted = 0 then 1 else 0 end), 0) as Late_Arrival_Rate,
  sum(case when Cancelled = 1 then 1 else 0 end) / count(*) as Cancellation_Rate,
  sum(case when Diverted = 1 and Cancelled = 0 then 1 else 0 end) / count(*) as Diversion_Rate,
  sum(case when Cancelled = 0 and Diverted = 0 then Arrival_Delay_Minutes end) as Arrival_Delay_Minutes,
  sum(case when Arrival_Delay_15_or_More = 1 then Carrier_Delay + Late_Aircraft_Delay end) as Controllable_Delay_Minutes,
  sum(case when Arrival_Delay_15_or_More = 1 then Weather_Delay end) as Weather_Delay_Minutes,
  sum(case when Arrival_Delay_15_or_More = 1 then National_Air_System_Delay end) as NAS_Delay_Minutes,
  sum(case when Arrival_Delay_15_or_More = 1 then Security_Delay end) as Security_Delay_Minutes
from airport_flights
group by Flight_Year, Flight_Month, Role, Airport_ID, Airport, City, State
