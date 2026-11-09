{{ config(materialized='view') }}

select distinct
  Year_Month_Key,
  Flight_Year,
  Flight_Month,
  make_date(Flight_Year, Flight_Month, 1) as Month_Start
from {{ ref('fact_flight') }}
