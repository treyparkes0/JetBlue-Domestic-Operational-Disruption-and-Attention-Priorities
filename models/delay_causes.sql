{{ config(materialized='view') }}

select
  Flight_Year * 100 + Flight_Month as Year_Month_Key,
  Flight_Date,
  Flight_Year,
  Flight_Month,
  Origin_Airport_ID,
  Origin_Airport,
  Destination_Airport_ID,
  Destination_Airport,
  Arrival_Delay_Minutes,
  Carrier_Delay,
  Late_Aircraft_Delay,
  Carrier_Delay + Late_Aircraft_Delay as Controllable_Delay_Minutes,
  Weather_Delay,
  National_Air_System_Delay,
  Security_Delay
from jetblue_capstone.views.flight_performance
where Arrival_Delay_15_or_More = 1
