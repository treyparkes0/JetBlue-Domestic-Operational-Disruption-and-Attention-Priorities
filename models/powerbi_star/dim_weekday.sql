{{ config(materialized='view') }}

select
  Day_of_Week,
  case Day_of_Week
    when 1 then 'Monday'
    when 2 then 'Tuesday'
    when 3 then 'Wednesday'
    when 4 then 'Thursday'
    when 5 then 'Friday'
    when 6 then 'Saturday'
    when 7 then 'Sunday'
  end as Day_Name
from (
  select explode(array(1, 2, 3, 4, 5, 6, 7)) as Day_of_Week
)
