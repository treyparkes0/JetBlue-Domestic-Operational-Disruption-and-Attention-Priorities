select
  Flight_Year,
  Flight_Month,
  Origin_Airport_ID,
  Destination_Airport_ID,
  count(*) as row_count
from {{ ref('route_month') }}
group by Flight_Year, Flight_Month, Origin_Airport_ID, Destination_Airport_ID
having count(*) > 1
