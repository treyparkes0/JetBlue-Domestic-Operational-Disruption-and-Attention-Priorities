select 'July 2023 is missing from monthly_performance' as problem
where (
  select count(*)
  from {{ ref('monthly_performance') }}
  where Flight_Year = 2023
    and Flight_Month = 7
) != 1
