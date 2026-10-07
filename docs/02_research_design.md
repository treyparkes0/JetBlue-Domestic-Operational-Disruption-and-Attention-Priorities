# Research design

**Project:** Film Performance Analytics  
**Films under study:** Disney movies  
**Phase:** 1. This document is the design. Decisions below were recorded on 7 October 2026. No dataset has been collected, and no model has been fit.

The business question is fixed:

> How early can Disney identify potential film underperformance using progressively available movie and early theatrical performance data?

Design choices that change the population, the label, or the clock are not made silently. A choice recorded on 7 October 2026 is marked **Decided** (7 October 2026). A choice that is still open stays marked **Needs your approval**.

## 1. Decisions already settled

These choices follow from the business question and from the requirement that a warning be usable at a real decision point. The population, window, outcome, expectation, label, clock, and evaluation recorded on 7 October 2026 are stated in the sections below. They are not reopened here.

1. The unit of analysis is one theatrical film. A later re-release is not folded into the original run’s week 1 or week 2.
2. There are three prediction stages: pre-release, week 1, and week 2. The question at each stage is the same: will the film finish under its expectation?
3. A stage may use only information that would have existed at that time. The rule is stated in full in Section 4.
4. Franchise and other historical features for a film may use only films released before that film.
5. Final gross is an outcome. It is never a feature at any stage.
6. Underperformance is performance relative to an expectation. It is not an arbitrary dollar cutoff, and it is not represented as Disney’s internal definition. Disney does not publish that definition.
7. The label is one binary flag for all three stages. Underperform = 1 when finished worldwide gross is below that film’s fitted expectation. The expectation is formed without that film or any later film, and it is not refit on the test period. The label is stored only on the outcome table and is never a feature. The continuous gap is the business metric, not the classifier target (Sections 5 and 6).
8. Evaluation uses a time-aware split. A random row split is not the primary evaluation.
9. The primary metric is ROC-AUC on a time-aware held-out test block. The report also includes precision and recall for the underperformance class, plus accuracy, F1, and a confusion matrix (Section 10).
10. Statistical work is regression and hypothesis tests on observational data. A/B testing is not part of the design: the studio did not randomly assign the films.
11. Forecasting and what-if analysis are reserved for Excel in a later phase. They are not a second implementation of the Python analysis.
12. Clustering is optional. It is not required to answer the business question.
13. Disney+ engagement is out of the feature set and out of the outcome. Reliable public title-level engagement for the theatrical slate was not found (see the data sources).
14. GitHub holds code and documentation only.
15. Phase 3 collection does not start until the unresolved items in Section 15 are closed, and it does not start by scraping sources whose terms prohibit automated collection. The design choices recorded on 7 October 2026 do not, by themselves, authorize collection.

## 2. Population and studio scope

**Decided** (7 October 2026). The population is all current Disney theatrical labels: Walt Disney Pictures, Walt Disney Animation Studios, Pixar, Marvel Studios, Lucasfilm, and 20th Century only for films released after Disney’s acquisition of 21st Century Fox (closed 20 March 2019). That is option C below. Disney+ originals with no wide theatrical release are out. A theatrical film that later streams on Disney+ stays in. Television films, shorts, and festival-only titles stay out.

The business question says Disney. Public sources attach films to different entities: Walt Disney Pictures, Walt Disney Animation Studios, Pixar, Marvel Studios, Lucasfilm, 20th Century, and the distributor Walt Disney Studios Motion Pictures. Those sets imply different sample sizes and different performance regimes. A Marvel film and a Walt Disney Animation film are not exchangeable observations.

| Option | Population | Tradeoff |
| --- | --- | --- |
| A. Walt Disney Pictures only | Live-action banner released under that production label | Cleaner brand definition. The count of wide theatrical titles may fall below the range this design can support. Animation, which is central to Disney’s theatrical slate, is omitted |
| B. Walt Disney Pictures, Walt Disney Animation Studios, and Pixar | Disney-branded theatrical live action and animation | Still excludes Marvel, Lucasfilm, and 20th Century, which have different budgets, fan bases, and release strategies |
| C. All current Disney theatrical labels, with 20th Century included only after the acquisition | Adds Marvel Studios, Lucasfilm, and post-acquisition 20th Century titles | Larger sample and a closer match to “films Disney releases.” Pools unlike businesses. The acquisition date must be applied as a rule, not as a loose label match on older Fox films |
| D. Disney+ originals | Titles produced for Disney+ without a wide theatrical release | Opening weekend and week 2 are undefined. Streaming minutes are not a theatrical gross. This option does not answer the business question as posed |

The alternatives above were considered. Option C is the recorded population. The acquisition rule is the close date, 20 March 2019: a 20th Century film is in only if it was released after that close. Option D is out. A theatrical film that later appears on Disney+ remains a theatrical film.

No film count is stated here. Sources were not censused. The in-scope count on a licensed extract is still unmeasured and remains unresolved. It must be checked in collection before modeling is treated as feasible.

Inclusion also requires a wide theatrical release. The operational rule for “wide” is the week-1 threshold in Section 4: the first Friday–Sunday on which domestic theaters are at least 600.

## 3. Year range

**Decided** (7 October 2026). The window is the last 10 years. The operational rule is a wide-release date on or after 7 October 2016.

This window is shorter than the earlier 100–200 sample-size goal and may be tight for a time-aware split. The eligible-title count is still unmeasured and must be checked in collection before modeling is treated as feasible.

The earlier design target was on the order of 100–200 or more theatrical films, because a three-stage model with a time-aware split and a franchise history needs enough earlier films to form an expectation. That target was a sample-size goal, not a finding. It is not met by choosing this window. The achievable count still depends on which sources can legally supply budget, week-1 gross, and week-2 theater counts.

| Window | Why it might be used | Cost |
| --- | --- | --- |
| Roughly the last 25 years of wide releases | More likely to approach the sample-size goal if several labels are included | Mixes pre-streaming and post-streaming release strategies |
| A shorter recent window | Closer to current release patterns | May be too small for a time-aware split, especially under option A |
| An explicit break around the 2020 theatrical shutdown | Avoids treating pandemic releases as exchangeable with earlier films | Splits an already small sample. The break date itself needs a rule |

The alternatives above were considered. The recorded window is the shorter recent window, not the 25-year span, and it does not drop or split out the 2020 theatrical shutdown. Films whose wide-release date falls on or after 7 October 2016 stay in the window, including shutdown-period titles that otherwise meet the population and wide-release rules. Hypothesis 4 still asks whether residuals in that period are larger.

The window is not chosen to hit a round number of titles.

## 4. Prediction stages and the leakage rule

### 4.1 Rule

A stage may use only information that would have existed at that time.

- Pre-release cannot use week 1, later weekends, theater counts from the run, or final gross as features.
- Week 1 cannot use week 2, later weekends, or final gross as features.
- Week 2 cannot use anything observed after that second Friday–Sunday, including final gross and a lifetime maximum theater count if that maximum occurs later.
- Franchise and historical features for a film may use only films released before that film. Later entries in the same series are invisible.
- The label may use the film’s own final outcome. The label is not a feature. It is stored only on the outcome table.
- International gross earned in territories that had not opened by the decision point is not yet known. Territory open dates differ. Week 1 does not treat a later territory opening as if it were known on that domestic weekend.
- A field that is stored as a current snapshot, rather than as a value dated on or before the stage, is not a feature. This applies to current user-rating averages, current vote counts, and current popularity scores (Section 6 of the data dictionary). Current ratings and popularity stay excluded.

The same rule binds the expectation used to build the label. The expectation for film *i* is estimated from films with an earlier wide-release date only. It is not refit on the film being labeled or on the test period.

### 4.2 Stages

The question at every stage is the same: will the film finish under its expectation?

**Pre-release.** Decision time is before the wide domestic opening. Allowed inputs are information fixed before that opening, and historical aggregates from earlier films: genre, production method, runtime, rating, budget, release calendar, franchise membership, and prior franchise history. Allowed inputs do not include any gross or theater count from this film’s run. A platform or preview weekend is part of that run’s history. It is not a pre-release feature.

**Week 1.** Decision time is the first Friday–Sunday on which domestic theaters are at least 600. Features add that weekend’s gross, theater count, and the per-theater average. They do not add week 2 or the final gross.

**Week 2.** Decision time is the next Friday–Sunday. Features add that weekend’s gross, theater count, and the hold from week 1. They do not add later weekends or the final gross.

**Decided** (7 October 2026): the clock.

Two definitions were considered and they are not the same.

- Box Office Mojo publishes a weekend (generally Friday–Sunday) and a week (Friday–Thursday). Its licensed time series distinguishes those occasion types.
- A limited platform opening is a different event from the wide opening. On 30 September 2026, Box Office Mojo’s *Frozen* (2013) title page and The Numbers’ *Frozen* page both showed a domestic opening of $243,390. The Numbers weekend table places that amount on 22 November 2013 at one theater, and places the wide expansion on the following weekend. Box Office Mojo’s summary page shows the same opening dollar amount and does not, on that view, show the theater count.

The recorded rule is:

- Week 1 is the first Friday–Sunday on which domestic theaters are at least 600.
- Week 2 is the next Friday–Sunday, not the Friday–Thursday week.
- A platform or preview weekend is release history, not week 1.

Box Office Mojo has described wide release as about 600 theaters. That description is the recorded threshold.

**Decided** (7 October 2026): one binary label for all three stages. The business question asks how early eventual underperformance can be identified. The design that matches that question uses one final-outcome label and three nested feature sets. Stage-specific labels (for example, “week 2 will disappoint given the opening”) were considered. They answer a different question and are not used.

## 5. Outcome

**Decided** (7 October 2026). The outcome is nominal worldwide theatrical gross. There is no CPI adjustment and no ticket-price adjustment. If worldwide gross is missing, the film is dropped. Domestic gross is not a fallback.

The outcome is theatrical box-office gross. It is not profit. Prints and advertising, participations, and ancillary income are not in the public sources reviewed.

| Choice | Options | Tradeoff |
| --- | --- | --- |
| Geography | Worldwide gross, or domestic gross | Worldwide is closer to the full theatrical result and is what budget-multiple commentary usually uses. Domestic is observed earlier, is more complete in U.S. sources, and matches the week-1 signal, which is domestic. International openings are on different dates, so a worldwide total is a poor week-1 feature and a reasonable final outcome |
| Dollars | Nominal dollars, or inflation-adjusted dollars | Nominal dollars are what was reported and need no deflator. They make a 2005 film and a 2025 film hard to compare. An adjustment is warranted if the year window is long |

The alternatives above were considered. Worldwide nominal gross is the recorded outcome. The window is 10 years, and the dollars stay nominal.

Domestic geography is not identical across sources. The Numbers’ market pages define the domestic market as the United States, Canada, Puerto Rico, and Guam. Box Office Mojo’s help text defines domestic as the United States, Canada, and Puerto Rico. IMDb’s licensed box-office dictionary defines area `XDOM` as the United States and Canada, and lists Puerto Rico separately. Those mismatches remain a data-risk note. They are not the outcome.

**Needs your approval:** a source-precedence rule when budget or gross figures disagree. That rule is still unresolved.

Inflation methods were considered and are not used:

| Deflator | What it measures | Constraint |
| --- | --- | --- |
| CPI-U, BLS series `CUUR0000SA0` (all items, U.S. city average, not seasonally adjusted) | General consumer prices | Public and documented. It is not a movie-ticket index. Not applied |
| Average ticket price, as used by The Numbers for its inflation-adjusted domestic box office | Ticket-price change | Matches theatrical purchasing power more closely. The Numbers’ terms require a license for academic or systematic use. Not applied |

Gross is not adjusted with an ad hoc multiplier.

Domestic and international final gross remain descriptive components. They are excluded as features. They do not replace a missing worldwide gross.

## 6. Expected performance and the label

**Decided** (7 October 2026). The expectation is a time-aware regression (Alternative 2). For film *i*, fit log worldwide gross on pre-release attributes using only films with an earlier wide-release date (an expanding window). The fitted value on the original dollar scale is the expectation. This regression is the bar, not the early-warning classifier. It is not refit on the film being labeled or on the test period.

Disney’s internal definition of underperformance is not public. This design does not invent a cutoff such as “below $100 million” or “below two times budget” and treat it as that definition. A fixed multiple may be used only if it is estimated from earlier films, or if it is an external benchmark that is cited and then explicitly approved. Neither of those was selected.

Three defensible ways to form the expectation are below. All three would be computed for film *i* from films with an earlier wide-release date only. Alternatives 1 and 3 were considered and are not the recorded expectation.

### Alternative 1 — Cohort benchmark

The expectation is the median final gross of earlier films in a pre-specified cohort: the approved studio set, production method, a budget band, and franchise versus original. The film underperforms when its outcome falls below that median by a relative margin, or below a pre-specified percentile of the earlier cohort.

Tradeoff: the comparison is explainable to a business audience. With a few hundred films and several cohort factors, many cells will be very small. Budget bands have to be fixed without looking at the film’s own outcome. Using the film itself, or later films, to define the cohort is leakage.

### Alternative 2 — Time-aware regression

This is the recorded expectation. For film *i*, log worldwide gross is fit on pre-release attributes using only films with an earlier wide-release date (an expanding window). The fitted value on the original dollar scale is the expectation. The film underperforms when finished worldwide gross is below that fitted value.

Tradeoff: the expectation can use budget, calendar, and franchise history together. The label then depends on a model. That regression is an expectation model. It is not the early-warning classifier, and it is not refit on the film being labeled or on the test period. Coefficients are estimated only on prior films. Log gross is the scale because gross is skewed. The fitted value is transformed back to dollars. The link is part of the specification and is not tuned against the test period.

### Alternative 3 — Budget-multiple hurdle

The expectation is *kᵢ × budgetᵢ*, where *kᵢ* is the median outcome-to-budget ratio among films released before *i*. The film underperforms when its outcome-to-budget ratio is below *kᵢ*.

Tradeoff: the hurdle is in investment language and does not require a thin cohort cell. It ignores marketing cost, so a high gross multiple can still be an unprofitable film, and a low multiple can still be a film Disney would consider successful for non-theatrical reasons. Films with missing or zero budgets cannot receive this label. A constant *k* chosen for roundness is an arbitrary cutoff and is not this alternative.

### Candidate covariates for the expectation regression

The candidate set is the one already named in the data dictionary. No covariate is added beyond it: budget, genre, a franchise flag and prior franchise history from earlier films only, animation versus live action, release month or season, runtime, and MPAA rating if available.

**Needs your approval:** the exact formula inside that set. The formula is frozen before the test period is inspected. It is not frozen yet.

### How the expectation becomes a label without leakage

1. Sort films by wide-release date.
2. For film *i*, estimate the expectation using only films with an earlier wide-release date.
3. After film *i*’s theatrical run is complete, compute the outcome and the gap  
   `gapᵢ = (outcomeᵢ − expectationᵢ) / expectationᵢ`.
4. Set underperform = 1 when finished worldwide gross is below that film’s fitted expectation. The label is stored only on the outcome table.
5. Feature tables for the three stages do not contain `outcome`, `gap`, the label, or any column measured after the stage.

The gap uses the final outcome, so it is known only when the run is complete. That is appropriate for supervised learning on historical films. It is not available when a live warning is issued. A live warning compares the stage’s predicted class, or a predicted gap, with the information known at that stage.

If worldwide gross is missing, the film is dropped. Domestic gross is not a fallback. Missing budgets and films that have not finished their theatrical run are not labeled by filling the hole with a later source’s number unless that number is dated and the source rule allows it.

### Binary target and continuous gap

**Decided** (7 October 2026). One binary label is the classifier target at all three stages. Underperform = 1 when finished worldwide gross is below that film’s fitted expectation. The continuous gap `(actual − expected) / expected` is retained as the business metric and is not the classifier target. The label is stored only on the outcome table. It is not a feature.

| Choice | What is optimized | What is retained |
| --- | --- | --- |
| Binary label for the classifiers | Underperform versus not. Matches a warning that is either raised or not | The continuous gap is kept as the business metric: severity, ranking, and Excel scenarios |
| Continuous model of the gap, with a binary warning derived from it | Magnitude of the miss | A threshold is still required to raise a warning, so the cutoff moves rather than disappears |

The first row is the recorded choice. The continuous model in the second row was considered and is not the classifier. The gap stops the project from treating every miss as equal. The primary classification metric is ROC-AUC, recorded in Section 10. Recall of underperformance is still reported. A missed warning may be costlier than a false alarm, but that cost ratio is not used to change the label.

Class balance is a result of the recorded rule. It is not a reason to move the cutoff until the classes look even.

## 7. Research questions

The primary specification is the one recorded on 7 October 2026: nominal worldwide gross, the time-aware regression, and the binary label. Question 2 is a sensitivity question. It is not an open choice of outcome.

1. At which stage does a leakage-safe classifier first identify eventual underperformance better than a transparent baseline, under a time-aware evaluation?
2. How much would that answer change, as a sensitivity check only, if domestic gross or inflation-adjusted dollars were used instead of nominal worldwide gross?
3. Which pre-release attributes are associated with the performance gap: budget, genre, production method, release timing, and franchise history built only from earlier films?
4. How large is the disagreement among sources on budget and gross for the same film, and does a documented precedence rule change the label?

## 8. Hypotheses

These are statements to test later. They are not findings.

1. Week-1 gross and theater count improve identification of the final label relative to pre-release attributes alone.
2. Week-2 gross and the hold versus week 1 improve identification further relative to the week-1 feature set.
3. Films with at least one earlier franchise entry have a different performance-gap distribution from films with none. The comparison uses only entries released before the film in question.
4. The recorded window includes 2020. Absolute residuals from a pre-release expectation fit on earlier years are larger for releases in the theatrical-shutdown period than for releases in the preceding years inside the window.

Hypotheses 1 and 2 are about predictive comparison on a later time block. Hypotheses 3 and 4 are associative. None of them supports a claim that changing a release plan would have changed the gross.

## 9. Statistical methods

Later analytical work uses the following methods. None of them is executed in this phase.

**Regression.** A time-aware regression of log worldwide gross on the candidate pre-release attributes estimates expected performance. The fitted value on the original dollar scale is the expectation. Films enter the estimation only when they have an earlier wide-release date than the film being scored. The regression is not refit on the film being labeled or on the test period. The exact formula inside the candidate set is frozen before the test period is inspected. Uncertainty is reported with the coefficient estimates. The same regression is the descriptive model for Research Question 3.

**Hypothesis tests.** Pre-specified comparisons in Hypotheses 3 and 4 use a test matched to the distribution. Rank-based or permutation tests are the default if residuals are skewed. Films are not a random sample of all movies, and errors can be dependent within a franchise and a release season. A test result is a statement about the observed Disney slate, not a universal theatrical law.

**Not in this design.** A/B testing is omitted because there is no random assignment. Forecasting of the remaining theatrical curve is an Excel task in a later phase: given an observed opening and an assumed hold, show scenario gross. That workbook consumes published assumptions and model outputs. It does not refit the regression or the classifiers.

**Clustering, optional.** If used, clusters are a descriptive aid for cohorts. They are fit on earlier films only, or replaced by the pre-specified cohorts in Alternative 1. A cluster solution fit on the full sample, including future films, is leakage and is not used. Clustering is not the expectation.

## 10. Machine-learning objective and evaluation

The objective, in a later phase, is to estimate three classifiers of the recorded label:

- Pre-release uses the pre-release feature view.
- Week 1 uses the week-1 feature view.
- Week 2 uses the week-2 feature view.

The question is how early classification becomes informative. It is not how to maximize a score with every column in the raw file. Each classifier answers the same question: will the film finish under its expectation?

**Split.** Training films are released before validation films, which are released before test films. The primary report is this forward split. An expanding-window check is appropriate because the sample may be small: for each cut date, train on all earlier labeled films and score the next block. The test period is not used to choose the label rule or the expectation formula. The formula is frozen before that period is inspected.

**Baselines.** **Decided** (7 October 2026). At pre-release, the one-feature baseline is budget only. After the opening, the one-feature baseline is opening-weekend gross divided by budget. Week 2 is compared with the opening-weekend model and with that opening baseline. A majority-class rate, and a comparison against the expectation regression itself, were considered. They are not the baselines in the useful-improvement rule.

**Metrics.** **Decided** (7 October 2026). The primary metric is ROC-AUC on a time-aware held-out test block. Also report precision and recall for the underperformance class, plus accuracy, F1, and the confusion matrix.

**Useful improvement.** A later stage is a useful improvement only when its test AUC is higher than both the previous stage and a one-feature baseline, and a bootstrap interval for the AUC difference lies above zero.

**Leakage audit.** Before any score is treated as evidence, a column inventory confirms that each feature view contains only columns allowed at that stage, and that the expectation for each test film was fit without that film or later films.

No algorithm is selected in this phase. The recorded window is shorter than the earlier 100–200 sample-size goal, so a simple model remains preferable to a flexible one. The eligible-title count is still unmeasured. That preference is a complexity constraint, not a claim that a particular algorithm has been trained.

## 11. Assumptions

1. A public or licensed gross is a usable record of theatrical performance. It is not Disney’s internal ultimate.
2. The recorded studio rule can be applied from production-company or distributor fields. Those fields will be checked; they will not be assumed to match the legal entity.
3. Production budget, when present, is in nominal U.S. dollars as stated by the source. TMDB’s movie bible says budget and revenue are entered in U.S. dollars and are not inflation-adjusted. Other sources need the same check at collection. TMDB is not cleared for model training (see the data sources).
4. Budget is treated as pre-release information only when the figure was public before opening. Reported budgets are often estimates and are sometimes revised. Timing is unverified and is listed as a data risk.
5. The theatrical run used for the final outcome is complete. Films still in release are not labeled.
6. One current row per film is the original theatrical cycle, not a re-release.
7. Comparable films are comparable only under the recorded regression specification.

## 12. Limitations

1. The label is a research definition. It is not Disney’s definition, and it does not identify a financially unsuccessful film once marketing and ancillaries are counted.
2. The sample is a selected slate of films from one corporate family. Results do not transfer automatically to other studios.
3. A time-aware split on this slate leaves a small test block. The recorded window, wide-release dates on or after 7 October 2016, is shorter than the earlier 100–200 sample-size goal and may be tight for that split. The eligible-title count is still unmeasured. Metric estimates will be noisy.
4. Source totals disagree. The *Frozen* (2013) pages observed on 30 September 2026 did not match: Box Office Mojo showed domestic $400,738,009 and worldwide $1,284,879,663; The Numbers showed domestic $400,953,009 and worldwide $1,269,253,418. A precedence rule can change both expectations and labels. That rule is not yet recorded.
5. Weekend fields can describe a platform release. Using them as week 1 without the 600-theater rule misstates the decision point.
6. Current ratings and popularity are not historical states. Using them leaks later audience response.
7. Terms of use remove several convenient collection methods. A variable that is visible on a web page is not automatically usable in this project (see the data sources).
8. No causal claim is available. An early warning does not, by itself, show that a different release plan would have raised gross.

## 13. Success criteria

The research design is successful as a capstone foundation when all of the following hold.

1. The population, window, outcome, expectation, label, clock, and evaluation have a recorded decision. The unresolved items in Section 15 are closed before collection starts.
2. The label rule is the recorded time-aware regression. Underperform = 1 when finished worldwide gross is below the fitted expectation. There is no arbitrary dollar cutoff.
3. A column-level leakage audit passes for all three feature views, including the franchise-history constraint.
4. Evaluation is time-aware. The primary metric is ROC-AUC on a held-out test block. The report also includes precision and recall for the underperformance class, plus accuracy, F1, and a confusion matrix, against the baselines in Section 10.
5. The written conclusion answers “how early,” including the possibility that no stage meets the useful-improvement rule in Section 10.
6. Excel and Power BI, when they are eventually built, present the warning, the stage, and the gap, and do not re-estimate the Python models.

An accuracy target is not set here. A target chosen before the label exists would be arbitrary.

## 14. Final deliverables

| Deliverable | Phase | Status |
| --- | --- | --- |
| Business problem | 1 | This capstone’s `docs/01_business_problem.md` |
| Research design | 1 | This document. Decisions recorded 7 October 2026 |
| Data dictionary and source matrix | 2 | `docs/03_data_dictionary.md`, `docs/04_data_sources.md` |
| Collected theatrical file, with a retrieval log and no raw dump in GitHub | 3 | Not started |
| dbt feature views for the three stages and an outcome view | Later | Not started |
| Regression, hypothesis tests, and the three classifiers with the metric set above | Later | Not started |
| Excel what-if workbook | Later | Not started |
| Power BI executive report | Later | Not started |
| Written answer to the business question | Final | Not started |

## 15. Decision record

### Recorded on 7 October 2026

1. Population: all current Disney theatrical labels — Walt Disney Pictures, Walt Disney Animation Studios, Pixar, Marvel Studios, Lucasfilm, and 20th Century only for films released after Disney’s acquisition of 21st Century Fox (closed 20 March 2019). Disney+ originals with no wide theatrical release are out. A theatrical film that later streams on Disney+ stays in. Television films, shorts, and festival-only titles stay out.
2. Window: the last 10 years. Wide-release date on or after 7 October 2016. The eligible-title count is still unmeasured. The window is shorter than the earlier 100–200 sample-size goal and may be tight for a time-aware split.
3. Outcome: nominal worldwide theatrical gross. No CPI and no ticket-price adjustment. If worldwide gross is missing, drop the film. Do not fall back to domestic.
4. Expectation: time-aware regression. For film *i*, fit log worldwide gross on pre-release attributes using only films with an earlier wide-release date. The fitted value on the original dollar scale is the expectation. This regression is the bar, not the early-warning classifier, and it is not refit on the film being labeled or on the test period.
5. Label: one binary label for all three stages. Underperform = 1 when finished worldwide gross is below that film’s fitted expectation. The continuous gap `(actual − expected) / expected` is the business metric, not the classifier target. The label is stored only on the outcome table and is not a feature.
6. Stages: one question, will the film finish under its expectation? Pre-release uses information fixed before the wide domestic opening and no gross or theater count from this film’s run. Week 1 is the first Friday–Sunday on which domestic theaters are at least 600, and adds that weekend’s gross, theater count, and per-theater average. Week 2 is the next Friday–Sunday, and adds that weekend’s gross, theater count, and the hold from week 1. A platform or preview weekend is release history, not week 1. No later weekends, no final gross as a feature, franchise history uses only earlier films, and current ratings and popularity stay excluded.
7. Evaluation: primary metric is ROC-AUC on a time-aware held-out test block. Also report precision and recall for the underperformance class, plus accuracy, F1, and the confusion matrix. A later stage is a useful improvement only when its test AUC is higher than both the previous stage and a one-feature baseline, and a bootstrap interval for the AUC difference lies above zero. Baselines: budget only at pre-release; opening-weekend gross / budget after the opening. Week 2 is compared with the opening-weekend model and with that opening baseline.

### Still unresolved

These items stay flagged. They are not solved.

1. No OpusData academic extract and no IMDb box-office license is in hand. Phase 3 must not scrape Box Office Mojo or The Numbers.
2. A movie-database API token in a local `.env` is not collection permission. TMDB content is not cleared for model training under the API terms cited in the data sources, and TMDB does not document opening weekend, theater counts, or weekly gross.
3. **Needs your approval:** the source-precedence rule when budget or gross figures disagree.
4. The in-scope film count on a licensed extract is unmeasured. Modeling is not treated as feasible until that count is checked.
5. **Needs your approval:** the exact pre-release formula inside the candidate set already named in Section 6 (budget, genre, franchise flag and prior franchise history from earlier films only, animation versus live action, release month or season, runtime, and MPAA rating if available). The formula is frozen before the test period is inspected. It is not frozen yet. No covariate is added beyond that set.
