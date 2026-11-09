# Methodology

Rules for how the project measures JetBlue domestic disruption. Facts about the file come from `DATA_AUDIT.md` (reviewed 8 October 2026). The exploratory rankings are in `FINDINGS.md` (run 25 October 2026). Scope decisions are marked as decisions. This file does not choose risk-score weights.

Nothing here is a causal estimate. An association between a schedule attribute and an outcome is not a claim that changing the attribute will change the outcome.

## Locked decisions

- **Geography.** Domestic only: the 50 states, the District of Columbia, Puerto Rico, and the U.S. Virgin Islands. `SJU` and `STT` are in. `BQN`, `PSE`, and `STX` are in the same domestic extract. Mexico and the rest of the Caribbean are out.
- **Carrier.** `Reporting_Airline` = `B6`. That is the multi-year analysis key. `DOT_ID_Reporting_Airline` = `20409` and `IATA_CODE_Reporting_Airline` = `B6` agree in this window. The IATA code is not the analysis key.
- **Source.** BTS Reporting Carrier On-Time Performance. The flight file is the official monthly download. The download form does not filter to a carrier. Rows are kept when `Reporting_Airline` is `B6`. No scraper.
- **On time.** Arrival delay under 15 minutes, which is `ArrDel15` = 0 on an operated flight. `ArrDel15` = 1 is a late arrival (15 minutes or more). The table profile uses the same rule: on time means arrival less than 15 minutes after the published arrival time.
- **Three outcomes stay separate.** Cancellation (`Cancelled`), diversion (`Diverted`), and arrival delay (`ArrDelay`, `ArrDel15`) are not collapsed into one label.
- **Controllable delay.** Carrier minutes plus late-aircraft minutes. Weather minutes and NAS minutes stay separate. Security minutes stay their own bucket. This split is a reporting-bucket rule, not a finding that JetBlue controls every carrier minute. The carrier bucket is broad.
- **Blanks.** A blank cause minute is not zero. Cause-minute KPIs use only rows where BTS populated the cause.
- **Priority idea.** Priority is risk with volume: delay minutes on busy places, read beside the delay rate. There is no weighted score. The written rules are in the priority framework below and in `origin_priority` and `route_priority`.
- **Window.** Flight dates 1 January 2018 through 31 July 2026. That is 103 consecutive months. The window stays this full span. See time handling.
- **Stack.** Python cleans the extract and produced the exploratory pass. Databricks SQL in catalog `jetblue_capstone` holds the flight file. dbt Core builds the tested views in `dbt_dev` and the dashboard model in `powerbi_star`. Excel compares attention lists. Power BI is the finished dashboard, `Jetblue_Final_analysis.pbix`. There is no machine-learning model, no forecast, and no peer airline.

## Closed decisions

Late arrival stays `ArrDel15` = 1. Cancellation, diversion, and arrival delay stay separate. There is no second “severe disruption” minute cutoff.

`Month` and `DayOfWeek` are the calendar units. Weekday results are in `weekday_performance`. The calendar-month table pools every year, including 2020. There is no coarser season bucket and no weighted risk score.

## Priority framework

The framework is a set of flags, not a score. A place can carry more than one flag. A high rate does not outrank a high minute total.

Volume floors, unchanged: origins with at least 1,000 flights, directed routes with at least 500 flights.

| Flag | Rule |
| --- | --- |
| High accumulated impact | Among places that meet the volume floor, the 10 with the most arrival-delay minutes. |
| Elevated late-arrival rate | Meets the volume floor, and the late-arrival rate is at or above the 75th percentile of that volume-qualified set. |
| Elevated cancellation rate | Meets the volume floor, and the cancellation rate is at or above the 75th percentile of that volume-qualified set. |
| Monitoring | Below the volume floor and at least 250 flights, with a late-arrival rate at or above the same 75th percentile. |

Places under 250 flights are left off the list. On the 2 November 2026 build, the origin cutoffs were 29.59% late and 3.06% cancelled. The route cutoffs were 30.95% late and 2.83% cancelled. Those percentiles are calculated in the views. They are not typed in as weights.

Arrival-delay minutes on operated flights use `ArrDelayMinutes`, which floors an early arrival at zero. Average minutes per operated flight uses that field. It is not the mean of signed `ArrDelay`. Controllable share uses the five cause buckets on late arrivals only.

## KPIs

Rates below are the definitions used in `FINDINGS.md` and the definitions the Databricks views must reproduce. The counts are the audit’s measured denominators. Year 2020 and January–July 2026 are reported as their own periods whenever a rate is pooled with other years.

Operated means `Cancelled` = 0 and `Diverted` = 0 (2,052,821 rows).

| KPI | Formula | Rows that are out of the measure |
| --- | --- | --- |
| Late-arrival rate | `ArrDel15` = 1 divided by operated flights | Cancelled and diverted rows, where `ArrDel15` is blank. A blank is not on time. |
| On-time arrival rate | `ArrDel15` = 0 divided by operated flights | Same exclusions. This is the DOT on-time share. |
| Cancellation rate | `Cancelled` = 1 divided by all flights in the period | None. Diversions are not cancellations. |
| Diversion rate | Diverted and not cancelled, divided by all flights in the period | Cancelled rows stay in the cancellation rate only. |
| Cancellation mix | Share of cancelled flights in codes `A`, `B`, `C`, and `D` | Non-cancelled rows, where `CancellationCode` is blank. |
| Arrival-delay minutes | Sum of `ArrDelayMinutes` on operated flights | Blank `ArrDelayMinutes` (cancelled and diverted). Early arrivals contribute 0, which is the official floor on this field. |
| Signed arrival delay | `ArrDelay`, which keeps early arrivals as negative minutes | Not the volume used for priority. Same blanks as `ArrDelay`. |
| Controllable delay minutes | `CarrierDelay` + `LateAircraftDelay` | Only rows with `ArrDel15` = 1. Blanks are not filled with zero. |
| Weather delay minutes | `WeatherDelay` | Same late-arrival rows only. |
| NAS delay minutes | `NASDelay` | Same late-arrival rows only. |
| Security delay minutes | `SecurityDelay` | Same late-arrival rows only. Not added to controllable, weather, or NAS. |
| Late-departure rate | `DepDel15` = 1 among rows where `DepDel15` is populated | A secondary description. The on-time headline is arrival. Blanks match missing `DepTime`. |

On every late-arrival row the five cause-minute fields are populated and sum to `ArrDelayMinutes`. Controllable, weather, NAS, and security minutes are a partition of those late-arrival minutes only. They are not an average delay per scheduled flight.

Departure delay (`DepDelay`, `DepDel15`) describes the departure. It does not replace `ArrDel15`.

Priority is not a weighted formula. `FINDINGS.md` ranks delay-minute volume on busy origins and busy directed routes and shows the delay rate beside that volume. A high delay rate on a thin place is a watch item. No weight is assigned here.

## Grains

**Flight.** One JetBlue scheduled nonstop domestic flight operation. One source row. Within a month the key is `FlightDate`, `Flight_Number_Reporting_Airline`, `Origin`, `Dest`, and `CRSDepTime`. The audit found no duplicate of that key. `Flights` is `1.00` and is not a weight.

**JetBlue × airport × month.** One row per carrier, airport, calendar month, and role. Role is origin or destination. A flight contributes once to its origin airport-month and once to its destination airport-month. The two roles are not averaged into an unlabeled airport row. Airport identity for multi-year work is `OriginAirportID` or `DestAirportID`. The letter codes matched those IDs in this window; the field list still prefers the ID because a code can change or be reused.

**JetBlue × route × month.** One row per carrier, directed `Origin`–`Dest` pair, and calendar month. The reverse direction is a different route. The audit found 718 directed routes, 356 pairs flown in both directions, and 6 pairs flown in one direction only.

Month follows `Year` and `Month` on the row. A route-month or airport-month with flights is not dropped because another month is thin. Thin months stay labeled.

The airport table in `FINDINGS.md` is origin-level for the whole window. The route table there is directed for the whole window. The SQL grain remains airport × month × role, and directed route × month. Views should match the whole-window totals when they are summed, and they should keep the month.

## Time handling

The measured window is locked at 1 January 2018 through 31 July 2026: 103 consecutive months, none missing and none empty. Flight dates run from 2018-01-01 through 2026-07-31. It is not extended earlier. History back to 1987 is on the table profile and was not downloaded.

| Year | JetBlue flights | Months |
| --- | ---: | --- |
| 2018 | 305,010 | January–December |
| 2019 | 297,411 | January–December |
| 2020 | 144,163 | January–December |
| 2021 | 202,702 | January–December |
| 2022 | 273,058 | January–December |
| 2023 | 274,852 | January–December |
| 2024 | 240,282 | January–December |
| 2025 | 231,413 | January–December |
| 2026 | 141,892 | January–July only |

2026 is not a full year and is not annualized to 12 months. The latest posted month on the audit date was July 2026. August 2026 was not on the PREZIP path that day. A later refresh stops at the posted month or waits for the next release.

**2020 is not exchangeable with the other years.** The thinnest month is May 2020 (2,762 flights). Other months under 10,000 flights are April, June, August, September, and October 2020, and January 2021. The fullest month in the window is July 2018 (26,671 flights). A trend that includes 2020 says so. Dropping 2020 without saying so is not allowed.

**From January 2026, marketed codeshare flights may be included.** Directive No. 40 is effective 1 January 2026. The layout has no column to split operated flights from marketed codeshare flights. Rates for 2026 carry that limit.

`FlightDate` is stored as `YYYY-MM-DD` even though the field list says `yyyymmdd`. Scheduled and actual times are local `hhmm`, not timestamps, and they are not converted to a single time zone here. Midnight in the directive is `2400`. Calendar comparisons use `FlightDate`, `Year`, `Month`, and `DayOfWeek`.

The reporting frequency is monthly. A month is posted after it ends.

## Cause-minute rule

Sum carrier, weather, NAS, security, and late-aircraft minutes only on rows where those fields are populated. In this extract that is `ArrDel15` = 1. Do not impute zero on the 1,501,068 operated on-time rows, the 50,674 cancelled rows, or the 7,288 diverted rows.

Cancelled flights are classified with `CancellationCode` (`A` carrier, `B` weather, `C` NAS, `D` security). They do not receive delay minutes.

`WeatherDelay` is the extreme-weather category. It is not a reconstruction of every weather minute inside `NASDelay`. No external weather series is joined in this phase. Weather waits.

## Status of the work

| Work | Status | Rule that binds it |
| --- | --- | --- |
| Load of the official monthly downloads, keeping `B6` | Done in Python | No scraper. The form does not filter to JetBlue. Raw flight files are not committed. The warehouse is Databricks catalog `jetblue_capstone`. |
| Exploratory analysis | Done | See `FINDINGS.md`. Rank delay minutes with volume. Keep controllable minutes separate from weather, NAS, and security. |
| SQL views | Done | Eight views in `jetblue_capstone.dbt_dev`: `monthly_performance`, `airport_month`, `route_month`, `delay_causes`, `weekday_performance`, `cancellation_reason`, `origin_priority`, and `route_priority`. Use that schema. Copies in `jetblue_capstone.views` are not part of the dbt project. |
| dbt | Done | `dbt build` on 8 November 2026 passed 13 views and 37 tests. That is the 8 analytical views in `dbt_dev` and the 5 dashboard views in `powerbi_star`. July 2023 remains 22,853 flights, 21,108 operated, 9,794 late arrivals, 1,564 cancellations, and 1,085,438 arrival-delay minutes. Origin minutes for JFK, Boston, Fort Lauderdale, Orlando, and San Juan match `FINDINGS.md`. |
| Weekday and cancellation mix | Done | `weekday_performance` and `cancellation_reason`. Cancellation codes stay separate from delay minutes. |
| Risk scores | Not used | No weights. The priority framework above is the ranking method. |
| Strategic priority list | Done | `origin_priority` and `route_priority`. First attention remains JFK, Boston, Fort Lauderdale, Orlando, and San Juan. The origin rollup of `dbt_dev.airport_month` matched those minute totals on 2 November 2026. |
| Excel attention lists | Done | `Jetblue_sensitivity_analysis.xlsx`. `Raw Data` is the origin extract. `Airports` ranks origins by minutes and by late-arrival rate. `Scenario` compares five list rules. The plan is the first five origins by minutes. `Scorecard` sets that list beside the five highest late-arrival rates. No dollar figure and no forecast. 2020 and January–July 2026 stay labeled. |
| Power BI star | Done | `fact_flight`, `dim_month`, `dim_weekday`, `dim_origin`, and `dim_route` in `jetblue_capstone.powerbi_star`. Counts stay on the fact. Flags stay on the origin and route dimensions. |
| Power BI dashboard | Done | `Jetblue_Final_analysis.pbix`. Pages: Overview, Three Events, Minutes, Rate and Size, Patterns, Attention. Rates are measures on `Fact_Flight`. `origin_priority` is used on Overview and Attention. The workbook comparison is not rebuilt in the report. |
| Recommendations | Written | `FINDINGS.md` and `EXECUTIVE_DECISION_MEMO.md`. Claims stay inside `BUSINESS_PROBLEM.md`. |

Left off the core path: Census attributes, T-100, Monte Carlo simulation, an independent weather feed, a peer airline, a machine-learning model, and any severe-disruption minute cutoff.

## Completed project

The analysis is complete. Python, the dbt views, the priority framework, the Excel workbook, and the Power BI report are done. The cleaned flight file stays local. Published rankings come from `jetblue_capstone.dbt_dev`. The dashboard reads `jetblue_capstone.powerbi_star`. Copies in `jetblue_capstone.views` are not the dbt build. The audit’s overall call remains GO for domestic disruption inside the limits above. The ranking in `FINDINGS.md` is the `dbt_dev` ranking.
