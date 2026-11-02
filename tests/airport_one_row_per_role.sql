select Flight_Year, Flight_Month, Role, Airport_ID, count(*) as row_count
from {{ ref('airport_month') }}
group by Flight_Year, Flight_Month, Role, Airport_ID
having count(*) > 1
