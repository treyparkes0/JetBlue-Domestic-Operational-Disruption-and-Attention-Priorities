# Data audit: JetBlue domestic on-time performance

**Review date:** 8 October 2026  
**Question this file must be able to serve later:** where JetBlue’s operational risk is concentrated, what is associated with it, and where management should focus.  
**This audit does not answer that question.** It records what was in the file.

**Call: GO.** Every field the project needs is in the flight-level file. The measured JetBlue extract covers 1 January 2018 through 31 July 2026, which is the latest month posted. No required field is absent. The extract is domestic only. Do not read it as international coverage.

This file review was completed on 8 October 2026. Current status of the views, the forecast, and the priority framework is in `METHODOLOGY.md`.

## Dataset

| Item | Value |
| --- | --- |
| Name | Reporting Carrier On-Time Performance (1987-present) |
| TranStats table parameter | `gnoyr_VQ=FGJ` |
| Publisher | Bureau of Transportation Statistics, U.S. Department of Transportation |
| What was measured | Reporting carrier `B6` (JetBlue Airways), calendar months January 2018 through July 2026 |
| Rows measured | 2,110,783 JetBlue flights |
| Grain | One scheduled nonstop domestic flight operation |

The table profile, read the same day, describes the full table as on-time arrival and departure data for nonstop domestic flights by month and year, by carrier and by origin and destination airport, including scheduled and actual departure and arrival times, cancelled and diverted flights, causes of delay and cancellation, and nonstop distance. That profile listed 235,010,356 records, 109 fields, first year 1987, last year 2026, monthly frequency, and latest available data of July 2026. Those figures are the whole table. The counts below are the JetBlue rows actually read.

## Source

Official pages used, and not replaced with invented columns:

- Table profile: https://transtats.bts.gov/TableInfo.asp?QO_fu146_anzr=b0-gvzr&V0s1_b0yB=D&gnoyr_VQ=FGJ
- Field list: https://www.transtats.bts.gov/Fields.asp?gnoyr_VQ=FGJ (the list is paged; the second page was opened so the `Div5` fields were included)
- Download form: https://www.transtats.bts.gov/DL_SelectFields.aspx?gnoyr_VQ=FGJ
- Cause and cancellation rules: BTS Technical Directive No. 40, On-Time Performance, issued 17 November 2025, effective 1 January 2026, https://www.bts.gov/explore-topics-and-geography/modes/aviation/number-40-technical-directive-reporting-time
- Carrier lookups linked from the download form, saved only as local checks and not committed

The monthly files that were measured are the TranStats PREZIP extracts of this same table. The `readme.html` inside each zip says the file was extracted from Reporting Carrier On-Time Performance (1987-present) in the On-Time database, and that the year and month are in the zip name.

## Carrier code

The field list tells the analyst which code to use. `Reporting_Airline` is described as: “Unique Carrier Code. When the same code has been used by multiple carriers, a numeric suffix is used for earlier users, for example, PA, PA(1), PA(2). Use this field for analysis across a range of years.” `IATA_CODE_Reporting_Airline` is described as an IATA code that is not always unique, with the instruction “For analysis, use the Unique Carrier Code.”

The lookup linked from `Reporting_Airline` on the download form lists:

| Code | Description |
| --- | --- |
| B6 | JetBlue Airways |

There is no `B6(1)` or other suffixed JetBlue code on that list. The lookup linked from `IATA_CODE_Reporting_Airline` was returned as `L_CARRIER_HISTORY.csv` and lists `B6` as “JetBlue Airways (2000 - )”. The airline-ID lookup lists `20409` as “JetBlue Airways: B6”.

The extract was filtered on `Reporting_Airline` = `B6`, which is the field the dictionary says to use. In these months the three identifiers do not disagree. Across 57,090,030 rows of all carriers:

| Check | Rows |
| --- | --- |
| `Reporting_Airline` = `B6` | 2,110,783 |
| `IATA_CODE_Reporting_Airline` = `B6` | 2,110,783 |
| `DOT_ID_Reporting_Airline` = `20409` | 2,110,783 |
| All three true on the same row | 2,110,783 |
| `B6` on one field but not the others | 0 |

JetBlue is also named on the 2026 reporting-carrier list in Technical Directive No. 40.

## Time period actually obtained

The working window was calendar year 2018 through the latest posted month. The field list and the table profile both said the latest available data was July 2026. The August 2026 PREZIP URL returned HTTP 404. July 2026 was present.

Every month from January 2018 through July 2026 was read: 103 months, 0 missing, 0 empty. Flight dates on the JetBlue rows run from **2018-01-01** through **2026-07-31**.

| Year | JetBlue flights | Months in the file |
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
| **Total** | **2,110,783** | **103 months** |

The thinnest month is May 2020 (2,762 flights). Other months under 10,000 flights are April, June, August, September, and October 2020, and January 2021. The fullest month in the window is July 2018 (26,671 flights). Year 2026 is not a full year.

## Grain

The table is flight-segment grain, not airline-month grain and not ticket grain. The table profile describes nonstop domestic flights. Technical Directive No. 40 defines a flight, for reporting to the Department, as a scheduled nonstop operation identified by a flight number and an origin-destination pair, and a flight operation as that flight on a given day.

On every one of the 2,110,783 JetBlue rows, `Flights` is `1.00`. Within each month, the key `FlightDate` + `Flight_Number_Reporting_Airline` + `Origin` + `Dest` + `CRSDepTime` had no duplicate.

## JetBlue coverage

| Measure | Count |
| --- | ---: |
| Flights | 2,110,783 |
| Distinct origins | 91 |
| Distinct destinations | 91 |
| Airports in either role | 91 (the origin set and the destination set are the same) |
| Distinct DOT origin airport IDs | 91 |
| Distinct DOT destination airport IDs | 91 |
| Directed routes (`Origin`–`Dest`) | 718 |
| Routes flown in both directions | 356 |
| Routes flown in one direction only | 6 |
| Calendar years with rows | 9 (2018–2026, with 2026 partial) |

The six one-direction pairs in this window are `BUR`–`FLL`, `LGA`–`BUF`, `LGA`–`SYR`, `MIA`–`SFO`, `ORH`–`PBI`, and `SWF`–`PBI`.

Each airport code maps to one `OriginAirportID` or `DestAirportID`, and each ID maps to one code. No code reuse showed up inside this window. The field list still says to use the airport ID for analysis across a range of years, because a code can change or be reused. That advice stands even though this window did not need a crosswalk.

Airports are in 35 states plus Puerto Rico and the U.S. Virgin Islands. State codes with no JetBlue airport in this extract: Alabama, Arkansas, Delaware, Hawaii, Indiana, Iowa, Kansas, Kentucky, Mississippi, Nebraska, North Dakota, Oklahoma, South Dakota, West Virginia, and Wyoming. That is network coverage, not a broken file.

`DCA` and `IAD` are both present. Their city name is `Washington, DC` and their state code is `VA`. No row uses state code `DC`. Washington flying is in the file. It is coded to Virginia, which is where those airports sit in this table.

Puerto Rico and the U.S. Virgin Islands are in the file:

| Airport | City name on the row | State | DOT airport ID | Role |
| --- | --- | --- | --- | --- |
| `SJU` | San Juan, PR | PR | 14843 | origin and destination |
| `BQN` | Aguadilla, PR | PR | 10732 | origin and destination |
| `PSE` | Ponce, PR | PR | 14254 | origin and destination |
| `STT` | Charlotte Amalie, VI | VI | 15024 | origin and destination |
| `STX` | Christiansted, VI | VI | 15027 | origin and destination |

Departures with origin state `PR`: 97,207. Arrivals with destination state `PR`: 97,214. Departures and arrivals with state `VI`: 6,597 each. Those are state totals. This audit did not split them into per-airport flight counts. San Juan (`SJU`) and St. Thomas (`STT`, Charlotte Amalie) are in the airport set. St. Croix (`STX`) is also in, which is inside the U.S. Virgin Islands.

Every origin state and every destination state on these rows is in the 50 states, the District of Columbia, Puerto Rico, or the U.S. Virgin Islands. No blank state, no Mexico, and no other Caribbean airport appeared. The file does not cover JetBlue flying to Mexico or to the rest of the Caribbean. Do not claim international coverage.

## Columns verified

The flight file has 109 columns. The same 109 names were on all 103 months. They match the download form and the field list, including the `Div5` fields on the second page of the field list. Two names on the field browser are analysis summaries, not columns in the flight file: `*OntimeArrivalPct` and `*OntimeDeparturePct`. On-time status in the flight file is the 15-minute indicators below.

Official names for the fields the project needs, all present:

| Needed concept | Official field name | In the file |
| --- | --- | --- |
| Flight date | `FlightDate` | Yes |
| Reporting airline | `Reporting_Airline` | Yes |
| Flight number | `Flight_Number_Reporting_Airline` | Yes |
| Origin | `Origin` | Yes |
| Destination | `Dest` | Yes |
| Scheduled departure | `CRSDepTime` | Yes |
| Actual departure | `DepTime` | Yes |
| Departure delay | `DepDelay` | Yes |
| Scheduled arrival | `CRSArrTime` | Yes |
| Actual arrival | `ArrTime` | Yes |
| Arrival delay | `ArrDelay` | Yes |
| Cancellation indicator | `Cancelled` | Yes |
| Cancellation reason | `CancellationCode` | Yes |
| Diversion | `Diverted` | Yes |
| Distance | `Distance` | Yes |
| Carrier delay minutes | `CarrierDelay` | Yes |
| Weather delay minutes | `WeatherDelay` | Yes |
| NAS delay minutes | `NASDelay` | Yes |
| Security delay minutes | `SecurityDelay` | Yes |
| Late-aircraft delay minutes | `LateAircraftDelay` | Yes |
| Departure 15-minute flag | `DepDel15` | Yes |
| Arrival 15-minute flag | `ArrDel15` | Yes |

**No required field is absent.**

Related fields that are also in the file, and that later work will confuse with the fields above if they are mixed:

| Official name | Official description | Why it is not a substitute |
| --- | --- | --- |
| `DepDelayMinutes` | Difference in minutes between scheduled and actual departure time. Early departures set to 0. | Floors early departures at zero. `DepDelay` keeps the negative. |
| `ArrDelayMinutes` | Difference in minutes between scheduled and actual arrival time. Early arrivals set to 0. | Same floor. `ArrDelay` keeps the negative. |
| `DOT_ID_Reporting_Airline` | DOT identification number of the unique airline | Agreed with `B6` in this window. The field list still says to use `Reporting_Airline` for multi-year analysis. |
| `IATA_CODE_Reporting_Airline` | IATA code, not always unique | Agreed with `B6` here. The field list says not to prefer it for multi-year analysis. |
| `OriginAirportID`, `DestAirportID` | DOT airport ID. Use for airport analysis across years because codes can change or be reused. | Stable versus `Origin` and `Dest` in this window. |
| `Year`, `Month`, `DayofMonth`, `DayOfWeek` | Calendar parts | Complete on every JetBlue row. `FlightDate` is the date. |
| `Flights` | Number of Flights | `1.00` on every JetBlue row. |

The field list groups the five cause fields under “Cause of Delay (Data starts 6/2003)”. June 2003 is before this window.

## Data types

The CSV stores every value as text. Types below are the official description plus the pattern observed on the JetBlue rows. Times follow Technical Directive No. 40: local time, 24-hour clock, reported as `hhmm` (3:15 p.m. is `1515`; the directive says midnight is `2400`).

| Official name | Official description | Observed on JetBlue rows |
| --- | --- | --- |
| `FlightDate` | Flight Date (yyyymmdd) | ISO dates `YYYY-MM-DD`, for example `2018-01-17`. The description says `yyyymmdd`. The file uses hyphens. No blanks. |
| `Reporting_Airline` | Unique Carrier Code. Use this field for analysis across a range of years. | Text `B6` on every row. |
| `Flight_Number_Reporting_Airline` | Flight Number | Digits, for example `375`. No blanks. |
| `Origin` | Origin Airport | Three-letter code. No blanks. |
| `Dest` | Destination Airport | Three-letter code. No blanks. |
| `CRSDepTime` | CRS Departure Time (local time: hhmm) | Digits, zero-padded in the text (`0700`, `1127`). No blanks. |
| `DepTime` | Actual Departure Time (local time: hhmm) | Same clock, or blank. |
| `DepDelay` | Difference in minutes between scheduled and actual departure time. Early departures show negative numbers. | Decimal minutes, including negatives (`-8.00`, `33.00`), or blank. |
| `CRSArrTime` | CRS Arrival Time (local time: hhmm) | Digits. No blanks. |
| `ArrTime` | Actual Arrival Time (local time: hhmm) | Digits, or blank. |
| `ArrDelay` | Difference in minutes between scheduled and actual arrival time. Early arrivals show negative numbers. | Decimal minutes, including negatives, or blank. |
| `Cancelled` | Cancelled Flight Indicator (1=Yes) | `0.00` or `1.00`. No blanks. |
| `CancellationCode` | Specifies The Reason For Cancellation | Blank, or `A`, `B`, `C`, `D`. |
| `Diverted` | Diverted Flight Indicator (1=Yes) | `0.00` or `1.00`. No blanks. |
| `Distance` | Distance between airports (miles) | Decimal miles (`992.00`). No blanks. |
| `CarrierDelay` | Carrier Delay, in Minutes | Decimal minutes, or blank. |
| `WeatherDelay` | Weather Delay, in Minutes | Decimal minutes, or blank. |
| `NASDelay` | National Air System Delay, in Minutes | Decimal minutes, or blank. |
| `SecurityDelay` | Security Delay, in Minutes | Decimal minutes, or blank. |
| `LateAircraftDelay` | Late Aircraft Delay, in Minutes | Decimal minutes, or blank. |
| `DepDel15` | Departure Delay Indicator, 15 Minutes or More (1=Yes) | `0.00`, `1.00`, or blank. |
| `ArrDel15` | Arrival Delay Indicator, 15 Minutes or More (1=Yes) | `0.00`, `1.00`, or blank. |

`DepDelayMinutes` and `ArrDelayMinutes` are decimals as well. Their blanks match `DepDelay` and `ArrDelay`. The samples of `DepDelayMinutes` are non-negative, which matches the official rule that early departures are set to 0.

The cancellation lookup linked from the download form defines the letters as `A` Carrier, `B` Weather, `C` National Air System, and `D` Security. Directive No. 40 uses the same letters and labels them Air Carrier, Weather, National Aviation System, and Security. The five minute fields are the delay categories in that directive: carrier, weather, national aviation system, security, and late-arriving aircraft.

## Missingness

Blanks below are empty cells. They are not a second code for zero. A populated zero is stored as `0.00`.

Identifiers, schedule, and distance are complete.

| Field | Blank rows | Share of 2,110,783 |
| --- | ---: | ---: |
| `FlightDate` | 0 | 0 |
| `Reporting_Airline` | 0 | 0 |
| `Flight_Number_Reporting_Airline` | 0 | 0 |
| `Origin` | 0 | 0 |
| `Dest` | 0 | 0 |
| `CRSDepTime` | 0 | 0 |
| `CRSArrTime` | 0 | 0 |
| `Cancelled` | 0 | 0 |
| `Diverted` | 0 | 0 |
| `Distance` | 0 | 0 |

Status counts, which are the denominators for the blanks that remain:

| Status | Rows | Rule used |
| --- | ---: | --- |
| Cancelled (`Cancelled` = 1) | 50,674 | 2.40% of all rows |
| Diverted and not cancelled | 7,288 | 0.345% of all rows |
| Operated: not cancelled and not diverted | 2,052,821 | The rest |
| Late arrival (`ArrDel15` = 1) | 551,753 | All of these are operated flights |

Departure and arrival clocks are blank only when the flight did not produce that time.

| Field | Blank rows | Where the blanks are |
| --- | ---: | --- |
| `DepTime` | 49,339 | All on cancelled flights. 1,335 cancelled flights still have a departure time. Operated and diverted rows have none blank. |
| `DepDelay` | 49,339 | Same rows as `DepTime`. |
| `DepDel15` | 49,339 | Same rows as `DepTime`. |
| `ArrTime` | 51,581 | All 50,674 cancelled flights, plus 907 diverted flights. The other 6,381 diverted flights have an arrival time. |
| `ArrDelay` | 57,962 | All 50,674 cancelled flights and all 7,288 diverted flights. Zero blanks on operated flights. |
| `ArrDel15` | 57,962 | Same rows as `ArrDelay`. |

The field list, on `DivArrDelay`, says the `ArrDelay` column remains null for all diverted flights. That is what these rows do, including the diverted flights that still have an `ArrTime`.

`CancellationCode` is blank on 2,060,109 rows, which is every row that is not cancelled. It is populated on all 50,674 cancelled rows:

| Code | Lookup label | Cancelled flights |
| --- | --- | ---: |
| A | Carrier | 14,477 |
| B | Weather | 18,287 |
| C | National Air System | 11,154 |
| D | Security | 6,756 |

The five cause-minute fields are blank on the same 1,559,030 rows and populated on the same 551,753 rows. The split is the late-arrival flag, not a random hole:

| Situation | Rows | Cause minutes |
| --- | ---: | --- |
| `ArrDel15` = 1 | 551,753 | All five fields populated on every row. The five minutes sum to `ArrDelayMinutes` on every row. |
| Operated and not late | 1,501,068 | All five fields blank on every row. |
| Cancelled | 50,674 | All five fields blank. The cancellation reason is in `CancellationCode`, not in the minute fields. |
| Diverted | 7,288 | All five fields blank. |

Directive No. 40 says causal data are required for cancelled flights and for flights that arrive 15 minutes or more after the scheduled arrival time, and are not required for on-time flights or diverted flights. The minute fields follow that rule. A blank cause is not a measured zero, and it is not evidence that the column is missing. Filling those blanks with zero would treat an on-time flight as a recorded zero for each cause.

`DepDel15` on rows where it is populated is `0.00` (1,511,364) or `1.00` (550,080). `ArrDel15` where populated is `0.00` (1,501,068) or `1.00` (551,753). The table profile defines a flight as on time when it arrives less than 15 minutes after its published arrival time. That comparison is `ArrDel15`, and it is complete for operated flights.

## Update frequency

The table profile says the frequency is monthly. On 8 October 2026 the latest posted month was July 2026. A month is posted after it ends. August 2026 was not on PREZIP that day. A later phase that needs a full recent year has to stop at the posted month or wait for the next release. History back to 1987 is on the table profile. It was not downloaded. This audit’s window starts in January 2018.

## Download method

The download form selects columns, a year, a month, and a state under geography. It does not offer a carrier filter. A carrier-filtered extract was not available from that form.

What was read instead:

1. One zip per month from `https://transtats.bts.gov/PREZIP/On_Time_Reporting_Carrier_On_Time_Performance_1987_present_{YEAR}_{MONTH}.zip`, for 2018_1 through 2026_7.
2. Each zip contains one CSV of all reporting carriers and a `readme.html`. The CSV header uses the official field names.
3. Rows were kept when `Reporting_Airline` was `B6`. The other carriers were counted and discarded.
4. The zips were not committed. They were removed after the counts were taken. This repository does not contain a data directory.

57,090,030 all-carrier rows were scanned to produce the 2,110,783 JetBlue rows.

## Limitations

1. **Domestic only.** The table profile defines domestic operations as the 50 states, the District of Columbia, Puerto Rico, and the U.S. Virgin Islands. Directive No. 40 uses that geography and also says “territories and possessions,” and it excludes transborder operations. Nothing outside the 50 states, D.C., Puerto Rico, and the U.S. Virgin Islands appeared in the JetBlue rows. Mexico and the rest of the Caribbean are not in this file. JetBlue’s international operation is invisible here.
2. **Scheduled reported flights.** Directive No. 40 says extra sections, nonscheduled flights, and charters are not in the Part 234 on-time file. The file is not JetBlue’s entire operation.
3. **Cause buckets are broad.** Carrier delay mixes maintenance, crew, baggage, and other items the carrier reports in that bucket. The file cannot separate those items. Weather in `WeatherDelay` is the extreme-weather category, not every weather minute that may sit inside `NASDelay`.
4. **No cost, load, safety, or aircraft-type outcome.** There is no passenger count, fare, crew roster, maintenance record, or independent weather observation in the columns that were verified. `Tail_Number` is a column. Its missingness was not measured, and it is not an aircraft type. A disruption score can be built. A dollar loss or a safety rate cannot.
5. **2020 is not exchangeable with the other years.** May 2020 has 2,762 flights against a July 2018 peak of 26,671. A trend or a model that pools 2020 with other years has to say so.
6. **2026 is partial, and the reporting rule changed.** Only January–July 2026 are posted. Directive No. 40, effective 1 January 2026, tells reporting carriers to include codeshare flights they market. The 109-column layout did not add a column that separates operated flights from marketed codeshare flights. Those 2026 rows cannot be split on that distinction.
7. **State code `DC` is unused.** Washington, D.C. airports in this extract are coded `VA`. Fifteen states have no JetBlue airport here.
8. **Clock and delay fields are easy to misuse.** `FlightDate` is documented as `yyyymmdd` and stored as `YYYY-MM-DD`. Times are local `hhmm`, not timestamps. `DepDelayMinutes` and `ArrDelayMinutes` hide early flights. Cause blanks are not zeros.
9. **The file is a carrier report to BTS.** It is not JetBlue’s internal operations database. Gate times follow the definitions on the table profile and in Directive No. 40.

## Fit for academic use

Yes, with citation and with the limits above.

The table is a public BTS release of Form 234 on-time reports. The table profile, field list, and download form did not present a paid license or a bar on academic use. The measured files were not added to git. A later write-up should cite Bureau of Transportation Statistics, Reporting Carrier On-Time Performance (1987-present), and should state the window 2018-01 through 2026-07 and the filter `Reporting_Airline` = `B6`.

The file is fit to describe and model domestic schedule disruption. It is not fit to stand in for international flying, for profit, or for a cause more specific than the five delay buckets and the four cancellation codes.

## Feasibility

The later question is where domestic operational risk is concentrated, what is associated with it, and where management should focus. “Risk” in this file can mean reported disruption: cancellation, diversion, arrival delay, the 15-minute flags, and the cause mix. It cannot mean international exposure, dollar loss, or safety incidents.

| Use | Call | Why |
| --- | --- | --- |
| Trend analysis | GO | 103 consecutive months, January 2018 through July 2026, with no empty month. 2020 and partial 2026 have to be labeled, not dropped in silence. |
| Airport analysis | GO | 91 airports, with origin, destination, city, state, and a DOT airport ID that did not split from the code in this window. |
| Route analysis | GO | 718 directed routes. Both directions are separate routes. Six pairs appear in one direction only. |
| Predictive modeling | GO, bounded | Flight-level outcomes and schedule, airport, route, distance, and calendar are present and, for operated flights, the delay and 15-minute fields are complete. The model cannot see loads, fares, aircraft type, or a weather feed. Cause minutes exist only for late arrivals. |
| Seasonal analysis | GO | `FlightDate`, `Month`, and `DayOfWeek` are complete, and the window covers more than eight summers and winters. |
| Operational risk scoring | GO, for domestic disruption | The file can rank airports, routes, and seasons by cancellation, diversion, arrival delay, and cause mix, and it is large enough to do that. It cannot score Mexico, the rest of the Caribbean, cost, or safety. |

**Overall: GO.** Nothing required is missing. The file can support the business question inside the domestic scope that was decided. It does not answer where management should focus. That answer is later work.

**Not a STOP.** A STOP would require a missing field, an empty JetBlue extract, or a file that could not see airports, routes, time, and disruption. None of those is true.

## What was not done

No ingestion pipeline, database, dbt project, model, Excel workbook, Power BI report, or AWS resource was built. Raw monthly extracts are not in the repository. This document is the Phase 1 audit only.
