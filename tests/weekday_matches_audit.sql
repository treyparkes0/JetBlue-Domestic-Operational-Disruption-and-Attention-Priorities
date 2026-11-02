with expected as (
  select 1 as Day_of_Week, 313919 as Total_Flights, 304750 as Operated_Flights, 85582 as Late_Arrivals_15_Plus, 8079 as Cancelled_Flights, 6946921 as Arrival_Delay_Minutes
  union all
  select 2, 289951, 282617, 67088, 6369, 5283487
  union all
  select 3, 290286, 283032, 66535, 6296, 5114853
  union all
  select 4, 313830, 305591, 85454, 7071, 6798707
  union all
  select 5, 314540, 306237, 87712, 7277, 6949800
  union all
  select 6, 275512, 267996, 70045, 6566, 5719780
  union all
  select 7, 312745, 302598, 89337, 9016, 7370693
)
select
  w.Day_of_Week,
  w.Total_Flights,
  w.Operated_Flights,
  w.Late_Arrivals_15_Plus,
  w.Cancelled_Flights,
  w.Arrival_Delay_Minutes
from {{ ref('weekday_performance') }} w
left join expected e
  on w.Day_of_Week = e.Day_of_Week
where e.Day_of_Week is null
   or w.Day_Name is null
   or w.Total_Flights != e.Total_Flights
   or w.Operated_Flights != e.Operated_Flights
   or w.Late_Arrivals_15_Plus != e.Late_Arrivals_15_Plus
   or w.Cancelled_Flights != e.Cancelled_Flights
   or cast(w.Arrival_Delay_Minutes as bigint) != e.Arrival_Delay_Minutes
