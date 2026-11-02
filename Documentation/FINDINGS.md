# Findings: JetBlue domestic operational risk

**Reconciled:** 2 November 2026  
**Warehouse:** `jetblue_capstone.dbt_dev`  
**Python check:** `src/jetblue_eda.py`, same date, against `data/raw/jetblue_b6.csv`  
**Question:** where JetBlue’s domestic operational risk is concentrated, what is associated with it, and where limited attention should go first.

These figures are descriptive. An association is not a cause. None of them is a dollar saving. Definitions are in `METHODOLOGY.md`.

## Executive summary

Over 1 January 2018 through 31 July 2026, JetBlue reported 2,110,783 domestic flights. Of those, 2,052,821 operated, 551,753 arrived 15 minutes or more late (26.9% of operated flights), 50,674 were cancelled (2.40%), and 7,288 were diverted and not cancelled.

Arrival-delay minutes are concentrated. Five origins — JFK, Boston, Fort Lauderdale, Orlando, and San Juan — account for 22,045,754 of the 44,184,241 arrival-delay minutes, which is 49.9%. The next five — Newark, LaGuardia, DCA, West Palm Beach, and LAX — bring the share to 65.4%.

The rate does not follow the same order. Boston has more departures than JFK and a lower late-arrival rate (25.4% versus 27.8%). JFK still has more minutes. Fort Lauderdale and Orlando combine a rate near 30% with a large base, so they sit in both the minute ranking and the top quartile of late-arrival rate. Miami is the clearest reliability watch item with a real base: 13,280 flights and a 34.3% late-arrival rate, outside the top 10 by minutes.

Sunday has the highest late-arrival rate (29.5%), the highest cancellation rate (2.88%), and the most minutes. Friday is the busiest day and is not the least reliable. Wednesday is the most reliable day. July is the heaviest calendar month. About 76.4% of recorded late-arrival cause minutes are carrier plus late aircraft.

The cancellation forecast for August 2026–July 2027 is 280,987 flights and 10,716 baseline cancellations. Cutting cancellations 5%, 10%, and 15% while holding flights fixed avoids 536, 1,072, and 1,607 cancellations. Those are scenario counts. The holdout missed by 2.31 percentage points on average.

## Overall operational performance

| Measure | Value | Denominator |
| --- | ---: | --- |
| Flights | 2,110,783 | Scheduled flights in the window |
| Operated | 2,052,821 | Not cancelled and not diverted |
| Late arrivals | 551,753 | 26.9% of operated flights |
| Cancellations | 50,674 | 2.40% of all flights |
| Diversions, not cancelled | 7,288 | 0.345% of all flights |
| Arrival-delay minutes | 44,184,241 | Operated flights. Early arrivals are stored as 0 |
| Average minutes per operated flight | 21.5 | Same floored field. Not signed delay |

2020 is inside these totals and is not a normal year. 2026 is January–July only (141,892 flights) and is not annualized. From January 2026 the file may include marketed codeshare flights, and no column splits them out.

July 2023 remains the check month: 22,853 flights, 21,108 operated, 9,794 late arrivals, 1,564 cancellations, 1,085,438 arrival-delay minutes. April 2020 was a cancellation month (35.8% cancelled, 6,886 flights). July 2026, inside the partial year, was already severe: 37.8% late and 9.8% cancelled.

## Airport performance

Origin role only. `dbt_dev.airport_month` matched the Python flight counts and minute totals for the airports below. The test `origin_ranking_matches_findings` passed.

| Origin | Flights | Late-arrival rate | Cancellation rate | Minutes | Avg minutes |
| --- | ---: | ---: | ---: | ---: | ---: |
| JFK | 317,477 | 27.8% | 2.64% | 6,516,458 | 21.1 |
| BOS | 350,117 | 25.4% | 2.35% | 6,312,537 | 18.5 |
| FLL | 170,468 | 30.0% | 2.03% | 3,778,579 | 22.7 |
| MCO | 144,635 | 30.2% | 2.15% | 3,508,770 | 24.9 |
| SJU | 82,442 | 28.8% | 1.71% | 1,929,410 | 23.9 |
| EWR | 66,090 | 29.6% | 2.80% | 1,555,224 | 24.3 |
| LGA | 65,340 | 28.1% | 3.32% | 1,469,175 | 23.3 |
| DCA | 68,037 | 24.3% | 2.54% | 1,375,259 | 20.8 |
| PBI | 64,081 | 27.1% | 2.56% | 1,355,351 | 21.8 |
| LAX | 71,555 | 22.3% | 1.18% | 1,117,182 | 15.9 |

DCA and LAX are large with better rates. Long Beach is the low-rate contrast: 21,520 flights, 17.5% late, 11.6 average minutes.

Miami is 13,280 flights, 34.3% late, 2.43% cancelled, 389,840 minutes, 30.2 average minutes. Denver is 11,117 flights and 33.0% late. Both clear the 1,000-flight floor and the late-arrival quartile. Neither is in the top 10 by minutes.

## Route reliability

Directed routes. MCO → JFK is not JFK → MCO. `route_mco_jfk_matches_findings` passed: 22,110 flights and 612,862 minutes.

| Route | Flights | Late-arrival rate | Cancellation rate | Minutes | Avg minutes |
| --- | ---: | ---: | ---: | ---: | ---: |
| MCO → JFK | 22,110 | 31.8% | 2.7% | 612,862 | 28.5 |
| DCA → BOS | 28,525 | 23.6% | 2.9% | 576,647 | 20.8 |
| JFK → MCO | 22,131 | 31.2% | 2.6% | 544,366 | 25.4 |
| FLL → JFK | 20,095 | 31.2% | 2.8% | 521,764 | 26.8 |
| BOS → DCA | 28,514 | 22.6% | 2.7% | 466,135 | 16.8 |
| JFK → BOS | 19,499 | 29.4% | 3.0% | 457,141 | 24.2 |
| MCO → BOS | 18,702 | 29.8% | 2.7% | 454,498 | 25.0 |
| JFK → FLL | 20,101 | 29.8% | 2.6% | 444,200 | 22.8 |
| MCO → EWR | 14,407 | 35.9% | 2.7% | 434,041 | 31.1 |
| BOS → MCO | 18,694 | 29.2% | 2.5% | 404,274 | 22.3 |

Four of those ten also sit in the route late-arrival quartile (cutoff 30.95%): MCO → JFK, JFK → MCO, FLL → JFK, and MCO → EWR. Boston–Washington carries a similar minute load at a rate in the low 20s because the flight count is larger.

FLL → EWR is the other high-rate route with a real base: 10,993 flights, 35.8% late, 299,164 minutes. JFK ↔ LAX is the contrast: 26,919 and 26,918 flights, late-arrival rates 21.2% and 20.3%, and 397,855 and 394,262 minutes.

## Day of week

`weekday_performance`, Monday = 1 through Sunday = 7. The test matched these counts. All years are pooled, including 2020.

| Day | Flights | Late-arrival rate | Cancellation rate | Minutes | Avg minutes |
| --- | ---: | ---: | ---: | ---: | ---: |
| Monday | 313,919 | 28.1% | 2.57% | 6,946,921 | 22.8 |
| Tuesday | 289,951 | 23.7% | 2.20% | 5,283,487 | 18.7 |
| Wednesday | 290,286 | 23.5% | 2.17% | 5,114,853 | 18.1 |
| Thursday | 313,830 | 28.0% | 2.25% | 6,798,707 | 22.2 |
| Friday | 314,540 | 28.6% | 2.31% | 6,949,800 | 22.7 |
| Saturday | 275,512 | 26.1% | 2.38% | 5,719,780 | 21.3 |
| Sunday | 312,745 | 29.5% | 2.88% | 7,370,693 | 24.4 |

Friday has the most flights. Sunday has the highest late-arrival rate, the highest cancellation rate, and the most minutes. Wednesday has the lowest late-arrival rate and the fewest minutes, and it is not the lightest day. Saturday has the fewest flights. The busiest day is not the least reliable day, and the lightest day is not the most reliable day.

Calendar month, all years pooled, is unchanged from the 25 October run. July is the heaviest month on both late-arrival rate (33.6%) and minutes (5,754,997). October is the lightest late-arrival month (21.1%). March’s cancellation rate (4.2%) is pulled up by 2020. August–December in that pooled table do not include 2026.

## Cancellation codes

`cancellation_reason` covers cancelled flights only. All 50,674 have a code. The test matched A 14,477, B 18,287, C 11,154, and D 6,756. There is no Unknown row. This split is not the delay-minute split.

| Code | Reason | Cancellations | Share |
| --- | --- | ---: | ---: |
| A | Carrier | 14,477 | 28.6% |
| B | Weather | 18,287 | 36.1% |
| C | National Air System | 11,154 | 22.0% |
| D | Security | 6,756 | 13.3% |

Security is not a standing pattern. 6,755 of the 6,756 security codes are in 2020, and 6,749 of those are March and April 2020, across large origins rather than one station. One security-coded cancellation is in May 2023. Outside 2020, weather is 42.5% of cancellations, carrier 31.5%, NAS 25.9%, and security is that one flight.

January is the weather month (4,672 weather cancellations). July is the NAS month (3,456). In January–July 2026, weather is 2,888 of 5,668 cancellations (50.9%). That partial year is not annualized.

## Delay causes

Cause minutes are on the 551,753 late arrivals only. `delay_causes` has that row count, and the minute sums match the Python check. Blanks on other flights are not zeros. The five buckets sum to 42,253,000 minutes.

| Cause | Minutes | Share |
| --- | ---: | ---: |
| Late aircraft | 16,561,970 | 39.2% |
| Carrier | 15,714,126 | 37.2% |
| NAS | 8,744,129 | 20.7% |
| Weather | 1,145,370 | 2.7% |
| Security | 87,405 | 0.2% |
| Carrier + late aircraft | 32,276,096 | 76.4% |

`WeatherDelay` is the extreme-weather bucket. It is not every weather minute inside NAS. The 76.4% figure is a reporting association on flights that already arrived 15 or more minutes late. It does not say those minutes were avoidable.

Arrival-delay minutes (44,184,241) are larger than cause minutes because operated flights with a delay under 15 minutes still contribute floored `ArrDelayMinutes`, and those flights have blank cause fields.

## Forecast

`Jetblue_Analysis.xlsx`, sheet `Forecast`. The method was not changed on 2 November 2026.

Flights and the cancellation rate are forecast separately with `FORECAST.ETS`, seasonality 12. Baseline cancellations are forecast flights times the forecast rate. The fit is January 2021–July 2026, so 2020 is excluded. The horizon is August 2026–July 2027. January–July 2026 stays labeled as a partial year.

The holdout fits January 2021–July 2025 and scores August 2025–July 2026. Average absolute error is 2.31 percentage points (`Forecast!L25` = 0.02306). April 2026 and July 2026 are the large misses. A percentage error on a near-zero cancellation month is not the headline.

## Scenario analysis

Sheets `Scenario` and `Scenario_Summary`. Flights stay at the forecast. The 5%, 10%, and 15% cuts apply to baseline cancellations. Cancellations avoided are baseline minus the scenario count.

| | August 2026–July 2027 |
| --- | ---: |
| Forecast flights | 280,987 |
| Baseline cancellations | 10,716 |
| Avoided at 5% | 536 |
| Avoided at 10% | 1,072 |
| Avoided at 15% | 1,607 |

August 2026 alone is 23,232 flights, 844 baseline cancellations, and 42 cancellations avoided at 5%. These counts are a sensitivity. They are not a measured saving and they do not say a management action will produce the cut.

The old `Sheet3` pivot summed 2018 late-arrival rates to 3.27. That sheet was removed. It is not a finding.

## Operational prioritization

Rules are in `METHODOLOGY.md`. Flags come from `origin_priority` and `route_priority`. A place can have more than one flag.

**High accumulated impact.** The ten origins in the airport table above, and the ten routes in the route table above.

**Elevated late-arrival rate, and also high impact.** Fort Lauderdale (30.0%), Orlando (30.2%), and Newark (29.6%) clear the origin quartile of 29.59%. On routes, MCO → JFK, JFK → MCO, FLL → JFK, and MCO → EWR clear 30.95%.

**Elevated late-arrival rate, outside the minute top 10.** Miami and Denver are the ones with a meaningful base. Smaller origins also clear the quartile, including Houston Intercontinental, Phoenix, Seattle, San Antonio, Albuquerque, and Newburgh. They are reliability items. They are not ahead of JFK on minutes.

**Elevated cancellation rate.** The origin cutoff is 3.06%. LaGuardia is the one that is also in the minute top 10 (3.32%). Several smaller Northeast origins are higher still, led by Nantucket at 4.85%, with a late-arrival rate that is not in the top quartile. A high cancellation rate is a different problem from a high late-arrival rate.

**Monitoring.** Six origins between 250 and 999 flights clear the late-arrival quartile: Asheville, Wilmington (NC), Hayden, Norfolk, Vero Beach, and Hyannis. Twenty-seven directed routes sit between 250 and 499 flights and clear the route quartile. An example is LAS → BDL, 251 flights and a 51.9% late-arrival rate. That rate is real in the file and too thin to investigate first. Origins under 250 flights, including a few with rates above 40%, stay off the list.

JFK, Boston, San Juan, DCA, West Palm Beach, and LAX are in the minute top 10 and are not in the late-arrival quartile. Boston–Washington is the same pattern on routes. Volume with a better rate still holds a large share of the minutes, so it stays in the first group.

## What management should investigate

These are places to look. They are not a claim that a particular change will cut delay.

1. JFK and Boston departure banks, turns, and late-aircraft patterns. Together they hold 12.8 million arrival-delay minutes. Boston’s rate is better than JFK’s. The network cause mix says late aircraft and carrier are the large buckets on flights that are already late.
2. Fort Lauderdale and Orlando, and the Florida–New York routes, especially July–August and December. Those origins are in both the minute ranking and the late-arrival quartile. MCO → EWR and FLL → EWR are the high-rate routes with a real base.
3. Sunday, and then Friday. Sunday combines the worst rate with the most minutes. Friday is the busiest day and is close behind on rate.
4. Miami as a station reliability review: 34.3% late on 13,280 departures, without being a top-10 minute airport.
5. LaGuardia’s cancellation rate (3.32%) beside its minute rank, separate from the late-arrival question.
6. Leave March–April 2020 security-coded cancellations out of a current security review. Leave airports and routes under 250 flights out of the first pass.

## Limitations

- Public BTS reports, not JetBlue’s internal operation. No passengers, fares, crew, maintenance, or independent weather.
- No causal estimate and no dollar figure. The scenario holds flights fixed and applies an assumed cut.
- 2020 is not exchangeable with other years. Weekday, calendar-month, and whole-window rates pool it unless a view is filtered.
- 2026 is seven months. Marketed codeshares may be included and cannot be split out.
- Blank delay fields are not zero. Cause minutes exist only on late arrivals.
- `WeatherDelay` is not every weather-related minute.
- Origin and destination are separate. Counting both would double-count flights.
- Average minutes use the floored delay field.
- The forecast’s average miss is 2.31 percentage points. Individual months, especially April 2026 and July 2026, miss by more.
- The quartile flags describe this network. They are not a score that can be compared with another airline.
