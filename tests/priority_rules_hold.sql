select
  Airport,
  Total_Flights,
  Minute_Rank,
  High_Accumulated_Impact,
  Elevated_Late_Arrival,
  Monitoring
from {{ ref('origin_priority') }}
where (Airport = 'JFK' and (Minute_Rank != 1 or High_Accumulated_Impact != 1))
   or (Airport = 'BOS' and (Minute_Rank != 2 or High_Accumulated_Impact != 1 or Elevated_Late_Arrival != 0))
   or (Airport = 'MIA' and (Total_Flights < 1000 or Elevated_Late_Arrival != 1 or High_Accumulated_Impact != 0))
   or (Airport = 'LGB' and Elevated_Late_Arrival != 0)
   or (Monitoring = 1 and (Total_Flights < 250 or Total_Flights >= 1000))
   or (High_Accumulated_Impact = 1 and Total_Flights < 1000)
