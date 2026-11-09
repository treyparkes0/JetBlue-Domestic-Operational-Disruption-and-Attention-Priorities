{{ config(materialized='view') }}

select
  Flight_Year * 100 + Flight_Month as Year_Month_Key,
  Flight_Year,
  Flight_Month,
  Flight_Date,
  Day_of_Week,
  Origin_Airport_ID,
  concat(Origin_Airport, '-', Destination_Airport) as Route_Key,
  Cancelled,
  Diverted,
  Arrival_Delay_15_or_More,
  Arrival_Delay_Minutes,
  Carrier_Delay,
  Late_Aircraft_Delay,
  Weather_Delay,
  National_Air_System_Delay,
  Security_Delay,
  case
    when Cancelled = 1 and CancellationCode in ('A', 'B', 'C', 'D') then CancellationCode
    when Cancelled = 1 then 'Unknown'
  end as Cancellation_Code
from jetblue_capstone.views.flight_performance
