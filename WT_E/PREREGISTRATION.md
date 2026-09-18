# Preregistration — *The Value of Wasted Time* (WT_E)

**Study title:** The Value of Wasted Time: Sunk Time, Survived Risk, and Abandonment under Duration Uncertainty
**Build:** `WT_E` (mixed-hand / FULLRAND, forked from `WT_D`). **Defining change from WT_D:** the alternative can only be accepted during its own hand's timed accept/refuse window (a fixed real-time countdown, 10-45s, shown with two buttons — Accept and switch / Refuse and stay); it no longer stays open for the rest of that hand once the window closes. This changes the primary within-participant identification strategy from a task-level hazard (§3.2/§5.1 of Part II) to an offer-level decision panel — see Part I §28-31 and Part II §2-5 throughout.
**Principal Investigator:** Michele Cantarella — IMT School for Advanced Studies Lucca — michele.cantarella@imtlucca.it
**Platform:** Prolific (recruitment) · GitHub Pages (delivery) · Google Sheets + Apps Script (data)
**Ethics:** Joint Ethical Committee of Scuola Superiore Sant'Anna / Scuola Normale Superiore / IMT Lucca — approval N. 23/2026, 30 April 2026
**Document version:** 2.0 · forked from the WT_D draft (v1.0, 2026-08-02) on 2026-09-18 for the WT_E mechanic change · **status: draft, not yet submitted**

---

## 0. How to use this document

This is written to be pasted field-by-field into the [AEA RCT Registry](https://www.socialscienceregistry.org/), whose data elements are fixed by the registry's [Data Elements Definitions](https://s3.amazonaws.com/aea-registry/AEA%20RCT%20Registry%20Data%20Elements%20Definitions.pdf) (updated 2 July 2020). Part I below maps 1:1 onto the registry's own required and optional fields, in the registry's own order. Part II is the pre-analysis plan, intended to be uploaded as the registry's optional **Analysis Plan** attachment.

Structure and house style follow two exemplars: [Evaluating the Sunk Cost Effect (AEARCTR-0004083)](https://www.socialscienceregistry.org/trials/4083) for the registry entry, and de Quidt, Haushofer & Roth, [*Measuring Experimenter Demand in an Effort Experiment: Pre-analysis Plan*](https://www.socialscienceregistry.org/versions/17761/docs/version/document) for the analysis plan (numbered hypotheses, explicit estimating equations, Anderson sharpened q-values, Lee bounds for attrition).

> **⚠ Eight items must be settled before this is submitted.** They are collected in §14 and flagged inline as **[DECISION]**. Three are substantive design issues carried over from the WT_D draft (surfaced by the simulations reported here); three are placeholders (sample size, dates, pilot status); two are new to this WT_E fork, arising directly from the mechanic change — the offer-level power calculation not yet being run (**7**), and the instrument not distinguishing an explicit refusal from a countdown timeout (**8**). Nothing in this document should be registered until those are resolved — a registered plan is costly to amend.

Fields marked **[PLACEHOLDER]** need a value. Fields marked **[HIDDEN]** should be entered into the registry's hidden variant, which stays private until the trial is marked complete.

---

# Part I — AEA RCT Registry fields

## Trial Information

**1. Trial Title**
The Value of Wasted Time: Sunk Time, Survived Risk, and Abandonment under Duration Uncertainty

**6. Country**
United Kingdom; United States *(set to match the Prolific screening actually used — see* **[DECISION 4]** *)*

**7. Region**
Online sample; no sub-national targeting.

**8. Primary Investigator**
Michele Cantarella, IMT School for Advanced Studies Lucca.

**10. Status**
In development.

**11. Keywords** *(registry controlled vocabulary)*
Labor

**12. Additional Keywords**
sunk cost, sunk time, optimal stopping, abandonment, duration uncertainty, hazard rate, outside option, real-effort task, online experiment, time use, opportunity cost of time

**13. JEL Codes**
D81, D91, D83, C91, J22

**15. Abstract**

> Time already spent is sunk: a decision-maker choosing whether to abandon an open-ended task for a bounded alternative should condition only on the expected time remaining, never on time already elapsed. This experiment tests that prediction, and asks a sharper question the existing sunk-cost literature cannot address: does it matter *what kind* of time was spent?
>
> Participants recruited on Prolific complete five sequences of a short real-effort grid task. Each sequence's main run has no announced length. It unfolds as a chain of **hands** — small groups of 1–10 tasks, dealt one at a time. Within each hand, every task is independently and visibly marked either **live** (the sequence can end on it) or **safe** (it cannot), and the hand's exact probability of ending is disclosed the moment it is dealt. If a hand does not end, a fresh hand is dealt with new parameters, so the sequence has no fixed horizon. At a randomly placed point in each hand, participants are offered a switch to an **alternative** sequence of known, fixed length, at the same reward; the offer is open only for that hand's own short, timed window (a countdown of 10-45 seconds, with an explicit accept/refuse choice) and lapses back into the main run if neither is chosen in time, though a later hand's own offer can still open a fresh window. Participants may also forfeit at any time.
>
> Because live and safe marks are independent coin flips, two participants who have completed the same number of tasks, in a hand of the same length, with the same disclosed end-probability, can differ substantially in how much of that elapsed time was spent under genuine risk of ending ("survived risk") versus spent on tasks that could not possibly have ended the sequence ("dead time"). Normatively both are equally sunk and equally irrelevant. This orthogonal variation — which a conventional block-structured design cannot generate — is the study's central identifying feature.
>
> Randomization is at the individual level. Each participant is assigned, uniformly, one of four **placement regimes** governing the joint draw of the offer's position and the hand's ending (ending-then-offer; offer-then-conditional-ending; independent; or a per-hand mixture of the first two), and, 50/50, one of two **horizon framings** (told the study has four sequences or five; everyone completes five, so the four-framing group receives an unannounced fifth). Primary outcomes are the decision to accept each hand's own offer, its timing, and the decision to forfeit. Planned sample: **[PLACEHOLDER — see §12; recommended N = 1,600, pending recomputation under the offer-level design — [DECISION 7]]** participants, each contributing five sequences and roughly ten offer-level decision points (one per hand whose own offer actually fired, not per task).

**16. External Link(s)**
**[PLACEHOLDER]** — GitHub Pages URL of the deployed instrument.

**17. External Link Description**
Live experimental instrument (single-page application; full source in `index.html`).

## Dates

**18. Trial Start Date** — **[PLACEHOLDER]**
**19. Intervention Start Date** — **[PLACEHOLDER]** (first day of data collection)
**20. Intervention End Date** — **[PLACEHOLDER]**
**21. Trial End Date** — **[PLACEHOLDER]**

## Experimental Details

### 28. Intervention (Public)

Participants complete five sequences of a real-effort task in a single online session lasting approximately 20 minutes. The real-effort task is a 3×3 grid of emoji that reveals progressively over 4.5 seconds; the participant clicks every instance of a named target emoji before a 2.5-second countdown auto-submits (≈7 seconds per task). Errors carry a £0.01 penalty each but never halt the sequence.

Each sequence's **main run** has no announced length. It is a chain of **hands**: groups of 1–10 tasks dealt one hand at a time and shown as a stack of cards. Every task within a hand is independently marked **live** (orange — the sequence can end on this task) or **safe** (white — it cannot); the marks are interspersed, not blocked. Each hand also carries a disclosed probability, between 10% and 90%, that the sequence ends somewhere inside that hand. If it ends, the ending task is uniform over that hand's live tasks. If the hand is survived, a fresh hand is dealt with a newly drawn length, live/safe pattern, and end-probability. Nothing about a hand is revealed before it is dealt.

At a randomly placed task within each hand, an **alternative sequence** of known, fixed length is offered at the same reward. The offer is presented in place, with a countdown of 10-45 seconds during which the participant sees two explicit choices, "Accept and switch" and "Refuse and stay"; if neither is chosen before the countdown ends, the default is to stay. Either way, that hand's own offer then closes and does not reopen — the alternative becomes available again only when a **later** hand's own offer fires, each one its own fresh, independently timed window. Participants may also forfeit the sequence entirely at any point (losing that sequence's reward but not their other earnings).

The interventions are two individual-level randomizations: a four-arm **placement regime** determining how the offer's position is drawn jointly with the hand's ending, and a two-arm **horizon framing** determining whether participants are told the study contains four or five sequences.

### 29. Intervention (Hidden) **[HIDDEN]**

*Withhold until the trial is complete: this reveals the generative parameters participants are not told, and disclosing it during fielding would compromise the design.*

Per-hand primitives, drawn independently for every hand:

```
length   ~ Uniform{1, …, 10}
live[k]  ~ Bernoulli(0.5) independently for each of the `length` tasks
           (one task forced live if all draws came up safe)
pInside  = round( clamp( Normal(0.50, 0.20), 0.10, 0.90 ) × 20 ) / 20
```

The first hand of each sequence draws `pInside` from a **quintile-stratified** scheme: a shuffled ordering of the five equal-mass quintiles of the `pInside` distribution is fixed once per participant at consent, and sequence *i* draws its first hand's `pInside` from quintile *i*. Every participant therefore sees each quintile exactly once across their five sequences, in an order randomized between participants. Later hands within a sequence draw unstratified.

An **undisclosed cap** of 6 hands per sequence forces the sixth hand to end. It binds in 1.5%–6.4% of sequences depending on regime (§Design Moments); those sequences are right-censored at their realized length.

Each hand draws its own offer position `pause ~ Uniform{0, …, length−1}`. The four placement regimes govern the joint draw of `pause` with that hand's ending:

```
REGIME 1  ending drawn first, offer placed before it
  ends   ~ Bernoulli(pInside);  if so  endPos ~ Uniform(live tasks)
  pause  ~ Uniform{0, …, min(length−1, endPos−1)}    if the hand ends
  pause  ~ Uniform{0, …, length−1}                   if it survives

REGIME 2  offer drawn first, ending conditional on surviving it
  pause  ~ Uniform{0, …, length−1}
  aheadLive     = live tasks strictly after `pause`
  insideMass    = pInside × |aheadLive| / |live tasks|
  pInGivenPause = insideMass / ( insideMass + (1 − pInside) )
  ends   ~ Bernoulli(pInGivenPause);  if so  endPos ~ Uniform(aheadLive)

REGIME 3  fully independent
  ends, endPos drawn as in Regime 1;  pause ~ Uniform{0, …, length−1}
  wasted = ends AND endPos < pause    (the hand ended before its own offer)

REGIME 0  per-hand mixture: each hand independently re-draws whether Regime 1
          or Regime 2 governs it (never Regime 3)
```

The alternative's length is drawn from a bounded bell (mean of three uniforms) whose **endpoint** is centred on the expected remaining main tasks at the first hand's offer, with support width equal to the mean hand length (5.5), floored at 2. The sequence **reward** is drawn from the same bounded bell centred instead on a whole-experiment population constant (`POP_MEAN_END` = 8.99 tasks, computed once from the hand-length and end-probability distributions restricted to `pInside ∈ [0.30, 0.70]`), so the reward never leaks the realized length of the participant's own sequence. Reward rate is £0.0375 per task of the drawn count.

**WT_E only — the accept/refuse window's own duration.** Independently of `pause` (WHICH card the offer lands on, drawn at generation time as above), each hand's offer also gets its own countdown length `pauseSecs ~ Uniform{10, …, 45}` seconds, redrawn fresh at the moment that hand's offer screen actually opens (a runtime draw, not a generation-time one — it is undrawn, and unlogged, for a hand whose own offer never fires, i.e. `wasted = 1` under sub-regime 3). This is the entire window in which that hand's offer can be accepted; unlike `pause`, it carries no participant-facing disclosure of its own distribution, only the live countdown numeral.

### 30. Primary Outcomes (end points)

1. **`switch_taken`** — binary, one per sequence: the participant accepted some hand's offer and switched to the alternative.
2. **Offer-level accept decision** — binary, one observation per **hand whose own offer actually fired** (i.e. `wasted = 0`) across all five sequences: did the participant accept *this* hand's offer, in the fixed window it was open for.
3. **`n_tasks_before_decision`** — count of main-phase tasks completed before switching, forfeiting, or the sequence ending naturally (a duration outcome, right-censored at natural endings and at cap-bound sequences).
4. **`forfeit_taken`** — binary, one per sequence.

### 31. Primary Outcomes (explanation)

Outcomes 1, 3 and 4 are recorded directly by the instrument (`Responses` sheet, one row per participant × sequence × attempt). Outcome 3 is `switch_taken_at_task` when a switch occurred, `forfeit_taken_at_task` on a forfeit, and the realized main length `n_req` otherwise, with a censoring indicator equal to 1 in the last case.

**Outcome 2 is the workhorse, and its unit of analysis is the WT_E mechanic's central departure from earlier builds.** In WT_D, the offer stayed open for the rest of a hand once it fired, so a task-level panel could ask "did they switch at *this* task, having survived every earlier task in the open window." In WT_E there is no such window to expand: each hand's own offer is a single accept/refuse decision, resolved once, inside its own timed countdown, with no main-sequence tasks completed while it is open. The panel is therefore built by taking one row per hand whose own offer fired (`wasted = 0` in the `Hands` sheet — see README §9), across every sequence and every hand within it, not per task. For each such row we compute, from the logged per-hand and per-sequence realization, the state the participant could actually see **at the moment that hand's own offer appeared**: that hand's disclosed length, offer position (`pause`, fixed at generation time — see Part I §29 — and therefore identical to the "position within hand" state at decision time, since there is only ever one decision point per hand), and disclosed end-probability; the number of live and safe cards already passed within that hand and cumulatively within the sequence so far (`active_passed_in_hand`/`_in_seq`, `inactive_passed_in_hand`/`_in_seq`, all in the `Hands` sheet); the alternative's fixed length; and the model-implied expected number of further main tasks. The expectation `E[remaining]` is the same quantity the instrument itself computes (`eRemFullrandWith_`): it walks that hand's actual remaining live positions and uses the population constant for any hands that might follow.

The two sunk-time regressors are `active_passed` (live tasks already completed, summing `_in_hand` and whatever was accumulated in earlier hands of the same sequence) and `inactive_passed` (safe tasks already completed, same construction). Their **sum** is elapsed time at the moment of that hand's own offer; their **difference** is the composition of that time. Neither should enter a normatively correct decision rule. Unlike the task-level panel this replaces, within a single hand these are now **fixed by generation** (that hand's own `pause` and live/safe mask, drawn before the participant ever saw the hand), not partly a function of how far the participant let the window run — the randomness the identification strategy in §3.2 of Part II relies on comes entirely from the generative draw, never from participant behaviour within an offer.

### 32. Secondary Outcomes (end points)

1. Switch timing conditional on switching (`switch_taken_at_task`). `switch_decision_secs` is **not** a deliberation-time measure in this build — accepting is a single immediate action, so it is always ~0 when populated (see Part I §28); it is kept only for schema consistency. The genuine within-window deliberation measure available in WT_E is instead the gap between that hand's own offer firing (`offer_fired_at`, `Hands` sheet) and the accept decision (`switch_taken_at_time`, `Responses`), bounded above by that hand's own `pause_secs` — not pre-computed by the instrument, so it must be constructed at analysis time by matching the accepted hand (the one whose `hand_n` corresponds to `switch_taken_at_task`) across the two sheets. There is no equivalent timestamp for an *explicit* refuse, since "Refuse and stay" and letting the countdown expire both route through the same `decide('continue')` call with no distinguishing record — see the limitation noted in §11.
2. Response to the offer's arrival: whether the participant accepted the very first offer of the section versus a later hand's own offer, having declined (or let lapse) an earlier one (`outcome_summary` distinguishes these — see Part II §4).
3. Real-effort performance and attention: `total_found`, `total_false_pos`, `total_missed`, `penalty`, and the `no_activity` flag per grid.
4. Abandonment behaviour across the session: number of sequences forfeited, and position of the first forfeit.
5. Reload/attempt behaviour: `seq_attempt > 1` rows, which record sequences abandoned mid-run by a new-session reload.
6. Elicited individual differences: risk tolerance (Dohmen et al. 2011, SOEP single item, 0–10) and patience (Falk et al. 2016, GPS single item, 0–10), plus the pre-registered background covariates in §33.

### 33. Secondary Outcomes (explanation)

Background covariates, all collected in a two-screen survey before training: education, employment status, monthly labour income (conditional on being employed or self-employed), marital status, household size, whether others contribute to household expenses, and a 7-point SOEP "able to make ends meet" scale asked for three time frames (now, one year ago, one year ahead). IP-derived country/region/city is collected client-side, best-effort, at consent.

Outcome 5 exists because the instrument deliberately re-draws a sequence's hands if a participant returns in a *new session* mid-sequence — this prevents learning the sequence's length by abandoning and returning. Each abandoned attempt is nonetheless written as its own row (`outcome = 'abandoned_reload'`, `is_latest_attempt = 0`), so strategic reloading is measurable rather than silently discarded. All primary analyses filter to `is_latest_attempt = 1`; §9 of the analysis plan treats these rows as an outcome in their own right.

### 34. Experimental Design (Public)

Between-subjects, two orthogonal individual-level randomizations, crossed, with a substantial within-subject component.

**Randomization A — placement regime (4 arms, equal probability).** Determines how each hand's offer position is drawn jointly with that hand's ending: (1) ending first, offer placed before it; (2) offer first, ending conditional on surviving it; (3) both drawn independently, so the offer can fail to arrive; (0) each hand independently re-draws whether rule (1) or rule (2) governs it. Assigned once at consent and held fixed across all five of a participant's sequences.

**Randomization B — horizon framing (2 arms, 50/50).** Participants are told the study contains either four or five sequences. All participants complete five. Those told four receive the fifth as an unannounced bonus sequence.

**Within-subject.** Each participant completes five sequences. Each sequence's first hand draws its disclosed end-probability from a different quintile of the end-probability distribution, in an order randomized per participant, so every participant experiences the full range of end-probabilities exactly once. Within each sequence, hand lengths, live/safe patterns, offer positions, and the alternative's length are redrawn independently.

Participants are recruited on Prolific. After consent and a two-screen background survey, a sixteen-screen training walkthrough staged on the real task screen teaches the grid task, the hand mechanic, the loop into a fresh hand, and the alternative offer's own timed accept/refuse window, ending with a three-question comprehension check (gating progress; wrong-answer counts logged) and a £0.10 completion bonus. The five sequences then run back to back. Total expected duration is approximately 20 minutes.

### 35. Experimental Design (Hidden) **[HIDDEN]**

*Withhold until complete.* Three properties of the realized design are not neutral across regime arms and are pre-registered here so that the analysis plan's remedies are on record before data collection.

**(i) Realized sequence length differs by regime.** Regime 2's conditional-ending rule reduces the chance a hand ends once its offer has been survived, so hands survive more often and sequences run longer. Simulated mean main-run length (600,000 sequences per arm): Regime 1 = 8.35 tasks, Regime 3 = 8.35, Regime 0 = 10.19, Regime 2 = 12.51. Mean hands per sequence 1.92–2.53; the undisclosed 6-hand cap binds in 1.45% (Regime 3) to 6.41% (Regime 2) of sequences. Any raw between-regime comparison of persistence therefore conflates the informational manipulation with the length distribution it induces. §5.4 of the analysis plan specifies the conditional comparison as primary and the raw comparison as descriptive.

**(ii) The offer's position is informatively correlated with sequence length in every arm, not only Regime 1.** Because the offer must land inside its own hand, the maximum offer position grows with hand length, so a later offer selects for a longer hand and hence a longer sequence. Simulated `E[main length | first hand's offer position]`:

| offer position | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|---|---|---|---|---|---|---|---|---|---|
| Regime 0 | 6.60 | 9.21 | 11.09 | 12.37 | 13.63 | 14.75 | 15.78 | 16.78 | 18.31 |
| Regime 1 | 5.34 | 7.70 | 9.33 | 10.99 | 12.39 | 13.55 | 14.88 | 15.67 | 17.33 |
| Regime 2 | 8.68 | 11.30 | 12.52 | 13.91 | 15.51 | 16.34 | 17.60 | 18.76 | 19.75 |
| Regime 3 | 6.83 | 7.71 | 9.36 | 10.54 | 11.77 | 13.08 | 14.12 | 14.63 | 15.67 |

The slopes are similar across arms (≈1.1–1.5 tasks per position); the *levels* differ. The regime contrast is therefore not a clean "informative versus uninformative offer timing" contrast. §5.4 specifies hand-length conditioning throughout, and §11 records this as a limitation.

**(iii) Regime 3 wastes offers frequently.** In 21.2% of Regime 3 sequences at least one hand ended before its own offer position, so that offer never fired; mean offers actually fired per sequence is 1.57 under Regime 3 against 2.50 under Regime 2. Wasted-offer hands contribute no accept/refuse decision and are dropped from the offer-level panel (Part II §3.2/§5.1), which induces a selection on short hands that is handled in §5.4 and §9.

### 36. Randomization Method

Randomization is performed client-side by the participant's browser at the moment of consent, using JavaScript's `Math.random()`, and is recorded immediately to the backend together with the consent timestamp. The placement regime is drawn uniformly from the four arms; the horizon framing is an independent fair coin. Both are written into the participant's resume snapshot at consent and restored verbatim on any reload, so neither can be re-drawn by refreshing, closing the tab, or returning on another device. A `?regime=` URL override exists for internal testing only; it is inert without the parameter and any session using it is identifiable in the data and excluded.

The per-participant ordering of end-probability quintiles across the five sequences is a Fisher–Yates shuffle of `{0,1,2,3,4}`, also drawn once at consent and persisted identically.

### 37. Randomization Unit

Individual participant. Both randomizations are assigned at the individual level and held fixed for all five of that participant's sequences. There is no group or session-level assignment.

### 38. Was the treatment clustered?

No.

### 39. Planned Number of Clusters

Not applicable — randomization is at the individual level and treatment is not clustered. Analyses nonetheless cluster standard errors by participant, because each participant contributes five sequences and roughly ten offer-level decision observations (one per hand whose own offer actually fired — see Part I §31/§35(iii); this replaces the ≈40 task-level observations per participant of the WT_D task-level-hazard design, since a WT_E offer resolves in a single decision, not a multi-task open window). **[DECISION 7]** flags this figure for exact resimulation before launch.

### 40. Planned Total Number of Observations

**[PLACEHOLDER — recommended 1,600 participants, pending §12/[DECISION 7]]**, yielding approximately 8,000 sequence-level observations and, provisionally, approximately 16,000 offer-level decision observations (≈10 per participant — see §39; not yet confirmed by simulation). See §12 for the power table this recommendation comes from.

### 41. Sample Size by Treatment Arms

Under the recommended N = 1,600, the two randomizations are independent, so cells are filled in expectation as:

| | Framing: 4 sequences | Framing: 5 sequences | Regime total |
|---|---|---|---|
| Regime 0 (per-hand mixture) | 200 | 200 | 400 |
| Regime 1 (ending → offer) | 200 | 200 | 400 |
| Regime 2 (offer → ending) | 200 | 200 | 400 |
| Regime 3 (independent) | 200 | 200 | 400 |
| **Framing total** | **800** | **800** | **1,600** |

There is no pure control arm: every participant faces some placement rule, and the estimands are contrasts between rules. Regime 2 is the natural reference (it is the rule under which the offer never fails to arrive and the conditional end-probability is recomputed consistently after every pause).

### 42. Power Calculation

Minimum detectable effects at 80% power, α = 0.05 two-sided, standard errors clustered by participant. Design effects use 5 sequences per participant for sequence-level outcomes, with intra-participant correlation ρ as stated. Full derivation in §12 of the analysis plan.

**Between-participant, sequence-level switch rate** (assumed base rate 0.40), single pre-specified pairwise regime contrast — unaffected by the WT_E mechanic change, since `switch_taken` is still one binary per sequence regardless of how many hand-level offers led to it:

| N | ρ = 0.30 | ρ = 0.50 |
|---|---|---|
| 1,200 | 7.4 pp | 8.7 pp |
| 1,600 | 6.4 pp | 7.5 pp |
| 2,000 | 5.8 pp | 6.7 pp |

**Between-participant, horizon framing** (two arms, so twice the per-arm sample): 4.6 pp (ρ = 0.30) to 5.3 pp (ρ = 0.50) at N = 1,600.

**Within-participant, offer-level accept decision** — the primary sunk-time test, and the part of this power analysis most affected by the mechanic change described in the document header. WT_D's figure here (34.8% of task-level live-passed variance surviving conditioning, residual SD 0.868, contrast residual SD 1.736, base hazard 0.06/task, ≈39.6 decision points/participant) does not carry over: the unit of analysis is no longer a task-level hazard inside an open window but one accept/refuse decision per fired offer (≈10/participant — §39), so both the residual-variance decomposition and the base rate need their own simulation at the new unit of analysis, not a reuse of the WT_D numbers. **[DECISION 7]: no MDE table is reported here until that offer-level simulation is run** — as a placeholder for what it will need to assume, the base accept rate is *roughly* one in four to five offers (implied by the ≈0.40 sequence-level switch rate spread over ≈2 fired offers per sequence, treating them as close to independent — this is illustrative, not a simulated figure), which is a much higher per-decision rate than the old 0.06 per-task hazard, and with roughly a quarter as many decision points per participant the design effect works out very differently. The MDE formula itself is unchanged (§12): `MDE(β) = 2.80 × SD(y) / (SD_resid(Contrast) × sqrt(n_eff))` with `n_eff` now built from ≈10 offer-level observations per participant rather than ≈39.6 task-level ones.

At N = 1,600 and ρ = 0.25 the design detects a difference of half a percentage point in switch hazard per unit of live-versus-safe imbalance — roughly a 8% proportional shift in the hazard for a two-task imbalance, which is well inside the range the sunk-cost literature reports.

## Institutional Review Board

**43. Did you obtain IRB approval?** Yes.
**44. IRB Name** Joint Ethical Committee of Scuola Superiore Sant'Anna, Scuola Normale Superiore, and IMT School for Advanced Studies Lucca.
**45. IRB Approval Date** 2026-04-30.
**46. IRB Approval Number** N. 23/2026.

## Docs & Materials (optional)

| Document | Type | Public at registration? |
|---|---|---|
| `index.html` — complete instrument source | Survey Instrument | **[DECISION 5]** — recommend withholding until complete |
| `README.md` — design and implementation reference | Other | Withhold until complete |
| `backend.txt` — data-collection backend source | Other | Withhold until complete |
| Consent form text | IRB Protocol | Public |
| This document, Part II | Analysis Plan | **[DECISION 5]** |

## Analysis Plan (optional)

Upload Part II of this document.

---

# Part II — Pre-Analysis Plan

## 1. Motivation

A decision-maker who has already spent time on an unfinished task, and who is offered a bounded alternative that delivers the same reward, should compare only the expected time still required against the alternative's known length. Time already spent enters neither side. The robust empirical finding is that it does anyway: people persist with what they have invested in. That finding is well established for money and reasonably well established for time.

This design targets a question one step further in. Elapsed time is not homogeneous. Some of it is spent under genuine risk that the task will end — effort that *could* have paid off at any moment, and did not. Some of it is spent in stretches where ending was impossible — effort that could not have paid off no matter what. Both are equally sunk. Both are equally irrelevant to a forward-looking decision. But they may not feel the same, and the study's title is the hypothesis: is time that could not possibly have delivered anything experienced as *more* wasted, and therefore more binding, than time that carried real hazard and simply did not resolve?

Two opposing intuitions are live. Under a "survived risk" account, live tasks accumulate salient near-misses; each is an occasion on which the sequence might have ended and did not, and that history is what a participant feels invested in. Under a "dead time" account, safe tasks are the ones that register as pure waste — nothing was at stake, the time bought nothing but position — and it is that felt waste that makes abandonment harder to accept. The design can distinguish these because it makes the two orthogonal to everything a rational agent would condition on, which no block-structured version of this task can do.

## 2. Design summary

Five sequences per participant. Each sequence's main run is a chain of hands; each hand is 1–10 tasks with independently drawn live/safe marks and a disclosed end-probability; a survived hand is followed by a fresh one. Each hand draws its own offer position, at which an alternative of known fixed length becomes available for that hand's own short, timed accept/refuse window only, closing again — for good, not just until the next task — if neither choice is made before it runs out. Two individual-level randomizations: placement regime (4 arms) and horizon framing (2 arms). Full detail in Part I, §§28–29 and 34–35.

## 3. Identification

### 3.1 The forward-looking state is observable and computable

At the moment each hand's own offer appears, the participant can see: which hand they are in, its total length, its disclosed end-probability, which of its tasks are live and which are safe (the whole hand's card stack is visible), how many tasks they have completed within it, and the alternative's exact length. From the logged realization we reconstruct exactly this information set, and compute the model-implied expected number of further main tasks using the instrument's own function. Nothing in the reconstructed state uses information the participant did not have.

### 3.2 The identifying variation

**This section describes the identification strategy as it holds in WT_E; it differs from the WT_D draft this document was forked from, and the difference is consequential, not cosmetic — see the note in the document header.** In WT_D, the offer stayed open for the rest of a hand once it fired, so position-within-the-open-window (`lp`) varied task by task while the participant decided, and the composition question could be asked repeatedly, once per task, as more of the hand passed. In WT_E each hand's own offer resolves in a single accept/refuse decision, made once, inside its own timed countdown, with no further main-sequence tasks completed while it is open — so there is exactly one decision point per fired offer, and the "position within hand at decision time" is not a participant-influenced quantity at all: it is simply that hand's own `pause`, fixed at generation before the hand was ever dealt (Part I §29).

Let a hand have length `L`, disclosed end-probability `p`, and its own offer position `pause`. Let `A` be the number of live tasks already completed in that hand *at* `pause` and `I = pause − A` the number of safe ones (both logged directly per hand — `active_passed_in_hand`/`inactive_passed_in_hand` in the `Hands` sheet). Because each task's live/safe mark is an independent fair coin flip, drawn independently of `L`, of `p`, and of `pause` itself, the split of `pause` into `(A, I)` is random conditional on `(L, pause, p)` — exactly the same argument as WT_D's, just evaluated at a single fixed point per hand rather than at every task of an open window.

This is the design's central feature and the reason for the mixed live/safe pattern. In a block-structured hand — a run of safe tasks followed by a run of live ones, as in earlier builds of this study — `A` is a deterministic function of `pause` and the block boundary, and the composition question cannot be asked at all.

Conditioning is not free: `E[remaining]` itself depends on how many live tasks have been survived, so `A` and the forward-looking state are not orthogonal unconditionally. The pre-specified remedy is to saturate on `(L, pause, p)` and identify from within-cell variation only. **The WT_D figure quoted in earlier drafts here (34.8% of variance in `A` surviving conditioning, residual SD 0.868, contrast residual SD 1.736) was computed over the task-level panel and does not transfer to the offer-level panel — see Part I §42/[DECISION 7] for why a fresh simulation is needed before this number can be reported for WT_E.**

### 3.3 What the regime randomization identifies

The regime arms vary the joint law of offer position and hand ending. They are *not* clean variation in "how informative the offer's timing is," because the offer must sit inside its own hand in every arm, which makes a late offer select for a long hand everywhere (Part I §35(ii)). What they do vary cleanly is (a) whether the offer can fail to arrive at all (Regime 3 only), (b) whether the conditional end-probability is recomputed on survival (Regime 2 and, per hand, Regime 0), and (c) in Regime 0, the placement rule *within* participant, which supports a within-participant test that the between-arm comparison cannot deliver.

## 4. Hypotheses

Hypotheses are grouped into two confirmatory families and one exploratory family. Multiplicity is controlled within each confirmatory family (§7).

### Family A — sunk time (within-participant, primary)

> **Hypothesis A1 (responsiveness).** The probability of accepting an offer is increasing in the expected time saved by switching. In the offer-level accept decision, the coefficient on `E[remaining] − alt_duration` is strictly positive.

This is the design check that participants respond to the forward-looking incentive at all. If A1 fails, the sunk-time hypotheses are uninterpretable and we will report that and stop.

> **Hypothesis A2 (sunk time binds).** Conditional on the forward-looking state, the probability of accepting a given hand's own offer is decreasing in the number of main tasks already completed *by the moment that offer appears*. In the offer-level accept decision, the coefficient on elapsed tasks is strictly negative.

> **Hypothesis A3 (composition of sunk time).** Conditional on the forward-looking state *and* on total elapsed tasks (both measured at the moment the offer in question appears), whether an offer is accepted depends on whether that time was spent on live or safe tasks. The coefficient on the live-minus-safe contrast is non-zero.
>
> **A3a (dead-time account):** safe tasks bind more — the contrast coefficient is positive (more live, relatively fewer safe, means *more* accepting).
> **A3b (survived-risk account):** live tasks bind more — the contrast coefficient is negative.
>
> A3 is tested two-sided; A3a and A3b are the directional readings and we pre-commit to reporting whichever obtains without claiming to have predicted it.

> **Hypothesis A4 (hand renewal).** A fresh hand attenuates the weight on time sunk in earlier hands. The coefficient on live-and-safe tasks accumulated in *previous* hands (before the current one started) is smaller in magnitude than the coefficient on tasks accumulated in the *current* hand (i.e. up to that hand's own offer position, `pause`).

### Family B — placement regime and horizon (between-participant, primary)

> **Hypothesis B1 (offer reliability).** Participants under Regime 3, who sometimes see the offer fail to arrive, switch more readily when it does arrive than participants under Regimes 1 and 2, for whom it always arrives.

> **Hypothesis B2 (draw order).** Conditional on the forward-looking state, switching differs between Regime 1 and Regime 2.

> **Hypothesis B3 (within-participant placement).** Among Regime 0 participants, the per-hand placement rule affects the offer-level accept decision, estimated with participant fixed effects.

> **Hypothesis B4 (horizon framing).** Participants told the study contains four sequences behave differently in sequence 4 — their believed last — from participants told it contains five. We test both persistence (offer acceptance) and abandonment (forfeit rate) in sequence 4, and separately test for a discontinuity at the unannounced sequence 5.

### Family C — exploratory (not multiplicity-controlled, reported as exploratory)

C1. Heterogeneity of A2 and A3 by elicited risk tolerance and patience.
C2. Heterogeneity by labour income and by the "ends meet" scale — whether the opportunity cost of time moderates sunk-time sensitivity.
C3. Deliberation time *within the accept/refuse window* — the gap between a hand's own offer firing (`offer_fired_at`, `Hands` sheet) and the accept decision (`switch_taken_at_time`, for the hand actually accepted), constructed at analysis time as described in Part I §32 — as a function of how close that offer's `alt_minus_expected` is to indifference. Not `switch_decision_secs`, which is degenerate in this build (see Part I §28/§32); only available for accepted offers, not for explicit refusals or timeouts (see the limitation in §11).
C4. Learning across the five sequences: does the sunk-time coefficient attenuate with experience?
C5. Whether the disclosed end-probability is used correctly — comparing behaviour against the Bayesian benchmark within hand, as live tasks pass.
C6. Strategic reloading: predictors of `seq_attempt > 1`.

## 5. Estimating equations

### 5.1 Primary specification — offer-level accept decision

For participant *i*, sequence *s*, hand *h* whose own offer actually fired (`wasted = 0`) and the participant had not already left the main run before it appeared:

**Equation (1)**

```
accept_ihs = α_i + λ_(L,pause,p)
             + β1 · Elapsed_ihs
             + β2 · Contrast_ihs
             + γ' · Forward_ihs
             + δ' · X_is
             + ε_ihs
```

where

- `accept_ihs` = 1 iff this specific hand's own offer was the one accepted;
- `Elapsed_ihs` = live + safe tasks completed so far in the sequence, as of that hand's own offer position (`pause`);
- `Contrast_ihs` = (live tasks passed) − (safe tasks passed) as of the same moment, the composition regressor;
- `λ_(L,pause,p)` = a full set of fixed effects for the cell (that hand's length × its own offer position × its disclosed end-probability) — the offer-level analogue of WT_D's `(L,lp,p)` cell (§3.2's note explains why `pause` replaces `lp` here: there is only ever one decision point per hand, at `pause` itself, not a range of task-level positions within an open window), and what makes `Contrast` exogenous;
- `Forward_ihs` = expected further main tasks from that hand's own offer, the alternative's length, their difference, the disclosed end-probability of that hand, live and safe tasks remaining in it;
- `α_i` = participant fixed effects;
- `X_is` = sequence index, whether this is the unannounced bonus sequence, and the sequence's reward.

Estimated as a linear probability model, with a logit reported as a robustness check. Standard errors clustered at the participant level throughout.

- **A1** tests `γ` on `E[remaining] − alt_duration` > 0.
- **A2** tests `β1 < 0`.
- **A3** tests `β2 ≠ 0`.

`Elapsed` and `Contrast` together span live-passed and safe-passed, so equation (1) is a reparameterization of entering both counts separately. We report the count parameterization alongside, since the composition coefficient is easier to read there:

**Equation (1′)**

```
accept_ihs = α_i + λ_(L,pause,p) + β_A · ActivePassed_ihs + β_I · InactivePassed_ihs
             + γ' · Forward_ihs + δ' · X_is + ε_ihs
```

with A2 as `β_A + β_I < 0` and A3 as `β_A ≠ β_I`.

**Multiple offers per sequence.** Because every hand whose own offer fires contributes a row, a participant can appear more than once per sequence in this panel (once accepting, or as many times as they had non-wasted offers if they never accepted). This is intentional — it is the source of the "switched after continuing" contrast in `outcome_summary` (Part I §31/§35(iii)) — but it means a sequence stops contributing rows the moment one offer is accepted (every later hand in that sequence, if any, is in the alternative phase, not the main run, and never draws a fresh offer). Sequences where the sequence ends naturally, or is forfeited, with every fired offer refused contribute all of their fired-offer rows, each with `accept_ihs = 0`.

### 5.2 Hand renewal (A4)

**Equation (2)**

```
accept_ihs = α_i + λ_(L,pause,p)
             + β_cur · ElapsedCurrentHand_ihs + β_prev · ElapsedPreviousHands_ihs
             + β2 · Contrast_ihs + γ' · Forward_ihs + δ' · X_is + ε_ihs
```

`ElapsedCurrentHand_ihs` is that hand's own `pause` (fixed at generation, not a choice); `ElapsedPreviousHands_ihs` is the sum of live and safe tasks accumulated over every earlier, fully-survived hand of the same sequence. A4 tests `|β_prev| < |β_cur|`.

### 5.3 Sequence-level switching and duration

**Equation (3)** — sequence-level linear probability model of `switch_taken`:

```
switch_is = α + Σ_r θ_r · Regime_ir + η · Frame_i + γ' · Forward_is + δ' · X_is + ε_is
```

with `Forward_is` evaluated at the first hand's offer. Regime 2 is the omitted reference. Unaffected by the WT_E mechanic change: `switch_taken` is still exactly one binary per sequence, however many hand-level offers preceded it.

**Equation (4)** — duration. A discrete-time complementary log-log hazard of leaving the main run (by switching or forfeiting), with a flexible baseline in position, treating natural endings and cap-bound sequences as right-censored. Reported alongside a Cox model as a robustness check. **Note on the risk set (WT_E-specific):** exit by switching is only possible at the specific main-phase tasks that are some hand's own offer position, never in between; exit by forfeiting remains possible at any task. The hazard's covariate set therefore differs by exit route at each task — at a non-offer task only the forfeit route is live, at an offer task both are — and the baseline hazard is estimated allowing for this discontinuity (a task-varying risk set) rather than assuming a smooth hazard throughout, which was a closer approximation under WT_D's persistent-offer window.

### 5.4 Regime comparisons, given the length confound

Raw between-regime differences in switching conflate the informational manipulation with the different sequence-length distributions each regime induces (Part I §35(i)). We therefore pre-specify:

1. **Descriptive, always reported:** unconditional switch rates, forfeit rates, realized lengths, hands per sequence, cap-bind rates, and offers-fired-per-sequence, by arm. These are reported as design realization, not as the treatment effect.
2. **Primary regime estimate:** equation (1) with the `(L, pause, p)` cell fixed effects and the full forward-looking vector, so regime contrasts are read at a held-fixed decision state. B1 and B2 are tested here.
3. **Cleanest regime estimate:** B3, within Regime 0 participants with participant fixed effects, where the placement rule varies hand to hand within person and no between-arm length difference can contaminate it. We pre-register B3 as the contrast we will lead with if B2 and B3 disagree.
4. **Wasted offers:** hands whose offer never fired contribute no decision and are excluded from equations (1) and (2). Since this exclusion is non-random (it selects short hands) and concentrated in Regime 3, we report the exclusion rate by arm, and re-estimate B1 on the subsample of hands long enough that an offer could not have been wasted.

## 6. Covariates, balance, and pre-specified controls

**Balance.** We regress each of the following on the regime and framing indicators and report the coefficients: age band (if collected), education, employment status, log labour income, household size, ends-meet (now), risk, patience, geolocated country, device type, and time of day at consent. We additionally regress the treatment indicators on the full covariate vector jointly and report an F-test. Randomization is by browser PRNG at consent and cannot be manipulated, so we expect balance; we report it regardless, and if any covariate is imbalanced at the 5% level we add the imbalanced covariates as controls and report both specifications.

**Controls.** All specifications include the covariates named in `X`. We do not data-mine the control set: any specification not listed in §5 is labelled exploratory.

## 7. Multiple hypothesis testing

Within Family A (A1–A4) and within Family B (B1–B4) separately, we report unadjusted p-values alongside sharpened two-stage q-values controlling the false discovery rate at 0.05 (Benjamini, Krieger & Yekutieli 2006; Anderson 2008). Family C is exploratory and reported without adjustment, labelled as such throughout. Where a hypothesis is tested in more than one specification, the adjustment uses the pre-specified primary specification only.

## 8. Exclusions

Applied in this order, with counts reported at each step:

1. `demo_mode > 0` — internal testing sessions.
2. Sessions where the `?regime=` override was used.
3. Participants who did not complete all five sequences (see §9 on attrition).
4. Sequences with `is_latest_attempt = 0` — superseded attempts abandoned by a new-session reload. Retained for the §9 attrition analysis and outcome C6, excluded from all primary analyses.
5. Offer-level observations from hands whose offer never fired (Regime 3 only), which carry no decision.

**Attention.** We do *not* exclude on the `no_activity` flag or on grid accuracy in the primary specification: failing to find every target is a performance measure, not an attention failure, and the no-activity screen already interrupts and holds the participant until acknowledged. We report primary results excluding participants who triggered the no-activity screen more than three times as a robustness check, and pre-commit to reporting both regardless of which is more favourable.

**Speeding and duplicates.** Prolific IDs are unique by construction and the backend is keyed on them, so a participant cannot complete the study twice. Participants completing the whole study faster than the mechanical minimum implied by their own task count (7 s per task, no offer pauses) are impossible by design; we report the realized duration distribution as a data-quality check.

## 9. Attrition

Attrition is a genuine risk in an online study of this length, and dropout is plausibly correlated with sequence length, which is itself correlated with regime. We estimate

**Equation (5)**

```
Complete_i = π0 + π1' · Regime_i + π2 · Frame_i + Π' · X_i + ε_i
```

If any element of `π1` or `π2` is significant at the 5% level, we report Lee (2009) bounds on the primary treatment effects in addition to the point estimates. We additionally report attrition timing: the sequence index and within-sequence position at which non-completers stopped, and whether non-completers had systematically longer sequences up to that point.

Because the backend records a full resume snapshot on every sequence completion and every 25 seconds, partial data are retained for participants who abandon the study, which makes this analysis possible rather than notional.

## 10. Robustness

1. Logit and complementary log-log alternatives to the linear probability model.
2. Dropping the `(L, pause, p)` saturation in favour of flexible polynomial controls, to show the composition result is not an artefact of the cell definition.
3. Restricting to the first hand of each sequence, where no earlier-hand sunk time exists.
4. Restricting to sequences where the first hand's offer opened at position 0, removing across-hand offer-position variation entirely (within a single hand there already is none — see §3.2).
5. Excluding cap-bound sequences.
6. Clustering at the sequence level and two-way clustering by participant and sequence index.
7. Estimating equation (1) separately by sequence index, to show the result is not driven by early sequences before participants understood the mechanic.

## 11. Known limitations, recorded before data collection

1. **The regime manipulation is not length-neutral** (Part I §35(i)). Regime 2 generates sequences roughly 50% longer than Regime 1. All regime comparisons condition on the decision state, and B3 — the within-participant contrast under Regime 0 — is the cleanest available test.
2. **Offer timing is informative in every arm** (Part I §35(ii)), because the offer must land inside its own hand. This is inherent to "the offer arrives during a hand" with hands this short. It is documented rather than removed; removing it would require offers placed outside the hand structure, which would change what the participant is told.
3. **The alternative's length is drawn close to indifference.** The gap between the alternative and the expected remaining main tasks has mean 0 and SD only 0.96 tasks, with the alternative shorter in 46.7% of sequences. This is by construction — it keeps switching a genuine choice — but it leaves little exogenous variation for A1, which is the hypothesis with the least statistical headroom. **[DECISION 3]** flags widening this before launch.
4. **Regime 3 loses 21.2% of sequences' offers**, so its effective sample for switch decisions is smaller than nominal and selected toward shorter hands.
5. **The hand cap is undisclosed**, so cap-bound sequences (1.5%–6.4% by arm) are right-censored in a way participants cannot anticipate. They are flagged in the data and excluded in robustness check 5.
6. **Single online session, modest stakes.** Mean total payment is approximately £3.30 for approximately 20 minutes. Sunk-time effects at these stakes need not generalize to larger commitments.
7. **(WT_E-specific) The identification strategy moved from a task-level hazard to a much sparser offer-level panel** (≈10 decision points per participant instead of ≈40 — Part I §39/§42). This is a direct consequence of the mechanic change (the offer no longer stays open across multiple tasks), not a design choice made for power reasons, and it is the reason the power table in §12/Part I §42 is not yet populated — see **[DECISION 7]**.
8. **(WT_E-specific) An explicit refusal cannot be told apart from letting the countdown run out.** Both "Refuse and stay" and a timeout call the same `decide('continue')` with no separate flag or timestamp recorded for which one happened (Part I §32/index.html's `decide()`). Any analysis of *active* rejection versus passive inattention within an offer window is therefore not possible with the current instrument; only acceptance versus non-acceptance is identified.
9. **(WT_E-specific) Missing an offer window is more consequential than in WT_D.** Because the alternative no longer stays available for the rest of the hand, a participant who is briefly away from the keyboard (or simply slow to read the offer) when a hand's own window closes loses that specific chance outright, with no visual difference on screen between "actively refused" and "timed out" (limitation 8). This raises the stakes of ordinary inattention relative to the WT_D design without necessarily being a confound for the sunk-time hypotheses themselves, since inattention is not expected to correlate with the sunk-time state at the moment the window opened.

## 12. Power — derivation

**Sequence-level, between-participant.** With `m = 5` sequences per participant and intra-participant correlation ρ, the design effect is `1 + (m−1)ρ`. For a pairwise regime contrast at N participants there are `N/4` participants and `5N/4` sequence observations per arm, giving `n_eff = (5N/4) / (1 + 4ρ)`. With a base switch rate `p = 0.40`, `MDE = 2.80 × sqrt(2p(1−p)/n_eff)`. For the horizon framing there are two arms rather than four, so `n_eff` doubles.

**Offer-level, within-participant (WT_E — supersedes the WT_D task-level derivation).** The WT_D draft this document was forked from computed `n_eff` from a task-level panel (simulation of 4,000 participants gave 158,358 task-level decision observations, 39.6 per participant, with the composition regressor's residual SD after conditioning on `(L, lp, p)` at 1.736 tasks and a base hazard of 0.06 per task). None of those figures apply to the offer-level panel `accept_ihs` is built from (Part II §5.1): the unit of analysis, the conditioning cell (`(L, pause, p)`, not `(L, lp, p)`), the residual variance of the composition contrast at that cell, and the base accept rate (plausibly ≈0.20–0.25 per offer, not 0.06 per task — see Part I §42) are all different quantities that require their own simulation of the offer-level generation process before an MDE table can be reported. The formula shape is otherwise the same, with `n_eff = n̄_offers × N / (1 + (n̄_offers − 1)ρ)` for `n̄_offers ≈ 10` fired offers per participant (Part I §39) in place of the old 39.6.

**[DECISION 7]: this simulation has not yet been run, so no offer-level MDE table is reported in Part I §42 or here.** It must be completed, and the target N reconsidered in light of it, before this document is registered. We will additionally re-run it on the pilot **[DECISION 6]** together with the sequence-level rate, and revise the target N *before* the main launch if realized rates differ materially, recording the revision as a registry amendment.

## 13. Data, code, and deviations

The instrument is a single self-contained HTML file; the backend is a Google Apps Script writing to three sheets (`Meta`, one row per participant; `Responses`, one row per participant × sequence × attempt; `Hands`, one row per participant × sequence × attempt × hand — new in WT_E's fork, see README §9). Column-level documentation is in `README.md` §9. All generative logic — hand parameters, placement regimes, expected-length computation — lives in `index.html` and is reproduced in Part I §29 of this document. `pauseSecs`, the runtime draw of each fired offer's own accept/refuse window length, is WT_E-only and is not part of the generative logic reproduced in §29's code blocks (it is drawn at the moment the offer screen opens, not at hand-generation time) — see the note appended to §29.

The simulated design moments quoted throughout were produced by evaluating the instrument's own generation functions headlessly (600,000 sequences per regime arm for the length and leak tables; 20,000 participants for the session-duration and regressor-variation figures). They are properties of the shipped code, not of a separate model of it. The generative process these draw on (hand length, live/safe marks, `pInside`, regime placement of `pause`) is identical between WT_D and WT_E, so these figures carry over unchanged. The one WT_D simulation that does **not** carry over is the 4,000-participant task-level identification run (39.6 decision points/participant, residual SD 1.736) — it evaluated a task-level panel that no longer exists in this build; see **[DECISION 7]** for the offer-level replacement still to be run.

Any deviation from this plan will be reported in the paper with the reason and the date it was decided, and any change made after data collection begins will be filed as a registry amendment with a timestamp.

---

## 14. Pre-launch decisions required

| # | Decision | Why it matters | Recommendation |
|---|---|---|---|
| **1** | **Task-completion pay is computed and logged but never paid.** `grid_pay` (£0.025 per task) is written to every row, but the results screen pays only `training bonus + Σ section bonuses − Σ penalties`, plus the fixed £1.50 show-up fee. `README.md` §8 states this pay is "reflected in the final results screen"; it is not. | Participants are underpaid relative to the documented design by ≈£1.23 on average, and the registered payment structure must match what is actually paid. | Decide whether to pay it. If yes, add `Σ grid_pay` to the results-screen total before launch. If no, remove the claim from `README.md` and drop it from the payment description here. |
| **2** | **Regime is confounded with realized length** (mean main run 8.35 to 12.51 tasks across arms; cap-bind 1.45% to 6.41%). | Raw regime comparisons are not interpretable as the informational treatment effect. | Keep the design, register the §5.4 conditional strategy, and lead with B3 (within-participant, Regime 0). Alternatively equalize lengths across arms, which would require changing the generative rule and re-simulating. |
| **3** | **The alternative sits very close to indifference** (gap SD 0.96 tasks). | A1 — the check that participants respond to incentives at all — has the least headroom of any hypothesis. | Consider widening the alternative's support (`alt_width`, currently the mean hand length of 5.5) to roughly double, which would raise the gap SD toward 2 tasks at modest cost to the ~50/50 switching balance. |
| **4** | Prolific screening: countries, approval-rate and prior-submission filters, and whether prior WT-build participants are excluded. | Determines the registry's Country field and the sample's external validity. | Exclude anyone who took an earlier WT build; they have seen a different hand structure. |
| **5** | Which supporting documents are public at registration. | Publishing `index.html` at registration reveals the hidden generative parameters to any participant who looks. | Withhold instrument and README until the trial is marked complete; publish the consent text immediately. |
| **6** | Pilot: whether to run one, and at what N. | The power table assumes a 0.40 sequence-level switch rate and a base offer-level accept rate that has not itself been simulated yet (Part I §42/**[DECISION 7]**). Neither is yet observed empirically. | Run 60–100 participants, check both rates and the completion rate, then finalize N and register. |
| **7** | **The offer-level power calculation has not been run.** WT_D's task-level MDE table (39.6 decision points/participant, residual SD 1.736, base hazard 0.06/task) does not carry over to WT_E's offer-level panel (≈10 decision points/participant, different conditioning cell, unknown residual SD and base rate) — Part I §42, Part II §12. | Without it, the target N in §40/§41 is provisional, and the design may be underpowered for A2/A3 at the recommended N = 1,600 given the roughly 4x fewer decision points per participant. | Simulate the offer-level accept panel (same headless-evaluation approach as the existing design-moment simulations, §13) before finalizing N; increase N or add sequences per participant if the resulting MDE is unacceptably wide. |
| **8** | **An explicit "Refuse and stay" click cannot be distinguished from a countdown timeout** in the data as currently logged (`decide('continue')` is identical either way — Part I §32, §11 limitation 8). | Blocks any analysis of active rejection versus passive inattention; also affects how to interpret A2/A3 for offers that were technically "not accepted" but never actively engaged with. | Decide whether this distinction is worth instrumenting (a one-line change to `decide()`/the button `onclick`s to log which path fired) before launch, or whether to accept the limitation as registered in §11. |

---

## References

Anderson, M. L. 2008. "Multiple Inference and Gender Differences in the Effects of Early Intervention." *Journal of the American Statistical Association* 103(484): 1481–1495.

Benjamini, Y., A. M. Krieger, and D. Yekutieli. 2006. "Adaptive Linear Step-up Procedures That Control the False Discovery Rate." *Biometrika* 93(3): 491–507.

Dohmen, T., A. Falk, D. Huffman, U. Sunde, J. Schupp, and G. G. Wagner. 2011. "Individual Risk Attitudes: Measurement, Determinants, and Behavioral Consequences." *Journal of the European Economic Association* 9(3): 522–550.

Falk, A., A. Becker, T. Dohmen, D. Huffman, and U. Sunde. 2016. "The Preference Survey Module: A Validated Instrument for Measuring Risk, Time, and Social Preferences." IZA Discussion Paper 9674.

Lee, D. S. 2009. "Training, Wages, and Sample Selection: Estimating Sharp Bounds on Treatment Effects." *Review of Economic Studies* 76(3): 1071–1102.

Sweis, B. M., S. V. Abram, B. J. Schmidt, K. D. Seeland, A. W. MacDonald, M. J. Thomas, and A. D. Redish. 2018. "Sensitivity to 'Sunk Costs' in Mice, Rats, and Humans." *Science* 361(6398): 178–181.
