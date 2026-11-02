# Data dictionary

Fields confirmed in `DATA_AUDIT.md` (reviewed 8 October 2026) for the JetBlue domestic extract. Official names are the BTS names in that audit. This is not a physical table design, and it does not list unverified columns as usable.

## Source and grain

| Item | Value |
| --- | --- |
| Table | Reporting Carrier On-Time Performance (1987-present) |
| Publisher | Bureau of Transportation Statistics, U.S. Department of Transportation |
| TranStats table parameter | `gnoyr_VQ=FGJ` |
| Extract measured | Reporting carrier `B6`, January 2018 through July 2026 |
| Rows | 2,110,783 |
| Columns in the flight file | 109, same names on all 103 months |
| Storage | CSV text. Types below are the official description plus the pattern on the JetBlue rows. |

**Grain.** One scheduled nonstop domestic flight operation. Technical Directive No. 40 defines a flight as a scheduled nonstop operation identified by a flight number and an origin-destination pair, and a flight operation as that flight on a given day. `Flights` is `1.00` on every JetBlue row. Within each month, `FlightDate` + `Flight_Number_Reporting_Airline` + `Origin` + `Dest` + `CRSDepTime` had no duplicate.

Domestic, in the table profile, is the 50 states, the District of Columbia, Puerto Rico, and the U.S. Virgin Islands. Every origin state and destination state on these rows is inside that set.

Two later grains are defined in `METHODOLOGY.md` and are not rows in this file: JetBlue × airport × month, and JetBlue × directed route × month.

## How to read the role column

| Role | Meaning |
| --- | --- |
| Pre-flight | Known from the scheduled operation or the calendar. Allowed as a later model input. |
| Post-flight outcome | Produced by the operation. Not a model input. |
| Cause | Reported reason. Populated only when BTS requires it. Also an outcome, so not a model input. |

A blank cell is empty. It is not a second code for zero. A populated zero is stored as `0.00`.

## Carrier and the analysis key

`Reporting_Airline` is the unique carrier code. The field list says to use it for analysis across a range of years. The lookup lists `B6` as JetBlue Airways. There is no `B6(1)` on that list. The airline-ID lookup lists `20409` as JetBlue Airways: B6.

In this window the three identifiers agree on all 2,110,783 rows, and they disagree on zero rows: `Reporting_Airline` = `B6`, `IATA_CODE_Reporting_Airline` = `B6`, and `DOT_ID_Reporting_Airline` = `20409`. The field list still says not to prefer the IATA code for multi-year analysis, because that code is not always unique.

The download form does not offer a carrier filter. The measured rows are the official monthly files with `Reporting_Airline` = `B6` kept.

## Verified fields

### Pre-flight

| Official name | Official description | Observed on JetBlue rows | Blank rows |
| --- | --- | --- | ---: |
| `FlightDate` | Flight Date (`yyyymmdd`) | ISO dates `YYYY-MM-DD`, for example `2018-01-17`. The description says `yyyymmdd`. The file uses hyphens. | 0 |
| `Reporting_Airline` | Unique Carrier Code. Use this field for analysis across a range of years. | Text `B6` on every row. | 0 |
| `Flight_Number_Reporting_Airline` | Flight Number | Digits, for example `375`. | 0 |
| `Origin` | Origin Airport | Three-letter code. | 0 |
| `Dest` | Destination Airport | Three-letter code. | 0 |
| `CRSDepTime` | CRS Departure Time (local time: `hhmm`) | Digits, zero-padded in the text (`0700`, `1127`). | 0 |
| `CRSArrTime` | CRS Arrival Time (local time: `hhmm`) | Digits. | 0 |
| `Distance` | Distance between airports (miles) | Decimal miles (`992.00`). | 0 |
| `Year` | Calendar part | Complete on every JetBlue row. | 0 |
| `Month` | Calendar part | Complete on every JetBlue row. | 0 |
| `DayofMonth` | Calendar part | Complete on every JetBlue row. | 0 |
| `DayOfWeek` | Calendar part | Complete on every JetBlue row. | 0 |
| `Flights` | Number of Flights | `1.00` on every JetBlue row. | 0 |

`FlightDate` is the date. `Year`, `Month`, `DayofMonth`, and `DayOfWeek` are the calendar parts of that date. Times follow Technical Directive No. 40: local time, 24-hour clock, reported as `hhmm` (3:15 p.m. is `1515`; the directive says midnight is `2400`). They are not timestamps.

Airport identifiers, also pre-flight, and stable against the codes in this window:

| Official name | Official description | Use |
| --- | --- | --- |
| `OriginAirportID` | DOT airport ID. Use for airport analysis across years because codes can change or be reused. | One ID per origin code in this window. 91 distinct origin IDs. |
| `DestAirportID` | Same rule for the destination. | One ID per destination code in this window. 91 distinct destination IDs. |
| `DOT_ID_Reporting_Airline` | DOT identification number of the unique airline. | `20409` on every JetBlue row. Analysis across years still uses `Reporting_Airline`. |
| `IATA_CODE_Reporting_Airline` | IATA code, not always unique. | `B6` on every JetBlue row. Not the preferred multi-year key. |

The origin set and the destination set are the same 91 airports. Each code maps to one airport ID, and each ID maps to one code. No code reuse showed up in this window. The field-list advice to prefer the airport ID across years still stands.

### Post-flight outcomes

| Official name | Official description | Observed on JetBlue rows | Blank rows | Where the blanks are |
| --- | --- | --- | ---: | --- |
| `DepTime` | Actual Departure Time (local time: `hhmm`) | Same clock, or blank. | 49,339 | All on cancelled flights. 1,335 cancelled flights still have a departure time. Operated and diverted rows have none blank. |
| `DepDelay` | Difference in minutes between scheduled and actual departure time. Early departures show negative numbers. | Decimal minutes, including negatives (`-8.00`, `33.00`), or blank. | 49,339 | Same rows as `DepTime`. |
| `DepDel15` | Departure Delay Indicator, 15 Minutes or More (1=Yes) | `0.00`, `1.00`, or blank. | 49,339 | Same rows as `DepTime`. Where populated: `0.00` on 1,511,364 rows and `1.00` on 550,080 rows. |
| `ArrTime` | Actual Arrival Time (local time: `hhmm`) | Digits, or blank. | 51,581 | All 50,674 cancelled flights, plus 907 diverted flights. The other 6,381 diverted flights have an arrival time. |
| `ArrDelay` | Difference in minutes between scheduled and actual arrival time. Early arrivals show negative numbers. | Decimal minutes, including negatives, or blank. | 57,962 | All 50,674 cancelled flights and all 7,288 diverted flights. Zero blanks on operated flights. |
| `ArrDel15` | Arrival Delay Indicator, 15 Minutes or More (1=Yes) | `0.00`, `1.00`, or blank. | 57,962 | Same rows as `ArrDelay`. Where populated: `0.00` on 1,501,068 rows and `1.00` on 551,753 rows. |
| `Cancelled` | Cancelled Flight Indicator (1=Yes) | `0.00` or `1.00`. | 0 | 50,674 rows are `1.00` (2.40 percent). |
| `Diverted` | Diverted Flight Indicator (1=Yes) | `0.00` or `1.00`. | 0 | 7,288 rows are diverted and not cancelled (0.345 percent). |

Status counts used as denominators: cancelled 50,674; diverted and not cancelled 7,288; operated (not cancelled and not diverted) 2,052,821. All 551,753 late arrivals (`ArrDel15` = 1) are operated flights.

The table profile defines a flight as on time when it arrives less than 15 minutes after its published arrival time. That comparison is `ArrDel15`. It is complete for operated flights. A blank `ArrDel15` is a cancelled or diverted flight, not an on-time flight and not a late flight.

The field list, on `DivArrDelay`, says `ArrDelay` remains null for all diverted flights. These rows do that, including the diverted flights that still have an `ArrTime`.

`Cancelled` and `Diverted` are outcomes. They are not cause fields. They are not one label, and neither is a substitute for `ArrDel15`.

### Cause fields

The field list groups the five minute fields under “Cause of Delay (Data starts 6/2003)”. June 2003 is before this window. Directive No. 40 names the categories carrier, weather, national aviation system, security, and late-arriving aircraft. Causal data are required for cancelled flights and for flights that arrive 15 minutes or more after the scheduled arrival time. They are not required for on-time flights or diverted flights.

| Official name | Official description | Observed on JetBlue rows |
| --- | --- | --- |
| `CarrierDelay` | Carrier Delay, in Minutes | Decimal minutes, or blank. |
| `WeatherDelay` | Weather Delay, in Minutes | Decimal minutes, or blank. |
| `NASDelay` | National Air System Delay, in Minutes | Decimal minutes, or blank. |
| `SecurityDelay` | Security Delay, in Minutes | Decimal minutes, or blank. |
| `LateAircraftDelay` | Late Aircraft Delay, in Minutes | Decimal minutes, or blank. |
| `CancellationCode` | Specifies The Reason For Cancellation | Blank, or `A`, `B`, `C`, `D`. |

The five minute fields are blank on the same 1,559,030 rows and populated on the same 551,753 rows. The split is the late-arrival flag:

| Situation | Rows | Cause minutes |
| --- | ---: | --- |
| `ArrDel15` = 1 | 551,753 | All five fields populated. The five minutes sum to `ArrDelayMinutes` on every row. |
| Operated and not late | 1,501,068 | All five fields blank. |
| Cancelled | 50,674 | All five fields blank. The reason is `CancellationCode`. |
| Diverted | 7,288 | All five fields blank. |

A blank cause minute is not a measured zero, and it is not evidence that the column is missing from the file.

`CancellationCode` is blank on 2,060,109 rows, which is every row that is not cancelled. It is populated on all 50,674 cancelled rows.

| Code | Download-form lookup | Directive No. 40 label | Cancelled flights |
| --- | --- | --- | ---: |
| A | Carrier | Air Carrier | 14,477 |
| B | Weather | Weather | 18,287 |
| C | National Air System | National Aviation System | 11,154 |
| D | Security | Security | 6,756 |

There is no fifth cancellation code in this extract. The year-and-month distribution of these codes is in `dbt_dev.cancellation_reason` and in `FINDINGS.md`. Security-coded cancellations are concentrated in March and April 2020.

## Fields that are not substitutes

| Official name | Official description | Why it is not a substitute |
| --- | --- | --- |
| `DepDelayMinutes` | Difference in minutes between scheduled and actual departure time. Early departures set to 0. | Floors early departures at zero. `DepDelay` keeps the negative. Blanks match `DepDelay`. Samples are non-negative. Role: post-flight outcome. |
| `ArrDelayMinutes` | Difference in minutes between scheduled and actual arrival time. Early arrivals set to 0. | Same floor. `ArrDelay` keeps the negative. Blanks match `ArrDelay`. On late rows, the five cause minutes sum to this field. Role: post-flight outcome. |

Signed delay and non-negative delay minutes answer different questions. Early flights disappear in the `*DelayMinutes` fields.

## Missing or unusable

| Item | Status |
| --- | --- |
| `*OntimeArrivalPct`, `*OntimeDeparturePct` | Names on the field browser. They are analysis summaries, not columns in the flight file. On-time status in the flight file is `ArrDel15` and `DepDel15`. |
| `Tail_Number` | A column in the file. Missingness was not measured. It is not an aircraft type. Unusable for aircraft type, and not cleared as a feature. |
| Passenger count, fare, crew roster, maintenance record, independent weather observation | Not in the columns the audit verified. A disruption description can be built. A dollar loss or a safety rate cannot. |
| Codeshare split for 2026 | Not in the 109-column layout. From 1 January 2026, marketed codeshare flights may be included. Those rows cannot be split into operated and marketed. |
| State code `DC` | Unused. `DCA` and `IAD` use city name `Washington, DC` and state code `VA`. Washington flying is in the file. |
| Cause minutes on on-time, cancelled, and diverted rows | Blank by rule. Unusable as zeros. |
| `ArrDelay`, `ArrDel15` on cancelled and diverted rows | Blank by rule. Unusable as on-time or as late. |
| `DepDelay`, `DepTime`, `DepDel15` on cancelled rows with no departure time | Blank. 1,335 cancelled rows still have those departure fields. |
| Diversion-detail columns through `Div5` | The 109 names match the field list, including the `Div5` fields. The audit did not measure those columns. `DivArrDelay` is cited only for the rule that `ArrDelay` stays null on diverted flights. Those columns are not cleared for use. |
| Taxi fields | Not in the verified field list. Not cleared for use. If a later phase finds taxi times in the unverified columns, they are outcomes. |
| History before January 2018 | On the table profile, back to 1987. Not downloaded. Not in this dictionary’s extract. |
| International airports | Not in the JetBlue rows. Mexico and the rest of the Caribbean are absent. |

Airports in the extract sit in 35 states plus Puerto Rico and the U.S. Virgin Islands. State codes with no JetBlue airport in this extract: Alabama, Arkansas, Delaware, Hawaii, Indiana, Iowa, Kansas, Kentucky, Mississippi, Nebraska, North Dakota, Oklahoma, South Dakota, West Virginia, and Wyoming.

Puerto Rico and U.S. Virgin Islands airports confirmed on the rows:

| Airport | City name on the row | State | DOT airport ID | Role |
| --- | --- | --- | --- | --- |
| `SJU` | San Juan, PR | PR | 14843 | origin and destination |
| `BQN` | Aguadilla, PR | PR | 10732 | origin and destination |
| `PSE` | Ponce, PR | PR | 14254 | origin and destination |
| `STT` | Charlotte Amalie, VI | VI | 15024 | origin and destination |
| `STX` | Christiansted, VI | VI | 15027 | origin and destination |

The audit did not publish a separate official field name for city or state in the verified-field table. The city, state, and ID values above are the values it recorded on the rows. Departures with origin state `PR`: 97,207. Arrivals with destination state `PR`: 97,214. Departures and arrivals with state `VI`: 6,597 each. Those are state totals. The audit did not split them into per-airport flight counts.

Directed routes: 718. Routes flown in both directions: 356. Routes flown in one direction only: 6 (`BUR`–`FLL`, `LGA`–`BUF`, `LGA`–`SYR`, `MIA`–`SFO`, `ORH`–`PBI`, `SWF`–`PBI`). Both directions are separate routes.

## What this dictionary does not do

It does not authorize the other columns in the 109 as model inputs. It does not set a severe-disruption minute cutoff. It does not treat cancellation, diversion, and arrival delay as one field.
