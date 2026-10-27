# Preregistration — *The Value of Wasted Time* (WT_K)

**Study title:** The Value of Wasted Time: Sunk Time, Survived Risk, and Abandonment under Duration Uncertainty
**Build:** WT_K
**Principal Investigator:** Michele Cantarella — IMT School for Advanced Studies Lucca — michele.cantarella@imtlucca.it
**Platform:** Prolific (recruitment) · GitHub Pages (delivery) · Google Sheets + Apps Script (data)
**Ethics:** Joint Ethical Committee of Scuola Superiore Sant'Anna / Scuola Normale Superiore / IMT Lucca — approval N. 23/2026, 30 April 2026
**Document version:** 1.0 · **status: draft, not yet submitted**

---

## 0. How to use this document

Part I maps onto the fields of the [AEA RCT Registry](https://www.socialscienceregistry.org/), in the registry's order. Part II is the pre-analysis plan, to be uploaded as the registry's **Analysis Plan** attachment (numbered hypotheses, explicit estimating equations, sharpened q-values, Lee bounds for attrition).

Fields marked **[PLACEHOLDER]** need a value; **[HIDDEN]** fields go into the registry's hidden variant (private until the trial is complete); **[DECISION]** items are collected in §14 and must be settled before registering. All simulated figures below were produced by running the instrument's own generation code (`index.html`).

---

# Part I — AEA RCT Registry fields

## Trial Information

**1. Trial Title** — The Value of Wasted Time: Sunk Time, Survived Risk, and Abandonment under Duration Uncertainty

**6. Country** — United Kingdom; United States *(to match the Prolific screening actually used —* **[DECISION 2]***)*

**7. Region** — Online sample; no sub-national targeting.

**8. Primary Investigator** — Michele Cantarella, IMT School for Advanced Studies Lucca.

**10. Status** — In development.

**11. Keywords** — Labor

**12. Additional Keywords** — sunk cost, sunk time, partial progress, optimal stopping, abandonment, duration uncertainty, outside option, choice, real-effort task, online experiment, time use

**13. JEL Codes** — D81, D91, D83, C91, J22

**15. Abstract**

> How do we value the time we have lost? We investigate the role of the sunk cost fallacy in labor supply decisions using data from a real-effort experiment. Participants work through sequences of tasks shown as cards; a sequence ends when three winning cards, hidden among the cards marked orange, have been found. At a random point, participants are offered an alternative of known length that pays the same reward, which randomizes the time they have already spent, how much of it was spent on cards that could have been winning ones, and how much progress they have made towards the three winning cards. Our results focus on four margins. First, we study how sunk time, its composition and partial progress affect switching and giving up. Second, we study whether having chosen the sequence oneself, rather than having it assigned, makes people stick with it. Third, we analyze how failures and successes in previous sequences affect behavior in subsequent ones. Finally, we study intertemporal substitution by randomizing whether participants believe the session contains four or five sequences.

**16. External Link(s)** — **[PLACEHOLDER]** (GitHub Pages URL of the instrument)

**17. External Link Description** — Live experimental instrument (single-page application, full source in `index.html`).

## Dates

**18. Trial Start Date** — **[PLACEHOLDER]** · **19. Intervention Start Date** — **[PLACEHOLDER]** · **20. Intervention End Date** — **[PLACEHOLDER]** · **21. Trial End Date** — **[PLACEHOLDER]**

## Experimental Details

### 28. Intervention (Public)

Participants complete five sequences of a real-effort task in a single online session of about 20 minutes. The task ("card") is a 3×3 grid of emoji revealed progressively over 4.5 s; the participant clicks every instance of a target emoji before a 2.5 s countdown auto-submits (about 7 s per card). Each error costs £0.01 but never stops the sequence.

Each sequence is a stack of cards, all visible from the start, each marked orange or white. Three of the orange cards are winning cards; every orange card is equally likely to be one of them, and white cards never are. The sequence ends when the third winning card is found, which pays the sequence's reward. Above the cards, three empty slots fill with a gold star as each winning card is found. No probability is shown: participants see only the cards.

Before each sequence, the participant sees its reward and either the next deck of cards or two or three decks to choose from; the deck chosen is the one played.

At a random card, the participant is offered an **alternative sequence** of a stated, fixed number of cards at the same reward; its length is revealed only at this moment. The task pauses for 10–30 seconds, and the participant can switch then, or at any later card, with a button. Switching restarts progress on the alternative's cards and cannot be undone. A participant may give up a sequence at any time, losing its reward but not other earnings. At the end of every sequence, all participants are shown the whole sequence: the cards they completed, where the three winning cards were and, if they took the alternative, its cards.

Within each sequence, the pattern of orange and white cards, the winning cards, the moment of the offer, the length of the alternative and the reward are drawn at random, so the time already spent when the offer comes, its split between orange and white cards, and the number of winning cards already found are random. The number of decks shown before a sequence (one, two or three) is also drawn at random for each sequence. Across participants, half are told the study has four sequences and half five; all play five, and those told four receive the fifth as an unannounced bonus. Separately, the rule that places the offer relative to the winning cards (the placement regime) varies across participants as a robustness check.

### 29. Intervention (Hidden) **[HIDDEN]**

*Withhold until the trial is complete: this section describes how sequences are generated, which participants are not told.*

**What participants know.** Participants see every card of the sequence and its colour from the start, and the reward. They are told that each sequence has three winning cards, that they are orange cards, and that every orange card is equally likely to be one of them. When the alternative is offered, they see how many cards it has. They are told that at the end of each sequence they will be shown where the winning cards were. They are not told how the cards, the moment of the offer or the length of the alternative are chosen, how the decks they choose between are built, nor that the sequence-count framing and the placement regimes exist. Every benchmark in the analysis (the number of cards expected to remain until the third winning card, the time expected to be saved by switching) is computed from what participants know, and nothing else: given the winning cards already found, the remaining ones are equally likely to be any set of the orange cards still ahead.

**The cards.** A sequence is made of two sections of 7–12 cards each, joined directly. First, the share of orange cards in the whole sequence is drawn, between 35% and 50%. Then each section gets its own density of orange cards, the same for every card in that section, chosen so that a given share of the orange cards falls in the left section. That share goes from 10% to 90%; so that every participant sees the whole range, it is split into five bands (10–25%, 30–40%, 45–55%, 60–70%, 75–90%), and each participant gets one sequence from each band, in random order. Each card is then orange or white independently, so orange cards are scattered within each section, and the sequence is redrawn until the realised share falls inside its band and each section has at least two orange cards. The first card is never orange and the last card is always orange, so a sequence has 14–24 cards (20 in the median). Because the winning cards are equally likely to be any orange cards, a section with more orange cards is more likely to hold them: participants can see this directly from the cards.

Because the colours are drawn at random, two participants at the same point of similar sequences can have completed different numbers of orange and white cards. This is what allows us to separate the effect of time spent on orange cards from time spent on white cards.

**The winning cards and the offer.** The three winning cards are a set of three orange cards, every set equally likely. The offer comes after a random number of completed cards, from zero (before the first card) to halfway between the second and the third winning card, every number in that range equally likely. On average this places the offer close to the first winning card, so that when the offer arrives the participant has found no winning card about half the time, one about a third of the time, and two about a fifth of the time. Since the offer's position is random, so are the time already spent and the progress already made when the participant first faces the choice. A sequence is drawn again if, at the offer, the end of the main sequence would already be certain (as many orange cards left as winning cards still to find), so that staying is always a gamble.

**Length of the alternative.** When the offer is drawn, one of three scenarios is picked at random, with zero, one or two winning cards already found; the alternative is the number of cards a participant would expect to need, from that point, to find the remaining winning cards in that scenario, rounded. The scenario matching the number actually found is picked with probability 70% if none has been found, 50% if one has and 60% if two have; the other two scenarios share the rest equally. These weights make switching save time in expectation in about half of the offers, and keep the alternative's length only weakly informative about progress. The alternative is always longer than the longest stretch of white cards in the sequence and than the best possible outcome of staying, and always shorter than the worst (completing the whole sequence). Once shown, its length does not change.

**Deck choice.** Before each sequence, one, two or three decks are shown, each number equally likely, as strips of orange and white cards in random order. One of them is the deck the sequence would have had anyway (the default). The others are drawn separately and kept only if they are much worse: in expectation, at least four more cards, and at least 25% more, before the third winning card (in the median, 1.36 times as many; in under 1% of cases, where the default is already very long, at least two more). Each deck is drawn to scale: a bar as wide as the longest possible deck (30 cards), so a shorter deck visibly ends sooner. With one deck, the screen simply shows the next deck. The deck chosen is played, with its own winning cards, offer and alternative.

**Reward.** Each participant has a total reward between £1.00 and £1.50, drawn at random and split at random across the five sequences, with at least £0.10 per sequence. A sequence's reward is unrelated to anything else about that sequence and is shown before it starts.

**Sequence-count framing.** Half of the participants, chosen at random, are told the study has four sequences, and half five. Everyone plays five; for those told four, the fifth is introduced only when it starts, as a bonus. Nothing else about the sequences changes. Participants told four believe that their fourth sequence is the last: if they plan their time over the session, they have no reason to save time for later in that sequence, and the unexpected fifth sequence shows whether that change is undone once more time becomes available.

**Placement regimes.** The simplest design would place the offer and the winning cards independently of each other. But then, whenever all three winning cards come before the offer, the sequence ends with no offer and no decision to observe. To avoid this, most participants get one of two rules that guarantee the offer appears. Each participant is assigned to one of four placement regimes:

| Regime | How it works | Does the moment of the offer reveal anything about the ending? | Does the offer always appear? |
|---|---|---|---|
| 1 | The winning cards are placed first, then the offer by the rule above | Somewhat: the offer's range depends on where the winning cards are | Yes |
| 2 | The offer is placed first, from the same rule averaged over all possible winning cards, then the winning cards, taking into account that the sequence was not over before the offer | No | Yes |
| 3 | Offer (as in regime 2) and winning cards are placed independently | No | Almost: if all three winning cards come first, the sequence ends with no offer (about 4% of sequences) |
| Mixed | Each sequence uses regime 1 or regime 2 at random | Varies from sequence to sequence | Yes |

The regimes are a robustness check: the main results should not depend on which regime generated the data. Regime 3 is used in the main study only, not in the pilots.

### 30. Primary Outcomes (end points)

1. **Switching at the offer**: whether the participant switches to the alternative while the task is paused at the offer. One observation per sequence in which the offer appeared.
2. **Switching after the offer**: whether the participant switches at a given later card, among those still in the main sequence. One observation per card after the offer.
3. **Switching at any point**: whether the participant switches to the alternative at any point before the main sequence ends. One observation per sequence.
4. **Giving up**: whether the participant gives up the sequence, losing its reward. One observation per sequence.

### 31. Primary Outcomes (explanation)

All four come from the per-sequence records described in the data dictionary. For every card at which a participant could decide, we can reconstruct exactly what they saw: how many orange and white cards they had completed, how many winning cards they had found, the orange and white cards still ahead, and the alternative's length. From this we compute the number of cards expected to remain until the third winning card and, comparing it with the alternative's length, the time saved, or lost, by switching in expectation.

The time already spent in a sequence, and its split into orange and white cards, enters none of these comparisons. A participant who decides only on what lies ahead should not respond to it. The number of winning cards already found matters only through what lies ahead (fewer winning cards left to find), which the benchmarks capture.

### 32. Secondary Outcomes (end points)

1. Deck choice: whether the participant chooses the default deck when two or three are offered, and the time spent choosing.
2. When participants switch: the card at which they switch, and whether they switch at the offer or later.
3. Deliberation: how long the pause lasted before the participant switched, resumed or let it run out; how often they opened the switch confirmation and then kept going; time taken to confirm a switch.
4. Effort and attention on the grid task: targets found, wrong clicks, missed targets, penalties, cards with no activity.
5. Giving up across the session: how many sequences are given up, and when the first one is.
6. Reloads: sequences restarted after the participant left and came back.
7. Risk tolerance and patience (self-reported, 0–10) and the background covariates in §33.

### 33. Secondary Outcomes (explanation)

Before the training, a two-screen survey asks about education, employment, monthly labour income (if employed), marital status, household size, whether other people contribute to household expenses, and how easily the household makes ends meet now, a year ago and a year from now. Approximate location and device type are recorded at consent. If a participant leaves in the middle of a sequence and returns in a new session, that sequence is redrawn, so nobody can learn how a sequence ends by leaving and coming back; the abandoned attempt is kept in the data and flagged.

### 34. Experimental Design (Public)

Each participant plays five sequences. Within each sequence, the pattern of orange and white cards, the winning cards, the moment of the offer, the length of the alternative, the reward and the number of decks shown before it are drawn at random, independently for every sequence. This within-participant variation is the core of the design: it makes random the time already spent when the offer comes, its split between orange and white cards, the number of winning cards already found, and whether the participant chose the deck or was simply given it.

At the end of every sequence, all participants are shown the whole sequence, including where the three winning cards were. This tells them what would have happened had they chosen differently, and is announced in the training.

Two features are randomized across participants, independently of each other and once for the whole session:

- **Sequence-count framing (2 arms, 50/50).** Participants are told the study has four or five sequences. All play five; those told four receive the fifth as an unannounced bonus.
- **Placement regime (4 arms, equal probability).** The rule that places the offer relative to the winning cards. This is a robustness check. The pilots use three of the four regimes.

After consent and the survey, a sixteen-step walkthrough on the real task screen explains the grid task, orange and white cards, the three winning cards and the slots that track them, the offer, the alternative and the choice of deck. It ends with three comprehension questions that must be answered correctly to continue; wrong answers are recorded. The walkthrough is not paid.

### 35. Experimental Design (Hidden) **[HIDDEN]**

Simulated with the instrument's own code, 12,000 sequences per regime:

| | Mixed | Regime 1 | Regime 2 | Regime 3 |
|---|---|---|---|---|
| Sequences with no offer | 0 | 0 | 0 | 4–5% |
| Average cards completed when the offer comes | 5.6 | 5.6 | 5.6 | 5.5 |
| Card on which the third winning card comes (median) | 17 | 16 | 17 | 17 |
| Average length of the alternative (cards) | 10.1 | 10.0 | 10.1 | 10.2 |
| Offers where switching saves time on average | 49% | 49% | 49% | 50% |
| Offers where switching beats staying with the long outcomes weighted less (geometric mean) | 49% | 48% | 49% | 50% |

At the offer, no winning card has been found in about 48% of offers, one in 32% and two in 20%. Because the alternative is based on the actual scenario only part of the time, switching saves time in expectation in about 63% of offers made before any winning card is found, 47% after one, and 13% after two.

On average, switching at the offer saves about 0.5 cards (standard deviation about 2.2), so the choice is close enough to call. The difference between orange and white cards completed at the offer has a standard deviation of about 2.5 cards, and about 1.6 cards after holding fixed the length of the sequence, its band and the moment of the offer.

Deck choice: one, two and three decks are each shown before about a third of sequences.

Two differences between regimes are known in advance and recorded here:

1. **Under regime 1 the moment of the offer carries some information**: the offer's range depends on where the winning cards are, so a later offer is weak evidence that they are later. Measured as the difference between the cards that actually remain at the offer and those a participant would expect, this is about −0.6 cards under regime 1 and zero under regimes 2 and 3.
2. **Regime 3 loses about 4% of offers**, because all three winning cards came first. Those sequences carry no offer decision and drop out of the analysis of the offer.

### 36. Randomization Method

Randomization is done by the participant's browser at consent and recorded immediately: the framing by a fair coin, the regime with equal probability over the four, the order of the five bands by a random shuffle. All three are saved and restored if the page is reloaded. The number of decks, and everything else about a sequence, is drawn when the session's sequences are generated. A testing option can force a regime through the study link; sessions that use it are identifiable and excluded.

### 37. Randomization Unit — Individual participant (framing, regime); sequence within participant (number of decks, and everything about the sequence).

### 38. Was the treatment clustered? — No.

### 39. Planned Number of Clusters — Not applicable. Standard errors are nonetheless clustered by participant, since each participant contributes five sequences.

### 40. Planned Total Number of Observations — **[PLACEHOLDER — recommended 1,600 participants]**: about 8,000 sequences and 7,900 offer decisions; the analysis of switching after the offer adds card-level observations for every offer that is not taken.

### 41. Sample Size by Treatment Arms

With 1,600 participants: 800 per framing arm; 400 per placement regime; 200 per combination. About 2,700 sequences each with one, two and three decks.

### 42. Power Calculation

80% power, 5% two-sided test, standard errors clustered by participant, within-participant correlation 0.3 (derivation in Part II §12). With 1,600 participants:

- **Sunk time and its composition:** an effect of about 1.3 percentage points on the probability of switching at the offer, per card of difference between orange and white cards completed.
- **Partial progress:** about 3.5 percentage points per winning card already found.
- **Chosen versus assigned deck:** about 3 percentage points in switching between sequences played on a chosen deck and on an assigned one.
- **Previous sequences:** about 4.5 percentage points between participants whose previous choice turned out, once revealed, to have been the wrong one and those whose choice turned out right.
- **Sequence-count framing:** about 7 percentage points in switching in the fourth sequence between participants told four and those told five.

**[DECISION 5]**: confirm these figures by simulating participants' behaviour on the instrument's own draws, and recompute them with the pilot's rates.

## Institutional Review Board

**43.** Yes · **44.** Joint Ethical Committee of Scuola Superiore Sant'Anna, Scuola Normale Superiore, and IMT School for Advanced Studies Lucca · **45.** 2026-04-30 · **46.** N. 23/2026

## Docs & Materials

| Document | Type | Public at registration? |
|---|---|---|
| Experiment source code | Survey Instrument | **[DECISION 3]**: recommend withholding until complete |
| Technical documentation, data dictionary, server code | Other | Withhold until complete |
| Consent form text | IRB Protocol | Public |
| Part II of this document | Analysis Plan | **[DECISION 3]** |

---

# Part II — Pre-Analysis Plan

## 1. Motivation

Someone who has spent time on an unfinished task and is offered a different way to reach the same reward should compare only the time each option still requires. Time already spent should play no role. The robust empirical finding is that it does.

This study goes further in three ways. First, not all time spent is alike. Some of it is spent under a real chance that the task would move forward (an orange card that could have been a winning one and was not); some on steps that could never have done so (white cards). Under a **survived-risk** account, orange cards are near-misses that make people feel invested; under a **dead-time** account, white cards are pure waste, and it is that waste that keeps people going. Second, a task can be partly done: with three winning cards to find, participants can be one or two steps closer to the end, and partial progress may bind people to a task beyond what it is worth. Third, people may stick more with a course of action they chose than with one they were given. The design separates all three because the colours of the cards, the winning cards, the moment of the offer and whether a choice of deck was offered are random and, given what lies ahead, irrelevant to a forward-looking participant.

The study also asks how what happened in earlier sequences, which participants see in full at the end of each one, affects later choices, and whether participants plan their time across the session, by changing how many sequences they believe are left.

## 2. Design summary

Each participant plays five sequences of 14–24 orange and white cards, each with three winning cards among the orange ones. Before each sequence the participant sees one deck, or chooses among two or three. Once per sequence, at a random card, an alternative of known length is offered at the same reward; the participant can take it then or at any later card. At the end of each sequence the whole sequence is revealed. Across participants, half are told there are four sequences and half five; the rule placing the offer relative to the winning cards (placement regime) also varies, as a robustness check. Details in Part I §28–29 and §34–35.

## 3. Identification

### 3.1 What participants see can be reconstructed exactly

At every card the participant sees the whole pattern, which cards are done, how many winning cards they have found and, once offered, the length of the alternative. All of this is recorded, so we can compute what a forward-looking participant would do at every decision point, using only that information.

### 3.2 What varies at random

At any decision point, the cards already completed split into orange and white at random, and the number of winning cards already found is random too. We always control for what lies ahead (the cards expected to remain until the third winning card, the alternative's length, the time expected to be saved by switching, and the orange and white cards still ahead), so that the orange and white cards already completed, and the winning cards already found, capture only their own effect.

The effect of time already spent as such comes from the random moment of the offer: in similar sequences, some participants face the offer before any card and others after more than ten. In the analysis of later switching, it also comes from the cards completed after the offer, compared at the same situation ahead.

### 3.3 Chosen versus assigned decks

Whether a sequence is preceded by a choice of decks is drawn at random for each sequence. The deck actually played is the default one in most cases (the alternatives are much worse), and it is drawn in exactly the same way whether or not other decks are shown. Comparing sequences played on the default deck after a choice with sequences played on a deck that was simply assigned therefore isolates the effect of having chosen.

### 3.4 Previous sequences

Every sequence is drawn independently of the previous ones. What happened in the previous sequence (how long it took, whether the reward was earned, and whether the reveal showed the participant's choice to have been the right one) is therefore unrelated to what the next sequence offers, and its effect on the next choice can be estimated holding the next sequence's situation fixed.

### 3.5 What the placement regimes are for

They check that the results do not depend on how the offer was placed: in particular, that participants are not guessing the ending from the moment of the offer, which is possible, weakly, only under regime 1.

## 4. Hypotheses

Four confirmatory families, one for each margin of the study, with multiple testing controlled within each family (§7), and a set of exploratory analyses.

### Family A — Sunk time, its composition and partial progress

> **A1 (participants respond to what lies ahead).** The more time switching is expected to save, the more likely participants are to switch, at the offer and afterwards.

This is a check on the design: if A1 fails, the other hypotheses cannot be interpreted, and we report that and stop.

> **A2 (sunk time).** Holding fixed what lies ahead, the more cards a participant has already completed, the less likely they are to switch.

> **A3 (composition of sunk time).** Holding fixed what lies ahead and the number of cards completed, switching depends on how many of those cards were orange rather than white. Tested in both directions: if white cards make participants less likely to switch, time that could never have paid off binds more (dead time); if orange cards do, near-misses bind more (survived risk).

> **A4 (partial progress).** Holding fixed what lies ahead and the cards completed, the more winning cards a participant has already found, the less likely they are to switch.

### Family B — Chosen versus assigned decks

> **B1 (choice).** Participants are less likely to switch, and to give up, in sequences played on a deck they chose than in sequences played on a deck they were given, holding fixed what lies ahead.

> **B2 (choosing a worse deck).** When a participant chooses a deck other than the default, their switching responds less to the time expected to be saved than when they choose the default. Tested in either direction.

### Family C — Previous sequences

> **C1 (time spent).** The number of cards completed in the previous sequence affects switching in the next one, holding the next sequence's situation fixed.

> **C2 (revealed outcome).** Participants whose previous choice turned out, once the sequence was revealed, to have been the wrong one (they switched and the third winning card would have come soon, or they stayed and it came late) switch differently in the next sequence from those whose choice turned out right.

Both are tested in either direction.

### Family D — Planning time across the session

> **D1 (believed last sequence).** In the fourth sequence, participants told there are four sequences switch and give up at different rates from participants told there are five.

> **D2 (unexpected extra sequence).** For participants told four, behaviour in the unannounced fifth sequence differs from their behaviour in the fourth.

### Exploratory analyses (reported as such, without multiple-testing adjustment)

How often participants choose the default deck, and how this changes across the session; how the effects in Family A vary with risk tolerance, patience, labour income and how easily the household makes ends meet; whether partial progress matters more just after a winning card is found; how long participants deliberate during the pause, and whether this depends on how close the two options are; learning over the five sequences; whether switching is more likely at the offer than at later cards in the same situation; and behaviour after reloads.

## 5. Estimating equations

Participant *i*, sequence *s*. Linear probability models, with logit as a robustness check; standard errors clustered by participant throughout.

### 5.1 Switching at the offer (Families A and B)

For sequences in which the offer appeared:

**Equation (1)**
```
Switch_is = α_i + λ_(b) + β_E · Done_is + β_C · (Orange − White)_is + β_W · Found_is + β_K · Chosen_is + γ' · Ahead_is + δ' · X_is + ε_is
```
- `Done`: cards completed when the offer comes; `Orange − White`: the difference between orange and white cards among them; `Found`: winning cards already found.
- `Chosen`: the deck was chosen among two or three (versus shown alone).
- `Ahead`: the time expected to be saved by switching, the cards expected to remain until the third winning card, the alternative's length, and the orange and white cards still ahead.
- `λ_(b)`: one indicator per band; `α_i`: one indicator per participant.
- `X`: position of the sequence in the session, reward, sequence length, framing arm and regime (the last two only when participant indicators are dropped).

A1: the coefficient on the time saved by switching is positive. A2: β_E < 0. A3: β_C ≠ 0. A4: β_W < 0. B1: β_K < 0.

**Equation (1′)**: the same with the numbers of orange and white cards completed entered separately (A2: their sum is negative; A3: they differ).

**Equation (1″)**: B1 restricted to sequences played on the default deck, so that the deck played is drawn identically with and without a choice.

**Equation (1‴)**: B2, adding to equation (1) an indicator for a non-default deck chosen and its interaction with the time expected to be saved.

### 5.2 Switching after the offer (Families A and B)

One observation per card after the offer at which the participant was still in the main sequence and could switch, until they switch, find the third winning card or give up:

**Equation (2)**
```
Switch_ist = α_i + μ_(t) + λ_(b) + β_E · Done_ist + β_C · (Orange − White)_ist + β_W · Found_ist + β_K · Chosen_is + γ' · Ahead_ist + δ' · X_is + ε_ist
```
with everything updated at card *t* and `μ` one indicator for each number of cards since the offer. Same tests as (1).

### 5.3 Giving up and switching at any point

**Equation (3)**: as equation (1), for y = switched at any point and y = gave up, with the variables measured at the offer. A discrete-time model of leaving the main sequence card by card, by switching or by giving up, is reported alongside.

### 5.4 Previous sequences (Family C)

For sequences 2–5, equation (1) with two additional terms describing the previous sequence: the cards completed in it (C1), and an indicator for a previous choice that the reveal showed to have been wrong (C2), controlling for whether the previous reward was earned. The same terms are added to equation (2).

### 5.5 Framing (Family D)

**Equation (4)**
```
y_is = α_s + θ · Told4_i × Seq4_s + η · Told4_i + γ' · Ahead_is + δ' · X_is + ε_is
```
over sequences 1–4, for y = switched at the offer, switched at any point, gave up. `α_s`: one indicator per sequence position. D1: θ ≠ 0. D2: among participants told four, the difference between the fifth and fourth sequences, against the same difference among participants told five.

## 6. Balance and controls

We regress education, employment, log labour income, household size, ends-meet (now), risk tolerance, patience, country, device type and time of day on the framing and regime indicators and report joint F-tests, and we check that the number of decks shown is unrelated to the sequence's band and position. Any covariate imbalanced at 5% is added as a control, and both specifications are reported. Controls are those named in §5; anything else is exploratory.

## 7. Multiple testing

Within each family (A1–A4, B1–B2, C1–C2, D1–D2) we report unadjusted p-values and sharpened q-values controlling the false discovery rate at 5% (Benjamini, Krieger and Yekutieli 2006; Anderson 2008), using the main specification of each hypothesis (equation (1) for Families A and B, §5.4 for Family C, equation (4) for Family D). Exploratory analyses and robustness checks are not adjusted.

## 8. Exclusions

In order, reporting the number excluded at each step:
1. Internal test sessions.
2. Sessions in which the regime was forced through the study link.
3. Participants who did not complete all five sequences (see §9).
4. Attempts discarded because the participant left mid-sequence and returned in a new session (kept for the reload analysis).
5. From the analysis of the offer and of later switching: sequences in which the offer never appeared.

No participant is excluded for inattention or poor accuracy in the main specification. As a robustness check, we exclude those who triggered the inactivity warning more than three times.

## 9. Attrition

**Equation (5)** `Complete_i = π0 + π1' · Regime_i + π2 · Told4_i + Π' · X_i + ε_i`. If the framing or the regimes significantly affect completion at 5%, we report Lee (2009) bounds on the main effects. We also report where non-completers stopped. Progress is saved every 25 seconds and at the end of every sequence, so partial data exist for those who leave.

## 10. Robustness

**Placement regimes.**
1. Equations (1) and (2) estimated separately by regime, and with regime indicators interacted with the variables of Families A and B.
2. Whether, holding fixed what participants see, switching after a late offer differs between regime 1 and regimes 2 and 3.
3. Families A and B excluding regime 1, and with regime 3 only.
4. Within the mixed regime, comparing sequences placed by rule 1 and rule 2 for the same participant.

**Other.**
5. Logit and complementary log-log versions.
6. Smooth functions of sequence length, band and cards completed instead of indicators.
7. Separate effects for one and for two winning cards already found.
8. Clustering by sequence position as well as by participant.
9. Equations (1)–(2) separately by sequence position.
10. Excluding pauses that ran out without an active choice.
11. Using the geometric-mean comparison of the two options in place of the expected time saved.
12. Controlling for the scenario on which the alternative was centred.

## 11. Known limitations, recorded before data collection

1. **Under regime 1 the moment of the offer is weakly informative** about where the winning cards are.
2. **Regime 3 loses about 4% of offers.**
3. **The alternative is based on the actual number of winning cards found only part of the time** (70%, 50% or 60% of offers with zero, one or two found), and on one of the other two scenarios otherwise. This keeps its length only weakly informative about progress, but makes switching more attractive before any winning card is found (63% of offers) than after two (13%). The time expected to be saved is always controlled for.
4. **Decks that are not the default are much worse by construction**, so few participants are expected to choose them; the main comparison for B1 is therefore between the default deck chosen and the default deck assigned.
5. **The alternative's length is fixed once offered**, so switching later is mechanically less attractive than switching at once in the same situation; the variables describing what lies ahead account for this.
6. **The reward varies across sequences** (from £0.10, in £0.05 steps, the five summing to £1.00–£1.50), independently of everything else; it enters as a control.
7. **Revealing each sequence at the end** may change how participants approach the next one. This is part of what Family C studies, and it applies equally to every participant.
8. **Single online session, modest stakes**: a bonus of at most £1.50 plus a £1.25 show-up fee, for about 20 minutes. The pilots do not include regime 3.

## 12. Power: derivation

For a coefficient on a continuous variable, the minimum detectable effect is 2.80 × SD(outcome) / (residual SD of the variable × √n), where n is the effective number of observations. With about 4.9 offers per participant and within-participant correlation ρ = 0.3, n = 4.9 × N / (1 + 3.9 ρ) ≈ 3,600 at N = 1,600, and SD(outcome) = 0.46 (a switching rate of 30% at the offer).

**Composition.** Residual SD of the orange–white difference 1.6 cards: about 1.3 percentage points per card.

**Partial progress.** Residual SD of the number of winning cards found about 0.6: about 3.5 percentage points per winning card.

**Chosen versus assigned deck.** About a third of sequences are played on an assigned deck; with the comparison made within participant, 2.80 × 0.46 × √(1/2,700 + 1/5,300) ≈ 3 percentage points.

**Previous sequences.** Four transitions per participant (n ≈ 3,370) and an indicator equal to one in about 40% of cases (SD 0.49): about 4.5 percentage points.

**Framing.** Two arms of 800, one observation each in the fourth sequence, switching rate 40%: 2.80 × √(2 × 0.4 × 0.6 / 800) ≈ 7 percentage points. Using the first three sequences as a baseline (equation (4)) adds precision.

**[DECISION 5]**: replace these approximations with a simulation of participants' behaviour on the instrument's own draws, and recompute them with the pilot's rates (**[DECISION 4]**) before fixing N. Any revision after data collection begins is filed as an amendment.

## 13. Data, code and deviations

The experiment runs in the browser and saves to two tables: one row per participant (survey answers, framing, regime, payments) and one row per sequence (everything drawn for that sequence, the decks shown and chosen, and every choice made in it). Variable names and definitions are in the data dictionary. All the rules that generate sequences are in the experiment's source code and are described in words in Part I §29. The figures in this document were produced by running that code. Deviations will be reported with their reason and date, and filed as amendments once data collection has begun.

## 14. Pre-launch decisions required

| # | Decision | Why it matters | Recommendation |
|---|---|---|---|
| **1** | **Per-card pay is recorded but not paid.** Each card is worth £0.025 in the data, but participants are paid only the sequence rewards net of penalties, plus the £1.25 show-up fee. | The registered payment structure must match what is paid. | Decide whether to pay it; if not, drop it from the payment description. |
| **2** | Prolific screening: countries, approval rate, exclusion of earlier participants. | Registry country field; external validity. | Exclude anyone who took part in an earlier version of this task. |
| **3** | Which documents are public at registration. | The source code reveals how sequences are generated. | Withhold the code and documentation until complete; publish the consent text. |
| **4** | Pilot: whether and with how many participants. | The switching, giving-up and deck-choice rates used for power are assumed, not observed. | 60–100 participants, then fix N and register. |
| **5** | Power by simulation. | §12 uses analytic approximations. | Simulate before fixing N. |
| **6** | **Server deployment.** The address of the data server is still a placeholder in the code. | No data is saved until it is set. | Deploy and test end to end in test mode before the pilot. |

---

## References

Anderson, M. L. 2008. "Multiple Inference and Gender Differences in the Effects of Early Intervention." *JASA* 103(484): 1481–1495.
Benjamini, Y., A. M. Krieger, and D. Yekutieli. 2006. "Adaptive Linear Step-up Procedures That Control the False Discovery Rate." *Biometrika* 93(3): 491–507.
Dohmen, T., A. Falk, D. Huffman, U. Sunde, J. Schupp, and G. G. Wagner. 2011. "Individual Risk Attitudes: Measurement, Determinants, and Behavioral Consequences." *JEEA* 9(3): 522–550.
Falk, A., A. Becker, T. Dohmen, D. Huffman, and U. Sunde. 2016. "The Preference Survey Module." IZA DP 9674.
Lee, D. S. 2009. "Training, Wages, and Sample Selection: Estimating Sharp Bounds on Treatment Effects." *REStud* 76(3): 1071–1102.
Sweis, B. M., et al. 2018. "Sensitivity to 'Sunk Costs' in Mice, Rats, and Humans." *Science* 361(6398): 178–181.
