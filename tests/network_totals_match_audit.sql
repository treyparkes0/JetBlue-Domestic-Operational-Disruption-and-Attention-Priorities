with totals as (
  select
    sum(Total_Flights) as Total_Flights,
    sum(Operated_Flights) as Operated_Flights,
    sum(Late_Arrivals_15_Plus) as Late_Arrivals_15_Plus,
    sum(Cancelled_Flights) as Cancelled_Flights,
    sum(Diverted_Flights) as Diverted_Flights,
    cast(sum(Arrival_Delay_Minutes) as bigint) as Arrival_Delay_Minutes
  from {{ ref('monthly_performance') }}
)
select
  Total_Flights,
  Operated_Flights,
  Late_Arrivals_15_Plus,
  Cancelled_Flights,
  Diverted_Flights,
  Arrival_Delay_Minutes
from totals
where Total_Flights != 2110783
   or Operated_Flights != 2052821
   or Late_Arrivals_15_Plus != 551753
   or Cancelled_Flights != 50674
   or Diverted_Flights != 7288
   or Arrival_Delay_Minutes != 44184241
