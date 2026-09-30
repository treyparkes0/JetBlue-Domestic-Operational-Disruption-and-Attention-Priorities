# Data dictionary

**Project:** Film Performance Analytics  
**Phase:** 2. This is a classification of candidate variables. It is not a collected dataset, and coverage has not been censused.

Classes:

| Class | Meaning |
| --- | --- |
| Required | Needed to define the population, the clock, the outcome, or a stage that the business question includes |
| Optional | Confirmed as a concept on at least one reviewed source, and useful only under some approved designs |
| Needs verification | Wanted, but existence, dating, or coverage is not established well enough to treat the field as available |
| Excluded | Not a feature, or not a permissible input. Some excluded fields may still be stored as outcomes |

The source-by-source matrix is in [04_data_sources.md](04_data_sources.md). A field is attributed to a source only where that attribution was checked against current documentation or a page reviewed on 30 September 2026.

## Grain

One row is one theatrical film in its original theatrical cycle. Re-releases are not additional rows in the modeling table. Weekly observations, if a license allows them to be stored, live in a separate curve table and are joined only for weeks the stage allows.

`movie_id` is a project key assigned at collection. It is not taken from a single vendor. Crosswalks to source identifiers are required so that disagreements can be audited.

## Required variables

| Variable | Definition | Stage | Notes |
| --- | --- | --- | --- |
| `movie_id` | Project identifier | All | Assigned by the project |
| `imdb_id` | IMDb `tconst` (`tt` + digits) | Crosswalk | Required join key. Present in IMDb non-commercial `title.basics`, in TMDB movie details as `imdb_id`, and on Box Office Mojo title URLs. Wikidata property P345 is the IMDb identifier |
| `title` | Display title used to audit matches | All, as an attribute | Not a predictive feature. Sources use different title fields (`primaryTitle`, TMDB `title`, Wikidata P1476) |
| `studio_label` | Production label used to apply the approved studio scope | Inclusion | Required to implement the scope decision. The field name differs by source (production company, distributor). Mapping to Walt Disney Pictures, Walt Disney Animation Studios, Pixar, Marvel Studios, Lucasfilm, and 20th Century is **Needs verification** |
| `is_wide_theatrical` | Film had a wide domestic theatrical release under the approved threshold | Inclusion | Required filter. The threshold is **Needs your approval** |
| `release_date` | Start date of the wide domestic theatrical run | Pre-release | Required clock. Platform and preview dates are stored separately and do not replace this date |
| `release_year` | Calendar year of `release_date` | Pre-release | Derived |
| `genre` | Source genre labels, retained as a list | Pre-release | Required for cohort or regression controls. Taxonomies differ and are not a shared code set. The coding crosswalk is **Needs verification** |
| `budget` | Reported production budget in nominal U.S. dollars | Pre-release, if the figure was public before opening | Required for the regression and budget-multiple alternatives. If the approved expectation is a cohort benchmark that does not use budget, this variable becomes Optional. Zero is not a verified budget: TMDB’s schema default for `budget` is 0 |
| `opening_weekend_gross` | Domestic gross for the first wide Friday–Sunday | Opening weekend | Required Stage 1 feature. A platform opening is not this field |
| `opening_theater_count` | Theater count for that same weekend | Opening weekend | Required Stage 1 feature. Public completeness is **Needs verification**; the licensed IMDb field `numTheaters` is documented |
| `week2_gross` | Domestic gross for the second week of the wide run | Week 2 | Required Stage 2 feature. Weekend versus Friday–Thursday week is **Needs your approval** |
| `week2_theater_count` | Theater count for that same week | Week 2 | Required Stage 2 feature |
| `outcome_gross` | Final theatrical gross in the approved geography and dollar units | Outcome only | Required label input. Never a feature. Geography and nominal versus real dollars are **Needs your approval** |

Until those approvals exist, collection does not create `outcome_gross`. Domestic, international, and worldwide totals may be staged as separate source columns so the approved outcome can be built without a second pull.

## Optional variables

| Variable | Definition | Stage | Notes |
| --- | --- | --- | --- |
| `release_month` | Month of `release_date` | Pre-release | Derived. Useful as a seasonality control. Collinear with the date |
| `franchise` | Indicator that the film has at least one earlier film in the same series | Pre-release | Derived only from earlier releases. Optional predictor |
| `franchise_name` | Series or collection name | Pre-release | Optional. TMDB `belongs_to_collection`, Wikidata P179, and The Numbers’ Franchise field are not the same construct. Coverage is **Needs verification** |
| `production_method` | Animation versus live action, or a finer method such as digital animation | Pre-release | Optional cohort factor. The Numbers publishes Production Method (observed on *Frozen* as Digital Animation). TMDB has an Animation genre, which is not the same as production method. Wikidata has no dedicated production-method property on the movie property list reviewed |
| `runtime` | Runtime in minutes | Pre-release | Optional. Documented on TMDB `runtime`, IMDb `runtimeMinutes`, Wikidata P2047. Box Office Mojo displayed running time on the *Frozen* title page |
| `mpaa_rating` | U.S. classification | Pre-release, when issued before opening | Optional. Observed on Box Office Mojo and The Numbers. Wikidata P1657 is MPA film rating. TMDB stores certification on the release-dates endpoint, not on the core details object |
| `domestic_gross` | Final domestic theatrical gross | Outcome component | Optional if worldwide is the approved outcome. Excluded as a feature in every case |
| `international_gross` | Final international theatrical gross | Outcome component | Same rule as domestic. Not known in full at the domestic opening |
| `worldwide_gross` | Final worldwide theatrical gross | Outcome component | Optional if domestic is the approved outcome. Excluded as a feature |
| `prior_franchise_count` | Count of earlier films in the same series | Pre-release | Derived. Optional. Uses only earlier releases |
| `prior_franchise_median_outcome` | Median outcome of those earlier films | Pre-release | Derived. Optional. Uses only earlier releases |
| `cpi_u` | BLS CPI-U `CUUR0000SA0` for the release month | Adjustment | Optional, and used only if real dollars via CPI-U are approved |
| `distributor` | Domestic theatrical distributor | Inclusion audit | Optional. Box Office Mojo displays Domestic Distributor. Wikidata P750 is “distributed by.” Distributor is not the same as production label |

## Needs verification

These items stay out of the required modeling table until the check named here is done.

| Item | What is unverified | Why it matters |
| --- | --- | --- |
| Budget timing | Whether the published budget for each film was public before opening, and whether it was later revised | A budget published after opening is not a pre-release feature |
| Studio crosswalk | Which source field, and which company names, implement options A–C in the research design | A wrong label changes the population |
| Eligible-title count | How many wide theatrical films each scope and year window actually yields on a permissible source | The 100–200+ goal may be infeasible |
| Genre crosswalk | How TMDB genres, IMDb’s up-to-three genres, The Numbers genre, and Wikidata P136 line up | Cohort cells depend on the coding |
| Franchise crosswalk | Share of Disney titles with TMDB `belongs_to_collection`, Wikidata P179, or a Numbers franchise, and whether membership was backfilled after later sequels | A collection created after the next sequel can leak future information if the “as of” date is ignored |
| Wikidata box office split | P2142 is “box office takings accumulated by a film.” The property does not, by itself, state domestic versus worldwide. Qualifiers such as point in time are not guaranteed | Cannot treat P2142 as the approved outcome without a per-statement check |
| Opening and week-2 completeness | Share of in-scope films with a wide-weekend gross and a theater count through week 2 | Stages 1 and 2 are undefined when the rows are missing |
| Public theater counts | IMDb’s help text says theater-count charts are on IMDbPro. A public weekend page reviewed on 30 September 2026 still displayed theater counts. Completeness of the public pages was not measured | Do not plan on scraping either set |
| OpusData column names | The public data-services page lists daily, weekend, weekly, and cumulative theatrical gross, plus budgets. It does not publish a field-level schema | Licensed columns are Required only after the extract is specified |
| Rating history | No reviewed source provides `vote_average` or IMDb `averageRating` as of opening weekend or as of week 2 | Without a dated snapshot, ratings stay Excluded |
| Source precedence | Which source wins when budget or gross disagree | The *Frozen* discrepancy in the research design shows the label can move |

## Excluded variables

| Variable | Reason |
| --- | --- |
| Disney+ engagement, hours viewed, or completion | No reliable public title-level series was found for this slate. Nielsen’s public Streaming Top 10 is a U.S. television-screen ranking of programs that reach the weekly list, not a theatrical panel and not a complete Disney+ extract. Excluded as a feature and as an outcome |
| `popularity` (TMDB) | Documented on movie details as a current score. It is not a pre-release or week-2 state |
| `vote_average`, `vote_count` (TMDB) | Documented current user aggregates. They accumulate after release. Excluded as features |
| `averageRating`, `numVotes` (IMDb non-commercial `title.ratings`) | Same leakage. The file is a current snapshot, refreshed daily |
| Critic scores (Wikidata P444 and similar) | The score is not dated to the decision point in the property definition. Excluded unless a snapshot dated on or before the stage is verified |
| Final gross as a feature | Outcome only. Applies to domestic, international, and worldwide |
| Weekly gross or theater count after week 2 | Not known at week 2. A later Excel forecast may use a sealed curve table. That table is not joined to the Stage 0, 1, or 2 feature views |
| Lifetime maximum theater count | Often occurs after week 2. Excluded from all three feature views. Opening and week-2 counts remain Required |
| Home-video sales and other ancillaries | Observed on The Numbers title pages. They are not theatrical underperformance |
| Overview, tagline, poster, and other text or image fields | Not performance measures, and public text can be edited after release |
| Arbitrary cutoffs | Not variables. A round gross or a round budget multiple is not a candidate field |

## Derived fields that are allowed only after the label rule is approved

| Field | Formula intent | Table |
| --- | --- | --- |
| `expectation` | Cohort median, regression fitted value, or *kᵢ × budget*, using earlier films only | Outcome construction |
| `performance_gap` | `(outcome − expectation) / expectation` | Business metric. Not a feature |
| `underperform` | Binary function of the gap under the approved rule | Machine-learning target. Not a feature |
| `opening_per_theater` | `opening_weekend_gross / opening_theater_count` | Stage 1 feature |
| `week2_hold` | Week-2 gross relative to opening-weekend gross | Stage 2 feature |

These columns are specified so later feature views have a contract. They are not computed in this phase.

## Missing values

A documented zero is not treated as a measured zero when the source uses zero as the default for unknown budget or revenue. TMDB’s movie-details schema shows that default for `budget` and `revenue`. Missing opening weekend, missing week-2 gross, or an unfinished run removes the film from the stage or from the labeled set. It is not imputed from final gross, because that imputation is leakage.
