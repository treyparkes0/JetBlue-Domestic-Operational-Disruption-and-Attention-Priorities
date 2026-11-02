# Business problem

Measurement rules for a Hofstra MS in Business Analytics capstone. The reader is a strategy, operations, business, data, or BI analyst. Facts about the file come from `DATA_AUDIT.md` (reviewed 8 October 2026). The location of risk is in `FINDINGS.md` (reconciled to `dbt_dev` on 2 November 2026). The decision memo is `EXECUTIVE_DECISION_MEMO.md`. The dbt views are in `jetblue_capstone.dbt_dev`. The Excel scenario workbook is built. The Power BI report is not built. There is no machine-learning model.

## Question

Where is JetBlue’s domestic operational risk concentrated, what is associated with it, and where should limited management attention go first?

The carrier in scope is JetBlue Airways, `Reporting_Airline` = `B6`. The public source is the Bureau of Transportation Statistics Reporting Carrier On-Time Performance table. There is no proprietary JetBlue extract.

## Why it matters operationally

The Department of Transportation on-time rule in this table is arrival less than 15 minutes after the published arrival time. In the flight file that rule is `ArrDel15`. A late arrival, a cancellation, and a diversion are different reported events. The audit counted them separately: 551,753 late arrivals, 50,674 cancellations (2.40 percent of 2,110,783 flights), and 7,288 diversions that were not cancelled (0.345 percent). Blending them into one rate would hide which event is driving a place.

The file supports a domestic ranking of airports, directed routes, and calendar periods by those events and by the cause mix. Phase 1 called that use GO. `FINDINGS.md` is the exploratory answer. The official ranking waits until the Databricks views reproduce those rates.

Attention is limited, so the later ranking has to show where delay minutes sit on busy places. A high delay rate on a thin route is not, by itself, the first place to look. Carrier delay and late-aircraft delay are the controllable buckets a later priority list can separate from weather and from National Air System (NAS) delay. Security delay stays its own bucket. Those buckets are broad. Carrier delay mixes maintenance, crew, baggage, and other items the carrier reports there. The file cannot separate those items. Weather delay is the extreme-weather category, not every weather minute that may sit inside NAS delay.

The file is a carrier report to BTS. It is not JetBlue’s internal operations database.

## What “risk” means here

In this file, risk means reported domestic schedule disruption: cancellation, diversion, arrival delay, the 15-minute flags, and the cause mix on flights where BTS required a cause.

It does not mean international exposure, dollar loss, or a safety incident. The verified columns have no passenger count, fare, crew roster, maintenance record, or independent weather observation. `Tail_Number` is present. The audit did not measure its missingness, and it is not an aircraft type.

## What priority will mean

Priority is risk considered with volume: delay minutes on busy places, not the delay rate alone. A high rate on a thin place is not automatically high priority. High volume with high risk comes before high risk with low volume. Low-volume, high-risk places stay visible as watch items.

No weights are set in this file. `FINDINGS.md` names the order: JFK, Boston, Fort Lauderdale, Orlando, and San Juan first, with Miami as the main reliability watch item. That order is arrival-delay minutes with a minimum flight count, plus the quartile flags in `METHODOLOGY.md`. It is not a weighted score. `dbt_dev.airport_month` reproduced the origin minute totals on 2 November 2026.

Controllable delay minutes, when a later phase sums them, are carrier minutes plus late-aircraft minutes. Weather minutes and NAS minutes stay separate. Security minutes stay separate. Cause-minute fields are populated only when BTS requires a cause. On this extract that is the late-arrival rows (`ArrDel15` = 1): 551,753 rows, all five cause fields populated, and the five minutes sum to `ArrDelayMinutes` on every one of those rows. A blank cause is not zero. Filling it with zero would treat an on-time flight as a recorded zero for each cause.

## What a recommendation is allowed to claim

A later recommendation may claim only what the measured domestic file can support:

- Where reported cancellation, diversion, and arrival delay concentrate, by airport, by directed route, and by calendar period, with 2020 and partial 2026 labeled.
- Which airports, directed routes, and calendar periods are associated with those outcomes. Association is not causation.
- How carrier and late-aircraft minutes compare with weather minutes and NAS minutes on the rows where a cause was required.
- Which places combine disruption with volume, as ranked in `FINDINGS.md`, so limited attention has an order. Any weights used later have to be written down. The exploratory order uses arrival-delay minutes and a minimum flight count.

A recommendation has to keep cancellation, diversion, and arrival delay as separate statements.

A recommendation may not claim:

- Dollar savings, profit, fare effects, or load effects.
- A safety rate, or an effect of aircraft type.
- Coverage of Mexico, the rest of the Caribbean, or any other international flying.
- A cause finer than the five delay buckets and the four cancellation codes.
- That a blank cause minute is a measured zero.
- That 2020 is exchangeable with the other years.
- That January–July 2026 rows can be split into operated flights and marketed codeshare flights.
- A severe-disruption minute cutoff. The audit does not publish the delay distribution that would justify one.
- That one management action will cause delay to fall.

## Scope

**In scope.** Domestic flying as this table defines it: the 50 states, the District of Columbia, Puerto Rico, and the U.S. Virgin Islands. `Reporting_Airline` = `B6`. San Juan (`SJU`) and St. Thomas (`STT`) are in that geography. So are the other Puerto Rico and U.S. Virgin Islands airports the audit found in the extract (`BQN`, `PSE`, `STX`). The working window is 1 January 2018 through 31 July 2026 (103 months, 2,110,783 flights).

Scheduled reported flights only. Extra sections, nonscheduled flights, and charters are not in the Part 234 on-time file. The file is not JetBlue’s entire operation.

**Out of scope.**

- Mexico and the rest of the Caribbean. The audit found no such airport on these rows. International leisure routes are out of the claims.
- A multi-airline study. No peer airline is added.
- Census data. T-100 is not on the core path.
- Monte Carlo simulation.
- An independent weather feed. Weather waits.
- Dollar savings. The Excel scenario counts cancellations avoided. It does not invent a cost.
- Proprietary JetBlue data.
- A web scraper. The download form does not filter to a carrier. A later load reads the official monthly downloads and keeps `B6`.

The analysis warehouse is Databricks catalog `jetblue_capstone`. dbt Core documents the SQL models. Excel and Power BI read those models. These documents do not add Snowflake, S3, or a machine-learning model.

## Limits that bind every claim

**2020 is not exchangeable with the other years.** JetBlue flights fall from 305,010 in 2018 and 297,411 in 2019 to 144,163 in 2020. May 2020 has 2,762 flights. July 2018 has 26,671. A trend that pools 2020 with other years has to say so.

**From January 2026, codeshare flights the carrier markets may be in the file.** Technical Directive No. 40, effective 1 January 2026, tells reporting carriers to include codeshare flights they market. The 109-column layout has no column that separates operated flights from marketed codeshare flights. 2026 in this extract is January–July only (141,892 flights). Those rows cannot be split on that distinction.

**Washington, D.C. flying is in the file and coded `VA`.** `DCA` and `IAD` are present. No row uses state code `DC`. Fifteen states have no JetBlue airport in this extract. That is network coverage, not a broken file.

**Correlation is not causation.** Schedule, airport, route, distance, and calendar attributes can be associated with disruption. The file cannot identify a management action as the cause.

## What this phase does not answer

`FINDINGS.md` is the ranking, reconciled to `dbt_dev` on 2 November 2026. These rules still bind every claim. There is no machine-learning model and no severe-delay class. The Power BI dashboard is not built yet.
