select
  Total_Flights,
  Operated_Flights,
  Late_Arrivals_15_Plus,
  Cancelled_Flights,
  Arrival_Delay_Minutes
from {{ ref('monthly_performance') }}
where Flight_Year = 2023
  and Flight_Month = 7
  and (
    Total_Flights != 22853
    or Operated_Flights != 21108
    or Late_Arrivals_15_Plus != 9794
    or Cancelled_Flights != 1564
    or Arrival_Delay_Minutes != 1085438
  )
