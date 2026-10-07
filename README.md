# Film Performance Analytics

Graduate Business Analytics capstone for Trey Parkes. The project asks how early Disney can identify potential theatrical underperformance as information arrives. The films under study are Disney movies. This repository name stays **Film-Performance-Analytics**.

Phases 1 and 2 are documentation only. They define the business problem, the research design, the variable list, and the source constraints. Collection, storage, transformation, statistics, models, forecasting workbooks, and dashboards are not built.

## Business question

How early can Disney identify potential film underperformance using progressively available movie and early theatrical performance data?

Underperformance is finished nominal worldwide theatrical gross below a time-aware expectation. The population, window, outcome, expectation, label, stages, and evaluation were recorded on 7 October 2026 and are marked **Decided** (7 October 2026) in the research design. A short record of the alternatives that were considered stays in that document. Items that are still open stay marked **Needs your approval**.

## Three prediction points

The intended system scores a film at three times. The question at each stage is the same: will the film finish under its expectation? A stage may use only information that would have existed at that time.

| Stage | Decision point | What may be used |
| --- | --- | --- |
| Pre-release | Before the wide domestic opening | Information fixed before that opening. No gross or theater count from this film’s run |
| Week 1 | The first Friday–Sunday on which domestic theaters are at least 600 | Pre-release attributes, plus that weekend’s gross, theater count, and the per-theater average |
| Week 2 | The next Friday–Sunday | Week-1 attributes, plus that weekend’s gross, theater count, and the hold from week 1 |

A platform or preview weekend is release history, not week 1. Week-1 features stop at that weekend. Week-2 features stop at that next weekend. Final gross is an outcome, never a feature. Franchise features for a film use only films released before that film. Current ratings and popularity stay excluded. The leakage rule is specified in [docs/02_research_design.md](docs/02_research_design.md).

## Planned pipeline

Each technology has one job. Nothing below has been implemented.

| Technology | Role |
| --- | --- |
| Public data | Permissible inputs only, after the remaining source and precedence items are resolved and terms of use are satisfied |
| Python collection | Acquire and log those inputs |
| AWS storage | Durable storage for collected files and later artifacts |
| SQL + dbt | Keys, cleaning, and separate feature views that enforce the leakage rule |
| Python EDA and statistics | Description, the expectation regression, and hypothesis tests |
| Python ML | Early-warning models at the three stages, with time-aware evaluation |
| Excel | Forecasting and what-if scenarios for decisions; not a second copy of the Python analysis |
| Power BI | Executive dashboard of results |
| GitHub | Code and documentation only |

GitHub does not hold raw datasets, credentials, or warehouse extracts.

## Repository layout

```text
README.md
docs/01_business_problem.md    Business problem, question, use case, and tool roles
docs/02_research_design.md     Stages, leakage, hypotheses, methods, and recorded decisions
docs/03_data_dictionary.md     Variable definitions and Required / Optional / Needs verification / Excluded
docs/04_data_sources.md        Source evidence, terms of use, and the source matrix
```

## Status

These design decisions are recorded. Collection, AWS, dbt, models, Excel, and Power BI are still unbuilt.

| Work | Status |
| --- | --- |
| Phase 1 research design | Decisions recorded 7 October 2026 |
| Phase 2 data dictionary and source review | Decisions recorded where they change a field; licenses and several checks still open |
| Python collection | Not built |
| AWS storage | Not built |
| SQL and dbt | Not built |
| Statistical analysis | Not built |
| Machine-learning models | Not built |
| Excel forecasting workbook | Not built |
| Power BI dashboard | Not built |

Phase 3 is collection. Recording the design decisions does not start it. It stays blocked on the unchecked items in [docs/04_data_sources.md](docs/04_data_sources.md): no licensed extract is in hand, TMDB is not cleared for model training, source precedence is unset, the in-scope film count is unmeasured, and the expectation formula is not frozen.
