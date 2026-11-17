# JetBlue Domestic Operational Disruption and Attention Priorities

An end-to-end operational analytics and decision-support project that locates where JetBlue’s domestic schedule disruption concentrates, separates arrival delays from cancellations and diversions, and turns those concentrations into a first-pass attention list for limited operational review.

Public Bureau of Transportation Statistics (BTS) on-time data for JetBlue (`Reporting_Airline` = `B6`), January 2018 through July 2026. Deliverables include tested dbt models, a Power BI star-schema dashboard, an Excel attention-list workbook, and a written decision memo.

The full decision argument is in [`Documentation/EXECUTIVE_DECISION_MEMO.md`](Documentation/EXECUTIVE_DECISION_MEMO.md).

---

## Business problem and objectives

**Central question:** Where is JetBlue’s domestic operational risk concentrated, what is associated with it, and where should limited operational attention go first?

Domestic means the 50 states, the District of Columbia, Puerto Rico, and the U.S. Virgin Islands. Mexico and the rest of the Caribbean are out of scope. A late arrival is 15 minutes or more on an operated flight. An operated flight is not cancelled and not diverted. Cancellations, diversions, and arrival delays stay separate measures.

### Analytical objectives

- Identify where arrival-delay minutes accumulate across origins and directed routes.
- Distinguish operational volume from reliability rates so a busy hub is not ranked the same way as a thin station with a high rate.
- Flag airport and directed-route priorities with volume floors and quartile rules, without a weighted score.
- Investigate weekday and monthly patterns, including checks with 2020 removed.
- Keep arrival delays, cancellations, and diversions as separate outcomes.
- Translate the ranking into five operational reviews a manager can act on.

### Why rate-only ranking misleads

Ranking only by late-arrival percentage pulls attention to thin places. On this extract, the five highest late-arrival rates cover **75,342** arrival-delay minutes (**0.17%** of the network). The five highest-minute origins cover **22,045,754** minutes (**49.9%**). Priority follows minutes on busy places, with the rate read beside the minutes. A high rate on a thin place stays a monitoring item.

---

## Executive summary

From **1 January 2018** through **31 July 2026**, JetBlue reported **2,110,783** domestic flights across **91** airports, **718** directed routes, and **103** consecutive months.

| KPI | Value |
| --- | ---: |
| Scheduled flights | 2,110,783 |
| Operated flights | 2,052,821 |
| Late-arrival rate | 26.9% of operated flights |
| Cancellation rate | 2.40% of scheduled flights |
| Diversion rate | 0.345% diverted and not cancelled |
| Arrival-delay minutes | 44,184,241 |
| Airports / directed routes | 91 / 718 |

Five origins — JFK, Boston, Fort Lauderdale, Orlando, and San Juan — account for **22,045,754** minutes (**49.9%**). Boston flies more than JFK and has a better late-arrival rate (**25.4%** versus **27.8%**); JFK still has more minutes. On late arrivals, carrier delay plus late-aircraft delay is **76.4%** of recorded cause minutes. That split is a reporting association, not a claim those minutes were avoidable and not a cost.

---

## Key findings

Reconciled counts live in [`Documentation/FINDINGS.md`](Documentation/FINDINGS.md). Figures below are descriptive associations, not causal estimates.

### A. Network-level operational performance

| Measure | Value | Denominator |
| --- | ---: | --- |
| Flights | 2,110,783 | Scheduled flights in the window |
| Operated | 2,052,821 | Not cancelled and not diverted |
| Late arrivals | 551,753 | 26.9% of operated flights |
| Cancellations | 50,674 | 2.40% of all flights |
| Diversions, not cancelled | 7,288 | 0.345% of all flights |
| Arrival-delay minutes | 44,184,241 | Operated flights; early arrivals stored as 0 |

**Why it matters:** The network is large enough that small percentage differences still move millions of minutes. **What to investigate:** Keep the three event types separate when reviewing any airport, route, or period.

### B. Airport-level concentration

| Origin | Flights | Late-arrival rate | Minutes |
| --- | ---: | ---: | ---: |
| JFK | 317,477 | 27.8% | 6,516,458 |
| Boston | 350,117 | 25.4% | 6,312,537 |
| Fort Lauderdale | 170,468 | 30.0% | 3,778,579 |
| Orlando | 144,635 | 30.2% | 3,508,770 |
| San Juan | 82,442 | 28.8% | 1,929,410 |

Together these five origins are **1,065,139** flights (**50.5%**) and **24,551** cancellations (**48.4%**). Fort Lauderdale and Orlando combine a rate near 30% with a large base. In 2022–2025, LaGuardia replaces San Juan as fifth by minutes; that window check does not change the first review.

**Why it matters:** Half the delay-minute problem sits in five origins. **What to investigate:** Start with JFK and Boston, then the Florida hubs that clear both the minute ranking and the late-arrival quartile.

### C. Directed-route performance

| Route | Flights | Late-arrival rate | Minutes |
| --- | ---: | ---: | ---: |
| MCO → JFK | 22,110 | 31.8% | 612,862 |
| DCA → BOS | 28,525 | 23.6% | 576,647 |
| MCO → EWR | 14,407 | 35.9% | 434,041 |
| FLL → EWR | 10,993 | 35.8% | 299,164 |

MCO → JFK is the largest directed route by minutes. Boston–Washington carries a comparable minute load at rates in the low 20s because it flies more often. MCO → EWR and FLL → EWR are the sharp high-rate cases with a real route base. Directions are separate: JFK → FLL is not FLL → JFK.

**Why it matters:** Route-level attention can be more actionable than an airport total. **What to investigate:** Florida–New York corridors in July, then August; leave December off that first list.

### D. Day-of-week patterns

Sunday leads on late-arrival rate (**29.5%**), cancellation rate (**2.88%**), and minutes (**7.37 million**). Friday is the busiest day (**314,540** flights, **28.6%** late). Wednesday is the most reliable (**23.5%** late) and is not the lightest day. Saturday is the lightest. Both Sunday and July still lead with 2020 removed.

The Sunday gap is seasonal. With every year included, Sunday sits **7.4** points above other days in January and **0.9** points in July. In August Sunday is **0.6** points better than the other days. July is a high late-arrival month on every day; a Sunday review does not explain July.

**Why it matters:** The busiest day is not the least reliable day. **What to investigate:** Sunday with the winter operation; Friday as the volume peak.

### E. Monthly seasonality

July is the heaviest month (**33.6%** late, **5,754,997** minutes). With 2020 removed, July is **34.9%** late. August and December both round to **32.0%** late; August has more minutes (**4,284,267** versus **3,942,031**). October is the lightest late-arrival month (**21.1%**). For MCO → JFK, MCO → EWR, and FLL → EWR together, July is first and August is second.

**Why it matters:** Seasonal pressure is measurable and concentrated. **What to investigate:** Summer peaks first; treat March cancellation rates carefully because 2020 is in the pooled table.

### F. Disruption causes

On late arrivals, cause minutes split as late aircraft **39.2%**, carrier **37.2%**, NAS **20.7%**, weather **2.7%**, security **0.2%**. Weather here is the extreme-weather bucket, not every weather minute inside NAS.

Cancellation codes: weather **36.1%**, carrier **28.6%**, NAS **22.0%**, security **13.3%**. Of the 2020 security-coded cancellations, **6,749** are March and April and six are in July. One security-coded cancellation is in May 2023.

**Why it matters:** Cause fields describe reporting buckets on flights that were already late or cancelled. **What to investigate:** Carrier and late-aircraft association at the priority hubs; do not treat 2020 security codes as a current security pattern.

### G. Reliability versus operational volume

Among origins with at least 1,000 flights, the top quartile starts at **29.59%** late and **3.06%** cancelled (2 November 2026 build). Miami clears the late-arrival quartile without being in the minute top 10: **13,280** flights, **34.3%** late, minute rank 22. LaGuardia is the cancellation case inside the minute top 10: **3.32%** cancelled on **65,340** flights.

The late-arrival-rate list of five with no flight minimum is Traverse City (74), Boise (39), Asheville (303), Wilmington, NC (273), and Newburgh (1,651). Only Newburgh clears 1,000 flights. That list still covers **0.17%** of minutes.

**Why it matters:** Volume and reliability answer different management questions. **What to investigate:** Minutes first for network impact; rates for reliability reviews once a meaningful flight base exists.

---

## Operational recommendations

These are places to investigate. They are not a claim that one change will cut delay, and they are not a dollar saving.

### 1. Review JFK and Boston first

| | Detail |
| --- | --- |
| **Priority** | First |
| **Evidence** | Together they hold **12.8 million** arrival-delay minutes, **29%** of the network’s **44.2 million**. JFK: **317,477** flights, **27.8%** late. Boston: **350,117** flights, **25.4%** late. Boston flies more and is late less often; JFK still has more minutes. |
| **Investigation** | Ask whether turns and late aircraft explain the JFK–Boston gap. On late flights, the recorded mix is **39.2%** late aircraft and **37.2%** carrier. That mix does not prove those minutes were avoidable. |
| **Decision** | Whether hub turn performance and late-aircraft recovery at JFK and Boston warrant deeper ops review before other stations. |

### 2. Review MCO → JFK, MCO → EWR, and FLL → EWR in July, then August

| | Detail |
| --- | --- |
| **Priority** | Second |
| **Evidence** | MCO → JFK: **22,110** flights, **31.8%** late, **612,862** minutes. MCO → EWR: **14,407** flights, **35.9%** late, **434,041** minutes. FLL → EWR: **10,993** flights, **35.8%** late, **299,164** minutes. July is first for the network and for these three routes together; August is second. |
| **Investigation** | Leave December off this list. June has more of these routes’ minutes than December. For FLL → EWR, also look at April (more of that route’s minutes than July; July has the higher late-arrival rate). |
| **Decision** | Whether summer Florida–New York schedule and recovery practices need a focused review. |

### 3. Review Sunday, then Friday

| | Detail |
| --- | --- |
| **Priority** | Third |
| **Evidence** | Sunday: **312,745** flights, **29.5%** late, **7.37 million** minutes. Friday: **314,540** flights, **28.6%** late, **6.95 million** minutes. Sunday’s gap is **7.4** points in January and **0.9** points in July. |
| **Investigation** | Pair Sunday with the winter operation. This review does not explain July. |
| **Decision** | Whether weekend staffing, turn buffers, or recovery plans need separate winter versus summer treatment. |

### 4. Review Miami for late arrivals

| | Detail |
| --- | --- |
| **Priority** | Fourth |
| **Evidence** | **34.3%** late on **13,280** flights. Miami is **22nd** by total minutes. |
| **Investigation** | Reliability review, not a minute review. Compare with other volume-qualified origins above the **29.59%** late-arrival cutoff. |
| **Decision** | Whether Miami’s late-arrival rate justifies a station reliability deep dive despite its lower minute rank. |

### 5. Review LaGuardia for cancellations

| | Detail |
| --- | --- |
| **Priority** | Fifth |
| **Evidence** | **2,168** of **65,340** flights cancelled (**3.32%**). LaGuardia is 7th by total minutes and the only top-10 minute airport above the **3.06%** cancellation line. |
| **Investigation** | Fort Myers is the next large airport on that cancellation list. Treat cancellation elevation separately from late-arrival elevation. |
| **Decision** | Whether LaGuardia cancellation drivers (schedule, slot, weather recovery) need a dedicated cancellation review. |

Leave the 2020 security-coded cancellations, including the six in July, and airports under 250 flights, out of the first pass.

---

## Power BI dashboard

[`Jetblue_Final_analysis.pbix`](Jetblue_Final_analysis.pbix) reads `jetblue_capstone.powerbi_star` (`Fact_Flight`, `Dim_Month`, `Dim_Weekday`, `Dim_Origin`, `Dim_Route`). Rates are measures on the flight fact: summed late arrivals ÷ summed operated flights, and summed cancellations ÷ summed flights. Priority flags sit on the origin and route dimensions. Counts stay on the fact.

The star schema exists so Power BI can filter and slice flight-level measures by month, weekday, origin, and directed route without rebuilding analytical grain tables inside the report. The attention-list comparison stays in the Excel workbook; it is not rebuilt in the dashboard.

Page images are in [`Reports/`](Reports/). They show the full window, including 2020. Title edits belong in Power BI Desktop. The `.pbix` is a signed package; unzipping it and rewriting report files makes Desktop reject the file.

### 1. Overview

![Overview](Reports/Screenshot%202026-11-16%20174933.png)

| | |
| --- | --- |
| **Displays** | Network flights, late-arrival rate, cancellation rate, diversion rate, arrival-delay minutes for high-impact origins, and flights by year. |
| **Answers** | How large is the operation, and where do delay minutes concentrate at the headline level? |
| **Supports** | Opening the first review conversation with JFK and Boston as the minute leaders. |

### 2. Three Events

![Three Events](Reports/Screenshot%202026-11-16%20175008.png)

| | |
| --- | --- |
| **Displays** | Late arrivals, cancellations, and diversions as separate counts, by busy origins and by calendar month. |
| **Answers** | Which disruption type dominates, and do the three events move together? |
| **Supports** | Keeping cancellation and diversion reviews from being collapsed into a single “delay” story. |

### 3. Minutes

![Minutes](Reports/Screenshot%202026-11-16%20203152.png)

| | |
| --- | --- |
| **Displays** | Arrival-delay minutes by origin and by directed route, with a year slicer. |
| **Answers** | Where do minutes accumulate, and which directed corridors drive that load? |
| **Supports** | Choosing minute-based priorities (hubs and Florida–New York routes) before rate-only watch items. |

### 4. Rate and Size

![Rate and Size](Reports/Screenshot%202026-11-16%20203213.png)

| | |
| --- | --- |
| **Displays** | Late-arrival rate beside flight volume for origins with at least 1,000 flights, plus elevated-cancellation origins, with a year slicer. |
| **Answers** | Which busy places also clear the reliability cutoffs? |
| **Supports** | Separating high-volume reliability problems from thin high-rate stations. |

### 5. Patterns

![Patterns](Reports/Screenshot%202026-11-16%20175046.png)

| | |
| --- | --- |
| **Displays** | Weekday flights and arrival-delay minutes, late arrivals by calendar month, and carrier, late-aircraft, security, weather, and NAS cause minutes. An origin slicer sits on this page. |
| **Answers** | When does disruption peak, and which reporting cause buckets travel with late arrivals? |
| **Supports** | Timing reviews (Sunday/Friday; July/August) and framing cause-bucket questions without claiming avoidability. |

### 6. Attention

![Attention](Reports/Screenshot%202026-11-16%20203012.png)

| | |
| --- | --- |
| **Displays** | The five reviews: JFK and Boston; the three Florida–New York routes in July then August; Sunday then Friday; Miami late arrivals; and LaGuardia cancellations. Charts show high-accumulated-impact origins, monitoring origins, elevated late-arrival routes, and elevated-cancellation origins. |
| **Answers** | Where should limited attention go first? |
| **Supports** | Translating the ranking into a short investigation list for operations leadership. |

---

## Excel attention-prioritization model

[`Jetblue_sensitivity_analysis.xlsx`](Jetblue_sensitivity_analysis.xlsx) exists to compare how different attention lists cover the network. It does not forecast, estimate savings, or run scenarios about program effects.

### Sheets

| Sheet | Role |
| --- | --- |
| **Raw Data** | Origin extract (91 origins) with flights, operated flights, late arrivals, cancellations, arrival-delay minutes, and controllable (carrier + late-aircraft) minutes. |
| **Airports** | Ranks each origin by arrival-delay minutes and by late-arrival rate. |
| **Scenario** | Dropdown comparison of five list rules and the share of minutes, flights, and cancellations each list covers. |
| **Scorecard** | Places the plan (first five by minutes) beside the five highest late-arrival rates and states the volume floors. |

### List rules compared

1. First five origins by arrival-delay minutes (the plan).
2. First ten origins by arrival-delay minutes.
3. Five highest late-arrival rates (no flight minimum).
4. Five origins with the most cancellations.
5. First five by minutes, plus the largest cancellation airport left off (formula cutoff stays at five so the added airport is not counted twice; covered list has six origins).

### How a manager uses it

| List of five | Minutes | Share of minutes | Flights | Share of flights |
| --- | ---: | ---: | ---: | ---: |
| First five by minutes | 22,045,754 | 49.9% | 1,065,139 | 50.5% |
| Five highest late-arrival rates | 75,342 | 0.17% | 2,340 | 0.11% |

The minutes list (JFK, Boston, Fort Lauderdale, Orlando, San Juan) covers nearly half the delay-minute problem on half the flights. The rate list covers almost none of the minutes because four of its five bases are thin. Extending the minutes list to ten origins reaches **65.4%** of minutes. Newark is the next airport by minutes; LaGuardia is the cancellation airport the first-five minutes list leaves off.

Volume and reliability are considered side by side, not collapsed into a score. Totals include 2020; 2026 is January–July only. The workbook compares coverage. It is not a saving, and it does not estimate the effect of a program.

---

## Technical architecture

```mermaid
flowchart LR
  bts[BTS monthly PREZIP files]
  py[Python extract and EDA]
  dbx[Databricks SQL flight_performance]
  dbt[dbt views and tests]
  star[powerbi_star]
  xl[Excel attention lists]
  pbi[Power BI dashboard]
  bts --> py --> dbx --> dbt
  dbt --> star --> pbi
  dbt --> xl
```

| Tool | Role in this project |
| --- | --- |
| **Python** (`src/filter_jetblue.py`, `src/jetblue_eda.py`) | Read monthly BTS zips, keep `Reporting_Airline` = `B6`, quality-check the extract, and produce the exploratory tables reconciled in `FINDINGS.md`. |
| **Databricks** | Catalog `jetblue_capstone` holds the flight-level store and the schemas dbt writes to. |
| **SQL** (`sql/flight_performance.sql`) | Maps BTS columns into `jetblue_capstone.views.flight_performance`, the flight-level source the models read. |
| **dbt** | Builds eight analytical views in `jetblue_capstone.dbt_dev` and five dashboard views in `jetblue_capstone.powerbi_star`, with tests that lock network totals and key findings. |
| **Excel** | Compares attention-list coverage on the origin extract. |
| **Power BI** | Finished interactive dashboard on the star schema. |

`dbt build` on **16 November 2026** passed **13 views** and **40 tests** (8 analytical views in `dbt_dev` + 5 dashboard views in `powerbi_star`). Copies of some views also exist in the `views` schema; those copies are not what dbt builds.

---

## Data engineering and transformation

1. **Monthly BTS files.** Official TranStats PREZIP extracts for Reporting Carrier On-Time Performance, January 2018 through July 2026 (103 months). The download form does not filter to a carrier.
2. **JetBlue filter.** `src/filter_jetblue.py` keeps rows where `Reporting_Airline` is `B6` and writes local `data/raw/jetblue_b6.csv` (gitignored).
3. **Flight-level preparation.** `src/jetblue_eda.py` selects the analysis columns, coerces types, and checks locked counts. `sql/flight_performance.sql` maps those columns into the Databricks flight-level view.
4. **Analytical grains.** dbt models roll the flight file to month, airport-month (origin/destination roles separate), directed route-month, weekday, delay causes, cancellation codes, and full-window origin/route priority flags.
5. **Tests.** Schema tests enforce keys and non-null relationships; singular tests lock network totals, origin and route rankings, weekday counts, cause minutes, cancellation codes, percentile cutoffs, and priority rules against `FINDINGS.md` / `DATA_AUDIT.md`.
6. **Power BI star.** `fact_flight` plus `dim_month`, `dim_weekday`, `dim_origin`, and `dim_route`. Dimensions carry keys and priority flags; flight counts stay on the fact.

Views in `dbt_dev`: `monthly_performance`, `airport_month`, `route_month`, `delay_causes`, `weekday_performance`, `cancellation_reason`, `origin_priority`, `route_priority`.

Views in `powerbi_star`: `fact_flight`, `dim_month`, `dim_weekday`, `dim_origin`, `dim_route`.

---

## Analytical methodology

Full rules are in [`Documentation/METHODOLOGY.md`](Documentation/METHODOLOGY.md).

| Topic | Rule used |
| --- | --- |
| Geography | Domestic only: 50 states, D.C., Puerto Rico, U.S. Virgin Islands. |
| Reporting period | Flight dates 1 January 2018 through 31 July 2026 (103 consecutive months). |
| Late arrival | `ArrDel15` = 1 (15 minutes or more) on an operated flight. |
| Operated-flight denominator | `Cancelled` = 0 and `Diverted` = 0 → **2,052,821** rows for late-arrival rates. |
| Cancellation denominator | All scheduled flights in the period. |
| Diversion treatment | Diverted and not cancelled; kept separate from cancellations and from late arrivals. |
| Airport volume floor | At least **1,000** flights for the main ranking. |
| Route volume floor | At least **500** directed-route flights. |
| Monitoring | Origins **250–999** flights (routes **250–499**) with late-arrival rate at or above the same 75th percentile. |
| Priority flags | High accumulated impact (top 10 by minutes among volume-qualified places); elevated late-arrival rate; elevated cancellation rate; monitoring. No weighted score. |
| Cutoffs (2 Nov 2026 build) | Origins: **29.59%** late, **3.06%** cancelled. Routes: **30.95%** late, **2.83%** cancelled. |
| 2020 | Labeled wherever a rate is pooled; not treated as a normal year. |
| 2026 | January–July only; not annualized; marketed codeshares may be present and cannot be split out. |

Arrival-delay minutes (`ArrDelayMinutes` on operated flights) and late-arrival rates are evaluated separately because minutes capture operational load and rates capture reliability. A high rate on a thin place is a watch item; it does not outrank a high minute total. Blank cause minutes stay blank and are not treated as zero. Carrier-plus-late-aircraft minutes are a reporting bucket on late arrivals only.

---

## Data sources and limitations

**Source.** Bureau of Transportation Statistics, Reporting Carrier On-Time Performance (1987–present), TranStats table parameter `gnoyr_VQ=FGJ`. Monthly PREZIP files, January 2018 through July 2026, kept where `Reporting_Airline` is `B6`. **103** months, **91** airports, **718** directed routes. Raw files stay local and are not committed.

Supporting documentation:

- [`Documentation/DATA_AUDIT.md`](Documentation/DATA_AUDIT.md) — measured file review
- [`Documentation/DATA_DICTIONARY.md`](Documentation/DATA_DICTIONARY.md) — verified fields
- [`Documentation/BUSINESS_PROBLEM.md`](Documentation/BUSINESS_PROBLEM.md) — what a recommendation may claim

**Not in the file**

- Passenger-level information
- Fares and revenue
- Crew information
- Maintenance records
- Independent weather data

The analysis is observational. It does not establish causality, dollar savings, safety outcomes, or aircraft-type effects. 2020 is not exchangeable with other years. 2026 cannot be split into operated versus marketed codeshare flights and cannot be annualized. Origin and destination roles stay separate; adding both double-counts flights. `WeatherDelay` is extreme weather only, not every weather-related minute inside NAS.

---

## Repository structure

```text
.
├── README.md
├── requirements.txt                 # pandas, openpyxl, dbt-core, dbt-databricks
├── dbt_project.yml                  # project jetblue_operations; profile jetblue
├── jetblue_theme.json               # Power BI theme
├── Jetblue_Final_analysis.pbix      # Finished dashboard
├── Jetblue_sensitivity_analysis.xlsx
├── src/
│   ├── filter_jetblue.py            # B6 extract from monthly zips
│   └── jetblue_eda.py               # Quality checks and exploratory tables
├── sql/
│   └── flight_performance.sql       # Flight-level Databricks view mapping
├── models/
│   ├── schema.yml                   # Model docs and column tests
│   ├── *.sql                        # Analytical grains and priority flags
│   └── powerbi_star/                # Fact and dimension views
├── tests/                           # Singular tests locking audit/findings counts
├── macros/
│   └── generate_schema_name.sql
├── Documentation/
│   ├── BUSINESS_PROBLEM.md
│   ├── DATA_AUDIT.md
│   ├── DATA_DICTIONARY.md
│   ├── METHODOLOGY.md
│   ├── FINDINGS.md
│   ├── EXECUTIVE_DECISION_MEMO.md
│   └── jetblue_bts_coverage.csv
├── Reports/                         # Dashboard page screenshots
└── data/raw/                        # Local BTS files (gitignored; not on GitHub)
```

---

## Reproduction guide

This repository ships documentation, transformation code, the Excel workbook, the Power BI file, and screenshots. It does **not** ship the raw BTS monthly files or a Databricks credentials profile.

### Required tools

- Python 3 with packages in `requirements.txt` (`pandas`, `openpyxl`, `dbt-core`, `dbt-databricks`)
- Databricks workspace with catalog access for `jetblue_capstone`
- dbt profile named `jetblue` (local; not committed)
- Microsoft Excel (or compatible) for the attention workbook
- Power BI Desktop for `Jetblue_Final_analysis.pbix`

### Data (public source; local files)

1. Download monthly PREZIP files from BTS TranStats for On-Time Reporting Carrier On-Time Performance, January 2018 through July 2026, into local `data/raw/`.
2. Run `python src/filter_jetblue.py` to build `data/raw/jetblue_b6.csv`.
3. Run `python src/jetblue_eda.py` to validate locked counts and produce the cleaned exploratory file used in the analysis path.

Expected locked row count: **2,110,783** JetBlue rows, dates **2018-01-01** through **2026-07-31**.

### Databricks and dbt

1. Load the cleaned extract into Databricks (project expectation: source table referenced by `sql/flight_performance.sql`).
2. Create or replace `jetblue_capstone.views.flight_performance` using `sql/flight_performance.sql`.
3. Configure a local dbt profile named `jetblue` pointing at that workspace.
4. From the repo root, run `dbt build` (or the equivalent build/test commands for your environment).

Published analytical rankings come from `jetblue_capstone.dbt_dev`. The dashboard model is `jetblue_capstone.powerbi_star`.

### Power BI and Excel

1. Open `Jetblue_Final_analysis.pbix` in Power BI Desktop and refresh against `powerbi_star` with your Databricks connection.
2. Open `Jetblue_sensitivity_analysis.xlsx` to compare attention-list coverage on the origin extract.

Connection strings, tokens, and profile files are environment-specific and are not stored in this repository.

---

## Skills demonstrated

### Data analytics

- Exploratory data analysis on a multi-year flight-level extract
- Operational performance analysis (minutes, rates, cancellations, diversions)
- Reliability versus volume analysis with explicit volume floors
- Root-cause investigation using reported BTS disruption categories
- Business recommendations framed as investigation priorities, not proven savings

### Data engineering

- Python data extraction from official monthly BTS archives
- SQL transformations into a governed flight-level view
- Databricks catalog/schema organization (`views`, `dbt_dev`, `powerbi_star`)
- dbt modeling and testing (13 views; documented build of 40 tests)
- Relational modeling of analytical grains and priority flags

### Business intelligence

- Power BI dashboard design across six decision-oriented pages
- Star schema (`fact_flight` + four dimensions)
- KPI development with explicit denominators
- Interactive slicing by year, origin, and related attributes
- Excel analytical modeling for attention-list coverage comparison
- Management decision support via memo, dashboard, and workbook

---

## Documentation index

| Document | Contents |
| --- | --- |
| [`Documentation/BUSINESS_PROBLEM.md`](Documentation/BUSINESS_PROBLEM.md) | Question, scope, and claim limits |
| [`Documentation/DATA_AUDIT.md`](Documentation/DATA_AUDIT.md) | Measured file contents and feasibility |
| [`Documentation/DATA_DICTIONARY.md`](Documentation/DATA_DICTIONARY.md) | Verified field definitions |
| [`Documentation/METHODOLOGY.md`](Documentation/METHODOLOGY.md) | KPI rules, grains, priority framework |
| [`Documentation/FINDINGS.md`](Documentation/FINDINGS.md) | Reconciled rankings and recommendations |
| [`Documentation/EXECUTIVE_DECISION_MEMO.md`](Documentation/EXECUTIVE_DECISION_MEMO.md) | Decision memo for operations leadership |
