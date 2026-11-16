with route as (
  select
    sum(Total_Flights) as Total_Flights,
    cast(sum(Arrival_Delay_Minutes) as bigint) as Arrival_Delay_Minutes
  from {{ ref('route_month') }}
  where Origin_Airport = 'FLL'
    and Destination_Airport = 'EWR'
)
select
  Total_Flights,
  Arrival_Delay_Minutes
from route
where Total_Flights != 10993
   or Arrival_Delay_Minutes != 299164
