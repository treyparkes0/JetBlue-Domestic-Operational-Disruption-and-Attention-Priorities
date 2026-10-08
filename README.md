# Film Performance Analytics

Graduate Business Analytics capstone for Trey Parkes. The films under study are Disney movies. This repository name stays **Film-Performance-Analytics**.

Phases 1 and 2 are documentation only. They define the business problem, the research design, the variable list, and the source constraints. Collection, storage, transformation, statistics, models, forecasting workbooks, and dashboards are not built.

A gross-based early-warning design was specified on 7 October 2026 and then set aside on 8 October 2026. Weekend gross, theater counts, and budgets are not available without a paid license. That design is not the current decision. The note is in [docs/02_research_design.md](docs/02_research_design.md).

## Business question

Before release, can Disney identify films that will draw a weaker audience response than earlier comparable Disney films?

The outcome is the current IMDb `averageRating`. A rating is audience response, not financial underperformance. It is not gross, not profit, and not Disney+ streaming.

## One prediction point

The intended system scores a film once, before release. It may use only information that would have existed then. Opening weekend and week 2 are not stages. There is no theater-count rule.

| Stage | Decision point | What may be used |
| --- | --- | --- |
| Pre-release | Before release | Studio label, up to three IMDb genres, runtime, release month, franchise versus original, and whether the director or a principal cast member appeared in an earlier in-scope Disney film |

IMDb `averageRating` and `numVotes` are the audience-response outcome and the vote count used to apply a minimum-vote rule. They are never features. The leakage rule is in [docs/02_research_design.md](docs/02_research_design.md).

## Planned pipeline

Each technology has one job. Nothing below has been implemented.

| Technology | Role |
| --- | --- |
| IMDb non-commercial datasets and Wikidata | Permissible inputs. Raw files stay out of GitHub |
| Python collection | Acquire and log those inputs |
| AWS storage | Durable storage for collected files and later artifacts |
| SQL + dbt | Keys, cleaning, and a pre-release feature view that enforces the leakage rule |
| Python EDA and statistics | Description, the expectation regression, and hypothesis tests |
| Python ML | One pre-release classifier, with time-aware evaluation |
| Excel | Forecasting and what-if scenarios for decisions; not a second copy of the Python analysis |
| Power BI | Executive dashboard of results |
| GitHub | Code and documentation only |

GitHub does not hold raw datasets, credentials, or warehouse extracts. TMDB is not used in the model. Box Office Mojo and The Numbers are not scraped.

## Repository layout

```text
README.md
docs/01_business_problem.md    Business problem, question, use case, and tool roles
docs/02_research_design.md     Population, label, leakage, evaluation, and the open cutoff
docs/03_data_dictionary.md     Variable definitions and Required / Optional / Needs verification / Excluded
docs/04_data_sources.md        IMDb and Wikidata evidence, terms of use, and the source matrix
```

## Status

The current design was recorded on 8 October 2026. Collection, AWS, dbt, models, Excel, and Power BI are still unbuilt.

| Work | Status |
| --- | --- |
| Phase 1 research design | Revised 8 October 2026. Gross design set aside |
| Phase 2 data dictionary and source review | Revised to the rating design. One cutoff still open |
| Python collection | Not built |
| AWS storage | Not built |
| SQL and dbt | Not built |
| Statistical analysis | Not built |
| Machine-learning models | Not built |
| Excel forecasting workbook | Not built |
| Power BI dashboard | Not built |

The label is not fixed until the minimum `numVotes` cutoff in [docs/02_research_design.md](docs/02_research_design.md) is approved. That cutoff is the only item marked **Needs your approval**.
