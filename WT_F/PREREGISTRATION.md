# Preregistration — *The Value of Wasted Time* (WT_F)

**Study title:** The Value of Wasted Time: Sunk Time, Survived Risk, and Abandonment under Duration Uncertainty
**Build:** WT_F
**Principal Investigator:** Michele Cantarella — IMT School for Advanced Studies Lucca — michele.cantarella@imtlucca.it
**Platform:** Prolific (recruitment) · GitHub Pages (delivery) · Google Sheets + Apps Script (data)
**Ethics:** Joint Ethical Committee of Scuola Superiore Sant'Anna / Scuola Normale Superiore / IMT Lucca — approval N. 23/2026, 30 April 2026
**Document version:** 1.0 · **status: draft, not yet submitted**

---

## 0. How to use this document

Part I maps onto the fields of the [AEA RCT Registry](https://www.socialscienceregistry.org/), in the registry's order. Part II is the pre-analysis plan, to be uploaded as the registry's **Analysis Plan** attachment (numbered hypotheses, explicit estimating equations, sharpened q-values, Lee bounds for attrition).

Fields marked **[PLACEHOLDER]** need a value; **[HIDDEN]** fields go into the registry's hidden variant (private until the trial is complete); **[DECISION]** items are collected in §14 and must be settled before registering. All simulated figures below were produced by running the instrument's own generation code (`index.html`) headlessly.

---

# Part I — AEA RCT Registry fields

## Trial Information

**1. Trial Title** — The Value of Wasted Time: Sunk Time, Survived Risk, and Abandonment under Duration Uncertainty

**6. Country** — United Kingdom; United States *(to match the Prolific screening actually used —* **[DECISION 4]***)*

**7. Region** — Online sample; no sub-national targeting.

**8. Primary Investigator** — Michele Cantarella, IMT School for Advanced Studies Lucca.

**10. Status** — In development.

**11. Keywords** — Labor

**12. Additional Keywords** — sunk cost, sunk time, optimal stopping, abandonment, duration uncertainty, outside option, real-effort task, online experiment, time use, opportunity cost of time

**13. JEL Codes** — D81, D91, D83, C91, J22

**15. Abstract**

> Time already spent is sunk: someone deciding whether to abandon an uncertain task for a bounded alternative should compare only the expected time still required with the alternative's length, never the time already elapsed. This experiment tests that prediction and asks whether it matters *what kind* of time was spent.
>
> Participants recruited on Prolific complete five sequences of a short real-effort grid task. Each sequence is a visible stack of 10–15 cards. Every card is independently marked either **orange** (it may be the winning card) or **white** (it cannot be); the last card is always orange. The probability that the sequence contains the winning card (10–90%) is disclosed before it starts. Finding the winning card ends the sequence and pays its reward. At a random point during the sequence, an **alternative** sequence of known length is offered at the same reward; its length is revealed only then. The participant can accept on the spot or refuse, and after that the alternative stays available at every later card. If the participant reaches the last card without finding the winning card, they are moved onto the alternative automatically and still earn the reward by completing it; only giving up loses it. The alternative's end is drawn so that taking it the moment it is offered always finishes after the main sequence's last card: staying is a gamble between finishing earlier (the winning card is still ahead) and later (the rest of the sequence plus the alternative).
>
> Because orange and white marks are independent coin flips, two participants who have completed the same number of cards, in sequences of the same length and probability, can differ in how much of that time was spent under genuine risk of finishing ("survived risk") versus on cards that could never have finished it ("dead time"). Both are equally sunk and normatively irrelevant. This orthogonal variation is the study's central identifying feature.
>
> Randomization is at the individual level: one of four **placement regimes** governing the joint draw of the offer's position and the sequence's ending, and one of two **horizon framings** (told the study has four or five sequences; all complete five). Primary outcomes are accepting the offer, the per-card hazard of switching after the offer, whether the participant switches at all in a sequence, and giving up. Planned sample: **[PLACEHOLDER — recommended N = 1,600, §12]** participants, each contributing five sequences, ≈4.7 offer decisions and ≈25 post-offer card-level decision points.

**16. External Link(s)** — **[PLACEHOLDER]** (GitHub Pages URL of the instrument)

**17. External Link Description** — Live experimental instrument (single-page application, full source in `index.html`).

## Dates

**18. Trial Start Date** — **[PLACEHOLDER]** · **19. Intervention Start Date** — **[PLACEHOLDER]** · **20. Intervention End Date** — **[PLACEHOLDER]** · **21. Trial End Date** — **[PLACEHOLDER]**

## Experimental Details

### 28. Intervention (Public)

Participants complete five sequences of a real-effort task in a single online session of about 20 minutes. The task ("card") is a 3×3 grid of emoji revealed progressively over 4.5 s; the participant clicks every instance of a target emoji before a 2.5 s countdown auto-submits (≈7 s per card). Each error costs £0.01 but never stops the sequence.

Each sequence is a stack of 10–15 cards, all visible from the start, each marked orange (it may be the winning card) or white (it cannot be), mixed at random; the last card is always orange. Before the sequence starts, the participant sees its reward and the probability (10–90%) that it contains the winning card; the probability stays on screen throughout. Finding the winning card ends the sequence and pays the reward.

At a random card, the participant is offered an **alternative sequence** of a stated, fixed number of cards at the same reward — its length is revealed only at this moment. An in-place banner offers "Accept and switch" / "Refuse and stay", with a confirmation step, for a countdown of 10–45 s; no choice before the countdown ends means staying. Whether refused or not, from then on the alternative remains available: a button lets the participant switch at any later card, again with a confirmation. Switching restarts progress on the alternative's cards and cannot be undone. If the participant reaches the end of the sequence without finding the winning card, they are moved onto the alternative automatically and earn the reward by completing it. A participant may give up a sequence at any time, losing its reward but not other earnings.

The interventions are two individual-level randomizations: a four-arm **placement regime** (how the offer's position is drawn jointly with the sequence's ending) and a two-arm **horizon framing** (told the study has four or five sequences).

### 29. Intervention (Hidden) **[HIDDEN]**

*Withhold until the trial is complete: this reveals generative parameters participants are not told.*

Per sequence:

```
L        ~ Uniform{10, …, 15}
orange[k] ~ Bernoulli(0.4) independently, k = 1 … L−1;   orange[L] = 1
pInside  = round( clamp( Normal(0.50, 0.20), 0.10, 0.90 ) × 20 ) / 20
```

`pInside` is **quintile-stratified**: a shuffled ordering of the five equal-mass quintiles of its distribution is fixed per participant at consent, and sequence *i* draws from quintile *i*, so every participant sees each quintile once, in random order. If the sequence contains the winning card, it is uniform over the orange cards.

The offer position `pause` (cards completed when the offer appears, 0 … L−1) is drawn from a Beta(2, 2) distribution over the sequence, discretised into one slice per card (`P(pause = k)` ∝ Beta(2,2) mass on [k/L, (k+1)/L]): offers are centred and rarely come at the very start or end. The four regimes govern the joint draw with the ending:

```
REGIME 1  ending drawn first, offer placed before it
  ends ~ Bernoulli(pInside);  if so endPos ~ Uniform(orange cards)
  pause ~ Beta-slices truncated to {0 … endPos−1}  if it ends;  on {0 … L−1} otherwise
REGIME 2  offer drawn first, ending conditional on surviving to it
  pause ~ Beta-slices on {0 … L−1}
  a = orange cards after pause;  W = all orange cards
  ends ~ Bernoulli( pInside·a/W / (pInside·a/W + 1 − pInside) );  if so endPos ~ Uniform(orange cards after pause)
REGIME 3  fully independent
  ends, endPos as Regime 1;  pause ~ Beta-slices on {0 … L−1}
  wasted = ends AND endPos ≤ pause   (the sequence is over before the offer point: no offer)
REGIME 0  per-sequence mixture: each sequence independently re-draws Regime 1 or 2 (never 3)
```

**Alternative.** Its end is drawn from a hidden window immediately after the main sequence, of the same length: `alt_global_end ~ Uniform{L+1, …, 2L}` (overall card count). The participant is shown `alt_duration = alt_global_end − pause` cards. Switching when offered therefore always ends after card L, whatever `pInside` is. The same `alt_duration` applies if the participant switches later or is moved onto the alternative automatically.

**Reward.** Each participant has a reward pool `reward_pool ~ Uniform{£1.00, £1.05, …, £1.50}`, drawn once at consent. It is split at random across the five sequences: each starts at £0.10 and the rest of the pool is handed out in £0.05 units, each to a uniformly random sequence, until the pool is used up. Sequence *i*'s reward `pay` is its share (≥ £0.10, mean £0.25). It is independent of the sequence's own draw and is shown before the sequence starts, next to `pInside`. The five rewards always sum to the pool, so the sequence rewards never exceed £1.50 per participant.

### 30. Primary Outcomes (end points)

1. **Offer accept** — binary, one per sequence whose offer appeared: accepted on the offer banner.
2. **Post-offer switch hazard** — binary, one observation per card position after the offer at which the participant was still in the main sequence (the button was available): switched at that card.
3. **`switch_taken`** — binary, one per sequence: switched voluntarily at any point (offer or button).
4. **`forfeit_taken`** — binary, one per sequence.

### 31. Primary Outcomes (explanation)

All four come from the `Responses` sheet (one row per participant × sequence × attempt). Outcome 1 is `offer_choice = 'accept'` among rows with `offer_wasted = 0`. Outcome 2 is built from each row's `pause`, `switch_source`, `switch_taken_at_task`, `n_main_tasks_done` and the card pattern: for every card position t from `pause` onward at which the participant was still in the main sequence and the offer banner had closed, y = 1 iff the button switch happened at t. The state at each decision point is fully reconstructable from the logged pattern (`live_pattern`), `pInside`, `L`, `pause` and `alt_duration`: orange and white cards already completed, orange and white cards left, the updated probability that the winning card is still ahead, and the expected further cards if staying (the instrument's own formula, logged at the offer as `p_ahead_at_pause` and `e_rem_at_pause`).

The sunk-time regressors are the orange cards and white cards already completed. Their sum is elapsed time; their difference is its composition. Neither enters a normatively correct decision rule.

### 32. Secondary Outcomes (end points)

1. Timing: `switch_taken_at_task`, `switch_source`, and switching on the button vs on the banner.
2. Deliberation: `deliberation_secs` (banner shown → resolved), `offer_undo_count`, `auto_refused` (countdown ran out with no choice), `auto_confirmed`, `alt_button_opens`/`alt_button_undos`, `switch_decision_secs`.
3. Real-effort performance and attention: `total_found`, `total_false_pos`, `total_missed`, `penalty`, per-card `no_activity`.
4. Abandonment across the session: sequences given up and the position of the first.
5. Reload behaviour: `seq_attempt > 1` rows.
6. Individual differences: risk (Dohmen et al. 2011) and patience (Falk et al. 2016), 0–10, and the covariates in §33.

### 33. Secondary Outcomes (explanation)

Covariates, from a two-screen survey before training: education, employment status, monthly labour income (if employed/self-employed), marital status, household size, whether others contribute to household expenses, the SOEP "able to make ends meet" scale for now / a year ago / a year ahead. IP-derived location and device type are collected at consent. A new-session reload mid-sequence redraws that sequence (so participants cannot learn a sequence by abandoning and returning); the abandoned attempt is logged as its own row (`is_latest_attempt = 0`).

### 34. Experimental Design (Public)

Between-subjects, two orthogonal individual-level randomizations, crossed, with a large within-subject component.

**Randomization A — placement regime (4 arms, equal probability):** (1) ending first, offer placed before it; (2) offer first, ending conditional on surviving to it; (3) both drawn independently, so the offer can fail to appear; (0) each sequence re-draws rule 1 or 2. Assigned at consent, fixed for all five sequences. (The pilot versions — `study_id` `pilot` and `studentpilot` — use arms 0–2 only; arm 3 is fielded in the main study.)

**Randomization B — horizon framing (2 arms, 50/50):** told the study has four or five sequences. All complete five; those told four receive the fifth as an unannounced bonus sequence.

**Within-subject:** each participant sees each quintile of the probability distribution once, in random order; lengths, patterns, offer positions, alternatives and rewards are redrawn every sequence.

After consent and the survey, a sixteen-step walkthrough on the real task screen teaches the grid task, orange and white cards, the probability, the offer, the persistent alternative button and the automatic move to the alternative, ending with a three-question comprehension check (progress gated; wrong answers counted). The walkthrough is not paid.

### 35. Experimental Design (Hidden) **[HIDDEN]**

Simulated design moments (15,000 sequences per arm):

| | P(winning card) | offer wasted | E[L] | E[alt_duration] | alt_minus_expected mean / SD | P(alternative shorter in expectation) | E[cards to reward, never switching] |
|---|---|---|---|---|---|---|---|
| Regime 0 | 0.46 | 0 | 12.5 | 14.0 | −0.04 / 3.9 | 0.56 | 18.0 |
| Regime 1 | 0.52 | 0 | 12.5 | 14.5 | 0.09 / 4.1 | 0.55 | 16.4 |
| Regime 2 | 0.40 | 0 | 12.5 | 13.4 | −0.23 / 3.7 | 0.58 | 19.4 |
| Regime 3 | 0.53 | 0.22 | 12.5 | 13.6 | −0.20 / 3.7 | 0.57 | 19.7 |

(`alt_minus_expected` = `alt_duration` minus the expected further cards if staying, at the offer.)

Three properties are not neutral across arms and are recorded here so the remedies are on record before data collection:

**(i) The chance of a winning card differs by arm** (0.40 under Regime 2, where surviving the offer point lowers it, vs ≈0.52 under Regimes 1 and 3), and with it the expected cards to the reward. Raw between-arm comparisons conflate the informational manipulation with this; §5.4 specifies the conditional comparison as primary.

**(ii) Under Regime 1 the offer's position is informative**: an offer can only come before the winning card, so a later offer signals a later (or no) winning card. Regimes 2 and 3 are flat in this respect.

**(iii) Regime 3 wastes 22% of offers** (the winning card came before the offer point). Those sequences carry no offer decision and are dropped from the offer and hazard panels, selecting on early endings; handled in §5.4 and §9.

The composition regressor at the offer (orange minus white cards completed) has SD ≈ 2.2–2.4 cards, of which 86–91% of the variance lies within cells of (L, pause, pInside).

### 36. Randomization Method

Client-side, in the participant's browser, at consent (`Math.random()`), recorded immediately with the consent timestamp. Regime uniform over four arms; framing an independent fair coin; quintile order a Fisher–Yates shuffle. All three are stored in the resume snapshot and restored on any reload. A `?regime=` URL override exists for testing only; it is inert without the parameter and such sessions are identifiable and excluded.

### 37. Randomization Unit — Individual participant.

### 38. Was the treatment clustered? — No.

### 39. Planned Number of Clusters — Not applicable. Standard errors are nonetheless clustered by participant, who contributes five sequences, ≈4.7 offer decisions and ≈25 post-offer card-level decision points.

### 40. Planned Total Number of Observations — **[PLACEHOLDER — recommended 1,600 participants]**: ≈8,000 sequences, ≈7,500 offer decisions, ≈40,000 post-offer card-level observations.

### 41. Sample Size by Treatment Arms

Recommended N = 1,600, cells in expectation: 200 per regime × framing cell; 400 per regime; 800 per framing arm. No pure control arm; Regime 2 (never wastes the offer, conditional ending recomputed at the offer) is the reference.

### 42. Power Calculation

80% power, α = 0.05 two-sided, clustered by participant (full derivation in Part II §12).

**Sequence-level switch rate** (base 0.40, 5 sequences per participant), single pairwise regime contrast:

| N | ρ = 0.30 | ρ = 0.50 |
|---|---|---|
| 1,200 | 7.4 pp | 8.7 pp |
| 1,600 | 6.4 pp | 7.5 pp |
| 2,000 | 5.8 pp | 6.7 pp |

**Horizon framing** (two arms): 4.6 pp (ρ = 0.30) to 5.3 pp (ρ = 0.50) at N = 1,600.

**Offer-level composition effect** (A3), analytic approximation: base accept rate 0.30 (SD 0.46), within-cell residual SD of the composition regressor 2.2 cards, 4.7 offers per participant, ρ = 0.30 → n_eff ≈ 2.2·N. At N = 1,600, MDE ≈ 1.0 pp per card of orange-minus-white imbalance (≈4 pp for a 4-card imbalance). This ignores the post-offer hazard panel, which adds power. **[DECISION 7]**: confirm by simulating a behavioural model on the instrument's own draws, and recompute after the pilot.

## Institutional Review Board

**43.** Yes · **44.** Joint Ethical Committee of Scuola Superiore Sant'Anna, Scuola Normale Superiore, and IMT School for Advanced Studies Lucca · **45.** 2026-04-30 · **46.** N. 23/2026

## Docs & Materials

| Document | Type | Public at registration? |
|---|---|---|
| `index.html` — instrument source | Survey Instrument | **[DECISION 5]** — recommend withholding until complete |
| `README.md`, `DATA_DICTIONARY.md`, `backend.txt` | Other | Withhold until complete |
| Consent form text | IRB Protocol | Public |
| Part II of this document | Analysis Plan | **[DECISION 5]** |

---

# Part II — Pre-Analysis Plan

## 1. Motivation

A decision-maker who has spent time on an unfinished task and is offered a bounded alternative with the same reward should compare only the expected time still required with the alternative's length. Time already spent enters neither side. The robust empirical finding is that it does anyway. This design targets one step further: elapsed time is not homogeneous. Some was spent under genuine risk that the task would end — cards that could have been the winning one and were not. Some was spent on cards that could never have ended it. Both are equally sunk. Under a **survived-risk** account, orange cards passed are near-misses the participant feels invested in; under a **dead-time** account, white cards are pure waste and it is that felt waste that binds. The design separates the two because orange/white marks are independent of everything a rational agent conditions on.

## 2. Design summary

Five sequences per participant; each is one visible stack of 10–15 orange/white cards, last card orange, with a disclosed probability that it contains the winning card. One offer per sequence at a Beta-centred random card; its length revealed only then; accept/refuse on a timed banner, and a persistent button afterwards. No winning card → moved onto the alternative automatically, reward kept. Two individual-level randomizations: placement regime (4 arms) and framing (2 arms). Details in Part I §28–29, §34–35.

## 3. Identification

### 3.1 The forward-looking state is observable

At any card the participant can see the whole pattern, which cards are done, `pInside`, `L`, and (once offered) the alternative's length. From the logged draw we reconstruct exactly this, and compute the rational benchmarks the instrument itself uses: the probability that the winning card is still ahead (conditioning on the orange cards already passed without winning), and the expected further cards if staying (winning card ahead, else the rest of the sequence plus the alternative). Nothing uses information the participant did not have.

### 3.2 The identifying variation

At a decision point with `e` cards completed, let A be the orange and I = e − A the white cards among them. Marks are independent coin flips, drawn independently of L, `pInside`, and — at the offer — of `pause` (Regimes 2 and 3 draw `pause` independently of the marks; under Regime 1 `pause` depends on the winning card's position, handled by the regime controls and robustness check 3). The split of `e` into (A, I) is therefore random conditional on (L, e, pInside). At the offer, 86–91% of the variance of A − I survives conditioning on (L, pause, pInside) cells.

Conditioning is not free: the forward-looking state depends on how many orange cards have passed (fewer orange cards ahead → lower chance the winning card is still ahead), so A − I and the forward state are correlated. Two remedies are pre-specified: (a) saturating on (L, e, pInside) cells, which holds the elapsed count fixed and leaves A − I as the only varying sunk term, with the forward-looking vector (which depends on A) controlled for; (b) the count parameterization with the forward-looking vector.

Sunk time itself (A2) is identified from variation in elapsed cards at a held-fixed forward-looking state: across offers, `pause` varies at given (L, pInside) independently of the pattern; in the hazard panel, elapsed cards vary within a sequence, with a flexible baseline in cards since the offer.

### 3.3 What the regimes identify

Whether the offer can fail to appear (Regime 3 only); whether the offer's position carries information about the ending (Regime 1 only); and, in Regime 0, the rule within participant.

## 4. Hypotheses

Two confirmatory families (multiplicity-controlled within family, §7) and one exploratory.

### Family A — sunk time (within-participant, primary)

> **A1 (responsiveness).** The probability of switching (at the offer, and per card afterwards) increases with the expected time saved by switching: the coefficient on (expected further cards if staying − alternative length) is strictly positive.

A design check: if A1 fails, the sunk-time hypotheses are uninterpretable; we report that and stop.

> **A2 (sunk time binds).** Conditional on the forward-looking state, the probability of switching decreases in cards already completed: the coefficient on elapsed cards is strictly negative.

> **A3 (composition of sunk time).** Conditional on the forward-looking state and on elapsed cards, switching depends on whether that time was spent on orange or white cards: the coefficient on the orange-minus-white contrast is non-zero (two-sided).
> **A3a (dead time):** white cards bind more — contrast coefficient positive. **A3b (survived risk):** orange cards bind more — negative. We report whichever obtains without claiming to have predicted it.

### Family B — regime and framing (between-participant, primary)

> **B1 (offer reliability).** Participants under Regime 3, for whom the offer sometimes never appears, accept it more readily when it does than participants under Regimes 1 and 2.

> **B2 (draw order).** Conditional on the forward-looking state, switching differs between Regime 1 and Regime 2.

> **B3 (within-participant placement).** Among Regime 0 participants, the sequence's own rule affects switching (participant fixed effects).

> **B4 (horizon framing).** Participants told there are four sequences behave differently in sequence 4 (their believed last) from those told five — in switching and in giving up — and there is a discontinuity at the unannounced sequence 5.

### Family C — exploratory (reported as such, no adjustment)

C1 Heterogeneity of A2/A3 by risk tolerance and patience. C2 By labour income and "ends meet" (opportunity cost of time). C3 Deliberation time on the banner as a function of closeness to indifference. C4 Learning across the five sequences. C5 Use of the disclosed probability: behaviour against the Bayesian benchmark as orange cards pass. C6 Offer salience: switching on the banner vs the per-card hazard on the button at the same state. C7 Contrast effects across contiguous sequences (change in `pInside`, alternative length, reward from the previous sequence). C8 Reloads (`seq_attempt > 1`).

## 5. Estimating equations

Participant *i*, sequence *s*; linear probability models, logit as robustness; standard errors clustered by participant throughout.

### 5.1 Offer decision

For sequences whose offer appeared (`offer_wasted = 0`):

**Equation (1)**
```
accept_is = α_i + λ_(L,p) + β_E · pause_is + β_C · Contrast_is + γ' · Forward_is + δ' · X_is + ε_is
```
- `Contrast` = orange − white cards completed at the offer; `pause` = elapsed cards;
- `Forward` = expected further cards if staying, alternative length, their difference, probability the winning card is still ahead, orange and white cards left;
- `λ_(L,p)` = length × probability cells; `α_i` participant fixed effects;
- `X` = sequence index, bonus-sequence indicator, reward, regime (when α_i is omitted).

A1: γ on (expected further − alternative) > 0. A2: β_E < 0. A3: β_C ≠ 0.

**Equation (1′)** — count parameterization: `β_A · Orange_is + β_I · White_is` in place of `β_E·pause + β_C·Contrast` (A2: β_A + β_I < 0; A3: β_A ≠ β_I).

**Equation (1″)** — A3 with saturated `λ_(L,pause,p)` cells (β_E absorbed).

### 5.2 Post-offer switch hazard

One row per card position t ≥ pause at which the participant was in the main sequence with the button available (from the card after the banner closed; the banner's own decision is equation (1)), until switching, the winning card, the automatic switch, or giving up:

**Equation (2)**
```
switch_ist = α_i + μ_(t − pause) + λ_(L,p) + β_E · Elapsed_ist + β_C · Contrast_ist + γ' · Forward_ist + δ' · X_is + ε_ist
```
with `Elapsed`, `Contrast` and `Forward` updated at card t (Forward uses the probability the winning card is still ahead given the orange cards passed so far), and `μ` a flexible baseline in cards since the offer. Same tests as (1). Sequences where the offer was accepted contribute no rows.

### 5.3 Sequence-level switching and giving up

**Equation (3)**
```
y_is = α + Σ_r θ_r · Regime_ir + η · Frame_i + γ' · Forward_is + δ' · X_is + ε_is
```
for y = `switch_taken` and y = `forfeit_taken`, Forward evaluated at the offer, Regime 2 omitted.

**Equation (4)** — competing-risks discrete-time hazard of leaving the main sequence by switching or by giving up, card by card, censored at the winning card or the automatic switch; Cox model as robustness. The switch route is only open from the offer on; the give-up route throughout.

### 5.4 Regime comparisons

1. **Descriptive, always reported:** raw switch, give-up, winning-card and automatic-switch rates, offers wasted, by arm — as design realization, not treatment effects.
2. **Primary:** equations (1) and (2) with arm indicators, at a held-fixed decision state (B1, B2).
3. **Cleanest:** B3, within Regime 0 with participant fixed effects; we lead with it if B2 and B3 disagree.
4. **Wasted offers:** excluded from (1) and (2); we report the exclusion rate by arm and re-estimate B1 on sequences whose winning card (if any) lies after the latest possible offer position.

## 6. Balance and controls

We regress education, employment, log labour income, household size, ends-meet (now), risk, patience, country, device type and time of day at consent on the arm indicators, and report a joint F-test. Any covariate imbalanced at 5% is added as a control, reporting both specifications. Controls are those named in §5; anything else is labelled exploratory.

## 7. Multiple testing

Within Family A (A1–A3) and Family B (B1–B4) separately: unadjusted p-values and sharpened two-stage q-values controlling the FDR at 0.05 (Benjamini, Krieger & Yekutieli 2006; Anderson 2008), using the primary specification only (equation (1) for A1–A3, with equation (2) reported alongside). Family C is exploratory.

## 8. Exclusions

In order, with counts at each step:
1. `demo_mode > 0` (internal testing).
2. Sessions using the `?regime=` override.
3. Participants who did not complete all five sequences (see §9).
4. Rows with `is_latest_attempt = 0` (kept for §9 and C8).
5. From equations (1)–(2): sequences whose offer never appeared.

No exclusion on the `no_activity` flag or grid accuracy in the primary specification; as a robustness check we exclude participants who triggered the no-activity screen more than three times, and report both.

## 9. Attrition

**Equation (5)** `Complete_i = π0 + π1'·Regime_i + π2·Frame_i + Π'·X_i + ε_i`. If any element of π1 or π2 is significant at 5%, we report Lee (2009) bounds on the primary effects. We also report where non-completers stopped. The instrument saves progress every 25 s and at every sequence end, so partial data exist for leavers.

## 10. Robustness

1. Logit and complementary log-log versions.
2. Flexible polynomials in L, pause and pInside instead of cells.
3. Excluding Regime 1 (informative offer position) from the A-family estimates.
4. Offers before the midpoint vs after.
5. Clustering by sequence, and two-way by participant and sequence index.
6. Equations (1)–(2) separately by sequence index.
7. Excluding offers resolved by the countdown (`auto_refused = 1`), i.e. keeping only active answers.

## 11. Known limitations, recorded before data collection

1. **The chance of a winning card differs by arm** (0.40 vs ≈0.52), so raw arm comparisons are not clean informational effects (§5.4).
2. **Regime 1's offer position is informative** about the ending.
3. **Regime 3 wastes 22% of offers**, selecting its effective sample toward later endings.
4. **Switching at the offer is never faster than finding the winning card**, by construction; this is what makes staying a genuine gamble and is disclosed only through the observed alternative length.
5. **The alternative's length is fixed once offered**; switching later restarts on the same number of cards, so later switches are mechanically less attractive than earlier ones at a given state — the forward-looking vector accounts for this.
6. **The reward varies across sequences** (£0.10 upward in £0.05 steps, the five summing to a per-participant pool of £1.00–£1.50), independently of the draw; it enters as a control. Because the five sum to the pool, a sequence's reward is mildly negatively correlated with the others' — but participants never see the pool or the split in advance.
7. **Single online session, modest stakes** (a bonus of at most £1.50 — the sum of the sequence rewards, net of penalties — plus a £1.50 show-up fee, for ≈20 minutes). Pilot evidence on the arms can't include Regime 3, which the pilots leave out.

## 12. Power — derivation

**Sequence level.** With m = 5 sequences and intra-participant correlation ρ, the design effect is 1 + (m−1)ρ. A pairwise regime contrast at N participants has N/4 participants and 5N/4 sequences per arm: n_eff = (5N/4)/(1+4ρ). With base rate p = 0.40, MDE = 2.80·√(2p(1−p)/n_eff). Framing: two arms, so n_eff doubles.

**Offer level.** MDE(β) = 2.80 · SD(y) / (SD_resid(Contrast) · √n_eff), with n_eff = m̄·N/(1+(m̄−1)ρ), m̄ = 4.7 offers per participant (share of wasted offers ≈ 5.5% averaged over arms), SD(y) = 0.46 (accept rate 0.30), SD_resid(Contrast) = 2.2 cards (within-cell, simulated). At N = 1,600 and ρ = 0.30: n_eff ≈ 3,560 and MDE ≈ 0.98 pp per card of imbalance. **[DECISION 7]**: replace with a simulation of a behavioural model on the instrument's own draws including the hazard panel, and re-run it on the pilot's realized rates **[DECISION 6]** before fixing N; any revision after data collection begins is filed as an amendment.

## 13. Data, code and deviations

The instrument is a single HTML file; the backend a Google Apps Script writing two sheets: `Meta` (one row per participant) and `Responses` (one row per participant × sequence × attempt — the sequence's draw, offer, switch and outcome on one row; see `DATA_DICTIONARY.md`). All generative logic lives in `index.html` and is reproduced in Part I §29. The design moments reported here were produced by running that code headlessly. Deviations will be reported with their reason and date, and filed as amendments once data collection has begun.

## 14. Pre-launch decisions required

| # | Decision | Why it matters | Recommendation |
|---|---|---|---|
| **1** | **Per-card pay is logged but not paid.** `grid_pay` (£0.025 per card) is written to every row, but the results screen pays only rewards − penalties, plus the fixed £1.50 show-up fee. | The registered payment structure must match what is paid. | Decide whether to pay it; if not, drop it from the payment description. |
| **2** | **Arms differ in the chance of a winning card** (0.40 vs ≈0.52). | Raw arm comparisons are not informational effects. | Keep; register §5.4 and lead with B3. |
| **3** | **Offer position distribution** (Beta(2,2), truncated before the ending in Regime 1). | Sets how much variation in elapsed time exists at the offer, and Regime 1's leak. | Keep, or flatten (Beta(1,1)) if the pilot shows too few early/late offers for A2. |
| **4** | Prolific screening: countries, approval rate, prior-participation exclusions. | Registry country field; external validity. | Exclude anyone who took part in an earlier version of this task. |
| **5** | Which documents are public at registration. | The source reveals hidden parameters. | Withhold instrument and README until complete; publish the consent text. |
| **6** | Pilot: whether and at what N. | Base rates (accept, switch, give-up) are assumed, not observed. | 60–100 participants, then finalize N and register. |
| **7** | Offer- and hazard-level power by simulation. | §12's figure is an analytic approximation. | Simulate before fixing N. |
| **8** | **Backend deployment.** `BACKEND_URL` in `index.html` is a placeholder; the script must be deployed on its own spreadsheet. | No data is saved until this is done. | Deploy and test end to end with `demomode=1` before the pilot. |

---

## References

Anderson, M. L. 2008. "Multiple Inference and Gender Differences in the Effects of Early Intervention." *JASA* 103(484): 1481–1495.
Benjamini, Y., A. M. Krieger, and D. Yekutieli. 2006. "Adaptive Linear Step-up Procedures That Control the False Discovery Rate." *Biometrika* 93(3): 491–507.
Dohmen, T., A. Falk, D. Huffman, U. Sunde, J. Schupp, and G. G. Wagner. 2011. "Individual Risk Attitudes: Measurement, Determinants, and Behavioral Consequences." *JEEA* 9(3): 522–550.
Falk, A., A. Becker, T. Dohmen, D. Huffman, and U. Sunde. 2016. "The Preference Survey Module." IZA DP 9674.
Lee, D. S. 2009. "Training, Wages, and Sample Selection: Estimating Sharp Bounds on Treatment Effects." *REStud* 76(3): 1071–1102.
Sweis, B. M., et al. 2018. "Sensitivity to 'Sunk Costs' in Mice, Rats, and Humans." *Science* 361(6398): 178–181.
