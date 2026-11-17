# Findings: JetBlue domestic operational risk

**Findings reconciled:** 2 November 2026  
**Workbook and dashboard documentation:** 8 November 2026  
**Latest documented dbt validation:** 16 November 2026 (`dbt build`, 13 views and 40 tests; see `METHODOLOGY.md`)  
**Warehouse:** `jetblue_capstone.dbt_dev`  
**Python check:** `src/jetblue_eda.py`, against `data/raw/jetblue_b6.csv` (aligned to the 2 November 2026 reconciliation)  
**Question:** where JetBlue’s domestic operational risk is concentrated, what is associated with it, and where limited attention should go first.

Central message: domestic operational disruption is concentrated across specific airports, routes, and time periods. Management should distinguish accumulated operational impact (arrival-delay minutes) from elevated reliability rates (late-arrival or cancellation rates) when prioritizing attention. Diversions and reported delay causes stay separate measures.

These figures are descriptive. An association is not a cause. None of them is a dollar saving. Definitions are in `METHODOLOGY.md`.

## Executive summary

Over 1 January 2018 through 31 July 2026, JetBlue reported 2,110,783 domestic flights. Of those, 2,052,821 operated, 551,753 arrived 15 minutes or more late (26.9% of operated flights), 50,674 were cancelled (2.40%), and 7,288 were diverted and not cancelled.

Arrival-delay minutes are concentrated. Five origins — JFK, Boston, Fort Lauderdale, Orlando, and San Juan — account for 22,045,754 of the 44,184,241 arrival-delay minutes, which is 49.9%. The next five — Newark, LaGuardia, DCA, West Palm Beach, and LAX — bring the share to 65.4%.

The rate does not follow the same order. Boston has more departures than JFK and a lower late-arrival rate (25.4% versus 27.8%). JFK still has more minutes. Fort Lauderdale and Orlando combine a rate near 30% with a large base, so they sit in both the minute ranking and the top quartile of late-arrival rate. Miami is the clearest reliability watch item with a real base: 13,280 flights and a 34.3% late-arrival rate, outside the top 10 by minutes.

Sunday has the highest late-arrival rate (29.5%), the highest cancellation rate (2.88%), and the most minutes. Friday is the busiest day and is not the least reliable. Wednesday is the most reliable day. July is the heaviest calendar month. Both leads hold with 2020 removed: Sunday is 30.8% late and 7,175,925 minutes, and July is 34.9% late and 5,671,988 minutes. About 76.4% of recorded late-arrival cause minutes are carrier plus late aircraft. That is a reporting association. It is not a claim that those minutes were avoidable.

The workbook compares attention lists. The first five origins by minutes cover 49.9% of arrival-delay minutes. The five highest late-arrival rates cover 0.17%. That comparison is in the workbook section below.

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

Miami is 13,280 flights, 34.3% late, 2.43% cancelled, 389,840 minutes, 30.2 average minutes. Denver is 11,117 flights and 33.0% late. Both clear the 1,000-flight floor and the late-arrival quartile. Neither is in the top 10 by minutes. Miami is minute rank 22.

In 2022 through 2025 the same four origins stay at the top by minutes: JFK, Boston, Orlando, and Fort Lauderdale. Orlando moves ahead of Fort Lauderdale inside that window. LaGuardia replaces San Juan as fifth, with 1,050,166 minutes against San Juan’s 1,008,950. Over the full window San Juan is fifth and LaGuardia is seventh. That swap does not change the first review.

## Route reliability

Directed routes. MCO → JFK is not JFK → MCO. `route_mco_jfk_matches_findings` passed: 22,110 flights and 612,862 minutes. `route_mco_ewr_matches_findings` locks MCO → EWR at 14,407 flights and 434,041 minutes. `route_fll_ewr_matches_findings` locks FLL → EWR at 10,993 flights and 299,164 minutes. `miami_laguardia_match_findings` locks Miami at 13,280 flights and minute rank 22, and LaGuardia at 65,340 flights, 2,168 cancellations, and minute rank 7.

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

Sunday’s gap is a winter gap. With every year included, Sunday’s late-arrival rate sits above the other days by 7.4 points in January, 4.6 in February, 5.9 in March, 5.0 in November, and 4.4 in December. In July the gap is 0.9 points, 34.4% against 33.5% on the other days. In August Sunday is 0.6 points lower than the other days. In September it is 1.0 point lower. July is a high late-arrival month on every day. A Sunday review belongs with the winter operation. It does not explain July.

Calendar month, all years pooled, is unchanged from the 25 October run. July is the heaviest month on both late-arrival rate (33.6%) and minutes (5,754,997). October is the lightest late-arrival month (21.1%). March’s cancellation rate (4.2%) is pulled up by 2020. August–December in that pooled table do not include 2026.

The same measures were rerun on 8 November 2026 with 2020 left out. The full-window query reproduced the locked Sunday counts (312,745 flights, 89,337 late arrivals, 7,370,693 minutes) and the locked July totals (33.6% late, 5,754,997 minutes). Rates are summed late arrivals divided by summed operated flights.

| Measure | All years, including 2020 | 2020 removed |
| --- | ---: | ---: |
| Sunday late-arrival rate | 29.5% | 30.8% |
| Sunday arrival-delay minutes | 7,370,693 | 7,175,925 |
| July late-arrival rate | 33.6% | 34.9% |
| July arrival-delay minutes | 5,754,997 | 5,671,988 |

Sunday still has the highest late-arrival rate, the highest cancellation rate (2.79%), and the most minutes. Friday is next on the late-arrival rate, at 29.6%. July still has the highest late-arrival rate and the most minutes. August and December both round to 32.0% late. August has 4,284,267 minutes and December has 3,942,031. With 2020 removed, January has the highest calendar-month cancellation rate, at 4.22%. August–December in that cut still do not include 2026.

With 2020 and 2026 both removed, so every calendar month covers the same years, July is still first, at 34.5% late and 4,941,707 minutes.

## Cancellation codes

`cancellation_reason` covers cancelled flights only. All 50,674 have a code. The test matched A 14,477, B 18,287, C 11,154, and D 6,756. There is no Unknown row. This split is not the delay-minute split.

| Code | Reason | Cancellations | Share |
| --- | --- | ---: | ---: |
| A | Carrier | 14,477 | 28.6% |
| B | Weather | 18,287 | 36.1% |
| C | National Air System | 11,154 | 22.0% |
| D | Security | 6,756 | 13.3% |

Security is not a standing pattern. 6,755 of the 6,756 security codes are in 2020, and 6,749 of those are March and April 2020, across large origins rather than one station. Six of the 2020 security-coded cancellations are in July, not March–April. One security-coded cancellation is in May 2023. Outside 2020, weather is 42.5% of cancellations, carrier 31.5%, NAS 25.9%, and security is that one flight.

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

## Attention lists

`Jetblue_sensitivity_analysis.xlsx`. `Raw Data` is the origin extract. `Airports` ranks each origin by arrival-delay minutes and by late-arrival rate. `Scenario` and `Scorecard` compare lists. They do not forecast, and they do not assign a new rank.

The plan is the first five origins by minutes: JFK, Boston, Fort Lauderdale, Orlando, and San Juan.

| List of five | Minutes | Share of minutes | Flights | Share of flights | Cancellations | Late-arrival rate |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| First five by minutes | 22,045,754 | 49.9% | 1,065,139 | 50.5% | 24,551 | 27.7% |
| Five highest late-arrival rates | 75,342 | 0.17% | 2,340 | 0.11% | 70 | 35.8% |

The rate list is Traverse City (74 flights), Boise (39), Asheville (303), Wilmington, NC (273), and Newburgh (1,651). That list has no volume floor. Traverse City and Boise are under 250 flights, so `origin_priority` leaves them off the monitoring list. Asheville and Wilmington sit in the 250–999 monitoring band. Newburgh is the only origin on the list with at least 1,000 flights. The rate is higher, and four of the five bases are small. The five together are still 0.17% of arrival-delay minutes. Newark is the largest minute airport left off the first five. LaGuardia is the cancellation airport left off the first five. Extending the minutes list to ten origins brings the share to 65.4%. The option that adds the largest cancellation airport left off the first five covers six origins. Its formula cutoff stays at five so that airport is not counted twice.

The workbook also offers the first ten by minutes, the five origins with the most cancellations, and the first five by minutes plus the largest cancellation airport left off. Each option reports the share of minutes, flights, and cancellations that list covers. These are coverage counts. They are not a measured saving, and they do not say a management action will produce a cut.

These totals include 2020. 2026 is January–July only. Shares are summed counts divided by the network total. The late-arrival rate on a list is late flights divided by flights that operated.

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

1. Review JFK and Boston first. Together they hold 12.8 million arrival-delay minutes, 29% of the 44.2 million. JFK has 317,477 flights and a 27.8% late-arrival rate. Boston has 350,117 flights and a 25.4% late-arrival rate. Boston flies more and is late less often. JFK still has more minutes. These are arrival-delay minutes on flights that departed the origin. Ask whether turns and late aircraft explain the gap. The file does not show that cause. On late flights, the recorded mix is 39.2% late aircraft and 37.2% carrier. That mix does not prove those minutes were avoidable.
2. Review MCO → JFK, MCO → EWR, and FLL → EWR, with the review month guided by each route’s pattern. MCO → JFK is 22,110 flights, 31.8% late, and 612,862 minutes. MCO → EWR is 14,407 flights, 35.9% late, and 434,041 minutes. FLL → EWR is 10,993 flights, 35.8% late, and 299,164 minutes. July is the strongest disruption month network-wide, and July is also first when these three routes are taken together; August is second for that combined view. That does not mean July is the best review month for every individual route. For FLL → EWR, April has more arrival-delay minutes than July, while July has the higher late-arrival rate. Leave December off the first list: June has more of these routes’ combined minutes than December does. Use each route’s monthly minute and rate pattern to set the review window. Fort Lauderdale and Orlando are in both the minute ranking and the late-arrival quartile.
3. Review Sunday, then Friday. Sunday has 312,745 flights, a 29.5% late-arrival rate, and 7.37 million minutes. Friday is the busiest day, with 314,540 flights, a 28.6% late-arrival rate, and 6.95 million minutes. With every year included, the Sunday gap is 7.4 points in January and 0.9 points in July. This review does not explain July.
4. Review Miami for late arrivals. 34.3% of Miami flights arrive late, on 13,280 flights. Miami is 22nd by total minutes, so this is a reliability review, not a minute review.
5. Review LaGuardia for cancellations. 2,168 of 65,340 flights were cancelled, 3.32%. LaGuardia is 7th by total minutes and the only top-10 minute airport above the 3.06% cancellation line. That line is the 75th percentile of cancellation rates among origins with at least 1,000 flights. Fort Myers is the next large airport on that cancellation list.
6. Leave the 2020 security-coded cancellations out of a current security review, including the six in July. Leave airports and routes under 250 flights out of the first pass.

## Limitations

- Public BTS reports, not JetBlue’s internal operation. No passengers, fares, crew, maintenance, or independent weather.
- No causal estimate and no dollar figure. The workbook reports the share of the network each attention list covers.
- 2020 is not exchangeable with other years. Weekday, calendar-month, and whole-window rates pool it unless a view is filtered.
- 2026 is seven months. Marketed codeshares may be included and cannot be split out.
- Blank delay fields are not zero. Cause minutes exist only on late arrivals.
- `WeatherDelay` is not every weather-related minute.
- Origin and destination are separate. Counting both would double-count flights.
- Average minutes use the floored delay field.
- The workbook compares coverage of attention lists. It does not estimate the effect of a management action.
- The quartile flags describe this network. They are not a score that can be compared with another airline.
