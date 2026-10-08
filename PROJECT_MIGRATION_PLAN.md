# Project migration plan

**Phase:** 0. This file is the migration plan. It does not collect data, and it does not build a pipeline.

**Capstone:** Hofstra MSBA, Trey Parkes.

**Repository inspected:** `main` at `9aebce4` (merge of pull request #1) and the unmerged branch `docs/record-design-decisions` at `67ff961` ([pull request #2](https://github.com/treyparkes0/Film-Performance-Analytics/pull/2)). No other files exist on either tree.

**This pull request** adds this file only. It does not edit `README.md` or anything under `docs/`. It does not delete any file. It does not merge pull request #2. It does not download Bureau of Transportation Statistics (BTS) data.

The project this plan points at is **JetBlue Operational Performance and Strategic Risk Analytics**. One company: JetBlue. The business question is: where is JetBlue’s operational risk concentrated, what is associated with it, and where should management focus limited resources?

The intended primary source, not yet audited, is BTS Reporting Carrier On-Time Performance. That audit is Phase 1. It has not started.

## What is in the tree

Both `main` and the open pull-request branch are documentation. The complete file list on each is:

```text
README.md
docs/01_business_problem.md
docs/02_research_design.md
docs/03_data_dictionary.md
docs/04_data_sources.md
```

`main` is the Disney theatrical-gross design from pull request #1. Phases 1 and 2 there are research-design documents. The README states that collection, storage, transformation, statistics, models, forecasting workbooks, and dashboards are not built. That statement matches the tree.

Pull request #2 is two commits ahead of `main`, and it is open:

| Commit | What it did | Where it lives now |
| --- | --- | --- |
| `112f63e` | Recorded 7 October 2026 gross-design decisions (population, window, outcome, expectation, label, stages, evaluation), and left license and source blockers open | History on the branch only. The next commit set this design aside. It is not a separate file. |
| `67ff961` | Replaced that gross design with an IMDb audience-rating design | Current tip of `docs/record-design-decisions`. Not on `main`. |

The rating design changes the same five files. It does not add a file. Its question is whether, before release, Disney can identify films that will draw a weaker audience response than earlier comparable Disney films. The outcome is the current IMDb `averageRating`. There is one pre-release stage. Sources named in that design are IMDb non-commercial datasets and Wikidata. The only item still marked **Needs your approval** on that branch is a minimum `numVotes` cutoff. Collection, AWS, dbt, models, Excel, and Power BI are still described as unbuilt. The branch contains no code that would implement them.

## What is not in the tree

There is no reusable pipeline. The following are not in the repository, on `main` or on the pull-request branch:

- Python ingestion, or any Python
- AWS, or any other cloud or storage configuration
- SQL, dbt, or a warehouse project
- Models, notebooks, or fitted outputs
- Excel workbooks or Power BI files
- Tests, CI, dependency manifests, or a `.gitignore`

The README and `docs/01_business_problem.md` name Python collection, AWS storage, SQL and dbt, statistics, machine learning, Excel, and Power BI. Those rows are a planned division of labor. They are prose. They are not infrastructure, and this plan does not treat them as components that can be kept or modified. Nothing in this phase invents a stack behind them.

GitHub is the remote for this repository. The repository name on GitHub is still **Film-Performance-Analytics**. Renaming that remote is not part of Phase 0.

## Component disposition

Dispositions are recommendations for later phases. **Nothing in this table is applied here.** No Disney file is edited. No file is deleted. Pull request #2 stays open and unmerged. “Remove” means “do not carry this forward,” not “delete it now.”

| Component | Disposition | Reason | JetBlue equivalent |
| --- | --- | --- | --- |
| `README.md` on `main` | Replace | States the Disney theatrical-underperformance question, three gross stages, and a pipeline that the same file says is not built. There is no code under it to keep. | A README for JetBlue Operational Performance and Strategic Risk Analytics. Not written in this phase. |
| `docs/01_business_problem.md` on `main` | Replace | Defines a Disney studio problem: how early a theatrical shortfall can be recognized. Scope, user, and outcome are film gross. | A business-problem note for where JetBlue operational risk is concentrated, what is associated with it, and where limited resources should go. Belongs with Phase 2. Not written here. |
| `docs/02_research_design.md` on `main` | Replace | Three-stage leakage design for Disney films, with gross outcome, expectation, and label still marked **Needs your approval**. No dataset was collected. | The business and data model for operational risk on BTS domestic JetBlue flights. Phase 2. Not written here. |
| `docs/03_data_dictionary.md` on `main` | Replace | Candidate film variables (`movie_id`, budget, opening weekend, week-2 gross, theater counts). It is a classification, not a collected dictionary, and the fields are not airline fields. | A field dictionary for the BTS reporting-carrier file, written only after the Phase 1 audit. Not written here. |
| `docs/04_data_sources.md` on `main` | Replace | Source review for IMDb, licensed box office, Box Office Mojo, The Numbers, OpusData, TMDB, Wikidata, BLS CPI-U, and Nielsen. No extract was downloaded. None of these is the JetBlue source. | A source note for BTS Reporting Carrier On-Time Performance, domestic only. Phase 1 starts that work and has not started. |
| `README.md` rating-design revision, pull request #2 only (`67ff961`) | Remove | Recommendation only. Not on `main`. Replaces the gross question with a pre-release IMDb rating question and still describes an unbuilt pipeline. No JetBlue content. This phase does not delete the branch or close the pull request. | None. Do not merge this revision forward. |
| `docs/01_business_problem.md` rating-design revision, pull request #2 only | Remove | Recommendation only. Not deleted. The problem is Disney audience response before release, not operational risk. The gross design is recorded there only as set aside. | None. Do not merge this revision forward. |
| `docs/02_research_design.md` rating-design revision, pull request #2 only | Remove | Recommendation only. Not deleted. One stage, IMDb `averageRating` label, franchise and cast features, and an open `numVotes` cutoff. Film leakage rules do not transfer to this project. | None. Do not merge this revision forward. |
| `docs/03_data_dictionary.md` rating-design revision, pull request #2 only | Remove | Recommendation only. Not deleted. Grain is one IMDb `movie` title. Required fields are title, studio, genres, runtime, rating, and vote count. | None. Do not merge this revision forward. |
| `docs/04_data_sources.md` rating-design revision, pull request #2 only | Remove | Recommendation only. Not deleted. Collection path is IMDb non-commercial files plus Wikidata. Licensed gross sources are explicitly out of that design. | None. Do not merge this revision forward. |

No row is **Keep**. No row is **Modify**. The Disney documents are not a base to edit into an airline study. The rating-design branch should not be merged and then rewritten. Later JetBlue documents replace the roles of the five files on `main`. The rating-design text has no equivalent and is not carried forward. Until a later phase writes those replacements, the files on `main` stay as they are.

The 7 October gross-decision commit is not given its own row. It is not a file on the branch tip. The rating-design documents already say that design was set aside.

## Decisions

### Domestic scope

**Decision, confirmed by Trey.** Not an assumption. Not a finding. No BTS file was downloaded to reach it.

The project is domestic only. For this project, BTS domestic means:

- the 50 states
- the District of Columbia
- Puerto Rico
- the U.S. Virgin Islands

San Juan and St. Thomas are in, because they are in Puerto Rico and the U.S. Virgin Islands. The decision is that geography, not a two-airport list. Other points in the same geography are in on the same decision. This plan does not list them and does not claim an airport census.

International leisure routes are out of scope. That includes Mexico and the rest of the Caribbean (Caribbean points that are not Puerto Rico or the U.S. Virgin Islands). Those routes must not be claimed as part of this study: not in the population, not in results, and not in recommendations. JetBlue may operate them. Operating them does not put them in scope.

## Working assumptions

These are assumptions. They are not decisions, and they are not findings. Phase 1 has to check them. This phase did not.

1. **Years.** Reporting months from 2018 through the latest posted BTS month. The latest posted month has not been looked up. No file was downloaded to name it.
2. **Carrier.** The reporting-carrier file is filtered to JetBlue as carrier code `B6`. The project is one company, JetBlue. The code itself is still an assumption about how that file identifies the carrier.

## Phase order

The order below is the one set for this capstone. Phase 0 is this file. Phase 1 is next and has not started. `DATA_AUDIT.md` does not exist yet.

0. Migration plan (this file)
1. Data feasibility audit
2. Business and data model
3. Ingestion
4. dbt marts
5. EDA
6. Risk framework
7. ML early-warning
8. Strategic prioritization
9. Excel scenarios
10. Power BI
11. Recommendations
12. Polish

## Out of scope for Phase 0

- Downloading or sampling BTS data
- Writing `DATA_AUDIT.md` or any later-phase document
- Editing or deleting the Disney `README.md` or `docs/`
- Merging, closing, or rewriting pull request #2
- Building ingestion, storage, dbt, models, Excel, or Power BI
- Renaming the GitHub repository
