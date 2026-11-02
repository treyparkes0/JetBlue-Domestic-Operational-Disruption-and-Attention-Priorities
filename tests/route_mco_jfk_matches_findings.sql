with route as (
  select
    sum(Total_Flights) as Total_Flights,
    cast(sum(Arrival_Delay_Minutes) as bigint) as Arrival_Delay_Minutes
  from {{ ref('route_month') }}
  where Origin_Airport = 'MCO'
    and Destination_Airport = 'JFK'
)
select
  Total_Flights,
  Arrival_Delay_Minutes
from route
where Total_Flights != 22110
   or Arrival_Delay_Minutes != 612862
