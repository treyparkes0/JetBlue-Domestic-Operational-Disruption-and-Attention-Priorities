with causes as (
  select count(*) as cause_rows
  from {{ ref('delay_causes') }}
),
late as (
  select sum(Late_Arrivals_15_Plus) as late_rows
  from {{ ref('monthly_performance') }}
)
select causes.cause_rows, late.late_rows
from causes
cross join late
where causes.cause_rows != late.late_rows
