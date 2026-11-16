# JetBlue Domestic Operational Disruption and Attention Priorities

Where JetBlue’s domestic disruption concentrates, and where limited operational attention should go first.

Public Bureau of Transportation Statistics on-time data for JetBlue (`Reporting_Airline` = `B6`), January 2018 through July 2026. The full decision argument is in `Documentation/EXECUTIVE_DECISION_MEMO.md`.

## Project overview and business question

Where is JetBlue’s domestic operational risk concentrated, what is associated with it, and where should limited operational attention go first?

Domestic means the 50 states, the District of Columbia, Puerto Rico, and the U.S. Virgin Islands. Mexico and the rest of the Caribbean are out of scope. A late arrival is 15 minutes or more on an operated flight. An operated flight is not cancelled and not diverted. Cancellations, diversions, and arrival delays stay separate measures.

Priority follows arrival-delay minutes on busy origins and directed routes, read beside the late-arrival rate. A high rate on a thin place is a watch item. There is no weighted score.

## Executive summary

From 1 January 2018 through 31 July 2026, JetBlue reported 2,110,783 domestic flights. Of the 2,052,821 operated flights, 26.9% arrived late. 2.40% of scheduled flights were cancelled, and 0.345% were diverted and not cancelled. Operated flights accumulated 44,184,241 arrival-delay minutes.

Five origins account for half of those minutes: JFK, Boston, Fort Lauderdale, Orlando, and San Juan (22,045,754 minutes, 49.9%). Boston flies more than JFK and has a better late-arrival rate (25.4% versus 27.8%). JFK still has more minutes. The five highest late-arrival rates, with no flight minimum, cover 75,342 minutes (0.17%).

On flights that were already late, carrier delay plus late-aircraft delay is 76.4% of recorded cause minutes. That split is a reporting association. It is not a claim that those minutes were avoidable, and it is not a cost.

## Key findings

- Top origins by arrival-delay minutes: JFK 6.52 million, Boston 6.31 million, Fort Lauderdale 3.78 million, Orlando 3.51 million, San Juan 1.93 million. Together they are 1,065,139 flights (50.5%) and 24,551 cancellations (48.4%).
- Largest directed route by minutes: MCO → JFK, 612,862 minutes, 31.8% late. Boston–Washington carries a similar load at a rate in the low 20s.
- High rate with a real route base: MCO → EWR 35.9% on 14,407 flights, FLL → EWR 35.8% on 10,993 flights.
- Sunday: 29.5% late, 2.88% cancelled, 7.37 million minutes. Friday is the busiest day (314,540 flights, 28.6% late). Wednesday is the most reliable day (23.5% late). Both Sunday and July still lead with 2020 removed.
- July is the heaviest month (33.6% late, 5,754,997 minutes). With 2020 removed, July is 34.9% late. August and December both round to 32.0% late, and August has more minutes (4,284,267 versus 3,942,031). October is the lightest late-arrival month (21.1%). For MCO → JFK, MCO → EWR, and FLL → EWR together, July is first and August is second. December is not the next month for those three routes.
- Cancellation codes: weather 36.1%, carrier 28.6%, NAS 22.0%, security 13.3%. Of the 2020 security-coded cancellations, 6,749 are March and April, and six are in July. One security-coded cancellation is in May 2023.
- Cause minutes on late arrivals: late aircraft 39.2%, carrier 37.2%, NAS 20.7%, weather 2.7%, security 0.2%. Weather here is the extreme-weather bucket, not every weather minute inside NAS.
- The late-arrival-rate list of five is Traverse City (74 flights), Boise (39), Asheville (303), Wilmington, NC (273), and Newburgh (1,651). Only Newburgh has at least 1,000 flights. The list still covers 0.17% of minutes.

## Operational recommendations

These are places to investigate. They are not a claim that one change will cut delay, and they are not a dollar saving.

1. Review JFK and Boston first. Together they hold 12.8 million arrival-delay minutes, 29% of the network’s 44.2 million. JFK has 317,477 flights and a 27.8% late-arrival rate. Boston has 350,117 flights and a 25.4% late-arrival rate. Boston flies more and is late less often. JFK still has more minutes. Ask whether turns and late aircraft explain that gap. The file does not show that cause. On late flights, the recorded mix is 39.2% late aircraft and 37.2% carrier. That mix does not prove those minutes were avoidable.
2. Review MCO → JFK, MCO → EWR, and FLL → EWR in July, then August. MCO → JFK is 22,110 flights, 31.8% late, and 612,862 minutes. MCO → EWR is 14,407 flights, 35.9% late, and 434,041 minutes. FLL → EWR is 10,993 flights, 35.8% late, and 299,164 minutes. July is first for the network and for these three routes together. August is second. Leave December off this list. June has more of these routes’ minutes than December does. For FLL → EWR, also look at April. April has more of that route’s minutes than July. July has the higher late-arrival rate.
3. Review Sunday, then Friday. Sunday has 312,745 flights, a 29.5% late-arrival rate, and 7.37 million minutes. Friday is the busiest day, with 314,540 flights, a 28.6% late-arrival rate, and 6.95 million minutes.
4. Review Miami for late arrivals. 34.3% of Miami flights arrive late, on 13,280 flights. Miami is 22nd by total minutes, so this is a reliability review, not a minute review.
5. Review LaGuardia for cancellations. 2,168 of 65,340 flights were cancelled, 3.32%. LaGuardia is 7th by total minutes and the only top-10 minute airport above the 3.06% cancellation line. That line is the top quarter of cancellation rates among origins with at least 1,000 flights. Fort Myers is the next large airport on that cancellation list.

Leave the 2020 security-coded cancellations, including the six in July, and airports under 250 flights, out of the first pass.

## Power BI dashboard

`Jetblue_Final_analysis.pbix` reads `jetblue_capstone.powerbi_star` (`Fact_Flight`, `Dim_Month`, `Dim_Weekday`, `Dim_Origin`, `Dim_Route`). Rates are measures on the flight fact: summed late arrivals divided by summed operated flights, and summed cancellations divided by summed flights. The attention-list comparison stays in the workbook.

Screenshot files are not in this repository. Open the report in Power BI Desktop and export the six pages if you want images in the portfolio. Edit titles in Desktop. The `.pbix` is a signed package, so unzipping it and rewriting the report files makes Desktop reject the file.

The page list below is the report that opens. Patterns shows carrier, late-aircraft, security, weather, and NAS cause minutes. Late aircraft is 39.2% of cause minutes.

| Page | What it shows |
| --- | --- |
| Overview | Flights, late-arrival rate, cancellation rate, and diversion rate, then arrival-delay minutes for the high-accumulated-impact origins. |
| Three Events | Late arrivals, cancellations, and diversions kept as separate counts. |
| Minutes | Arrival-delay minutes by origin and by directed route. A year slicer sits on this page. |
| Rate and Size | Late-arrival rate beside flight volume for origins with at least 1,000 flights, plus elevated cancellations. A year slicer sits on this page. |
| Patterns | Weekday flights and arrival-delay minutes, late arrivals by calendar month, and carrier, late-aircraft, security, weather, and NAS cause minutes. An origin slicer sits on this page. The month chart includes every month and plots the count of late arrivals. July is the highest month on that chart. |
| Attention | The five reviews: JFK and Boston, the three Florida–New York routes in July then August, Sunday then Friday, Miami late arrivals, and LaGuardia cancellations. Charts show high-accumulated-impact origins, monitoring origins, elevated late-arrival routes, and elevated-cancellation origins. |

## Methodology

Definitions and the priority rules are in `Documentation/METHODOLOGY.md`. The reconciled counts are in `Documentation/FINDINGS.md`.

Operated flights are the late-arrival denominator. All scheduled flights are the cancellation denominator. Blank delay fields stay blank. Carrier minutes plus late-aircraft minutes are summed only on late arrivals. That sum is a reporting bucket. It is not a claim that the minutes were avoidable.

Origins need at least 1,000 flights to enter the main ranking. Directed routes need at least 500. JFK → FLL and FLL → JFK are different routes. Origin and destination roles stay separate. Monitoring is 250–999 flights for origins and 250–499 for routes, with a late-arrival rate at or above the same 75th percentile. On the 2 November 2026 build the origin cutoffs were 29.59% late and 3.06% cancelled. The route cutoffs were 30.95% late and 2.83% cancelled.

2020 is labeled wherever a rate is pooled. 2026 is January–July only.

`origin_priority` and `route_priority` assign flags. They do not compute a weighted score.

- **High accumulated impact:** the 10 volume-qualified origins, and the 10 volume-qualified routes, with the most arrival-delay minutes.
- **Elevated reliability:** the same volume floors, and a late-arrival rate or a cancellation rate at or above the 75th percentile of that set. The two rates are separate flags.
- **Monitoring:** below the volume floor and at least 250 flights, with a late-arrival rate at or above that same percentile.

## Technical architecture

Each tool has one job.

| Tool | Job |
| --- | --- |
| Python `src/filter_jetblue.py` | Read the monthly BTS zips, keep `Reporting_Airline` = `B6`, write `data/raw/jetblue_b6.csv`. |
| Python `src/jetblue_eda.py` | Check the extract and produce the exploratory tables that `FINDINGS.md` was reconciled against. |
| Databricks `jetblue_capstone.views.flight_performance` | Flight-level store the models read. |
| dbt `jetblue_capstone.dbt_dev` | One tested view per analytical grain, including the priority flags. |
| dbt `jetblue_capstone.powerbi_star` | Flight fact and the dimensions the dashboard uses. |
| Excel `Jetblue_sensitivity_analysis.xlsx` | Compare attention lists on the origin extract. |
| Power BI `Jetblue_Final_analysis.pbix` | The finished dashboard. |

```mermaid
flowchart LR
  bts[BTS monthly files]
  py[Python extract and checks]
  dbx[Databricks SQL flight_performance]
  dbt[dbt views and tests]
  star[powerbi_star]
  xl[Excel attention lists]
  pbi[Power BI dashboard]
  bts --> py --> dbx --> dbt
  dbt --> star --> pbi
  dbt --> xl
```

`jetblue_capstone.views.flight_performance` is the flight-level source the models read. dbt writes the analytical views to `jetblue_capstone.dbt_dev` and the dashboard model to `jetblue_capstone.powerbi_star`. Copies of some views also exist in the `views` schema. Those copies are not what dbt builds.

Views in `dbt_dev`: `monthly_performance`, `airport_month`, `route_month`, `delay_causes`, `weekday_performance`, `cancellation_reason`, `origin_priority`, `route_priority`.

Views in `powerbi_star`: `fact_flight`, `dim_month`, `dim_weekday`, `dim_origin`, `dim_route`. The dimensions carry keys and the priority flags. Flight counts stay on `fact_flight`.

## Data sources and limitations

Bureau of Transportation Statistics Reporting Carrier On-Time Performance (1987–present), TranStats table parameter `gnoyr_VQ=FGJ`. Monthly PREZIP files, January 2018 through July 2026, kept where `Reporting_Airline` is `B6`. 103 months, 91 airports, 718 directed routes. The raw files stay local. The audit is `Documentation/DATA_AUDIT.md`. Field definitions are in `Documentation/DATA_DICTIONARY.md`. What a recommendation is allowed to claim is in `Documentation/BUSINESS_PROBLEM.md`.

The file has no passengers, fares, crew, maintenance, or independent weather. There is no causal claim and no dollar saving. 2020 is not a normal year. 2026 cannot be split into operated and marketed codeshare flights and cannot be annualized. Blank cause minutes are not zeros. Arrival-delay minutes use the floored field, so early arrivals contribute 0. The workbook compares lists. It does not estimate the effect of a program.

## Reproduction instructions

1. Put the official monthly zips in `data/raw/`.
2. From this folder, run `python src/filter_jetblue.py`, then `python src/jetblue_eda.py`. Both scripts resolve `data/raw` from the repository folder. `jetblue_eda.py` writes `data/raw/jetblue_b6_clean.csv` only after the row, carrier, date, duplicate, clock, cancellation, and diversion checks pass.
3. Load `data/raw/jetblue_b6_clean.csv` into Databricks, then create `jetblue_capstone.views.flight_performance` from `sql/flight_performance.sql`. That load is already done in this workspace and is not built by dbt. The SQL file is the column mapping. Do not run it until its source table name matches the table you loaded. The models read these columns: `Flight_Year`, `Flight_Month`, `Flight_Date`, `Day_of_Week`, `Origin_Airport_ID`, `Origin_Airport`, `Origin_City`, `Origin_State`, `Destination_Airport_ID`, `Destination_Airport`, `Destination_City`, `Destination_State`, `Cancelled`, `Diverted`, `Arrival_Delay_15_or_More`, `Arrival_Delay_Minutes`, `Carrier_Delay`, `Late_Aircraft_Delay`, `Weather_Delay`, `National_Air_System_Delay`, `Security_Delay`, and `CancellationCode`.
4. Use a dbt profile named `jetblue` whose target schema is `dbt_dev`. `dbt_project.yml` sends the dashboard models to the `powerbi_star` schema. From this folder, run `dbt build`.
5. `Raw Data` in the workbook is the origin extract. `Airports`, `Scenario`, and `Scorecard` read that sheet. The `Airports` and `Scenario` tabs have a trailing space in the sheet name. The formulas use that name. `Scorecard` compares the minutes list with the highest late-arrival rates and states the volume floors.

`dbt build` on 16 November 2026 passed 13 views and 40 tests: the 8 analytical views in `dbt_dev` and the 5 dashboard views in `powerbi_star`. July 2023, the origin ranking, and MCO → JFK still match `FINDINGS.md`. The 40 tests include the network totals, the five cause-minute totals, and the percentile cutoffs.

## Repository structure

```text
src/filter_jetblue.py          Keep B6 from the monthly zips
src/jetblue_eda.py             Quality checks and the exploratory tables
sql/flight_performance.sql     Column mapping into the flight-level view
models/                        dbt analytical views and the Power BI star
tests/                         dbt tests, including the locked counts
Jetblue_sensitivity_analysis.xlsx          Attention-list comparison
Jetblue_Final_analysis.pbix    Finished dashboard
Documentation/                 Audit, dictionary, methodology, findings, memo
data/raw/                      Local BTS files. Not in git
```
