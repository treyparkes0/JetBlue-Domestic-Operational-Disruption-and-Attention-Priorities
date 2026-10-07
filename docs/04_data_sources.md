# Data sources

**Project:** Film Performance Analytics  
**Phase:** 2. Sources were reviewed on 30 September 2026. Design decisions recorded on 7 October 2026 are applied below where they change a field’s role. This is not a data extract. No file was downloaded for analysis, and no page was scraped for a dataset.

A field is listed under a source only when current public documentation or the source page itself supports it. “Observed” means the field was present on a page opened during this review. It does not mean the field is complete for Disney films.

## Source roles

| Source | Role in this project | Acquisition constraint |
| --- | --- | --- |
| IMDb non-commercial datasets | Identity, title type, year, runtime, up to three genres, current rating and vote count | Personal and non-commercial use, local copies allowed under IMDb’s non-commercial terms. No box office in these files. Raw files are not committed to GitHub |
| IMDb / Box Office Mojo licensed bulk data (AWS Data Exchange) | Budgets, lifetime gross by area, opening weekend, and daily/weekend/weekly time series with theater counts | Paid license. Schema reviewed from public documentation. Not obtained |
| Box Office Mojo public pages | Illustration of fields an analyst can see, and a check on definitions | Automated collection is prohibited without IMDb’s prior written permission. Not a collection method for Phase 3 |
| The Numbers public pages | Same, plus production method, franchise, and an inflation-adjusted domestic figure | Systematic copying, scraping, and academic reuse require an OpusData license. Not a collection method for Phase 3 |
| OpusData | Licensed feed behind The Numbers: budgets and domestic/international theatrical gross at daily, weekend, weekly, and cumulative grain | Academic subscriptions and one-time extracts exist; pricing is on request. Column-level schema was not on the public page reviewed |
| TMDB API | Candidate identity and production metadata | API terms, last updated 20 October 2023, prohibit use of the APIs or TMDB content in connection with a machine-learning application, including training. Not cleared for this project’s models |
| Wikidata | Candidate identity, genre, series, budget, and cumulative box office under CC0 | Query via the public SPARQL service. Coverage and box-office qualifiers are **Needs verification** |
| BLS CPI-U `CUUR0000SA0` | Considered deflator, not used | Public. **Decided** (7 October 2026): no CPI adjustment. The outcome is nominal worldwide gross |
| Nielsen Streaming Top 10 | Checked as a possible Disney+ engagement source | Not usable for this design. See Exclusions |

GitHub stores code and documentation only. Credentials, `.env` files, and raw datasets are not committed.

## Terms and scraping risk

Phase 3 does not include a scraper. No OpusData academic extract and no IMDb box-office license is in hand.

**Box Office Mojo and IMDb.** `robots.txt` on Box Office Mojo states that data mining or scraping by automated means is prohibited without prior written permission from IMDb, and it points licensing to IMDb. IMDb’s Conditions of Use prohibit data mining, robots, screen scraping, or similar extraction tools except with express written consent. The licensed box-office product is the permitted machine-readable path.

**The Numbers.** Terms reviewed on 30 September 2026 prohibit scraping and automated collection except for a narrow search-engine exception. Section 4.3 requires prior written permission before automated collection for datasets used to train or develop machine-learning models. Section 6 states that academic research use requires an OpusData license. Personal, non-commercial reading and casual copying do not cover a systematic capstone extract or redistribution in a repository.

**TMDB.** The API license requires attribution and prohibits selling TMDB content. It also prohibits using the APIs or TMDB content in connection with, including for training, a machine-learning or AI application. Cache of API content is limited to six months. A student project whose purpose is a machine-learning early-warning model is inside that prohibition unless TMDB grants written permission. Identity lookup that never enters a modeling table would still need a careful reading of “in connection with” an ML application. Until permission exists, TMDB is not a modeling source. A movie-database API token in a local `.env` is not collection permission.

**Wikidata.** Structured data in the main and property namespaces are available under CC0. That license is compatible with research use. It does not repair missing weekly grosses.

**IMDb non-commercial files.** They may support a title spine. Publishing those files in this public repository would go beyond holding a local copy for personal non-commercial use. Keep them out of Git.

## What each source actually documents

### TMDB API

Reviewed: [movie details](https://developer.themoviedb.org/reference/movie-details), [release dates](https://developer.themoviedb.org/reference/movie-release-dates), [API terms](https://www.themoviedb.org/api-terms-of-use), and the [movie bible on budget and revenue](https://www.themoviedb.org/bible/movie).

Documented on movie details: `id`, `imdb_id`, `title`, `original_title`, `release_date`, `runtime`, `genres` (id and name), `budget`, `revenue`, `vote_average`, `vote_count`, `popularity`, `belongs_to_collection` (id and name, nullable), `production_companies` (id and name), `status`.

Documented on release dates: country-level dates and a type code. Type 2 is theatrical (limited). Type 3 is theatrical. Type 4 is digital. The endpoint does not provide gross.

Movie bible: budget and revenue are in U.S. dollars and are not inflation-adjusted. For U.S. movies, worldwide box office is requested when available, and “US only is fine” otherwise. The API field is still a single integer named `revenue`. It does not carry a territory flag. A value cannot be assumed to be worldwide for every title.

Not documented, and not claimed: opening weekend, theater count, weekly gross, prints and advertising, Disney+ engagement, and a historical rating snapshot. There is no animation-versus-live-action field. An Animation genre is not that field. A local API token does not change that, and it is not clearance to collect TMDB content for this project.

### IMDb non-commercial datasets

Reviewed: [non-commercial datasets](https://developer.imdb.com/non-commercial-datasets/).

`title.basics` documents `tconst`, `titleType`, `primaryTitle`, `originalTitle`, `startYear`, `runtimeMinutes`, and `genres` (up to three). `title.ratings` documents `averageRating` and `numVotes`.

Not included: budget, gross, opening weekend, theater count, franchise, and production company.

### IMDb licensed box office

Reviewed: [box-office data dictionary](https://developer.imdb.com/documentation/bulk-data-documentation/data-dictionary/box-office).

| File | Documented fields relevant here |
| --- | --- |
| `boxoffice_title_budgets_v1` | Production budget in USD |
| `boxoffice_title_grosses_v1` | Lifetime `grossToDate` by area |
| `boxoffice_title_opening_weekends_v1` | Opening weekend `gross`, `startDate`, `endDate`, `numTheaters`. Occasion value documented as `weekend` |
| `boxoffice_title_grosses_timeseries_v1` | `gross`, `grossToDate`, `numTheaters`, `startDate`, `endDate`, `ocassionId` including Weekend, Weekly, and Daily |

Area `XDOM` is domestic (United States and Canada). `XNDOM` is international. `XWW` is worldwide. Puerto Rico is a separate area code, which does not match every public definition of domestic.

This is the source that documents the week-1 and week-2 fields as data, rather than as HTML. It is not in hand. No OpusData academic extract is in hand either. Phase 3 must not scrape Box Office Mojo or The Numbers.

### Box Office Mojo public pages

Reviewed: the help article on [Box Office Mojo by IMDbPro](https://help.imdb.com/article/imdbpro/industry-research/box-office-mojo-by-imdbpro-faq/GCWTV4MQKGWRAUAP), `robots.txt`, and the public title page for *Frozen* (2013) at `https://www.boxofficemojo.com/title/tt2294629/`.

The help text defines domestic as the United States, Canada, and Puerto Rico, and international as the rest of the world. It states that theater-count charts are available exclusively on IMDbPro.

The *Frozen* title page displayed domestic, international, and worldwide gross, domestic opening, budget, earliest release date, MPAA rating, running time, genres, and domestic distributor, plus territory-level opening and gross. That summary view did not display a theater count or a weekly time series.

A public weekend page for *The Wild Robot* (`/release/rl3443949569/weekend/`), fetched the same day, rendered a weekend table with date, rank, weekend gross, theaters, average, and a weekend index, and it displayed a widest-release theater count. The page links a domestic weekly view; that weekly view was not opened. This conflicts with the help-center statement that theater-count charts are exclusive to IMDbPro. Completeness of public theater counts is **Needs verification**. These pages are evidence of what is rendered, not a license to collect it.

### The Numbers and OpusData

Reviewed: [terms of service](https://www.the-numbers.com/terms-of-service), [data services](https://www.the-numbers.com/data-services), the market-definition page describing domestic as the United States, Canada, Puerto Rico, and Guam, and the public title page `https://www.the-numbers.com/movie/Frozen-(2013)`.

The *Frozen* page displayed domestic, international, and worldwide box office; opening weekend; production budget; opening and maximum theater counts; inflation-adjusted domestic box office; franchise; production method; genre; running time; MPAA rating; and weekend and daily tables with gross, theaters, and a week index. The opening figure matched the platform opening, so the page’s “opening weekend” is not automatically the wide opening.

OpusData’s public description lists production budgets and domestic and international theatrical box office at daily, weekend, weekly, and cumulative grain, and states that academic subscribers can request extracts. It does not list column names. Treat the grain as documented and the physical schema as **Needs verification**.

### Wikidata

Reviewed: [WikiProject Movies properties](https://www.wikidata.org/wiki/Wikidata:WikiProject_Movies/Properties), property pages for P2142 and P345, and [Wikidata licensing](https://www.wikidata.org/wiki/Wikidata:Licensing).

Properties on that list that match candidate fields:

| Property | ID | Use |
| --- | --- | --- |
| Title | P1476 | Title |
| Publication date | P577 | A release date, not necessarily the wide domestic date. Qualifier P291 is place of publication |
| Genre | P136 | Genre |
| Production company | P272 | Studio-scope candidate |
| Distributed by | P750 | Distributor |
| Part of the series | P179 | Franchise candidate, with qualifiers for follows, followed by, and series ordinal |
| Capital cost | P2130 | Budget candidate, with a currency unit |
| Box office | P2142 | Cumulative takings. Territory is not in the property definition |
| Duration | P2047 | Runtime |
| IMDb ID | P345 | Crosswalk |
| MPA film rating | P1657 | Optional rating |

No weekly-gross property and no theater-count property appear on the movie property list reviewed. Do not invent them.

### BLS

Reviewed: [CPI series ID codes](https://www.bls.gov/cpi/factsheets/cpi-series-ids.htm). `CUUR0000SA0` is CPI-U, all items, U.S. city average, not seasonally adjusted. It is a general price index. It was considered as a deflator and is not applied. The recorded outcome is nominal worldwide gross.

### Disney+ engagement

Nielsen’s public Streaming Top 10 ranks U.S. television-screen viewing for titles that make a weekly list. Disney does not publish a complete title-level Disney+ engagement file in the sources reviewed. Engagement is **Excluded**.

## Source matrix

Stage names the earliest decision point at which the field would be usable if the leakage rule is met. “Outcome only” means the column may be stored for the label and must not enter a feature view.

| Variable | Source | Availability | Stage | Class | Notes |
| --- | --- | --- | --- | --- | --- |
| `movie_id` | Project | Assigned at collection | All | Required | Not a vendor key |
| `imdb_id` | IMDb `title.basics` | Documented | Crosswalk | Required | `tconst` |
| `imdb_id` | TMDB movie details | Documented as `imdb_id` | Crosswalk | Needs verification | Field exists. Use in this ML project is not cleared by the API terms |
| `imdb_id` | Wikidata P345 | Documented | Crosswalk | Optional | CC0 cross-check |
| `title` | IMDb `primaryTitle` | Documented | Attribute | Required | |
| `title` | TMDB `title` | Documented | Attribute | Needs verification | Same terms constraint |
| `title` | Wikidata P1476 | Documented | Attribute | Optional | Monolingual text |
| `title` | Box Office Mojo, The Numbers | Observed on *Frozen* | Attribute | Excluded | As a scraped source. Visible, not collectable under current terms |
| `studio_label` | TMDB `production_companies` | Documented | Inclusion | Needs verification | Names must be mapped. Terms constrain use |
| `studio_label` | Wikidata P272 | Documented | Inclusion | Needs verification | Coverage of each Disney label is uncounted |
| `studio_label` | Box Office Mojo distributor | Observed as Domestic Distributor | Inclusion | Needs verification | Distributor is not production company |
| `studio_label` | The Numbers production companies | Observed on *Frozen* | Inclusion | Needs verification | License required for systematic use |
| `release_date` | TMDB `release_date` and release-dates types 2 and 3 | Documented | Pre-release | Needs verification | Core `release_date` is one date. Wide versus limited requires the release-dates endpoint. Terms constrain use |
| `release_date` | IMDb `startYear` | Documented | Pre-release | Needs verification | Year only, not a date |
| `release_date` | Wikidata P577 | Documented | Pre-release | Needs verification | Not guaranteed to be the wide U.S. date |
| `release_date` | Box Office Mojo, The Numbers | Observed | Pre-release | Needs verification | *Frozen* earliest/domestic date aligned with the one-theater weekend on The Numbers. The wide date has to be identified separately. License or permission required |
| `release_year` | Derived from the approved `release_date` | Derived | Pre-release | Required | |
| `release_month` | Derived from the approved `release_date` | Derived | Pre-release | Optional | |
| `genre` | TMDB `genres` | Documented | Pre-release | Needs verification | Terms constrain use |
| `genre` | IMDb `genres` | Documented, up to three | Pre-release | Optional | Usable non-commercial spine if kept out of Git |
| `genre` | Wikidata P136 | Documented | Pre-release | Optional | Crosswalk unverified |
| `genre` | Box Office Mojo, The Numbers | Observed | Pre-release | Needs verification | Different taxonomies. The Numbers also has subgenre and creative type |
| `budget` | TMDB `budget` | Documented, USD, not inflation-adjusted; 0 is the schema default | Pre-release | Needs verification | Territory and timing of the figure are not on the record. Terms constrain use |
| `budget` | IMDb `boxoffice_title_budgets_v1` | Documented, production budget in USD | Pre-release | Required | Only after a license, and only if pre-release timing is accepted |
| `budget` | Wikidata P2130 | Documented quantity with currency | Pre-release | Needs verification | Coverage unknown |
| `budget` | The Numbers / OpusData | Observed on the public page; listed in the licensed feed | Pre-release | Required | Preferred commercial path if the academic extract includes it. Timing still **Needs verification** |
| `budget` | Box Office Mojo public page | Observed on *Frozen* | Pre-release | Excluded | As a scraped field |
| `franchise_name` | TMDB `belongs_to_collection` | Documented, nullable | Pre-release | Needs verification | A collection is not always a franchise, and it can be edited after later sequels |
| `franchise_name` | Wikidata P179 | Documented | Pre-release | Optional | Use ordinal and “follows” qualifiers. Confirm the earlier-film rule at build time |
| `franchise_name` | The Numbers Franchise | Observed on *Frozen* | Pre-release | Needs verification | License required. Coverage uncounted |
| `franchise` | Derived | Not a source field | Pre-release | Optional | True only if an earlier film in the series exists |
| `production_method` | The Numbers Production Method | Observed | Pre-release | Optional | Best public match to animation versus live action. License required for systematic use |
| `production_method` | TMDB genres | Animation genre documented; method is not | Pre-release | Excluded | Not a substitute for production method |
| `runtime` | TMDB `runtime` | Documented, minutes | Pre-release | Needs verification | Terms constrain use |
| `runtime` | IMDb `runtimeMinutes` | Documented | Pre-release | Optional | |
| `runtime` | Wikidata P2047 | Documented | Pre-release | Optional | |
| `mpaa_rating` | TMDB release dates `certification` | Documented on the release-dates endpoint | Pre-release | Needs verification | Not on the core details object |
| `mpaa_rating` | Wikidata P1657 | Documented | Pre-release | Optional | |
| `mpaa_rating` | Box Office Mojo, The Numbers | Observed | Pre-release | Needs verification | Permission or license required |
| `opening_weekend_gross` | IMDb `boxoffice_title_opening_weekends_v1` | Documented, by area, with dates | Week 1 | Required | License required. **Decided** (7 October 2026): the row is the first Friday–Sunday with at least 600 domestic theaters, not a platform or preview weekend |
| `opening_weekend_gross` | OpusData | Weekend grain listed publicly; columns not listed | Week 1 | Required | Schema **Needs verification** |
| `opening_weekend_gross` | Box Office Mojo, The Numbers public pages | Observed | Week 1 | Excluded | As scraped fields. *Frozen* opening was the platform weekend |
| `opening_weekend_gross` | TMDB, Wikidata, IMDb non-commercial | Not found | — | Excluded | Not a documented field |
| `opening_theater_count` | IMDb opening-weekend `numTheaters` | Documented | Week 1 | Required | License required |
| `opening_theater_count` | OpusData | Implied by theatrical theater reporting; not a named public column | Week 1 | Needs verification | Confirm the column in an academic extract |
| `opening_theater_count` | Box Office Mojo public weekend page | Observed on one title; help text says theater charts are IMDbPro | Week 1 | Needs verification | Do not scrape. Completeness unknown |
| `opening_theater_count` | The Numbers | Observed as opening theaters | Week 1 | Needs verification | License required |
| `week2_gross` | IMDb timeseries, occasion Weekly or Weekend | Documented | Week 2 | Required | **Decided** (7 October 2026): the next Friday–Sunday after week 1, not the Friday–Thursday weekly occasion. License required. Confirm the extract row is that weekend |
| `week2_gross` | OpusData weekly gross | Listed at category level | Week 2 | Required | Schema **Needs verification** |
| `week2_gross` | The Numbers weekend table | Observed, with a Week index | Week 2 | Needs verification | License required. Week 1 on *Frozen* was the platform week |
| `week2_theater_count` | IMDb timeseries `numTheaters` | Documented | Week 2 | Required | License required |
| `week2_theater_count` | The Numbers weekend table | Observed | Week 2 | Needs verification | License required |
| `domestic_gross` | IMDb lifetime gross, area `XDOM` | Documented | Outcome only | Optional | Not the outcome. Area `XDOM` is the United States and Canada. That geography mismatch is a data-risk note, not a fallback when worldwide gross is missing. Excluded as a feature. License required |
| `domestic_gross` | The Numbers / OpusData | Observed and listed | Outcome only | Optional | Not the outcome. This domestic definition includes Puerto Rico and Guam. Geography mismatch is a data-risk note, not a fallback. License required for systematic use |
| `domestic_gross` | Box Office Mojo public page | Observed | Outcome only | Excluded | As a scraped field. Help definition includes Puerto Rico |
| `domestic_gross` | Wikidata P2142 | Documented cumulative takings only | Outcome only | Needs verification | Do not assume this is domestic |
| `international_gross` | IMDb area `XNDOM`; Numbers; Box Office Mojo | Documented or observed as above | Outcome only | Optional | Excluded as a feature |
| `worldwide_gross` | IMDb area `XWW`; Numbers; Box Office Mojo | Documented or observed as above | Outcome only | Required | **Decided** (7 October 2026): nominal worldwide gross is `outcome_gross`. If it is missing, drop the film. Do not fall back to domestic. Not a feature. License or permission required; public pages are not a collection path |
| `worldwide_gross` | TMDB `revenue` | Documented integer. Bible prefers worldwide when available | Outcome only | Needs verification | No territory attribute. Terms constrain use. 0 is the schema default. Not cleared for model training. A local API token is not collection permission, and this field is not a fallback for a missing worldwide gross |
| `weekly_gross` after week 2 | IMDb timeseries; OpusData; Numbers daily/weekend tables | Documented or observed | Excluded from features | Excluded | May be stored later in a sealed curve table for Excel. Not joined to feature views |
| `ratings`, `vote_count` | TMDB `vote_average`, `vote_count`; IMDb `title.ratings` | Documented current snapshots | Excluded from features | Excluded | No as-of-opening snapshot found |
| `popularity` | TMDB | Documented current score | Excluded | Excluded | |
| Disney+ engagement | Nielsen Top 10 | Public weekly ranks only | Excluded | Excluded | Not a film-level theatrical measure |
| CPI-U | BLS `CUUR0000SA0` | Documented | Not used | Excluded | Considered and not applied. Nominal worldwide gross was decided on 7 October 2026 |
| Inflation-adjusted domestic gross | The Numbers | Observed | Not used | Excluded | Ticket-price adjustment was considered and is not applied. Not a second outcome |

## Data-quality risks

1. **Definition drift.** Domestic does not mean the same geography on The Numbers, Box Office Mojo help text, and IMDb area `XDOM`.
2. **Level disagreement.** *Frozen* (2013) totals on the two public pages did not match on 30 September 2026. See the research design. Either source can move a label.
3. **Platform openings.** Using the first reported weekend as week 1 misplaces the decision for films that open limited and then expand. The recorded week 1 is the first Friday–Sunday with at least 600 domestic theaters.
4. **Re-releases.** The Numbers weekend table for *Frozen* includes a November 2020 return. That row is not week 2 of the 2013 run.
5. **Zero-as-missing.** TMDB budget and revenue use 0 as a schema default.
6. **Undated ratings and popularity.** Current scores leak post-release audience response.
7. **Franchise backfill.** Collection and series membership can be added after a later film exists.
8. **Budget timing and content.** Published budgets omit prints and advertising and may be estimates.
9. **Unfinished runs.** A gross pulled while a film is still in release is not a final outcome.
10. **Small-n selection.** Dropping films with missing worldwide gross, missing budgets, or missing week-1 or week-2 counts will favor better-documented titles. A missing worldwide gross drops the film. Domestic gross is not a fallback.
11. **Structural break.** Releases during the 2020 theatrical shutdown are not exchangeable with other years. **Decided** (7 October 2026): the window keeps a title when its wide-release date is on or after 7 October 2016, including shutdown-period titles that otherwise qualify. The window is not split to drop them. Hypothesis 4 still asks whether residuals in that period are larger.
12. **License and terms.** A field observed in a browser is still unavailable if the terms prohibit systematic reuse or machine-learning use.

## Required and optional, in one list

**Required concepts:** project `movie_id`, `imdb_id`, title, studio label sufficient to apply the recorded scope, wide-theatrical flag, wide-release date, release year, genre, production budget, week-1 gross, week-1 theater count, week-2 gross, week-2 theater count, and nominal worldwide theatrical gross.

**Optional concepts:** release month or season, franchise name and the derived franchise indicator, prior-franchise history from earlier films only, animation versus live action, runtime, MPAA rating if available, domestic and international final gross as descriptive components, and distributor. Together with budget and genre, those pre-release fields are the candidate set for the expectation regression. CPI-U is not in that set.

**Excluded concepts:** Disney+ engagement, current ratings and vote counts, TMDB popularity, final gross as a feature, post-week-2 curves as features, lifetime maximum theaters, ancillaries, arbitrary cutoffs, CPI adjustment, and ticket-price adjustment.

**Not cleared for model training:** TMDB content. A movie-database API token in a local `.env` is not collection permission. TMDB does not document opening weekend, theater counts, or weekly gross.

## What must be verified before Phase 3 collection

The population, window, outcome, expectation, label, clock, and evaluation were recorded on 7 October 2026. The wide-release rule is part of that record and is applied to the date fields before any feature is built: week 1 is the first Friday–Sunday with at least 600 domestic theaters, week 2 is the next Friday–Sunday, and a platform or preview weekend is release history, not week 1. The items below are still open. Phase 3 does not start while they are open. Collection, AWS, dbt, models, Excel, and Power BI are still unbuilt.

1. An OpusData academic extract, an IMDb box-office license, or both. Neither is in hand. Scraping Box Office Mojo or The Numbers is not the path.
2. TMDB stays out of model training. A movie-database API token in a local `.env` is not collection permission. TMDB does not document opening weekend, theater counts, or weekly gross.
3. A column list from the licensed extract that names budget, nominal worldwide lifetime gross, week-1 gross, week-1 theater count, and week-2 gross and theaters, with area codes.
4. A count of in-scope theatrical films on that extract. The window is a wide-release date on or after 7 October 2016. The count is unmeasured. Modeling is not treated as feasible until it is checked. The window is shorter than the earlier 100–200 sample-size goal and may be tight for a time-aware split.
5. **Needs your approval:** a precedence rule when budget or gross figures disagree.
6. A check, on a pilot of titles, that Wikidata P2142 either is or is not usable as a cross-check of nominal worldwide gross.
7. Confirmation that raw extracts, API keys, and `.env` files are gitignored and will not be committed.
8. **Needs your approval:** the exact expectation formula inside the named candidate set. The formula is frozen before the test period is inspected. It is not frozen yet. No covariate is added beyond that set.

## Checklist to start Phase 3

Phase 3 is collection only. Checked items were recorded on 7 October 2026. Collection, AWS, dbt, models, Excel, and Power BI are still unbuilt. Phase 3 does not start while an unchecked item remains.

- [x] Population: all current Disney theatrical labels — Walt Disney Pictures, Walt Disney Animation Studios, Pixar, Marvel Studios, Lucasfilm, and 20th Century only for films released after Disney’s acquisition of 21st Century Fox (closed 20 March 2019). Disney+ originals with no wide theatrical release are out. A theatrical film that later streams on Disney+ stays in. Television films, shorts, and festival-only titles stay out.
- [x] Window: wide-release date on or after 7 October 2016. The eligible-title count is still an unchecked item below.
- [x] Outcome: nominal worldwide theatrical gross. No CPI and no ticket-price adjustment. If worldwide gross is missing, drop the film. Do not fall back to domestic.
- [x] Expectation and label: time-aware regression of log worldwide gross on pre-release attributes, using only films with an earlier wide-release date. The fitted value on the original dollar scale is the expectation. Underperform = 1 when finished worldwide gross is below that value. One binary label for all three stages, stored only on the outcome table. It is not a feature. The gap `(actual − expected) / expected` is the business metric, not the classifier target.
- [x] Clock: week 1 is the first Friday–Sunday with at least 600 domestic theaters and adds that weekend’s gross, theater count, and per-theater average. Week 2 is the next Friday–Sunday and adds that weekend’s gross, theater count, and the hold from week 1. A platform or preview weekend is release history, not week 1.
- [x] Evaluation: ROC-AUC on a time-aware held-out test block is the primary metric. Also report precision and recall for the underperformance class, plus accuracy, F1, and the confusion matrix. A later stage is a useful improvement only when its test AUC is higher than both the previous stage and a one-feature baseline, and a bootstrap interval for the AUC difference lies above zero. Baselines: budget only at pre-release; opening-weekend gross / budget after the opening. Week 2 is compared with the opening-weekend model and with that opening baseline.
- [ ] OpusData academic extract and/or IMDb box-office license. Neither is in hand. Do not scrape Box Office Mojo or The Numbers.
- [ ] TMDB stays out of model training. A movie-database API token in a local `.env` is not collection permission.
- [ ] Source-precedence rule when budget or gross figures disagree.
- [ ] In-scope film count on the licensed extract, before modeling is treated as feasible.
- [ ] Exact expectation formula inside the named candidate set, frozen before the test period is inspected. Do not add covariates beyond that set.
- [ ] Raw extracts, API keys, and `.env` files stay out of Git.
