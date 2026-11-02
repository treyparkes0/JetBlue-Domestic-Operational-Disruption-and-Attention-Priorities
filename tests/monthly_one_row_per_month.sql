select Flight_Year, Flight_Month, count(*) as row_count
from {{ ref('monthly_performance') }}
group by Flight_Year, Flight_Month
having count(*) > 1
