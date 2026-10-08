# Data sources

**Project:** Film Performance Analytics  
**Phase:** 2. Sources for the gross design were reviewed on 30 September 2026. The current design was recorded on 8 October 2026. This is not a data extract. No file was downloaded for analysis, and no page was scraped for a dataset.

A gross-based early-warning design was specified on 7 October 2026 and then set aside on 8 October 2026. Weekend gross, theater counts, and budgets are not available without a paid license. Those licensed sources are not the current collection path. The outcome is the current IMDb average rating.

A field is listed under a source only when current public documentation or a page reviewed on 30 September 2026 supports it.

## Citation

IMDb. “IMDb Non-Commercial Datasets.” https://developer.imdb.com/non-commercial-datasets/. The page documents the files used here and states that the datasets are refreshed daily, that local copies are allowed for personal and non-commercial use, and that use is subject to IMDb’s non-commercial terms. Dataset files are served from https://datasets.imdbws.com/. Raw files are not committed to this repository.

## Source roles

| Source | Role in this project | Acquisition constraint |
| --- | --- | --- |
| IMDb non-commercial datasets | Identity, `titleType`, year, runtime, up to three genres, directors, principals, names, current `averageRating`, and `numVotes` | Cited above. Local copy only. Do not commit the raw files. No box office in these files |
| Wikidata | Production company (P272), publication date (P577), IMDb id (P345), and series (P179) | CC0 for structured data in the main and property namespaces. Query via the public SPARQL service |
| IMDb licensed box office and OpusData | Reviewed for the gross design | Not obtained. Not the current path. Weekend gross, theater counts, and budgets stay unavailable without a paid license |
| Box Office Mojo and The Numbers public pages | Reviewed on 30 September 2026 as illustrations | Not a collection method. Do not scrape |
| TMDB API | Reviewed earlier | Not used in the model. API terms prohibit use of the APIs or TMDB content in connection with a machine-learning application, including training |
| BLS CPI-U | Considered only for the gross design | Not used. There is no dollar outcome |
| Nielsen Streaming Top 10 | Checked as a Disney+ engagement source | Not the outcome |

GitHub stores code and documentation only. Credentials, `.env` files, and raw datasets are not committed.

## Terms and scraping risk

Phase 3 does not include a scraper.

**IMDb non-commercial files.** IMDb’s dataset page permits a local copy for personal and non-commercial use under its terms. Publishing those files in this public repository would go beyond that local copy. Keep them out of Git. IMDb’s Conditions of Use prohibit data mining, robots, screen scraping, or similar extraction tools except with express written consent. The non-commercial files are the permitted path for the rating, not a license to scrape IMDb or Box Office Mojo pages.

**Box Office Mojo.** `robots.txt` states that data mining or scraping by automated means is prohibited without prior written permission from IMDb. The paid box-office product is a different path, and it is not in hand. The current design does not use it.

**The Numbers.** Terms reviewed on 30 September 2026 prohibit scraping and automated collection except for a narrow search-engine exception. Academic research use requires an OpusData license. That license is not in hand. The current design does not use The Numbers.

**TMDB.** The API terms, last updated 20 October 2023, prohibit using the APIs or TMDB content in connection with, including for training, a machine-learning or AI application. A movie-database API token in a local `.env` is not permission to put TMDB in the model. TMDB is not a source for this design.

**Wikidata.** Structured data in the main and property namespaces are available under CC0. That license does not fix a series link that was added after a later sequel.

## What the current sources document

### IMDb non-commercial datasets

Cited above. The files used are:

| File | Fields used | Role |
| --- | --- | --- |
| `title.basics` | `tconst`, `titleType`, `primaryTitle`, `startYear`, `runtimeMinutes`, `genres` (up to three) | Inclusion type, title, runtime, genres. `startYear` is a year, not the window date |
| `title.ratings` | `tconst`, `averageRating`, `numVotes` | Outcome and the vote-count screen. IMDb describes `averageRating` as a weighted average of all individual user ratings. Never features |
| `title.crew` | `tconst`, `directors` (array of `nconst`) | Director for the prior-person flag |
| `title.principals` | `tconst`, `ordering`, `nconst`, `category`, `job`, `characters` | Principal cast for the prior-person flag. Cast is `category` `actor` or `actress` |
| `name.basics` | `nconst`, `primaryName` | Person crosswalk. `knownForTitles` is not a feature |

`titleType` examples on the IMDb page include `movie`, `short`, `tvseries`, `tvepisode`, and `video`. Inclusion requires `movie`.

Not in these files: budget, gross, opening weekend, theater count, production company, and series.

### Wikidata

Reviewed: [WikiProject Movies properties](https://www.wikidata.org/wiki/Wikidata:WikiProject_Movies/Properties), the property pages for P345 and P2142, and [Wikidata licensing](https://www.wikidata.org/wiki/Wikidata:Licensing).

| Property | ID | Use |
| --- | --- | --- |
| Production company | P272 | Studio-scope match and the studio-label feature |
| Publication date | P577 | Release date for the window and for release month. Not guaranteed to be a U.S. theatrical date |
| IMDb ID | P345 | Join to `tconst` |
| Part of the series | P179 | Franchise candidate, with qualifiers for follows, followed by, and series ordinal |

Wikidata series membership can be backfilled after a later sequel. The franchise flag must not use a series link that postdates the film. This has to be checked.

P2142 (box office) is not the outcome. Territory is not in that property definition. It is not collected for the model.

### Sources that are not the collection path

The IMDb licensed box-office dictionary documents budgets, lifetime gross, opening weekend, and theater counts. OpusData’s public description lists budgets and theatrical gross. Neither extract is in hand. That is why the gross design was set aside. Public Box Office Mojo and The Numbers pages showed those fields for individual titles on 30 September 2026. Visibility on a page is not permission to collect them. Do not scrape.

TMDB movie details document `vote_average`, `revenue`, and `budget`. Those fields are not used. TMDB does not document opening weekend, theater counts, or weekly gross, and it is not cleared for model training.

## Source matrix

“Outcome only” means the column may be stored for the label and must not enter the feature view.

| Variable | Source | Availability | Role | Class | Notes |
| --- | --- | --- | --- | --- | --- |
| `imdb_id` | IMDb `title.basics` `tconst` | Documented | Key | Required | Cited IMDb dataset |
| `imdb_id` | Wikidata P345 | Documented | Key | Required | Join |
| `title` | IMDb `primaryTitle` | Documented | Attribute | Required | Not a feature |
| `title_type` | IMDb `titleType` | Documented | Inclusion | Required | Must be `movie` |
| `studio_label` | Wikidata P272 | Documented | Inclusion and feature | Required | Names still need a match to the six labels. Coverage is uncounted |
| `release_date` | Wikidata P577 | Documented | Window | Required | On or after 7 October 2016 |
| `release_month` | Derived from P577 | Derived | Feature | Required | |
| `genres` | IMDb `title.basics` | Documented, up to three | Feature | Required | `Animation` is a proxy, not production method |
| `runtime_minutes` | IMDb `runtimeMinutes` | Documented | Feature | Required | |
| `franchise` | Derived from Wikidata P179 and earlier films | P179 documented; the flag is derived | Feature | Required | Must ignore a series link that postdates the film. Check not yet run |
| `prior_person` | Derived from `title.crew`, `title.principals`, and earlier films | Files documented; the flag is derived | Feature | Required | Do not use `knownForTitles` |
| `average_rating` | IMDb `title.ratings` | Documented current snapshot | Outcome only | Required | Not a feature. Not gross |
| `num_votes` | IMDb `title.ratings` | Documented | Inclusion screen | Required | **Needs your approval:** minimum votes to keep a film. Not a feature. No cutoff chosen |
| Gross, theaters, budget | Licensed IMDb or OpusData | Documented only behind a license that is not in hand | — | Excluded | Set aside with the gross design |
| Gross, theaters, budget | Box Office Mojo, The Numbers pages | Observed 30 September 2026 | — | Excluded | Do not scrape |
| TMDB rating, revenue, budget, popularity | TMDB API | Documented | — | Excluded | Not used in the model |
| Disney+ engagement | Nielsen Top 10 | Public weekly ranks only | — | Excluded | Not the outcome |
| CPI-U | BLS | Documented | — | Excluded | No dollar outcome |

## Data-quality risks

1. **Current rating.** `averageRating` and `numVotes` change after release. The outcome is that current snapshot. Using either as a feature would leak post-release response.
2. **Thin vote counts.** A handful of votes can move `averageRating`. The minimum `numVotes` is **Needs your approval** and is not chosen here.
3. **Series backfill.** A P179 link can appear after a later sequel. The franchise flag must not use a link that postdates the film. This has to be checked.
4. **Company names.** P272 strings have to be mapped to the six labels. 20th Century is in only after 20 March 2019.
5. **Date meaning.** P577 is not guaranteed to be the wide U.S. opening. The theater-count rule that defined “wide” was dropped.
6. **Limited releases and Disney+ originals.** Theater counts are unavailable, so limited theatrical releases can remain. A Disney+ original typed as `movie` is not removed by a theater threshold. The population rule still excludes Disney+ originals, but these files do not mark that status by themselves.
7. **`knownForTitles`.** That array can name later films. It is not the prior-person feature.
8. **No gross reconciliation.** Source disagreements on *Frozen* (2013) gross were a risk in the set-aside design. They do not define this label.
9. **Terms.** A field seen in a browser is still unavailable if the terms prohibit systematic reuse or machine-learning use.

## What must be true before the label is built

The population, window, outcome, features, and evaluation were recorded on 8 October 2026. Collection, AWS, dbt, models, Excel, and Power BI are still unbuilt.

1. **Needs your approval:** the minimum `numVotes` below which a film is dropped. Do not build the label with a cutoff this document does not contain.
2. Map Wikidata P272 names to the recorded labels, with 20th Century only after 20 March 2019.
3. Apply the window to P577: on or after 7 October 2016. Keep `titleType` `movie` only.
4. Build the franchise flag without a series link that postdates the film, and record the check.
5. Build `prior_person` from `title.crew` and `title.principals` on earlier in-scope films only.
6. Keep raw IMDb files, API tokens, and `.env` files out of Git.
7. Do not call TMDB for the model. Do not scrape Box Office Mojo or The Numbers.

## Checklist

- [x] Outcome is current IMDb `averageRating`, not gross. A rating is audience response, not financial underperformance.
- [x] One pre-release stage. Opening weekend, week 2, and the 600-theater rule are out.
- [x] Population and window recorded: the six labels, 20th Century only after 20 March 2019, Disney+ originals out, television films, shorts, and episodes out, release date on or after 7 October 2016, `titleType` `movie` plus Wikidata P272. Limited releases can remain.
- [x] Feature list recorded. Rating and `numVotes` are not features. Animation is the IMDb genre proxy.
- [x] Sources recorded: the five IMDb non-commercial files and Wikidata P272, P577, P345, and P179. Raw files stay out of Git. TMDB is out of the model. No scraping.
- [x] Evaluation recorded: ROC-AUC on a time-aware holdout, plus precision and recall for the underperformance class. Baselines to report: genre only, and studio label only.
- [ ] **Needs your approval:** the minimum `numVotes` below which a film is dropped.
