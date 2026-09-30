# Research design

**Project:** Film Performance Analytics  
**Films under study:** Disney movies  
**Phase:** 1. This document is the design. No dataset has been collected, and no model has been fit.

The business question is fixed:

> How early can Disney identify potential film underperformance using progressively available movie and early theatrical performance data?

Design choices that change the population, the label, or the clock are not made silently. Each one is marked **Needs your approval**.

## 1. Decisions already settled

These choices follow from the business question and from the requirement that a warning be usable at a real decision point.

1. The unit of analysis is one theatrical film. A later re-release is not folded into the original run’s opening weekend or week 2.
2. There are three prediction stages: pre-release, after the opening weekend, and after week 2.
3. A stage may use only information that would have existed at that time. The rule is stated in full in Section 4.
4. Franchise and other historical features for a film may use only films released before that film.
5. Final gross is an outcome. It is never a feature at any stage.
6. Underperformance is performance relative to an expectation. It is not an arbitrary dollar cutoff, and it is not represented as Disney’s internal definition. Disney does not publish that definition.
7. Whatever label is approved, it is built from the film’s own outcome and from an expectation formed without that film or any later film. The label is never a feature. Whether every stage shares one final-outcome label is still open (Section 4).
8. Evaluation uses a time-aware split. A random row split is not the primary evaluation.
9. Reported evaluation includes accuracy, precision, recall, F1, ROC-AUC, and a confusion matrix.
10. Statistical work is regression and hypothesis tests on observational data. A/B testing is not part of the design: the studio did not randomly assign the films.
11. Forecasting and what-if analysis are reserved for Excel in a later phase. They are not a second implementation of the Python analysis.
12. Clustering is optional. It is not required to answer the business question.
13. Disney+ engagement is out of the feature set and out of the outcome. Reliable public title-level engagement for the theatrical slate was not found (see the data sources).
14. GitHub holds code and documentation only.
15. Phase 3 collection does not start until the items marked **Needs your approval** are resolved, and it does not start by scraping sources whose terms prohibit automated collection.

## 2. Population and studio scope

**Needs your approval.**

The business question says Disney. Public sources attach films to different entities: Walt Disney Pictures, Walt Disney Animation Studios, Pixar, Marvel Studios, Lucasfilm, 20th Century, and the distributor Walt Disney Studios Motion Pictures. Those sets imply different sample sizes and different performance regimes. A Marvel film and a Walt Disney Animation film are not exchangeable observations.

| Option | Population | Tradeoff |
| --- | --- | --- |
| A. Walt Disney Pictures only | Live-action banner released under that production label | Cleaner brand definition. The count of wide theatrical titles may fall below the range this design can support. Animation, which is central to Disney’s theatrical slate, is omitted |
| B. Walt Disney Pictures, Walt Disney Animation Studios, and Pixar | Disney-branded theatrical live action and animation | Still excludes Marvel, Lucasfilm, and 20th Century, which have different budgets, fan bases, and release strategies |
| C. All current Disney theatrical labels, with 20th Century included only after the acquisition | Adds Marvel Studios, Lucasfilm, and post-acquisition 20th Century titles | Larger sample and a closer match to “films Disney releases.” Pools unlike businesses. The acquisition date must be applied as a rule, not as a loose label match on older Fox films |
| D. Disney+ originals | Titles produced for Disney+ without a wide theatrical release | Opening weekend and week 2 are undefined. Streaming minutes are not a theatrical gross. This option does not answer the business question as posed |

Working boundary for discussion, not a decision: options A–C are theatrical. Option D is out of the outcome and out of the feature set. A theatrical film that later appears on Disney+ remains a theatrical film. A Disney+ original with no wide theatrical run is out.

No film count is stated here. Sources were not censused. Whether any option yields approximately 100–200 or more eligible theatrical films is **Needs your approval** together with the year window in Section 3, and it has to be counted in Phase 3 before modeling is planned.

Inclusion also requires a wide theatrical release. Festival-only titles, television films, and shorts are outside the three decision points. The operational rule for “wide” is **Needs your approval** (Section 4).

## 3. Year range

**Needs your approval.**

The design target is on the order of 100–200 or more theatrical films, because a three-stage model with a time-aware split and a franchise history needs enough earlier films to form an expectation. That target is a sample-size goal, not a finding. The achievable count depends on the studio option and on which sources can legally supply budget, opening weekend, and week-2 theater counts.

| Window | Why it might be used | Cost |
| --- | --- | --- |
| Roughly the last 25 years of wide releases | More likely to approach the sample-size goal if several labels are included | Mixes pre-streaming and post-streaming release strategies |
| A shorter recent window | Closer to current release patterns | May be too small for a time-aware split, especially under option A |
| An explicit break around the 2020 theatrical shutdown | Avoids treating pandemic releases as exchangeable with earlier films | Splits an already small sample. The break date itself needs a rule |

The window is chosen after a source can support it. It is not chosen to hit a round number of titles.

## 4. Prediction stages and the leakage rule

### 4.1 Rule

A stage may use only information that would have existed at that time.

- Pre-release cannot use opening weekend, later weekly gross, theater counts from the run, or final gross as features.
- Opening weekend cannot use week 2, later weeks, or final gross as features.
- Week 2 cannot use anything observed after week 2, including final gross and a lifetime maximum theater count if that maximum occurs later.
- Franchise and historical features for a film may use only films released before that film. Later entries in the same series are invisible.
- The label may use the film’s own final outcome. The label is not a feature.
- International gross earned in territories that had not opened by the decision point is not yet known. Territory open dates differ. Stage 1 does not treat a later territory opening as if it were known on the domestic opening weekend.
- A field that is stored as a current snapshot, rather than as a value dated on or before the stage, is not a feature. This applies to current user-rating averages, current vote counts, and current popularity scores (Section 6 of the data dictionary).

The same rule binds the expectation used to build the label. The expectation for film *i* is estimated from films released before film *i* only.

### 4.2 Stages

**Pre-release.** Decision time is the day before the domestic theatrical opening that the design treats as the start of the run. Allowed inputs are production and release facts that are fixed by then, and historical aggregates from earlier films: genre, production method, runtime, rating, budget, release calendar, franchise membership, and the prior films’ outcomes. Allowed inputs do not include any gross or theater count from this film’s run.

**After opening weekend.** Decision time is the end of the first *wide* domestic weekend. Allowed inputs add that weekend’s gross, theater count, and the per-theater average derived from those two. They do not add week 2 or the final gross.

**After week 2.** Decision time is the end of the second week of the wide domestic run. Allowed inputs add gross and theater count observed through that week, and the change from the opening weekend. They do not add later weeks or the final gross.

**Needs your approval:** the clock.

Two definitions are in common use and they are not the same.

- Box Office Mojo publishes a weekend (generally Friday–Sunday) and a week (Friday–Thursday). Its licensed time series distinguishes those occasion types.
- A limited platform opening is a different event from the wide opening. On 30 September 2026, Box Office Mojo’s *Frozen* (2013) title page and The Numbers’ *Frozen* page both showed a domestic opening of $243,390. The Numbers weekend table places that amount on 22 November 2013 at one theater, and places the wide expansion on the following weekend. Box Office Mojo’s summary page shows the same opening dollar amount and does not, on that view, show the theater count.

The working definition, submitted for approval, is:

- Opening weekend means the first wide domestic Friday–Sunday.
- Week 2 means the second week of that wide run.
- A platform or preview weekend is stored as release history and is not the Stage 1 feature.

The theater-count threshold that separates limited from wide is **Needs your approval**. Box Office Mojo has described wide release as about 600 theaters. That description is a candidate rule, not a rule adopted here.

**Needs your approval:** one label versus three. The business question asks how early eventual underperformance can be identified. The design that matches that question uses one final-outcome label and three nested feature sets. Stage-specific labels (for example, “week 2 will disappoint given the opening”) answer a different question. They are not the default.

## 5. Outcome

**Needs your approval.**

The outcome is theatrical box-office gross. It is not profit. Prints and advertising, participations, and ancillary income are not in the public sources reviewed.

| Choice | Options | Tradeoff |
| --- | --- | --- |
| Geography | Worldwide gross, or domestic gross | Worldwide is closer to the full theatrical result and is what budget-multiple commentary usually uses. Domestic is observed earlier, is more complete in U.S. sources, and matches the opening-weekend signal, which is domestic. International openings are on different dates, so a worldwide total is a poor Stage 1 feature and a reasonable final outcome |
| Dollars | Nominal dollars, or inflation-adjusted dollars | Nominal dollars are what was reported and need no deflator. They make a 2005 film and a 2025 film hard to compare. An adjustment is warranted if the year window is long |

Domestic geography is not identical across sources. The Numbers’ market pages define the domestic market as the United States, Canada, Puerto Rico, and Guam. Box Office Mojo’s help text defines domestic as the United States, Canada, and Puerto Rico. IMDb’s licensed box-office dictionary defines area `XDOM` as the United States and Canada, and lists Puerto Rico separately. A chosen outcome still needs a source-precedence rule in Phase 3.

Inflation method, if real dollars are approved:

| Deflator | What it measures | Constraint |
| --- | --- | --- |
| CPI-U, BLS series `CUUR0000SA0` (all items, U.S. city average, not seasonally adjusted) | General consumer prices | Public and documented. It is not a movie-ticket index |
| Average ticket price, as used by The Numbers for its inflation-adjusted domestic box office | Ticket-price change | Matches theatrical purchasing power more closely. The Numbers’ terms require a license for academic or systematic use. The adjustment is not a substitute for CPI-U |

Gross is not adjusted with an ad hoc multiplier.

If worldwide gross is the outcome, domestic and international final gross remain descriptive components. They are still excluded as features. If domestic gross is the outcome, the same exclusion applies to final worldwide gross.

## 6. Expected performance and the label

**Needs your approval.**

Disney’s internal definition of underperformance is not public. This design does not invent a cutoff such as “below $100 million” or “below two times budget” and treat it as that definition. A fixed multiple may be used only if it is estimated from earlier films, or if it is an external benchmark that is cited and then explicitly approved.

Three defensible ways to form the expectation are below. All three are computed for film *i* from films released before *i* only.

### Alternative 1 — Cohort benchmark

The expectation is the median final gross of earlier films in a pre-specified cohort: the approved studio set, production method, a budget band, and franchise versus original. The film underperforms when its outcome falls below that median by a relative margin, or below a pre-specified percentile of the earlier cohort.

Tradeoff: the comparison is explainable to a business audience. With a few hundred films and several cohort factors, many cells will be very small. Budget bands have to be fixed without looking at the film’s own outcome. Using the film itself, or later films, to define the cohort is leakage.

### Alternative 2 — Time-aware regression

The expectation is the fitted value from a regression of outcome on pre-release attributes, trained on earlier films only (an expanding window). The film underperforms when its residual is below a margin or a quantile that was also estimated on earlier films only.

Tradeoff: the expectation can use budget, calendar, and franchise history together. The label then depends on a model. That regression is an expectation model. It is not the early-warning classifier, and it is not refit on the film being labeled. Coefficients are estimated only on prior films. Log gross is the natural scale because gross is skewed; the link is part of the specification and is reported, not tuned against the test period.

### Alternative 3 — Budget-multiple hurdle

The expectation is *kᵢ × budgetᵢ*, where *kᵢ* is the median outcome-to-budget ratio among films released before *i*. The film underperforms when its outcome-to-budget ratio is below *kᵢ*.

Tradeoff: the hurdle is in investment language and does not require a thin cohort cell. It ignores marketing cost, so a high gross multiple can still be an unprofitable film, and a low multiple can still be a film Disney would consider successful for non-theatrical reasons. Films with missing or zero budgets cannot receive this label. A constant *k* chosen for roundness is an arbitrary cutoff and is not this alternative.

### How the expectation becomes a label without leakage

1. Sort films by the approved theatrical release date.
2. For film *i*, estimate the expectation using only films with an earlier release date.
3. After film *i*’s theatrical run is complete, compute the outcome and the gap  
   `gapᵢ = (outcomeᵢ − expectationᵢ) / expectationᵢ`.
4. Assign the binary label only from that gap and the approved rule. The label is stored on the outcome table.
5. Feature tables for the three stages do not contain `outcome`, `gap`, the label, or any column measured after the stage.

The gap uses the final outcome, so it is known only when the run is complete. That is appropriate for supervised learning on historical films. It is not available when a live warning is issued. A live warning compares the stage’s predicted class, or a predicted gap, with the information known at that stage.

Missing budgets, missing finals, and films that have not finished their theatrical run are not labeled by filling the hole with a later source’s number unless that number is dated and the source rule allows it.

### Binary target and continuous gap

**Needs your approval.**

| Choice | What is optimized | What is retained |
| --- | --- | --- |
| Binary label for the classifiers | Underperform versus not. Matches a warning that is either raised or not | The continuous gap is kept as the business metric: severity, ranking, and Excel scenarios |
| Continuous model of the gap, with a binary warning derived from it | Magnitude of the miss | A threshold is still required to raise a warning, so the cutoff moves rather than disappears |

The working proposal, submitted for approval, is the first row. Binary classification matches the warning. The gap stops the project from treating every miss as equal. The primary classification metric among accuracy, precision, recall, F1, and ROC-AUC is **Needs your approval**. Recall of underperformance matters if a missed warning is costlier than a false alarm. That cost ratio is a business judgment, not a property of the data.

Class balance is a result of the approved rule. It is not a reason to move the cutoff until the classes look even.

## 7. Research questions

1. At which stage does a leakage-safe classifier first identify eventual underperformance better than a transparent baseline, under a time-aware evaluation?
2. How much does that answer change if the outcome is domestic rather than worldwide, or real rather than nominal?
3. Which pre-release attributes are associated with the performance gap: budget, genre, production method, release timing, and franchise history built only from earlier films?
4. How large is the disagreement among sources on budget and gross for the same film, and does a documented precedence rule change the label?

## 8. Hypotheses

These are statements to test later. They are not findings.

1. Opening-weekend gross and theater count improve identification of the final label relative to pre-release attributes alone.
2. Week-2 gross and the hold versus opening weekend improve identification further relative to the opening-weekend feature set.
3. Films with at least one earlier franchise entry have a different performance-gap distribution from films with none. The comparison uses only entries released before the film in question.
4. If the approved window includes 2020, absolute residuals from a pre-release expectation fit on earlier years are larger for releases in the theatrical-shutdown period than for releases in the preceding years.

Hypotheses 1 and 2 are about predictive comparison on a later time block. Hypotheses 3 and 4 are associative. None of them supports a claim that changing a release plan would have changed the gross.

## 9. Statistical methods

Later analytical work uses the following methods. None of them is executed in this phase.

**Regression.** A time-aware regression of the approved outcome on pre-release attributes estimates expected performance under Alternative 2, and it is also the descriptive model for Research Question 3. Films enter the estimation only after they are released and only to predict later films. Gross is modeled on the log scale unless a documented reason requires otherwise. Uncertainty is reported with the coefficient estimates.

**Hypothesis tests.** Pre-specified comparisons in Hypotheses 3 and 4 use a test matched to the distribution. Rank-based or permutation tests are the default if residuals are skewed. Films are not a random sample of all movies, and errors can be dependent within a franchise and a release season. A test result is a statement about the observed Disney slate, not a universal theatrical law.

**Not in this design.** A/B testing is omitted because there is no random assignment. Forecasting of the remaining theatrical curve is an Excel task in a later phase: given an observed opening and an assumed hold, show scenario gross. That workbook consumes published assumptions and model outputs. It does not refit the regression or the classifiers.

**Clustering, optional.** If used, clusters are a descriptive aid for cohorts. They are fit on earlier films only, or replaced by the pre-specified cohorts in Alternative 1. A cluster solution fit on the full sample, including future films, is leakage and is not used.

## 10. Machine-learning objective and evaluation

The objective, in a later phase, is to estimate three classifiers of the approved label:

- Stage 0 uses the pre-release feature view.
- Stage 1 uses the opening-weekend feature view.
- Stage 2 uses the week-2 feature view.

The question is how early classification becomes informative. It is not how to maximize a score with every column in the raw file.

**Split.** Training films are released before validation films, which are released before test films. The primary report is this forward split. An expanding-window check is appropriate because the sample is small: for each cut date, train on all earlier labeled films and score the next block. The most recent block is not used to choose the label rule.

**Baselines.** Each stage is compared with the majority class and with a transparent rule from the approved expectation (the cohort, regression, or budget-multiple rule itself). A classifier that does not beat those baselines is not an early-warning system.

**Metrics.** Report accuracy, precision, recall, F1, ROC-AUC, and the confusion matrix at each stage, on the time-aware test block. Precision and recall are for the underperformance class. ROC-AUC is omitted only if the approved model does not produce a ranking score, in which case the omission is stated. The primary metric is **Needs your approval**.

**Leakage audit.** Before any score is treated as evidence, a column inventory confirms that each feature view contains only columns allowed at that stage, and that the expectation for each test film was fit without that film or later films.

No algorithm is selected in this phase. With roughly 100–200 films, a simple model is preferable to a flexible one. That preference is a complexity constraint, not a claim that a particular algorithm has been trained.

## 11. Assumptions

1. A public or licensed gross is a usable record of theatrical performance. It is not Disney’s internal ultimate.
2. The approved studio rule can be applied from production-company or distributor fields. Those fields will be checked; they will not be assumed to match the legal entity.
3. Production budget, when present, is in nominal U.S. dollars as stated by the source. TMDB’s movie bible says budget and revenue are entered in U.S. dollars and are not inflation-adjusted. Other sources need the same check at collection.
4. Budget is treated as pre-release information only when the figure was public before opening. Reported budgets are often estimates and are sometimes revised. Timing is unverified and is listed as a data risk.
5. The theatrical run used for the final outcome is complete. Films still in release are not labeled.
6. One current row per film is the original theatrical cycle, not a re-release.
7. Comparable films are comparable only under the approved cohort or regression specification.

## 12. Limitations

1. The label is a research definition. It is not Disney’s definition, and it does not identify a financially unsuccessful film once marketing and ancillaries are counted.
2. The sample is a selected slate of films from one corporate family. Results do not transfer automatically to other studios.
3. A time-aware split on a few hundred films leaves a small test block. Metric estimates will be noisy.
4. Source totals disagree. The *Frozen* (2013) pages observed on 30 September 2026 did not match: Box Office Mojo showed domestic $400,738,009 and worldwide $1,284,879,663; The Numbers showed domestic $400,953,009 and worldwide $1,269,253,418. A precedence rule can change both expectations and labels.
5. Opening-weekend fields can describe a platform release. Using them as Stage 1 without a wide-release rule misstates the decision point.
6. Current ratings and popularity are not historical states. Using them leaks later audience response.
7. Terms of use remove several convenient collection methods. A variable that is visible on a web page is not automatically usable in this project (see the data sources).
8. No causal claim is available. An early warning does not, by itself, show that a different release plan would have raised gross.

## 13. Success criteria

The research design is successful as a capstone foundation when all of the following hold.

1. Every item marked **Needs your approval** has a recorded decision before collection.
2. The label rule matches one approved expectation method and contains no arbitrary cutoff.
3. A column-level leakage audit passes for all three feature views, including the franchise-history constraint.
4. Evaluation is time-aware and reports accuracy, precision, recall, F1, ROC-AUC, and a confusion matrix against the baselines in Section 10.
5. The written conclusion answers “how early,” including the possibility that no stage beats the baseline by the approved margin.
6. Excel and Power BI, when they are eventually built, present the warning, the stage, and the gap, and do not re-estimate the Python models.

An accuracy target is not set here. A target chosen before the label exists would be arbitrary.

## 14. Final deliverables

| Deliverable | Phase | Status |
| --- | --- | --- |
| Business problem | 1 | This capstone’s `docs/01_business_problem.md` |
| Research design | 1 | This document |
| Data dictionary and source matrix | 2 | `docs/03_data_dictionary.md`, `docs/04_data_sources.md` |
| Collected theatrical file, with a retrieval log and no raw dump in GitHub | 3 | Not started |
| dbt feature views for the three stages and an outcome view | Later | Not started |
| Regression, hypothesis tests, and the three classifiers with the metric set above | Later | Not started |
| Excel what-if workbook | Later | Not started |
| Power BI executive report | Later | Not started |
| Written answer to the business question | Final | Not started |

## 15. Approval list

The following remain **Needs your approval** before Phase 3:

1. Studio scope: option A, B, or C in Section 2. Disney+ originals in or out, with the working proposal that they are out.
2. Year range, after a count of titles the permissible sources can support, aimed at roughly 100–200 or more theatrical films.
3. Outcome geography: worldwide or domestic.
4. Outcome units: nominal or inflation-adjusted, and CPI-U versus a ticket-price index if real dollars are used.
5. Expectation method: cohort benchmark, time-aware regression, or budget-multiple hurdle, including the margin that turns the gap into a label.
6. One final-outcome label for all three stages, or separate labels at each stage. The working proposal is one final-outcome label.
7. Whether the machine-learning target stays binary, with the continuous gap kept as the business metric.
8. Wide-release threshold, and weekend versus weekly as the week-2 clock.
9. Primary classification metric and the improvement over baseline that counts as an earlier useful warning.
