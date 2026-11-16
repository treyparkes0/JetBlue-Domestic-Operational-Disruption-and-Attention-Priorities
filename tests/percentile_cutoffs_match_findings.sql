with origin_cuts as (
  select
    min(Late_Rate_P75) as late_min,
    max(Late_Rate_P75) as late_max,
    min(Cancellation_Rate_P75) as cancel_min,
    max(Cancellation_Rate_P75) as cancel_max
  from {{ ref('origin_priority') }}
),
route_cuts as (
  select
    min(Late_Rate_P75) as late_min,
    max(Late_Rate_P75) as late_max,
    min(Cancellation_Rate_P75) as cancel_min,
    max(Cancellation_Rate_P75) as cancel_max
  from {{ ref('route_priority') }}
)
select
  'origin' as grain,
  o.late_min,
  o.late_max,
  o.cancel_min,
  o.cancel_max
from origin_cuts o
where o.late_min != o.late_max
   or o.cancel_min != o.cancel_max
   or round(o.late_min, 4) != 0.2959
   or round(o.cancel_min, 4) != 0.0306
union all
select
  'route' as grain,
  r.late_min,
  r.late_max,
  r.cancel_min,
  r.cancel_max
from route_cuts r
where r.late_min != r.late_max
   or r.cancel_min != r.cancel_max
   or round(r.late_min, 4) != 0.3095
   or round(r.cancel_min, 4) != 0.0283
