# Research design

**Project:** Film Performance Analytics  
**Films under study:** Disney movies  
**Phase:** 1. This document is the design. The current decisions were recorded on 8 October 2026. No dataset has been collected, and no model has been fit.

The business question is:

> Before release, can Disney identify films that will draw a weaker audience response than earlier comparable Disney films?

A choice recorded on 8 October 2026 is marked **Decided** (8 October 2026). The one choice that is still open is marked **Needs your approval**.

## Design set aside

A gross-based early-warning design was specified on 7 October 2026 and then set aside on 8 October 2026. Weekend gross, theater counts, and budgets are not available without a paid license. Opening weekend, week 2, and the 600-theater rule were part of that design. They are not the current decision. The project does not scrape Box Office Mojo or The Numbers to recover them, and it does not use TMDB in the model.

## 1. Decisions already settled

1. The unit of analysis is one film with IMDb `titleType` `movie`. A later re-release is not a second row.
2. There is one prediction stage: pre-release. Opening weekend and week 2 are out.
3. A feature may use only information that would have existed before release, and historical facts from earlier in-scope films only.
4. The outcome is the current IMDb `averageRating`. A rating is audience response, not financial underperformance. It is not gross, not profit, and not Disney+ streaming.
5. `averageRating` and `numVotes` are never features.
6. The label is one binary flag. Underperform = 1 when the film’s rating is below the rating predicted for it by a time-aware regression fit only on earlier films. The gap, actual rating minus expected rating, is the business metric, not the classifier target. The label is stored only on the outcome table.
7. Evaluation uses a time-aware holdout. A random row split is not the primary evaluation. There is no previous stage.
8. The metric is ROC-AUC, plus precision and recall for the underperformance class.
9. Statistical work is regression and hypothesis tests on observational data. A/B testing is not part of the design.
10. Forecasting and what-if analysis are reserved for Excel in a later phase. They are not a second implementation of the Python analysis.
11. GitHub holds code and documentation only. Raw IMDb files are not committed.
12. The minimum `numVotes` used to drop a film is the only item still marked **Needs your approval** (Section 6). No cutoff is chosen here.

## 2. Population and window

**Decided** (8 October 2026). The population stays all current Disney theatrical labels: Walt Disney Pictures, Walt Disney Animation Studios, Pixar, Marvel Studios, Lucasfilm, and 20th Century only after 20 March 2019. Disney+ originals are out. Television films, shorts, and episodes are out.

Inclusion is an IMDb `titleType` of `movie` plus a Wikidata production-company match (property P272) to one of those labels. A 20th Century match is in only when the film’s release date is after 20 March 2019. IMDb’s non-commercial `title.basics` file documents `titleType` with examples that include `movie`, `short`, `tvseries`, `tvepisode`, and `video` (IMDb, Non-Commercial Datasets). Only `movie` is in. That filter is how television films, shorts, and episodes stay out.

Limited theatrical releases can remain, because theater counts are unavailable. The 600-theater rule is dropped with the gross design.

**Decided** (8 October 2026). The window is a release date on or after 7 October 2016. The date is Wikidata publication date P577. IMDb `startYear` is a year, not a date, and it does not replace P577.

No film count is stated here. Sources were not censused.

The label sets above were the population recorded on 7 October 2026. The inclusion mechanism changed on 8 October 2026 with the rating design: `titleType` `movie`, a Wikidata company match, and no theater-count screen.

## 3. Outcome

**Decided** (8 October 2026). The outcome is the current IMDb `averageRating` from `title.ratings`. IMDb documents that field as a weighted average of all the individual user ratings, and documents that the datasets are refreshed daily.

A rating is audience response, not financial underperformance. It is not gross, not profit, and not Disney+ streaming.

The file is a current snapshot. It is not a rating frozen on the release date. That is a limitation of the non-commercial file, and it is accepted for the outcome. The same fields are still forbidden as features, because a current rating is not known before release.

If `averageRating` is missing, the film is not labeled. Domestic gross is not a substitute. There is no gross outcome.

## 4. One stage and the leakage rule

**Decided** (8 October 2026). The only stage is pre-release. The question is whether the film will draw a weaker audience response than the rating predicted from earlier comparable Disney films.

Allowed features:

- studio label, from the Wikidata production-company match
- up to three IMDb genres, from `title.basics`
- runtime, from `title.basics` `runtimeMinutes`
- release month, from Wikidata P577
- franchise versus original
- whether the director or a principal cast member appeared in an earlier in-scope Disney film

Animation is the IMDb genre `Animation`. That genre is a proxy, not a true production-method field.

Not allowed:

- `averageRating` and `numVotes`
- gross, theater counts, budgets, and any week-1 or week-2 field
- TMDB fields, including `vote_average`, `vote_count`, and `popularity`
- IMDb `knownForTitles` on `name.basics`, because that list can include later films

Franchise versus original uses Wikidata series property P179. Wikidata series membership can be backfilled after a later sequel. The franchise flag must not use a series link that postdates the film. A link that exists only because a later sequel was added is not evidence that the film was a franchise entry at release. This has to be checked. The flag is true only when an earlier in-scope film shares a series relationship that does not postdate the film being scored.

The director is a person in `title.crew` `directors`. A principal cast member is a person in `title.principals` whose `category` is `actor` or `actress`. The repeat-appearance flag is true only when that director or cast member appears on an earlier in-scope film, using `title.crew` and `title.principals` for those earlier films. Later films are invisible. No billing-rank cutoff is added.

The expectation regression is not a feature table. It is fit only on earlier films. It is not refit on the film being labeled or on the test period.

## 5. Expected rating and the label

**Decided** (8 October 2026). For film *i*, fit a regression of `averageRating` on the pre-release features in Section 4, using only films with an earlier release date. The fitted rating is the expectation. This regression is the bar, not the classifier.

Underperform = 1 when the film’s rating is below that prediction. The business metric is the gap

`gapᵢ = actual ratingᵢ − expected ratingᵢ`.

The gap is not the classifier target. The label is stored only on the outcome table. It is not a feature.

The regression is not refit on the film being labeled or on the test period. The feature list in Section 4 is the specification. No gross covariate is added.

### How the label is built

1. Keep films that pass the population, window, and `titleType` rules, and that have a non-missing `averageRating`.
2. Drop films whose `numVotes` is below the minimum approved in Section 6. Until that minimum exists, do not build the label.
3. Sort the remaining films by release date.
4. For film *i*, fit the expectation using only films with an earlier release date.
5. Set underperform = 1 when the actual rating is below the fitted rating. Store the label and the gap only on the outcome table.

## 6. Minimum vote count

**Needs your approval:** the minimum `numVotes` below which a film is dropped, so a tiny vote count cannot define the label.

No cutoff is chosen in this document. A round number is not proposed here. `numVotes` is used only for that inclusion rule. It is never a feature.

## 7. Research questions

1. Before release, does a leakage-safe classifier identify a weaker-than-expected IMDb rating better than the genre-only baseline and the studio-label-only baseline, under a time-aware holdout?
2. Which allowed pre-release attributes are associated with the rating gap: studio label, genre (including the Animation proxy), runtime, release month, franchise versus original, and prior appearance of the director or a principal cast member?
3. How often does a Wikidata series link postdate the film, and does enforcing that check change the franchise flag?

Question 1 is the business question. Questions 2 and 3 do not reopen the outcome.

## 8. Hypotheses

These are statements to test later. They are not findings.

1. On the time-aware holdout, the pre-release classifier’s test AUC beats a one-feature baseline, and a bootstrap interval for that difference lies above zero. Both baselines are reported: genre only, and studio label only.
2. Films with at least one earlier franchise entry have a different rating-gap distribution from films with none. The comparison uses only a series link that does not postdate the film.
3. Films whose director or a principal cast member appeared in an earlier in-scope film have a different rating-gap distribution from films with no such appearance.

None of these supports a claim that changing a release plan, a director, or a cast member would have changed the rating.

## 9. Statistical methods

Later analytical work uses the following methods. None of them is executed in this phase.

**Regression.** A time-aware regression of `averageRating` on the Section 4 features estimates the expected rating. Films enter the estimation only when they have an earlier release date than the film being scored. The regression is not refit on the film being labeled or on the test period. Uncertainty is reported with the coefficient estimates. The same regression is the descriptive model for Research Question 2. The outcome is the rating itself, not a log gross.

**Hypothesis tests.** Pre-specified comparisons in Hypotheses 2 and 3 use a test matched to the distribution. Rank-based or permutation tests are the default if residuals are skewed. Films are not a random sample of all movies. A test result is a statement about the observed Disney slate, not a universal law.

**Not in this design.** A/B testing is omitted because there is no random assignment. Excel, in a later phase, may show scenarios from published assumptions. That workbook does not refit the regression or the classifier.

## 10. Machine-learning objective and evaluation

The objective, in a later phase, is one classifier of the recorded label. It uses the pre-release feature view. There is no opening-weekend model and no week-2 model.

**Split.** Training films are released before validation films, which are released before test films. The primary report is this time-aware holdout. The test period is not used to choose the label rule, the expectation formula, or the `numVotes` cutoff.

**Baselines.** **Decided** (8 October 2026). The baselines to report are genre only and studio label only. There is no previous stage, and there is no budget baseline. The gross-design baselines were set aside with that design.

**Metrics.** **Decided** (8 October 2026). Report ROC-AUC on the time-aware holdout, plus precision and recall for the underperformance class.

**Useful model.** A model is useful when its test AUC beats a one-feature baseline and a bootstrap interval for the difference lies above zero. Both baselines are reported: genre only, and studio label only.

**Leakage audit.** Before any score is treated as evidence, a column inventory confirms that the feature view excludes `averageRating`, `numVotes`, the gap, and the label, and that the expectation for each test film was fit without that film or later films. The franchise check in Section 4 is part of the audit.

No algorithm is selected in this phase.

## 11. Assumptions

1. The current IMDb `averageRating` is a usable record of audience response. It is not Disney’s internal score, and it is not a financial result.
2. The studio rule can be applied from Wikidata P272. Those company names will be checked against the six labels. They will not be assumed to match without that check.
3. `titleType` `movie` is the inclusion type documented by IMDb. Other types in that file are out.
4. A director in `title.crew`, and a person in `title.principals`, can be linked across films by `nconst` from `name.basics`.
5. One current row per film is the title itself, not a re-release.
6. Comparable films are comparable under the recorded feature list.

## 12. Limitations

1. The label is a research definition of weaker audience response. It is not financial underperformance, and it is not Disney’s definition.
2. `averageRating` and `numVotes` are current snapshots, refreshed daily. They move after release. The outcome accepts that snapshot. The features do not.
3. Theater counts are unavailable, so limited releases can remain, and a Disney+ original that IMDb types as `movie` and Wikidata credits to one of these companies is not removed by a theater threshold. The population rule still says Disney+ originals are out. The available fields do not mark that status on their own.
4. A Wikidata series link can be added after a later sequel. Using that link as a franchise flag would leak. The check is required and has not been run.
5. P577 is a publication date. It is not guaranteed to be a U.S. theatrical date. The wide-release screen that would have addressed that was dropped with the gross design.
6. The sample is one corporate family. Results do not transfer automatically to other studios.
7. A time-aware holdout on this window can leave a small test block. Metric estimates will be noisy. The eligible-title count is unmeasured.
8. No causal claim is available.

## 13. Success criteria

The research design is successful as a capstone foundation when all of the following hold.

1. The population, window, outcome, label, feature list, and evaluation match Section 15.
2. The `numVotes` minimum is recorded before the label is built. It is not chosen in this document.
3. A column-level leakage audit passes for the pre-release feature view, including the franchise-link check and the exclusion of rating and vote count.
4. Evaluation is a time-aware holdout and reports ROC-AUC, plus precision and recall for the underperformance class, against the genre-only and studio-label-only baselines.
5. The written conclusion answers the business question, including the possibility that the model does not beat a one-feature baseline by the rule in Section 10.
6. Excel and Power BI, when they are eventually built, present the warning and the gap, and do not re-estimate the Python model.

## 14. Final deliverables

| Deliverable | Phase | Status |
| --- | --- | --- |
| Business problem | 1 | `docs/01_business_problem.md` |
| Research design | 1 | This document. Revised 8 October 2026 |
| Data dictionary and source matrix | 2 | `docs/03_data_dictionary.md`, `docs/04_data_sources.md` |
| Collected file, with a retrieval log and no raw dump in GitHub | 3 | Not started |
| dbt feature view for pre-release, and an outcome view | Later | Not started |
| Regression, hypothesis tests, and the classifier | Later | Not started |
| Excel what-if workbook | Later | Not started |
| Power BI executive report | Later | Not started |
| Written answer to the business question | Final | Not started |

## 15. Decision record

### Recorded on 8 October 2026

1. Question: before release, can Disney identify films that will draw a weaker audience response than earlier comparable Disney films?
2. Outcome: current IMDb `averageRating`. Not gross, not profit, not Disney+ streaming. A rating is audience response, not financial underperformance.
3. Label: one binary label. Underperform = 1 when the film’s rating is below the rating predicted by a time-aware regression fit only on earlier films. The gap (actual rating − expected rating) is the business metric, not the classifier target. Rating and `numVotes` are never features.
4. Stage: pre-release only. Opening weekend and week 2 are out. No theater-count rule. The 600-theater rule is dropped with the gross design.
5. Population: Walt Disney Pictures, Walt Disney Animation Studios, Pixar, Marvel Studios, Lucasfilm, and 20th Century only after 20 March 2019. Disney+ originals are out. Television films, shorts, and episodes are out. Window: release date on or after 7 October 2016. Inclusion is IMDb `titleType` `movie` plus a Wikidata production-company match. Limited theatrical releases can remain because theater counts are unavailable.
6. Features: studio label, up to three IMDb genres, runtime, release month, franchise versus original, and whether the director or a principal cast member appeared in an earlier in-scope Disney film. Animation is the IMDb genre `Animation`, a proxy, not a production-method field.
7. Sources: IMDb non-commercial datasets `title.basics`, `title.ratings`, `title.crew`, `title.principals`, and `name.basics`, plus Wikidata P272, P577, P345, and P179. Raw files are not committed. TMDB is not used in the model. Box Office Mojo and The Numbers are not scraped.
8. Evaluation: ROC-AUC on a time-aware holdout, plus precision and recall for the underperformance class. There is no previous stage. A model is useful when test AUC beats a one-feature baseline and a bootstrap interval for the difference lies above zero. The baselines to report are genre only and studio label only.

### Still open

**Needs your approval:** the minimum `numVotes` below which a film is dropped, so a tiny vote count cannot define the label. No cutoff is chosen here.

The franchise-link check in Section 4 has to be done at build time. It is not a second cutoff, and it is not a license request. The gross-design license, source-precedence rule, and 600-theater rule are not open decisions. That design was set aside.
