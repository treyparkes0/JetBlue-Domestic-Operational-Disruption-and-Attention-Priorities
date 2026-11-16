select
  Airport,
  Total_Flights,
  Cancelled_Flights,
  cast(Arrival_Delay_Minutes as bigint) as Arrival_Delay_Minutes,
  Minute_Rank,
  Elevated_Late_Arrival,
  Elevated_Cancellation,
  High_Accumulated_Impact
from {{ ref('origin_priority') }}
where (Airport = 'MIA' and (
    Total_Flights != 13280
    or cast(Arrival_Delay_Minutes as bigint) != 389840
    or Minute_Rank != 22
    or Elevated_Late_Arrival != 1
    or Elevated_Cancellation != 0
    or High_Accumulated_Impact != 0
  ))
   or (Airport = 'LGA' and (
    Total_Flights != 65340
    or Cancelled_Flights != 2168
    or Minute_Rank != 7
    or Elevated_Late_Arrival != 0
    or Elevated_Cancellation != 1
    or High_Accumulated_Impact != 1
  ))
