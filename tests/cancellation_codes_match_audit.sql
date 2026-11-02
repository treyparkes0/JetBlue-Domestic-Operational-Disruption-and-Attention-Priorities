with rolled as (
  select
    Cancellation_Code,
    sum(Cancelled_Flights) as Cancelled_Flights
  from {{ ref('cancellation_reason') }}
  group by Cancellation_Code
),
expected as (
  select 'A' as Cancellation_Code, 14477 as Cancelled_Flights
  union all
  select 'B', 18287
  union all
  select 'C', 11154
  union all
  select 'D', 6756
)
select
  coalesce(r.Cancellation_Code, e.Cancellation_Code) as Cancellation_Code,
  r.Cancelled_Flights as actual_flights,
  e.Cancelled_Flights as expected_flights
from rolled r
full outer join expected e
  on r.Cancellation_Code = e.Cancellation_Code
where e.Cancellation_Code is null
   or r.Cancellation_Code is null
   or r.Cancelled_Flights != e.Cancelled_Flights
