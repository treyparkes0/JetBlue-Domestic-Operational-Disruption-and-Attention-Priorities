# Business problem

**Project:** Film Performance Analytics  
**Films under study:** Disney movies  
**Phase:** 1 of the capstone. This document defines the problem. It does not report results, and no analytical system has been built.

## Problem

Disney’s theatrical slate is released into a market where the information set grows in steps: production and release attributes before opening, audience response after the first wide weekend, and a hold after the next weekend. A final gross is available only once that run has been reported. Marketing weight and screen-count decisions are more useful if a shortfall relative to expectation can be recognized at one of the earlier steps.

Public box-office reporting does not state how Disney itself defines underperformance. A gross figure alone is also a weak management signal: a film can finish with a large gross and still fall short of the performance its budget, franchise position, and release slot would have led the studio to expect. The capstone therefore treats underperformance as performance relative to an expectation that can be estimated from earlier films, not as a fixed dollar cutoff.

The practical problem is timing. The studio, and an outside analyst reconstructing the studio’s public information set, learns in stages:

1. Before the wide domestic opening, production and release attributes are known, along with the track record of earlier films. Gross and theater counts from this film’s run are not.
2. At week 1, the first Friday–Sunday on which domestic theaters are at least 600, that weekend’s gross, theater count, and per-theater average are known.
3. At week 2, the next Friday–Sunday, that weekend’s gross, theater count, and the hold from week 1 are known. The final gross is still not known.

The business problem is to determine which of those stages, if any, supports a reliable early warning. The question at each stage is the same: will the film finish under its expectation?

## Business question

How early can Disney identify potential film underperformance using progressively available movie and early theatrical performance data?

## Objective

Specify, and in later phases estimate, a three-stage early-warning assessment of theatrical underperformance for Disney films. Each stage uses only information that would have existed at that time. The assessment compares a film with an expectation formed from earlier films. It does not claim to recover Disney’s internal hurdle, profit, or greenlight model.

This phase produces the problem statement, the research design, and the data plan. It does not produce data files, models, or a dashboard.

## What “early” means

“Early” is defined by the decision point, not by a model score.

| Stage | When the warning would be issued | Business use of a warning at that time |
| --- | --- | --- |
| Pre-release | Before the wide domestic opening | Release-slot, marketing-weight, and expectation-setting decisions |
| Week 1 | The first Friday–Sunday on which domestic theaters are at least 600 | First read on whether the film is tracking below the pre-release expectation |
| Week 2 | The next Friday–Sunday | Confirmation or reversal of the week-1 signal, while most of the final gross is still unrealized |

A later stage is useful only if it improves identification enough to justify waiting. **Decided** (7 October 2026): a later stage is a useful improvement only when its test ROC-AUC is higher than both the previous stage and a one-feature baseline, and a bootstrap interval for the AUC difference lies above zero. The rule is stated in [02_research_design.md](02_research_design.md). A finding that early data are not informative is a valid answer to the business question.

## Business use case

The user of the eventual assessment is a studio distribution or finance audience that reviews a title at one of the three points above. The output they need is:

- whether the film is classified as tracking toward underperformance
- the continuous gap between outcome and expectation, so a near-miss is not treated like a severe miss
- which stage produced the warning
- a short list of the inputs that were available at that stage

The use case is decision support for films already being released. It is not a system for recommending scripts, casting, or acquisition targets. It does not estimate profit, Disney+ contribution, consumer products, or theme-park value.

Excel, in a later phase, is the place for what-if cases (for example, a weaker hold or a different screen count). Power BI, in a later phase, is the place an executive reads the warning, the stage, and the gap. Neither tool is a second copy of the statistical or machine-learning analysis.

## Scope boundary

The outcome is theatrical performance. Home entertainment, television, and streaming engagement are outside the performance definition.

**Decided** (7 October 2026). The population is all current Disney theatrical labels: Walt Disney Pictures, Walt Disney Animation Studios, Pixar, Marvel Studios, Lucasfilm, and 20th Century only for films released after Disney’s acquisition of 21st Century Fox (closed 20 March 2019). Disney+ originals with no wide theatrical release are out. A theatrical film that later streams on Disney+ stays in. Television films, shorts, and festival-only titles stay out. The same rule is specified in [02_research_design.md](02_research_design.md).

Public data are a proxy for what an outside analyst can know. They are not Disney’s daily ultimates, and they do not include prints-and-advertising spend. Gross is not profit.

## Distinct roles of each technology

The intended system, once later phases are approved and built, separates tools so that each one does a single job.

| Technology | Role in the intended system |
| --- | --- |
| Public data | Inputs, limited to sources whose terms allow the project’s use |
| Python collection | Acquisition and a retrieval log |
| AWS storage | Durable storage of collected files and later artifacts |
| SQL and dbt | Conformed film grain and stage-specific feature views. The views are where the leakage rule is enforced |
| Python EDA and statistics | Description, regression for expected performance, and hypothesis tests |
| Python machine learning | Classification of the early-warning label at the three stages, and the evaluation of those classifiers |
| Excel | Forecasting and what-if scenarios used in a management discussion |
| Power BI | Executive presentation of stage, warning, gap, and uncertainty |
| GitHub | Code and documentation only. Raw datasets, credentials, and warehouse extracts do not belong in the repository |

Collection, AWS, dbt, models, Excel, and Power BI are planned. They are not built.

## Relationship to the rest of the capstone

| Phase | Product | Status |
| --- | --- | --- |
| 1 | Business problem and research design | This document and [02_research_design.md](02_research_design.md). Design decisions recorded 7 October 2026 |
| 2 | Data dictionary and source assessment | [03_data_dictionary.md](03_data_dictionary.md) and [04_data_sources.md](04_data_sources.md) |
| 3 | Collection | Not started. Design decisions are recorded. Blocked on the remaining items in the research design and the data sources |
| Later | Storage, dbt, statistics, models, Excel, Power BI | Not started |

## Success, stated as a business standard

The capstone succeeds if it can say, with a leakage audit and a time-aware evaluation, whether a warning at pre-release, week 1, or week 2 identifies eventual underperformance better than the recorded baseline. The standard is an evidenced answer, including a negative answer. It is not a target accuracy chosen in advance.

**Decided** (7 October 2026). The outcome is nominal worldwide theatrical gross, with no CPI adjustment and no ticket-price adjustment. The expectation is a time-aware regression of log worldwide gross, and the fitted value on the original dollar scale is the bar. Underperform = 1 when finished worldwide gross is below that fitted value. The primary evaluation metric is ROC-AUC. Disney’s internal definition remains unknown. The recorded label is a research definition, not that internal hurdle. The specification is in the research design.
