# Research Proposal

**Program:** Hofstra University, Master of Science in Business Analytics  
**Student:** Trey Parkes  
**Title:** JetBlue Operational Performance and Strategic Risk Analytics

*This document describes the proposed research and methodology. It does not report analytical findings.*

## 1. Research Question

Where is JetBlue Airways' domestic operational risk concentrated, what factors are associated with that risk, and where should management prioritize attention and resources to improve operational reliability?

The project will use historical flight data, statistical analysis, and predictive modeling to identify patterns in operational disruption and develop a data-backed framework for prioritizing airports and routes.

## 2. Business Objective

The objective is to move beyond reporting historical delay rates and develop an analytical approach that helps distinguish the most consequential operational risks.

The project will investigate:

- **Performance:** How delays, cancellations, and diversions vary over time.
- **Risk concentration:** Which airports and directed routes experience elevated disruption rates and how those rates relate to operational volume.
- **Associated factors:** Which observable flight characteristics and historical performance patterns are associated with disruption.
- **Predictive risk:** Whether pre-departure information can help estimate the probability of a significant arrival delay.
- **Strategic prioritization:** Which airports and routes warrant further management attention when disruption risk and flight volume are considered together.

The intended outcome is a prioritized set of operational improvement opportunities supported by evidence, with scenario analysis to illustrate the potential effect of hypothetical improvements.

## 3. Scope and Boundaries

The project will focus on JetBlue Airways' domestic operations, defined for this study as flights within the 50 U.S. states, the District of Columbia, Puerto Rico, and the U.S. Virgin Islands.

The carrier will be identified using `Reporting_Airline = B6`. San Juan (SJU) and St. Thomas (STT) are included. Mexico and other international destinations are excluded.

The study uses publicly available data and does not rely on a proprietary JetBlue data extract. Its conclusions will be limited to the operations represented in the selected dataset and will not be presented as findings commissioned, validated, or endorsed by JetBlue.

## 4. Data Source and Study Period

The primary source is the Bureau of Transportation Statistics (BTS) Reporting Carrier On-Time Performance dataset.

The audited extract covers **January 1, 2018, through July 31, 2026**. According to `DATA_AUDIT.md`, the extract contains:

- 2,110,783 JetBlue flights
- 103 months of data
- 91 airports
- 718 directed origin–destination routes

These figures establish the audited dataset's coverage; they are not analytical findings about where operational risk is concentrated.

Flight volume for the first priority ranking is the flight count in that on-time file. The T-100 Domestic Segment dataset is a possible later supplement for passengers, seats, and capacity. It is not required for the first analysis.

The official monthly files include every reporting carrier. JetBlue rows are kept with `Reporting_Airline = B6`. Those flight-level files are not stored in GitHub. `data/jetblue_bts_coverage.csv` is the coverage summary only.

## 5. Definitions and Grain

A flight is on time, under the Department of Transportation rule used here, when it arrives less than 15 minutes after its published arrival time. In the flight file that comparison is `ArrDel15`.

The grain is one scheduled nonstop domestic flight. Later summaries are JetBlue by airport by month and JetBlue by directed route by month. A directed route is one origin–destination pair. The two directions of a city pair stay separate.

The cutoff for a “significant” arrival delay is not locked. It will be chosen only after the arrival-delay distribution is inspected. Until then, cancellation, diversion, and arrival delay stay separate outcomes, and none of them is the model label.

Cause-of-delay minutes are populated only when BTS requires a cause. A blank cause field is not a measured zero.

## 6. Methodology

The work proceeds in this order.

1. **BTS data.** Use the Reporting Carrier On-Time Performance file as the flight-performance source. Operational volume for the first ranking is the flight count in that file.
2. **Python ingestion and data quality.** Load the official monthly downloads, keep `Reporting_Airline = B6`, and check the result against the audited count of 2,110,783 flights. There is no web scraper.
3. **Snowflake and dbt.** Store the validated extract in Snowflake. Use dbt for the SQL transformations, tests, and documentation. The flight, airport, and route tables are checked against the audit. The downloaded files stay on hand, so the Snowflake trial is not the only copy of the data.
4. **Python diagnosis, then one model.** Exploratory analysis comes first: delays, cancellations, diversions, airports, routes, and time, with flight volume reported beside each rate. One logistic regression then estimates the probability of disruption from information known before departure. Historical airport and route rates in that model use earlier flights only. Another model is added only if this one fails in a way that model would fix.
5. **Priority list and Excel.** Rank airports and routes by disruption risk and flight volume together. A high rate on a thin route is not, by itself, the first place to look. Excel tests 5 percent, 10 percent, and 15 percent improvements in disrupted-flight counts. No dollar amounts are invented.
6. **Power BI.** The dashboard is last. It presents the finished tables and the scenario results to answer where performance stands, where risk sits, what is associated with it, where disruption is more likely, where to focus, and what the scenarios say.

Monte Carlo simulation is not one of these steps. Whether it would add anything is decided only after the pipeline, the diagnosis, the model, and the priority list exist.

## 7. What This Project Will Not Claim

- **Causation.** An association between a pre-departure characteristic and a reported outcome is not evidence that changing that characteristic would change the outcome.
- **Dollar savings.** Scenario results are changes in disrupted-flight counts.
- **International flying.** Mexico and the rest of the Caribbean are outside the file.
- **A weather study.** A reported weather-delay bucket is not an independent weather analysis.
- **Passenger loads,** unless T-100 is added later and the join is documented.
- **An endorsement by JetBlue.** The study uses public BTS reports, not JetBlue’s internal operations system.
