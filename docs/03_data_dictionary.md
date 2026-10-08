# Data dictionary

**Project:** Film Performance Analytics  
**Phase:** 2. This is a classification of variables for the design recorded on 8 October 2026. It is not a collected dataset, and coverage has not been censused.

A gross-based early-warning design was specified on 7 October 2026 and then set aside on 8 October 2026. Weekend gross, theater counts, and budgets are not available without a paid license. Those fields are not required, and they are not the outcome. The 600-theater rule is not a current field.

Classes:

| Class | Meaning |
| --- | --- |
| Required | Needed to define the population, the window, the outcome, or the pre-release model |
| Optional | Documented on a reviewed source, and not required for the recorded design |
| Needs verification | Wanted, but existence, dating, or coverage is not established well enough to treat the field as available |
| Excluded | Not a feature, or not a permissible input. The outcome fields are excluded as features |

The source matrix is in [04_data_sources.md](04_data_sources.md). IMDb fields below are the ones documented on the [IMDb Non-Commercial Datasets](https://developer.imdb.com/non-commercial-datasets/) page. Wikidata properties are the ones named in the research design.

## Grain

One row is one IMDb title with `titleType` `movie` in its original title record. Re-releases are not additional rows. There is no weekly curve table. The gross design’s week-level grain was set aside.

`movie_id` is a project key assigned at collection. `imdb_id` is the IMDb `tconst`. Wikidata P345 is the crosswalk to that identifier.

## Required variables

| Variable | Definition | Role | Notes |
| --- | --- | --- | --- |
| `movie_id` | Project identifier | Key | Assigned by the project |
| `imdb_id` | IMDb `tconst` | Key | From `title.basics`. Wikidata P345 must match it for the production-company join |
| `title` | `primaryTitle` | Attribute | Audit only. Not a feature |
| `title_type` | IMDb `titleType` | Inclusion | **Decided** (8 October 2026). Must be `movie`. Television films, shorts, and episodes are out |
| `studio_label` | Production company from Wikidata P272, mapped to the recorded labels | Inclusion and feature | **Decided** (8 October 2026): Walt Disney Pictures, Walt Disney Animation Studios, Pixar, Marvel Studios, Lucasfilm, and 20th Century only after 20 March 2019. Disney+ originals are out as a population rule |
| `release_date` | Wikidata publication date P577 | Window and feature input | **Decided** (8 October 2026). The window is a release date on or after 7 October 2016. IMDb `startYear` is not this date |
| `release_month` | Month of `release_date` | Feature | Derived |
| `genres` | Up to three genres from `title.basics` | Feature | The genre `Animation` is a proxy for animation, not a production-method field |
| `runtime_minutes` | `runtimeMinutes` | Feature | Minutes. `\N` in the IMDb file means missing |
| `franchise` | 1 if an earlier in-scope film shares a Wikidata P179 series link that does not postdate this film; otherwise 0 | Feature | Franchise versus original. A series link that postdates the film must not set this flag. That check has to be done |
| `prior_person` | 1 if the director or a principal cast member appeared in an earlier in-scope Disney film | Feature | Director from `title.crew`. Principal cast is `title.principals` `category` `actor` or `actress`. History uses only earlier films. Do not use `knownForTitles` |
| `average_rating` | Current IMDb `averageRating` | Outcome only | **Decided** (8 October 2026). Audience response, not financial underperformance. Never a feature. Missing rating means the film is not labeled |
| `num_votes` | IMDb `numVotes` | Inclusion screen only | Never a feature. **Needs your approval:** the minimum below which the film is dropped. No cutoff is chosen |

## Optional variables

| Variable | Definition | Notes |
| --- | --- | --- |
| `release_year` | Calendar year of `release_date` | Derived. Not a substitute for the date |
| `imdb_start_year` | `startYear` from `title.basics` | Year only. Does not place a film on 7 October 2016 |
| `franchise_name` | Series name from Wikidata P179 | Audit aid. The feature is the flag, not the name. Coverage and backfill have to be checked |
| `director_ids` | `nconst` values from `title.crew` `directors` | Inputs to `prior_person`. Not a text feature |
| `principal_ids` | `nconst` values from `title.principals` where `category` is `actor` or `actress` | Inputs to `prior_person`. Cast, not every principal job |
| `person_name` | `primaryName` from `name.basics` | Audit only |

## Needs verification

These checks are not a second approval item. The only **Needs your approval** field is the `numVotes` minimum in the required table.

| Item | What is unverified | Why it matters |
| --- | --- | --- |
| Studio name match | Which Wikidata P272 labels correspond to the six recorded companies, including post-2019 20th Century names | A wrong name changes the population |
| Disney+ originals | No reviewed field marks “Disney+ original” once `titleType` is `movie` | The population rule excludes them. Theater counts, which might have separated them, are unavailable |
| Eligible-title count | How many titles pass `titleType` `movie`, the company match, and the 7 October 2016 window | Unmeasured. Not a license question |
| Series-link timing | Whether P179, or a qualifier on it, postdates the film | A later sequel can backfill the link. The franchise flag must not use that link. This has to be checked |
| Publication date | Whether P577 is present and is the date intended as “release” | Without it the window cannot be applied. `startYear` is not the fallback |

## Excluded variables

| Variable | Reason |
| --- | --- |
| Worldwide, domestic, and international gross | Set aside with the gross design. Not the outcome and not a feature. Not available in the IMDb non-commercial files |
| Opening-weekend gross, week-2 gross, theater counts, per-theater average, and the 600-theater flag | Set aside. Weekend gross and theater counts require a paid license. They are not collected by scraping |
| Budget | Not in the IMDb non-commercial files. Not a feature. The budget baseline was part of the gross design |
| CPI and ticket-price adjustment | There is no dollar outcome |
| Disney+ hours, completion, or Nielsen rank | Not the outcome |
| TMDB `vote_average`, `vote_count`, `popularity`, `revenue`, and `budget` | TMDB is not used in the model |
| IMDb `knownForTitles` | Can include later films. Do not build `prior_person` from it |
| Current rating as a feature | `averageRating` is the outcome only |
| `numVotes` as a feature | Inclusion screen only, after the cutoff is approved |
| Home-video sales and other ancillaries | Not audience-response ratings |
| MPAA rating | Not in the allowed feature list |
| Production method as a separate field | Not in `title.basics`. Use the genre `Animation` as a proxy |
| Arbitrary gross or budget-multiple cutoffs | The gross design was set aside |

## Derived fields

Recorded on 8 October 2026. Not computed in this phase.

| Field | Formula intent | Table |
| --- | --- | --- |
| `expectation` | Fitted `averageRating` from a regression on the allowed pre-release features, using only films with an earlier release date | Outcome construction. Not a feature. Not refit on the film being labeled or on the test period |
| `performance_gap` | `actual rating − expected rating` | Business metric. Not the classifier target and not a feature |
| `underperform` | 1 when the film’s rating is below that fitted rating | Classifier target. Outcome table only. Not a feature |

## Missing values

IMDb uses `\N` for a missing field. That is not a measured zero. A missing `averageRating` drops the film from the labeled set. A missing P577 drops the film from the window. Gross is not imputed, and domestic gross is not a fallback, because gross is not the outcome. `numVotes` is not imputed. Films below the approved vote minimum are dropped. That minimum is not chosen in this dictionary.
