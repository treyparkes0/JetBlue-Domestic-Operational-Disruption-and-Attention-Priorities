# Decision memo: where domestic operational attention should go first

**To:** Director, airline operations  
**From:** Trey Parkes  
**Date:** 2 November 2026  
**Source:** U.S. Bureau of Transportation Statistics, Reporting Carrier On-Time Performance, JetBlue (`B6`) only. Public data. Not an internal JetBlue extract.  
**Window:** 1 January 2018–31 July 2026. 2,110,783 domestic flights.

## The problem

JetBlue’s domestic disruption is not spread evenly. A late arrival, a cancellation, and a diversion are different events, and the file is large enough to show where each one concentrates. Limited attention should follow the minutes on busy places, with the rate read beside the minutes. A high rate on a thin place is a watch item.

In this window, 26.9% of operated flights arrived 15 minutes or more late, 2.40% of scheduled flights were cancelled, and 0.345% were diverted and not cancelled. Operated flights accumulated 44.2 million arrival-delay minutes. On the flights that were already late, 76.4% of the recorded cause minutes sit in the carrier and late-aircraft buckets. That is an association in the reporting categories. It is not proof that those minutes were avoidable, and it is not a cost.

## Where the minutes are

Five origins account for half of arrival-delay minutes:

| Origin | Flights | Late-arrival rate | Minutes |
| --- | ---: | ---: | ---: |
| JFK | 317,477 | 27.8% | 6.52 million |
| Boston | 350,117 | 25.4% | 6.31 million |
| Fort Lauderdale | 170,468 | 30.0% | 3.78 million |
| Orlando | 144,635 | 30.2% | 3.51 million |
| San Juan | 82,442 | 28.8% | 1.93 million |

Boston flies more than JFK and arrives late less often. JFK still accounts for more minutes. Fort Lauderdale and Orlando are the origins where a high rate and a large operation sit together. San Juan is inside domestic scope and is fifth by minutes.

The same pattern shows up on routes. Florida–New York carries both the minutes and late-arrival rates near or above 31%. MCO → JFK is 612,862 minutes at 31.8%. The Boston–Washington shuttle carries a comparable minute load at 23.6% and 22.6%, because it flies more often. MCO → EWR is the sharp route-level case: 14,407 flights, 35.9% late, 434,041 minutes. FLL → EWR is 35.8% late on 10,993 flights.

DCA, LAX, and the JFK–LAX routes show the other side. They are busy, and their late-arrival rates are in the low 20s. They still belong in the first group because the minutes are large. They are not the reliability problem.

## Where reliability is elevated

Among origins with at least 1,000 flights, the top quartile starts at 29.6% late and 3.06% cancelled. Those are separate flags. A high cancellation rate is not ranked above a high minute total.

Fort Lauderdale, Orlando, and Newark clear the late-arrival quartile and are also in the top 10 by minutes. Miami clears it without being in that top 10: 13,280 departures, 34.3% late, about 30 minutes of floored delay per operated flight. Denver is the same kind of item at 11,117 flights and 33.0% late.

LaGuardia is the cancellation case inside the minute top 10: 3.32% cancelled. Several smaller Northeast origins cancel more often than that and do not have a high late-arrival rate. Nantucket is the extreme, at 4.85% cancelled. Treat that as a cancellation question, not as evidence that those stations are the delay problem.

Six origins between 250 and 999 flights have late-arrival rates in the same range as the quartile: Asheville, Wilmington (NC), Hayden, Norfolk, Vero Beach, and Hyannis. They are monitoring items. Airports below 250 flights stay off the first list even when the rate looks extreme.

## What travels with the disruption

**Day of week.** Sunday is the worst day in this file: 29.5% late, 2.88% cancelled, and 7.37 million minutes. Friday is the busiest day, at 314,540 flights and 28.6% late. Wednesday is the most reliable, at 23.5% late, and it is not the lightest day. Saturday is the lightest. A schedule review that assumes the busiest day is the problem, or that the quietest day is the recovery day, does not match these counts.

**Season.** July is the heaviest month on both the late-arrival rate (33.6%) and the minutes. October is the lightest late-arrival month (21.1%). March’s cancellation rate is high because 2020 is in the pool. July 2023 and July 2026 were severe individual months. April 2020 was a cancellation month, at 35.8%, on a shrunken schedule.

**Causes.** On late arrivals, late aircraft is 39.2% of cause minutes and carrier is 37.2%. NAS is 20.7%. The weather bucket is 2.7%, and that bucket is extreme weather only, not every weather minute inside NAS. Security delay minutes are 0.2%.

**Cancellations.** Weather is the largest cancellation code (36.1%), then carrier (28.6%) and NAS (22.0%). The security code is 13.3% of cancellations only because 6,749 of those 6,756 flights were cancelled in March and April 2020, across the large origins. One security-coded cancellation appears after 2020. It is not a current security pattern. January is the weather-cancellation month. July is the NAS-cancellation month. In the partial 2026 year, weather is about half of cancellations so far.

## What to investigate first

1. **JFK and Boston turns and late-aircraft flow.** These two origins hold 12.8 million arrival-delay minutes. The cause mix on late flights points at late aircraft and carrier before it points at the extreme-weather bucket. Boston’s better rate is part of the question, not a reason to skip Boston.
2. **Fort Lauderdale, Orlando, and the Florida–New York routes, in July–August and December.** This is where rate and minutes coincide. Include MCO → EWR and FLL → EWR in that review.
3. **Sunday operation, then Friday.** Sunday combines the worst rate with the most minutes. Friday is the volume day just behind it.
4. **Miami as a station review.** The rate is high on a base large enough to trust, and the minute total is not large enough to put it ahead of the five origins above.
5. **LaGuardia cancellations, kept separate from late arrivals.**

Do not start with the March–April 2020 security codes, with airports under 250 flights, or with a network-wide claim that a single change will cut the 76.4% controllable share.

## What the forecast is for

The workbook projects the cancellation rate from January 2021 through July 2026, leaving 2020 out of the fit, through July 2027. The baseline is 280,987 flights and 10,716 cancellations. A 5%, 10%, or 15% reduction, with flights held fixed, avoids 536, 1,072, or 1,607 cancellations. Over the year before the horizon, the same method missed by 2.31 percentage points on average, and it missed April 2026 and July 2026 by more. Use it as a planning range. It is not a saving, and it is not evidence that a program will deliver the cut.

## What this cannot establish

The file cannot support a dollar saving, a safety claim, an aircraft-type claim, or a statement that one management action will cause delay to fall. It cannot split 2026 marketed codeshares from operated flights. It cannot see inside the carrier bucket (crew, maintenance, baggage, and the other items reported there). It cannot treat 2020 as a normal year, and it cannot turn January–July 2026 into a full year. Origin and destination are separate, so an airport total that adds both roles double-counts flights.

The supporting counts, the quartile rules, and the test results are in `FINDINGS.md` and `METHODOLOGY.md`.
