-- Column mapping from the BTS extract to the flight-level view dbt reads.
-- Source columns are the official BTS names on data/raw/jetblue_b6_clean.csv.
-- Load that file first, then point the FROM clause at the table you loaded.
-- The name below is the expected load target. Do not run this statement
-- until that table exists. Running it replaces jetblue_capstone.views.flight_performance.

create or replace view jetblue_capstone.views.flight_performance as
select
  cast(Year as int) as Flight_Year,
  cast(Month as int) as Flight_Month,
  cast(FlightDate as date) as Flight_Date,
  cast(DayOfWeek as int) as Day_of_Week,
  cast(OriginAirportID as int) as Origin_Airport_ID,
  Origin as Origin_Airport,
  OriginCityName as Origin_City,
  OriginState as Origin_State,
  cast(DestAirportID as int) as Destination_Airport_ID,
  Dest as Destination_Airport,
  DestCityName as Destination_City,
  DestState as Destination_State,
  cast(Cancelled as int) as Cancelled,
  cast(Diverted as int) as Diverted,
  cast(ArrDel15 as int) as Arrival_Delay_15_or_More,
  cast(ArrDelayMinutes as double) as Arrival_Delay_Minutes,
  cast(CarrierDelay as double) as Carrier_Delay,
  cast(LateAircraftDelay as double) as Late_Aircraft_Delay,
  cast(WeatherDelay as double) as Weather_Delay,
  cast(NASDelay as double) as National_Air_System_Delay,
  cast(SecurityDelay as double) as Security_Delay,
  CancellationCode
from jetblue_capstone.raw.jetblue_b6
where Reporting_Airline = 'B6'
