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
| `studio_label` | Production label used to apply the recorded studio scope | Inclusion | **Decided** (7 October 2026): Walt Disney Pictures, Walt Disney Animation Studios, Pixar, Marvel Studios, Lucasfilm, and 20th Century only for films released after the acquisition of 21st Century Fox closed on 20 March 2019. The field name differs by source (production company, distributor). Mapping those names is still **Needs verification** |
| `is_wide_theatrical` | Film had a wide domestic theatrical release | Inclusion | **Decided** (7 October 2026). Week 1 is the first Friday–Sunday on which domestic theaters are at least 600. Disney+ originals with no wide theatrical release are out. A theatrical film that later streams on Disney+ stays in. Television films, shorts, and festival-only titles stay out |
| `release_date` | Start date of the wide domestic theatrical run | Pre-release | Required clock. **Decided** (7 October 2026): the window is a wide-release date on or after 7 October 2016. Platform and preview dates are stored separately and do not replace this date |
| `release_year` | Calendar year of `release_date` | Pre-release | Derived |
| `genre` | Source genre labels, retained as a list | Pre-release | Candidate covariate for the expectation regression. Taxonomies differ and are not a shared code set. The coding crosswalk is **Needs verification** |
| `budget` | Reported production budget in nominal U.S. dollars | Pre-release, if the figure was public before opening | Candidate covariate for the recorded expectation regression, and the pre-release one-feature baseline. The budget-multiple alternative was not selected. Zero is not a verified budget: TMDB’s schema default for `budget` is 0. Timing remains **Needs verification** |
| `opening_weekend_gross` | Domestic gross for week 1: the first Friday–Sunday on which domestic theaters are at least 600 | Week 1 | **Decided** (7 October 2026). Required week-1 feature. A platform or preview weekend is not this field |
| `opening_theater_count` | Theater count for that same Friday–Sunday | Week 1 | Required week-1 feature. The wide threshold is at least 600 domestic theaters. Public completeness is **Needs verification**; the licensed IMDb field `numTheaters` is documented |
| `week2_gross` | Domestic gross for week 2: the next Friday–Sunday after week 1 | Week 2 | **Decided** (7 October 2026). Required week-2 feature. Not the Friday–Thursday week |
| `week2_theater_count` | Theater count for that same Friday–Sunday | Week 2 | Required week-2 feature |
| `outcome_gross` | Finished nominal worldwide theatrical gross | Outcome only | **Decided** (7 October 2026). Required label input. Never a feature. No CPI and no ticket-price adjustment. If worldwide gross is missing, drop the film. Do not fall back to domestic |

The outcome definition is recorded, so collection can build `outcome_gross` as nominal worldwide theatrical gross once a licensed extract is in hand. Collection itself has not started. Domestic and international totals may be staged as separate source columns for the data-risk note and for a precedence rule. They do not fill a missing worldwide gross. A missing worldwide gross drops the film.

## Optional variables

| Variable | Definition | Stage | Notes |
| --- | --- | --- | --- |
| `release_month` | Month of `release_date` | Pre-release | Derived. Candidate covariate for the expectation regression (release month or season). Collinear with the date |
| `franchise` | Indicator that the film has at least one earlier film in the same series | Pre-release | Candidate covariate. Derived only from earlier releases |
| `franchise_name` | Series or collection name | Pre-release | Optional. TMDB `belongs_to_collection`, Wikidata P179, and The Numbers’ Franchise field are not the same construct. Coverage is **Needs verification** |
| `production_method` | Animation versus live action, or a finer method such as digital animation | Pre-release | Candidate covariate (animation versus live action). The Numbers publishes Production Method (observed on *Frozen* as Digital Animation). TMDB has an Animation genre, which is not the same as production method. Wikidata has no dedicated production-method property on the movie property list reviewed |
| `runtime` | Runtime in minutes | Pre-release | Candidate covariate. Documented on TMDB `runtime`, IMDb `runtimeMinutes`, Wikidata P2047. Box Office Mojo displayed running time on the *Frozen* title page |
| `mpaa_rating` | U.S. classification | Pre-release, when issued before opening | Candidate covariate if available. Observed on Box Office Mojo and The Numbers. Wikidata P1657 is MPA film rating. TMDB stores certification on the release-dates endpoint, not on the core details object |
| `domestic_gross` | Final domestic theatrical gross | Outcome component | Descriptive component only. Not the outcome, and not a fallback when worldwide gross is missing. Excluded as a feature. Domestic geography mismatches across sources remain a data-risk note |
| `international_gross` | Final international theatrical gross | Outcome component | Descriptive component only. Not the outcome and not a feature. Not known in full at week 1 |
| `worldwide_gross` | Final worldwide theatrical gross, nominal dollars | Outcome component | This is `outcome_gross`. **Decided** (7 October 2026). Excluded as a feature. If it is missing, drop the film |
| `prior_franchise_count` | Count of earlier films in the same series | Pre-release | Candidate covariate (prior franchise history). Derived. Uses only earlier releases |
| `prior_franchise_median_outcome` | Median outcome of those earlier films | Pre-release | Candidate covariate (prior franchise history). Derived. Uses only earlier releases |
| `distributor` | Domestic theatrical distributor | Inclusion audit | Optional. Box Office Mojo displays Domestic Distributor. Wikidata P750 is “distributed by.” Distributor is not the same as production label |

## Needs verification

These items stay out of the required modeling table until the check named here is done.

| Item | What is unverified | Why it matters |
| --- | --- | --- |
| Budget timing | Whether the published budget for each film was public before opening, and whether it was later revised | A budget published after opening is not a pre-release feature |
| Studio crosswalk | Which source field and which company names implement the recorded population: Walt Disney Pictures, Walt Disney Animation Studios, Pixar, Marvel Studios, Lucasfilm, and 20th Century only after 20 March 2019 | A wrong label changes the population. The scope rule is decided. The crosswalk is not |
| Eligible-title count | How many films the recorded population and window yield on a licensed extract: wide-release date on or after 7 October 2016 | Still unmeasured. The window is shorter than the earlier 100–200 sample-size goal and may be tight for a time-aware split. Modeling is not treated as feasible until this count is checked |
| Genre crosswalk | How TMDB genres, IMDb’s up-to-three genres, The Numbers genre, and Wikidata P136 line up | Genre is a candidate covariate. The coding is not a shared code set |
| Franchise crosswalk | Share of Disney titles with TMDB `belongs_to_collection`, Wikidata P179, or a Numbers franchise, and whether membership was backfilled after later sequels | A collection created after the next sequel can leak future information if the “as of” date is ignored |
| Wikidata box office split | P2142 is “box office takings accumulated by a film.” The property does not, by itself, state domestic versus worldwide. Qualifiers such as point in time are not guaranteed | Cannot treat P2142 as nominal worldwide gross without a per-statement check |
| Opening and week-2 completeness | Share of in-scope films with week-1 gross and theaters (first Friday–Sunday at 600 or more domestic theaters) and with the next Friday–Sunday | Week 1 and week 2 are undefined when those rows are missing |
| Public theater counts | IMDb’s help text says theater-count charts are on IMDbPro. A public weekend page reviewed on 30 September 2026 still displayed theater counts. Completeness of the public pages was not measured | Do not plan on scraping either set |
| OpusData column names | The public data-services page lists daily, weekend, weekly, and cumulative theatrical gross, plus budgets. It does not publish a field-level schema | Licensed columns are Required only after the extract is specified |
| Rating history | No reviewed source provides `vote_average` or IMDb `averageRating` as of opening weekend or as of week 2 | Without a dated snapshot, ratings stay Excluded |
| Source precedence | Which source wins when budget or gross disagree | **Needs your approval.** The *Frozen* discrepancy in the research design shows the label can move. Not solved |
| Expectation formula | Which covariates inside the named candidate set enter the regression | **Needs your approval.** The set is budget, genre, franchise flag and prior franchise history from earlier films only, animation versus live action, release month or season, runtime, and MPAA rating if available. The formula is frozen before the test period is inspected. It is not frozen yet. No covariate is added beyond that set |

## Excluded variables

| Variable | Reason |
| --- | --- |
| Disney+ engagement, hours viewed, or completion | No reliable public title-level series was found for this slate. Nielsen’s public Streaming Top 10 is a U.S. television-screen ranking of programs that reach the weekly list, not a theatrical panel and not a complete Disney+ extract. Excluded as a feature and as an outcome |
| `popularity` (TMDB) | Documented on movie details as a current score. It is not a pre-release or week-2 state |
| `vote_average`, `vote_count` (TMDB) | Documented current user aggregates. They accumulate after release. Excluded as features |
| `averageRating`, `numVotes` (IMDb non-commercial `title.ratings`) | Same leakage. The file is a current snapshot, refreshed daily |
| Critic scores (Wikidata P444 and similar) | The score is not dated to the decision point in the property definition. Excluded unless a snapshot dated on or before the stage is verified |
| Final gross as a feature | Outcome only. Applies to domestic, international, and worldwide |
| Weekly gross or theater count after week 2 | Not known at week 2. A later Excel forecast may use a sealed curve table. That table is not joined to the pre-release, week-1, or week-2 feature views |
| `cpi_u` and ticket-price adjustment | **Decided** (7 October 2026): the outcome is nominal worldwide gross. CPI-U and a ticket-price index were considered and are not applied |
| Lifetime maximum theater count | Often occurs after week 2. Excluded from all three feature views. Opening and week-2 counts remain Required |
| Home-video sales and other ancillaries | Observed on The Numbers title pages. They are not theatrical underperformance |
| Overview, tagline, poster, and other text or image fields | Not performance measures, and public text can be edited after release |
| Arbitrary cutoffs | Not variables. A round gross or a round budget multiple is not a candidate field |

## Derived fields

The label rule was recorded on 7 October 2026. These columns are the contract for later tables. They are not computed in this phase.

The candidate pre-release attributes for `expectation` are budget, genre, a franchise flag and prior franchise history from earlier films only, animation versus live action, release month or season, runtime, and MPAA rating if available. No covariate is added beyond that set. The exact formula inside that set is **Needs your approval**. It is frozen before the test period is inspected. It is not frozen yet.

| Field | Formula intent | Table |
| --- | --- | --- |
| `expectation` | Fitted value, on the original dollar scale, from a regression of log worldwide gross on the candidate pre-release attributes, using only films with an earlier wide-release date | Outcome construction. Not a feature. Not refit on the film being labeled or on the test period |
| `performance_gap` | `(actual − expected) / expected` | Business metric. Not the classifier target and not a feature |
| `underperform` | 1 when finished worldwide gross is below that film’s fitted expectation | Machine-learning target. Stored only on the outcome table. Not a feature |
| `opening_per_theater` | `opening_weekend_gross / opening_theater_count` | Week-1 feature |
| `week2_hold` | Week-2 Friday–Sunday gross relative to week-1 Friday–Sunday gross | Week-2 feature |

## Missing values

A documented zero is not treated as a measured zero when the source uses zero as the default for unknown budget or revenue. TMDB’s movie-details schema shows that default for `budget` and `revenue`. If worldwide gross is missing, the film is dropped. Domestic gross is not a fallback. Missing week-1 gross, missing week-2 gross, or an unfinished run removes the film from that stage or from the labeled set. It is not imputed from final gross, because that imputation is leakage.
