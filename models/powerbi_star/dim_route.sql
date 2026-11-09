{{ config(materialized='view') }}

select
  Route_Key,
  Origin_Airport,
  Destination_Airport,
  Minute_Rank,
  High_Accumulated_Impact,
  Elevated_Late_Arrival,
  Elevated_Cancellation,
  Monitoring
from {{ ref('route_priority') }}
