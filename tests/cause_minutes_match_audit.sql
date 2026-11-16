with totals as (
  select
    cast(sum(Late_Aircraft_Delay) as bigint) as Late_Aircraft_Delay,
    cast(sum(Carrier_Delay) as bigint) as Carrier_Delay,
    cast(sum(National_Air_System_Delay) as bigint) as National_Air_System_Delay,
    cast(sum(Weather_Delay) as bigint) as Weather_Delay,
    cast(sum(Security_Delay) as bigint) as Security_Delay
  from {{ ref('delay_causes') }}
)
select
  Late_Aircraft_Delay,
  Carrier_Delay,
  National_Air_System_Delay,
  Weather_Delay,
  Security_Delay
from totals
where Late_Aircraft_Delay != 16561970
   or Carrier_Delay != 15714126
   or National_Air_System_Delay != 8744129
   or Weather_Delay != 1145370
   or Security_Delay != 87405
