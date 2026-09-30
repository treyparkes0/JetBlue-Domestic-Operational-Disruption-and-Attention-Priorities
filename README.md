# Film Performance Analytics

Graduate Business Analytics capstone for Trey Parkes. The project asks how early Disney can identify potential theatrical underperformance as information arrives. The films under study are Disney movies. This repository name stays **Film-Performance-Analytics**.

Phases 1 and 2 are documentation only. They define the business problem, the research design, the variable list, and the source constraints. Collection, storage, transformation, statistics, models, forecasting workbooks, and dashboards are not built.

## Business question

How early can Disney identify potential film underperformance using progressively available movie and early theatrical performance data?

Underperformance is not an arbitrary gross cutoff, and Disney’s internal definition is not public. The research design states defensible alternatives and marks each unresolved choice **Needs your approval**. No label has been selected.

## Three prediction points

The intended system scores a film at three times. A stage may use only information that would have existed at that time.

| Stage | Decision point | What may be used |
| --- | --- | --- |
| Pre-release | Before domestic theatrical opening | Production and release attributes, plus franchise history from films released earlier |
| After opening weekend | End of the first wide domestic weekend | Pre-release attributes, plus that weekend’s gross and theater count |
| After week 2 | End of the second week of the wide domestic run | Opening-weekend attributes, plus gross and theater count through week 2 |

Opening-weekend features stop at that weekend. Week-2 features stop at week 2. Final gross is an outcome, never a feature. Franchise features for a film use only films released before that film. The leakage rule is specified in [docs/02_research_design.md](docs/02_research_design.md).

## Planned pipeline

Each technology has one job. Nothing below has been implemented.

| Technology | Role |
| --- | --- |
| Public data | Permissible inputs only, after the flagged design choices are approved and terms of use are satisfied |
| Python collection | Acquire and log those inputs |
| AWS storage | Durable storage for collected files and later artifacts |
| SQL + dbt | Keys, cleaning, and separate feature views that enforce the leakage rule |
| Python EDA and statistics | Description, regression, and hypothesis tests |
| Python ML | Early-warning models at the three stages, with time-aware evaluation |
| Excel | Forecasting and what-if scenarios for decisions; not a second copy of the Python analysis |
| Power BI | Executive dashboard of results |
| GitHub | Code and documentation only |

GitHub does not hold raw datasets, credentials, or warehouse extracts.

## Repository layout

```text
README.md
docs/01_business_problem.md    Business problem, question, use case, and tool roles
docs/02_research_design.md     Stages, leakage, hypotheses, methods, and open decisions
docs/03_data_dictionary.md     Variable definitions and Required / Optional / Needs verification / Excluded
docs/04_data_sources.md        Source evidence, terms of use, and the source matrix
```

## Status

| Work | Status |
| --- | --- |
| Phase 1 research design | Draft, in this branch |
| Phase 2 data dictionary and source review | Draft, in this branch |
| Python collection | Not built |
| AWS storage | Not built |
| SQL and dbt | Not built |
| Statistical analysis | Not built |
| Machine-learning models | Not built |
| Excel forecasting workbook | Not built |
| Power BI dashboard | Not built |

Phase 3 is collection, and it starts only after the decisions marked **Needs your approval** are resolved. The checklist is in [docs/04_data_sources.md](docs/04_data_sources.md).
