# JetBlue Operational Performance and Strategic Risk Analytics

Graduate capstone for the MS in Business Analytics at Hofstra University.

Public Bureau of Transportation Statistics on-time data for JetBlue (`Reporting_Airline` = `B6`). This is not proprietary JetBlue operational data. No peer airline and no machine-learning model.

## Business problem

Where is JetBlue’s domestic operational risk concentrated, what is associated with it, and where should limited operational attention go first?

Domestic means the 50 states, the District of Columbia, Puerto Rico, and the U.S. Virgin Islands. Mexico and the rest of the Caribbean are out of scope. Cancellations, diversions, and arrival delays stay separate. A late arrival is 15 minutes or more on an operated flight. An operated flight is not cancelled and not diverted.

## Executive summary

From January 2018 through July 2026, JetBlue reported 2,110,783 domestic flights. 26.9% of operated flights arrived late, and 2.40% of scheduled flights were cancelled.

Half of arrival-delay minutes sit at five origins: JFK, Boston, Fort Lauderdale, Orlando, and San Juan. Boston flies more than JFK and has a better late-arrival rate. JFK still has more minutes. Fort Lauderdale and Orlando combine a rate near 30% with a large base. Miami is the main reliability watch item that is not in the top 10 by minutes: 13,280 flights and a 34.3% late-arrival rate.

Sunday is the worst day. Friday is the busiest. July is the heaviest month. On flights that were already late, carrier delay plus late-aircraft delay is 76.4% of recorded cause minutes. That split is not a claim that the minutes were avoidable.

The full argument is in `Documentation/EXECUTIVE_DECISION_MEMO.md` and `Documentation/FINDINGS.md`.

## Key findings

- Top origins by arrival-delay minutes: JFK 6.52 million, Boston 6.31 million, Fort Lauderdale 3.78 million, Orlando 3.51 million, San Juan 1.93 million.
- Largest directed route by minutes: MCO → JFK, 612,862 minutes, 31.8% late. Boston–Washington carries a similar load at a rate in the low 20s.
- High rate with a real route base: MCO → EWR 35.9% on 14,407 flights, FLL → EWR 35.8% on 10,993 flights.
- Sunday: 29.5% late, 2.88% cancelled, 7.37 million minutes. Wednesday: 23.5% late.
- Cancellation codes: weather 36.1%, carrier 28.6%, NAS 22.0%, security 13.3%. Almost all security-coded cancellations are March–April 2020.
- Forecast, August 2026–July 2027: 280,987 flights, 10,716 baseline cancellations. Assumed 5/10/15% cuts avoid 536 / 1,072 / 1,607 cancellations. Holdout error is 2.31 percentage points. These are not savings.

## Technology stack

Python and pandas for the extract and the exploratory checks. Databricks SQL, catalog `jetblue_capstone`. dbt Core for the views and tests, schema `dbt_dev`. Excel for the cancellation forecast and the scenarios. Power BI is the planned presentation layer and is not built.

## Data source

Bureau of Transportation Statistics Reporting Carrier On-Time Performance (1987–present), TranStats table parameter `gnoyr_VQ=FGJ`. Monthly PREZIP files, January 2018 through July 2026, kept where `Reporting_Airline` is `B6`. 103 months, 91 airports, 718 directed routes. The raw files stay local.

## Project architecture

```mermaid
flowchart LR
  bts[BTS monthly files]
  py[Python extract and checks]
  dbx[Databricks SQL flight_performance]
  dbt[dbt views and tests in dbt_dev]
  xl[Excel forecast and scenarios]
  pbi[Power BI not built]
  bts --> py --> dbx --> dbt
  dbt --> xl
  dbt --> pbi
  xl --> pbi
```

`jetblue_capstone.views.flight_performance` is the flight-level source the models read. dbt writes the analytical views to `jetblue_capstone.dbt_dev`. Copies of some views also exist in the `views` schema. Those copies are not what dbt builds.

## Analytical methodology

Operated flights are the late-arrival denominator. All scheduled flights are the cancellation denominator. Blank delay fields stay blank. Controllable minutes are `CarrierDelay` plus `LateAircraftDelay`, and only on late arrivals. `WeatherDelay` is not every weather minute inside NAS.

Origins need at least 1,000 flights to enter the main ranking. Directed routes need at least 500. JFK → FLL and FLL → JFK are different routes. Origin and destination roles stay separate.

2020 is labeled and is excluded from the forecast fit. 2026 is January–July only. The rules are in `Documentation/METHODOLOGY.md`.

## Forecasting and scenario analysis

`Jetblue_Analysis.xlsx`.

- `Raw_Data` holds the 103 months.
- `Forecast` fits flights and the cancellation rate from January 2021 through July 2026 with `FORECAST.ETS`, seasonality 12, and projects August 2026 through July 2027. Baseline cancellations are flights times the rate.
- The holdout, August 2025–July 2026, misses by 2.31 percentage points on average.
- `Scenario` and `Scenario_Summary` hold forecast flights fixed and apply 5%, 10%, and 15% cuts to cancellations. Avoided cancellations are a count.

There is no dollar conversion.

## Operational prioritization

`origin_priority` and `route_priority` assign flags. They do not compute a weighted score.

- **High accumulated impact:** the 10 volume-qualified origins, and the 10 volume-qualified routes, with the most arrival-delay minutes.
- **Elevated reliability:** the same volume floors, and a late-arrival rate or a cancellation rate at or above the 75th percentile of that set. The two rates are separate flags.
- **Monitoring:** 250–999 flights for origins, and 250–499 for routes, with a late-arrival rate at or above that same percentile.

On the current build the origin cutoffs are 29.59% late and 3.06% cancelled. The route cutoffs are 30.95% late and 2.83% cancelled.

## Project structure

```text
src/filter_jetblue.py          Keep B6 from the monthly zips
src/jetblue_eda.py             Quality checks and the exploratory tables
models/                        dbt views
tests/                         dbt tests, including the locked counts
Jetblue_Analysis.xlsx          Forecast and scenarios
Documentation/                 Audit, dictionary, methodology, findings, memo
data/raw/                      Local BTS files. Not in git
```

Views in `dbt_dev`: `monthly_performance`, `airport_month`, `route_month`, `delay_causes`, `weekday_performance`, `cancellation_reason`, `origin_priority`, `route_priority`.

Two files in `data/` are old query downloads. They are not the system of record. `Jet_Blue_Operations_and_Strategy_Analytics__1_.csv` is a partial airport export.

## Reproduce the analysis

1. Put the official monthly zips in `data/raw/`.
2. Run `python src/filter_jetblue.py`, then `python src/jetblue_eda.py`. The script expects the local Windows paths at the top of each file. It rewrites `data/raw/jetblue_b6_clean.csv` only after the audit checks pass.
3. Load the flight-level table behind `jetblue_capstone.views.flight_performance`. That load is already done in this workspace.
4. From this folder, with the dbt profile `jetblue`, run `dbt build`. The target schema is `dbt_dev`.
5. Refresh `Raw_Data` in the workbook from `monthly_performance` if the warehouse changes. The forecast formulas read that sheet.

`dbt build` on 2 November 2026 passed 8 views and 11 tests.

## Limitations

No passengers, fares, crew, maintenance, or independent weather. No causal claim and no dollar saving. 2020 is not a normal year. 2026 cannot be split into operated and marketed codeshare flights and cannot be annualized. Blank cause minutes are not zeros. The Power BI report is not part of this repository.

## Where to start in Power BI

Import from `jetblue_capstone.dbt_dev`, not from `views`, and not from the 2.1 million-row flight file.

Use `monthly_performance`, `airport_month`, `route_month`, `weekday_performance`, `cancellation_reason`, `origin_priority`, and `route_priority`. Cause minutes are already on the aggregate views, so the dashboard does not need `delay_causes`.

Do not average the stored rate columns. Late-arrival rate is `DIVIDE` of summed late arrivals by summed operated flights. Cancellation rate is `DIVIDE` of summed cancellations by summed flights. Build the date as `DATE(Flight_Year, Flight_Month, 1)`.

Filter airports to `Role = 'Origin'`. Label a route as origin to destination, and do not combine the two directions. Mark 2020 as not comparable and 2026 as January–July only.

A useful check card is July 2023: 22,853 flights, 21,108 operated, 9,794 late arrivals, 1,564 cancellations.

For the scenario page, use the Excel horizon rather than rebuilding `FORECAST.ETS` in DAX. The 12-month totals are 280,987 flights, 10,716 baseline cancellations, and 536 / 1,072 / 1,607 cancellations avoided. Show the 2.31 percentage-point holdout miss next to them.
