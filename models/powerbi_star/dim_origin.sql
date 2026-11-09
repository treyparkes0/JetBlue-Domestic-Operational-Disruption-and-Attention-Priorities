{{ config(materialized='view') }}

select
  Airport_ID,
  Airport,
  City,
  State,
  Minute_Rank,
  High_Accumulated_Impact,
  Elevated_Late_Arrival,
  Elevated_Cancellation,
  Monitoring
from {{ ref('origin_priority') }}
