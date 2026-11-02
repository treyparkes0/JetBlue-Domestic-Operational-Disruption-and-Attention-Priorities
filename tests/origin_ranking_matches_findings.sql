with origin as (
  select
    Airport,
    sum(Total_Flights) as Total_Flights,
    cast(sum(Arrival_Delay_Minutes) as bigint) as Arrival_Delay_Minutes
  from {{ ref('airport_month') }}
  where Role = 'Origin'
  group by Airport
),
expected as (
  select 'JFK' as Airport, 317477 as Total_Flights, 6516458 as Arrival_Delay_Minutes
  union all
  select 'BOS', 350117, 6312537
  union all
  select 'FLL', 170468, 3778579
  union all
  select 'MCO', 144635, 3508770
  union all
  select 'SJU', 82442, 1929410
)
select
  e.Airport,
  o.Total_Flights,
  o.Arrival_Delay_Minutes
from expected e
left join origin o
  on e.Airport = o.Airport
where o.Airport is null
   or o.Total_Flights != e.Total_Flights
   or o.Arrival_Delay_Minutes != e.Arrival_Delay_Minutes
