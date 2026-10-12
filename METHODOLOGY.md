# Methodology

Rules for how later phases measure JetBlue domestic disruption. Facts about the file come from `DATA_AUDIT.md` (reviewed 8 October 2026). Scope decisions are marked as decisions. This phase does not compute the rankings, fit a model, or choose weights.

Nothing here is a causal estimate. An association between a pre-flight attribute and an outcome is not a claim that changing the attribute will change the outcome.

## Locked decisions

- **Geography.** Domestic only: the 50 states, the District of Columbia, Puerto Rico, and the U.S. Virgin Islands. `SJU` and `STT` are in. `BQN`, `PSE`, and `STX` are in the same domestic extract. Mexico and the rest of the Caribbean are out.
- **Carrier.** `Reporting_Airline` = `B6`. That is the multi-year analysis key. `DOT_ID_Reporting_Airline` = `20409` and `IATA_CODE_Reporting_Airline` = `B6` agree in this window. The IATA code is not the analysis key.
- **Source.** BTS Reporting Carrier On-Time Performance. The flight file is the official monthly download. The download form does not filter to a carrier. Rows are kept when `Reporting_Airline` is `B6`. No scraper.
- **On time.** Arrival delay under 15 minutes, which is `ArrDel15` = 0 on an operated flight. `ArrDel15` = 1 is a late arrival (15 minutes or more). The table profile uses the same rule: on time means arrival less than 15 minutes after the published arrival time.
- **Three outcomes stay separate.** Cancellation (`Cancelled`), diversion (`Diverted`), and arrival delay (`ArrDelay`, `ArrDel15`) are not collapsed into one label.
- **Controllable delay.** Carrier minutes plus late-aircraft minutes. Weather minutes and NAS minutes stay separate. Security minutes stay their own bucket. This split is a reporting-bucket rule, not a finding that JetBlue controls every carrier minute. The carrier bucket is broad.
- **Blanks.** A blank cause minute is not zero. Cause-minute KPIs use only rows where BTS populated the cause.
- **Priority idea.** Later priority is risk with volume: delay minutes on busy places, not the delay rate alone. Weights are not set.
- **Model, later.** One logistic regression. It is an input to a priority list, not the center of the project. Features are pre-flight only. Historical airport and route rates use earlier flights only.
- **Peer, later.** One same-airport peer. Not a multi-airline study. The peer is not chosen in this phase.
- **Window available.** Flight dates 1 January 2018 through 31 July 2026. See time handling. The window may still be narrowed. A different window is not locked.

## Open decisions

**Severe-disruption cutoff: open.** The audit does not publish the arrival-delay distribution, so no minute cutoff is justified. This phase does not set 30 minutes, 60 minutes, or any other threshold. Phase 5 has to supply that distribution before a cutoff can be chosen. Until then, “severe disruption” is not a field and not a model label. Cancellation, diversion, and arrival delay stay separate. They are not combined to fill the gap.

Also open, and not filled in here:

- Whether the working window stays the full 103 months or is narrowed inside 1 January 2018 through 31 July 2026.
- A coarser season bucket. `Month` and `DayOfWeek` are the locked calendar units.
- Risk-score weights. A later risk write-up writes them down. High rate on a thin place is not automatically high priority.
- Which one carrier is the same-airport peer.
- The logistic-regression positive class. It cannot be chosen until the cutoff question above is closed, and it cannot be a blend of cancellation, diversion, and a minute threshold.
- The warehouse product. The later phase plan still names S3 as the landing place for the load. These documents do not lock that choice and do not switch the project to Snowflake.

## KPIs

Rates below are definitions for later phases. The counts are the audit’s measured denominators, not the business answer. Year 2020 and January–July 2026 are reported as their own periods whenever a rate is pooled with other years.

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

Priority is not a formula in this phase. When it is built, it ranks delay-minute volume on busy airports and busy directed routes above the delay rate alone. A high delay rate on a thin place is a watch item, not an automatic first priority. No weight is assigned here.

## Grains

**Flight.** One JetBlue scheduled nonstop domestic flight operation. One source row. Within a month the key is `FlightDate`, `Flight_Number_Reporting_Airline`, `Origin`, `Dest`, and `CRSDepTime`. The audit found no duplicate of that key. `Flights` is `1.00` and is not a weight.

**JetBlue × airport × month.** One row per carrier, airport, calendar month, and role. Role is origin or destination. A flight contributes once to its origin airport-month and once to its destination airport-month. The two roles are not averaged into an unlabeled airport row. Airport identity for multi-year work is `OriginAirportID` or `DestAirportID`. The letter codes matched those IDs in this window; the field list still prefers the ID because a code can change or be reused.

**JetBlue × route × month.** One row per carrier, directed `Origin`–`Dest` pair, and calendar month. The reverse direction is a different route. The audit found 718 directed routes, 356 pairs flown in both directions, and 6 pairs flown in one direction only.

Month follows `Year` and `Month` on the row. A route-month or airport-month with flights is not dropped because another month is thin. Thin months stay labeled.

## Time handling

The measured window is 1 January 2018 through 31 July 2026: 103 consecutive months, none missing and none empty. Flight dates run from 2018-01-01 through 2026-07-31. The window can still be narrowed. It is not extended earlier in this phase. History back to 1987 is on the table profile and was not downloaded.

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

**2020 is not exchangeable with the other years.** The thinnest month is May 2020 (2,762 flights). Other months under 10,000 flights are April, June, August, September, and October 2020, and January 2021. The fullest month in the window is July 2018 (26,671 flights). A trend or a model that includes 2020 says so. Dropping 2020 without saying so is not allowed.

**From January 2026, marketed codeshare flights may be included.** Directive No. 40 is effective 1 January 2026. The layout has no column to split operated flights from marketed codeshare flights. Rates for 2026 carry that limit.

`FlightDate` is stored as `YYYY-MM-DD` even though the field list says `yyyymmdd`. Scheduled and actual times are local `hhmm`, not timestamps, and they are not converted to a single time zone here. Midnight in the directive is `2400`. Calendar comparisons use `FlightDate`, `Year`, `Month`, and `DayOfWeek`.

The reporting frequency is monthly. A month is posted after it ends.

## Leakage rules

A later model uses pre-flight information only.

**Allowed inputs.** `FlightDate` and its calendar parts, `Reporting_Airline`, `Flight_Number_Reporting_Airline`, `Origin`, `Dest`, the DOT airport IDs, `CRSDepTime`, `CRSArrTime`, and `Distance`. Historical airport rates and historical route rates built only from flights with an earlier `FlightDate`.

**Not inputs.** Actual departure and arrival clocks (`DepTime`, `ArrTime`). Signed and floored delay (`DepDelay`, `ArrDelay`, `DepDelayMinutes`, `ArrDelayMinutes`). The 15-minute flags (`DepDel15`, `ArrDel15`). `Cancelled`, `Diverted`, and `CancellationCode`. The five cause-minute fields. Taxi time, which the audit did not verify as a column and which is an outcome if it appears later. The flight’s own outcome, and any rate that includes that flight or a later flight.

Same-calendar-day flights are not treated as earlier. Times are local `hhmm`, not an ordered timestamp, so same-day rows are not used as if they were already known.

Cause minutes leak the late-arrival label: they are populated exactly on `ArrDel15` = 1. `CancellationCode` leaks cancellation. Neither can be a feature for a disruption label.

The positive class is open because the severe-disruption cutoff is open. Phase 5 publishes the delay distribution first. Phase 7, when it is built, is one logistic regression and reports precision, recall, F1, ROC-AUC, and a confusion matrix for the class that was actually defined. Those metrics are not computed here.

## Peer-benchmark rule

A later phase may add one other reporting carrier at the same airport, from the same BTS table, for the same month, under the same on-time rule. The point is to see whether an airport’s disruption shows up for that peer as well, so a JetBlue airport result is not read as unique to JetBlue by default.

The peer is one carrier, not a panel of airlines. It is not chosen here. The comparison does not use Census data and does not put T-100 on the core path. It does not create a dollar gap or a causal gap between carriers.

## Cause-minute rule

Sum carrier, weather, NAS, security, and late-aircraft minutes only on rows where those fields are populated. In this extract that is `ArrDel15` = 1. Do not impute zero on the 1,501,068 operated on-time rows, the 50,674 cancelled rows, or the 7,288 diverted rows.

Cancelled flights are classified with `CancellationCode` (`A` carrier, `B` weather, `C` NAS, `D` security). They do not receive delay minutes.

`WeatherDelay` is the extreme-weather category. It is not a reconstruction of every weather minute inside `NASDelay`. No external weather series is joined in this phase. Weather waits.

## What is deferred

| Later work | Rule that already binds it |
| --- | --- |
| Load of the official monthly downloads, keeping `B6` | No scraper. The form does not filter to JetBlue. Raw files are not committed. Warehouse product is not locked. The later phase plan still names S3. This project is not switched to Snowflake here. |
| Marts for flights, airports, routes, risk, and priorities | Must reproduce the audit’s grain, keys, and blank rules. |
| Exploratory analysis | Trends, airports, routes, and calendar. Rank delay minutes and volume, not the delay rate alone. Publish the arrival-delay distribution before any severe cutoff. Separate controllable minutes from weather and NAS. |
| Risk scores | Weights written down before use. A thin high-rate place is not automatically first. |
| One logistic regression | Pre-flight features only. Earlier flights only. Not the center of the project. |
| Strategic priority list | Volume with risk first. High risk and low volume is a watch item. Uses the written weights and the model. Does not invent weights in advance. |
| Scenarios | 5, 10, and 15 percent cases on disrupted-flight counts at the priority locations. No dollar savings unless a cited cost is labeled as an external assumption. No cost is cited here, so no dollar figure is in scope. |
| Dashboard | Reads the measures above. It is not built here. |
| Recommendations | Written from those results. Claims stay inside `BUSINESS_PROBLEM.md`. |

Also deferred, and not added to the core path: Census attributes, T-100, Monte Carlo simulation, an independent weather feed, and any severe-disruption minute cutoff.

## What this phase does not build

No ingestion, SQL, dbt project, model, Excel workbook, Power BI report, or warehouse was built. The monthly BTS files are not in the repository. The audit’s overall call remains GO for domestic disruption inside the limits above. That call is not a ranking and not a recommendation.
