# Business problem

**Project:** Film Performance Analytics  
**Films under study:** Disney movies  
**Phase:** 1 of the capstone. This document defines the problem. It does not report results, and no analytical system has been built.

A gross-based early-warning design was specified on 7 October 2026 and then set aside on 8 October 2026. Weekend gross, theater counts, and budgets are not available without a paid license. The current problem is audience response before release, not theatrical gross. The gross rules are not the current decision.

## Problem

Disney releases a slate of films whose audience response can be compared with earlier Disney films that shared a studio label, genre, runtime, release month, franchise position, or key people. A rating is not a gross, and it is not profit. It is a public record of how viewers scored the film.

The practical problem is whether that weaker-than-expected response can be identified before release, using only information that would have existed then. Opening-weekend gross and a week-2 hold are not available for this project without a paid license, so they are not decision points.

## Business question

Before release, can Disney identify films that will draw a weaker audience response than earlier comparable Disney films?

## Objective

Specify, and in later phases estimate, a pre-release assessment of audience response for Disney films. The assessment compares a film with an expectation formed from earlier films. It does not claim to recover Disney’s internal hurdle, profit, or greenlight model. It does not estimate theatrical gross.

This phase produces the problem statement, the research design, and the data plan. It does not produce data files, models, or a dashboard.

## What “early” means

“Early” means before release. There is one decision point.

| Stage | When the warning would be issued | Business use of a warning at that time |
| --- | --- | --- |
| Pre-release | Before release | Expectation-setting for audience response, using only pre-release information |

There is no week-1 stage and no week-2 stage. A finding that pre-release data are not informative is a valid answer to the business question.

**Decided** (8 October 2026). A model is useful when its test ROC-AUC beats a one-feature baseline and a bootstrap interval for the difference lies above zero. The baselines to report are genre only and studio label only. There is no previous stage. The rule is stated in [02_research_design.md](02_research_design.md).

## Business use case

The user of the eventual assessment is a studio audience that reviews a title before release. The output they need is:

- whether the film is classified as drawing a weaker audience response than expected
- the continuous gap between the actual rating and the expected rating, so a near-miss is not treated like a severe miss
- a short list of the pre-release inputs that were used

The use case is decision support for films already being released. It is not a system for recommending scripts, casting, or acquisition targets. It does not estimate profit, theatrical gross, Disney+ contribution, consumer products, or theme-park value.

A rating is audience response, not financial underperformance.

Excel, in a later phase, is the place for what-if cases. Power BI, in a later phase, is the place an executive reads the warning and the gap. Neither tool is a second copy of the statistical or machine-learning analysis.

## Scope boundary

**Decided** (8 October 2026). The population stays the current Disney theatrical labels: Walt Disney Pictures, Walt Disney Animation Studios, Pixar, Marvel Studios, Lucasfilm, and 20th Century only after 20 March 2019. Disney+ originals are out. Television films, shorts, and episodes are out. The window is a release date on or after 7 October 2016.

Inclusion is an IMDb `titleType` of `movie` plus a Wikidata production-company match. Limited theatrical releases can remain, because theater counts are unavailable. The 600-theater rule was dropped with the gross design.

The outcome is the current IMDb average rating. Home entertainment, television, and streaming engagement are outside that definition. Public ratings are not Disney’s internal score.

## Distinct roles of each technology

The intended system, once later phases are built, separates tools so that each one does a single job.

| Technology | Role in the intended system |
| --- | --- |
| IMDb non-commercial datasets and Wikidata | Inputs, under the terms cited in the data sources. Raw files are not committed |
| Python collection | Acquisition and a retrieval log |
| AWS storage | Durable storage of collected files and later artifacts |
| SQL and dbt | Conformed film grain and the pre-release feature view. The view is where the leakage rule is enforced |
| Python EDA and statistics | Description, regression for expected rating, and hypothesis tests |
| Python machine learning | Classification of the early-warning label, and the evaluation of that classifier |
| Excel | Forecasting and what-if scenarios used in a management discussion |
| Power BI | Executive presentation of the warning, the gap, and uncertainty |
| GitHub | Code and documentation only. Raw datasets, credentials, and warehouse extracts do not belong in the repository |

TMDB is not used in the model. Box Office Mojo and The Numbers are not scraped. Collection, AWS, dbt, models, Excel, and Power BI are planned. They are not built.

## Relationship to the rest of the capstone

| Phase | Product | Status |
| --- | --- | --- |
| 1 | Business problem and research design | This document and [02_research_design.md](02_research_design.md). Revised 8 October 2026 |
| 2 | Data dictionary and source assessment | [03_data_dictionary.md](03_data_dictionary.md) and [04_data_sources.md](04_data_sources.md) |
| 3 | Collection | Not started. The label waits on the `numVotes` cutoff in the research design |
| Later | Storage, dbt, statistics, models, Excel, Power BI | Not started |

## Success, stated as a business standard

The capstone succeeds if it can say, with a leakage audit and a time-aware evaluation, whether a pre-release warning identifies a weaker-than-expected audience rating better than the recorded baselines. The standard is an evidenced answer, including a negative answer. It is not a target accuracy chosen in advance.

**Decided** (8 October 2026). The outcome is the current IMDb `averageRating`. The expectation is a time-aware regression fit only on earlier films. Underperform = 1 when the film’s rating is below that prediction. The gap is actual rating minus expected rating. The primary metric is ROC-AUC, with precision and recall for the underperformance class. A rating is audience response, not financial underperformance.
