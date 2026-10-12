# Research proposal

**Program:** Hofstra University, MS in Business Analytics  
**Student:** Trey Parkes  
**Title:** JetBlue Operational Performance and Strategic Risk Analytics

This document is the plan. It does not report results.

## Question

Where is JetBlue’s domestic operational risk concentrated, what is associated with it, and where should limited attention go first?

## Scope

The work is domestic only: the 50 states, the District of Columbia, Puerto Rico, and the U.S. Virgin Islands. The carrier is JetBlue Airways, filtered as `Reporting_Airline` = `B6`. San Juan (`SJU`) and St. Thomas (`STT`) are in. Mexico and the rest of the Caribbean are out.

There is no proprietary JetBlue extract.

## Source and window

The source is the Bureau of Transportation Statistics Reporting Carrier On-Time Performance table (1987-present). The window is the audited extract: 1 January 2018 through 31 July 2026.

`DATA_AUDIT.md` measured that extract. It contains 2,110,783 JetBlue flights, 103 months, 91 airports, and 718 directed routes. Those figures are the population this plan will use. They are not a finding about where risk sits.

## Definitions and grain

The Department of Transportation on-time rule used here is arrival under 15 minutes: a flight is on time when it arrives less than 15 minutes after its published arrival time. In the flight file that comparison is `ArrDel15`.

The grain is one flight: one scheduled nonstop domestic flight operation. Later summaries are airport-month and route-month. A directed route is an origin–destination pair. The two directions of a city pair stay separate.

## Later path

The later path, in order, is:

1. Validate the official monthly downloads against the audited counts.
2. SQL transforms to the flight grain and to airport-month and route-month.
3. Exploratory analysis of where reported disruption sits.
4. One logistic regression, using pre-flight fields only.
5. Excel scenarios at 5 percent, 10 percent, and 15 percent, with no invented dollar figures.
6. A Power BI report of the measured domestic results.

The severe-disruption cutoff is not locked. Until that cutoff is chosen from the arrival-delay distribution, it is not a model label. Cancellation, diversion, and arrival delay stay separate outcomes.

## What this project will not claim

- Causation. An association between a pre-flight field and a reported outcome is not a claim that changing the field changes the outcome.
- Dollar savings. The Excel cases are percent changes in disrupted flights. No dollar amount will be invented.
- International flying. Mexico and the rest of the Caribbean are outside the file.
- Weather. The verified columns have no independent weather observation. A reported weather bucket is not a weather analysis.
- Passenger loads. The verified columns have no passenger count.

## Choices left open

Priority will combine risk and flight volume. A high rate on a thin place is not, by itself, the first place to look. The weights are not chosen yet.

No Monte Carlo simulation is part of this plan. No scraper is part of this plan. The flight file is the official BTS monthly download.

The warehouse is not locked. Amazon S3 and Snowflake are both still open. Neither is chosen.
