# Preregistration — *The Value of Wasted Time* (WT_S)

**Study title:** The Value of Wasted Time: Sunk Time, Missed Chances, and Abandonment under Duration Uncertainty
**Build:** WT_S
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

**1. Trial Title** — The Value of Wasted Time: Sunk Costs and Labor Supply under Uncertainty

**6. Country** — United Kingdom; United States *(to match the Prolific screening actually used —* **[DECISION 2]***)*

**7. Region** — Online sample; no sub-national targeting.

**8. Primary Investigator** — Michele Cantarella, IMT School for Advanced Studies Lucca.

**10. Status** — In development.

**11. Keywords** — Labor

**12. Additional Keywords** — sunk cost, sunk time, partial progress, optimal stopping, abandonment, duration uncertainty, outside option, choice bracketing, real-effort task, online experiment, time use

**13. JEL Codes** — D81, D91, D83, C91, J22

**15. Abstract**

> How do we value the time we have lost? We study the sunk cost fallacy in labor supply decisions with a real-effort experiment. Participants complete a sequence of tasks to find a winning card, hidden at random, and exert effort upfront to reduce the perceived cost of future search. At a random point, they receive an offer to switch to an alternative of known length, which randomizes the sunk costs they have accumulated depending on the upfront effort invested and on the apparent endowments they receive. We study three margins. First, how sunk time and its composition affect the decisions to switch and to give up. Second, how failures and successes in earlier sequences affect behavior in later ones. Third, whether participants respond differently to sunk costs when they believe later sequences can amortize the loss than when they believe a sequence is the last.

**16. External Link(s)** — **[PLACEHOLDER]** (GitHub Pages URL of the instrument)

**17. External Link Description** — Live experimental instrument (single-page application, full source in `index.html`).

## Dates

**18. Trial Start Date** — **[PLACEHOLDER]** · **19. Intervention Start Date** — **[PLACEHOLDER]** · **20. Intervention End Date** — **[PLACEHOLDER]** · **21. Trial End Date** — **[PLACEHOLDER]**

## Experimental Details

### 28. Intervention (Public)

Participants complete five sequences of a real-effort task in a single online session of about 20 minutes. The task ("card") is a 3×3 grid of emoji revealed progressively over 4.5 s; the participant clicks every instance of a target emoji before a 2.5 s countdown auto-submits (about 7 s per card). Each error costs £0.01 but never stops the sequence.

Each sequence is a deck of 12–32 cards, all visible from the start, each marked orange or white. A deck has one winning card, which can only be on an orange card, every orange card equally likely. Every card of the deck is locked and is opened with a key, one key per card, in order; keys are made by completing cards in a separate keys deck. Finding the winning card pays the sequence's reward.

Before each sequence, the participant sees its reward, the keys they start with (none in some sequences), and either the next deck or, in half of the sequences that involve keys, two or three decks to choose from; the deck chosen is the one played.

At a random card, the participant is offered an **alternative sequence** of a stated, fixed number of cards at the same reward, with no winning card to find and no keys needed; its length is revealed only at this moment. The task pauses for 10–30 seconds: the participant can switch with the alternative's button, unlock the deck's cards with its button, or make more keys with the keys' button; letting the countdown run out makes keys. From then on the participant can move between unlocking cards and making keys at any card, with the same two buttons. The cards are unlocked in order, one key each; when no key is left, a key is made first. Making a key while one is already in hand gains nothing and is recorded as inefficient time. The alternative remains available: the same button lets the participant switch at any later card. Switching restarts progress on the alternative's cards and cannot be undone. A participant may give up a sequence at any time, losing its reward but not other earnings. At the end of every sequence, all participants are shown the whole sequence: the cards they completed, where the winning card was and, if they took the alternative, its cards.

Within each sequence, the pattern of orange and white cards, the moment of the offer, the length of the alternative and the reward are drawn at random. Each sequence is played by four participants, in four versions that face the same choice at the offer and differ in the keys made before it and the keys received at the start. Across participants, half are told the study has four sequences and half five; all play five, and those told four receive the fifth as an unannounced bonus.

### 29. Intervention (Hidden) **[HIDDEN]**

*Withhold until the trial is complete: this section describes how sequences are generated and grouped, which participants are not told.*

**What participants know.** Participants see every card of the deck and its colour from the start, the reward and the keys they start with. They know that the deck has one winning card, that it can only be on an orange card and that every orange card is equally likely to hold it, and that each card is opened with a key, in order. When the alternative is offered, they see how many cards it has. They are told that the alternative remains available until the end, and that at the end of each sequence they will be shown where the winning card was. They are not told how the cards, the offer, the alternative or the decks to choose between are drawn, that sequences are played in four versions across participants, nor that the sequence-count framing exists. Every benchmark in the analysis (the number of cards expected to remain before the winning card is found, the time expected to be saved by switching) is computed from what participants know, and nothing else.

**The orange cards.** The chance that a card is orange decreases from card to card along a smooth curve, set so that the alternative stays about equally attractive whenever it is offered: for a participant still in the deck after any orange card found empty, the cards expected to remain before the winning card are about the same as at the moment of the offer (within 15%). The cards are drawn one at a time: each card is orange with its chance on the curve plus a correction for the orange cards drawn so far, so that a run of white cards is followed by more orange cards and the deck as a whole follows its curve, while long runs of either colour still happen at random. The strength of this correction is drawn for each sequence. The last card is always orange.

**Keys, and the offer.** The offer comes after the participant has made a number of keys (2, 4, 6, 8 or 10, equally likely) or, in some versions, at once (below). A key opens a card at the cost of one card of work instead of two (a key, then the card). On its own this would make the deck cheaper to finish. To remove it, every two keys held at the offer come with one extra white card at the front of the deck: opening an extra white card and the card after it costs two cards of work, exactly what a key and a card cost without keys. So every orange card costs the same to reach from the offer whether the participant holds keys or not: keys look like a discount, but are not one, and switching wastes them.

**Versions.** Every sequence is played by four participants:
- **Full**: the participant makes the keys before the offer; in one sequence in five, they also receive some keys at the start.
- **Mixed**: the participant receives some keys at the start and makes some more before the offer; how many of each is drawn at random, independently.
- **Truncated**: no keys and no extra white cards; the offer comes at the start. It is the baseline.
- **Truncated with gift**: the participant receives at the start all the keys the full version makes; in one sequence in five, they also make some keys before the offer, otherwise none and the offer comes at the start.

In the mixed version, the keys received are between a quarter and three quarters of the keys made in the full version, and the keys made between a quarter and all of them, drawn independently, their total even. The extra keys of the full version (received) and of the truncated version with gift (made) are at least one and at most the keys of the full version, drawn so that numbers close to none or to all of them are more frequent than numbers in between; the total is kept even. The four versions face exactly the same cards ahead, chance and alternative at the offer, and so the same choice. The full and the truncated versions differ in the keys made and held; the truncated version with gift holds the same keys as the full version without having made them; the mixed version varies the keys made and the keys held independently of each other. It also means that starting with keys does not tell a participant that the offer comes at once. Each participant plays each version once and one version a second time at random, in random order. When a participant starts, for each of their five sequences the study looks for a sequence whose required version is still to be played; if there is one, the participant plays it, otherwise a new sequence is drawn, played in the required version, and kept for later participants. A participant never plays two versions of the same sequence, and is never grouped twice with the same participant.

**Length of the alternative.** When the offer comes, staying (opening the next card that can be the winning one, then switching or not at every later card, as is best) is a gamble: few cards if the winning card comes soon, many if it does not. Three lengths of the alternative make staying and switching equally costly, depending on how the gamble is valued: by its geometric mean (long outcomes weighted less), its arithmetic mean (the fair value) and its quadratic mean (long outcomes weighted more), each with the switching rule that is best under that valuation. In half of the sequences the alternative is drawn between the geometric and the fair value, in the half of that range nearer the fair value, so that switching is the better option; in the other half between the fair and the quadratic value, in the half nearer the fair value, so that staying is better. It is rounded strictly on its side of the fair value and kept between 5 and 20 cards; a sequence is drawn again otherwise. Once shown, its length does not change: switching later means completing the same number of alternative cards.

**Deck choice.** Half of the sequences in the three versions with keys, at random, are preceded by a choice (never in the truncated version, which stays the baseline with no sunk cost of any kind): two or three decks, each number equally likely, shown as strips of orange and white cards in random order. All the decks shown are valid sequences in that version, taken from those still waiting for the version or newly drawn. The deck chosen is played; the decks not chosen go back to the pool. In earlier builds of this task, where only full versions had a choice, switching at the offer was lower after a choice (13–20 points, small samples).

**Reward.** Each participant has a total reward between £1.00 and £1.50, drawn at random and split at random across the five sequences, with at least £0.10 per sequence. A sequence's reward is unrelated to anything else about that sequence and is shown before it starts.

**Sequence-count framing.** Half of the participants, chosen at random, are told the study has four sequences, and half five. Everyone plays five; for those told four, the fifth is introduced only when it starts, as a bonus. Nothing else about the sequences changes. Each sequence pays only its own reward, so a loss in one sequence cannot actually be recovered in another; but participants who believe more sequences follow may treat a lost or risky sequence as something later ones can make up for. Those told four believe their fourth sequence is their last opportunity to earn in the study, and the unexpected fifth shows whether their behaviour changes back once another opportunity appears.

### 30. Primary Outcomes (end points)

1. **Switching at the offer**: whether the participant switches to the alternative while the task is paused at the offer. One observation per sequence.
2. **Switching after the offer**: whether the participant switches at a given later card, among those still in the main sequence. One observation per card after the offer.
3. **Switching at any point**: whether the participant switches to the alternative at any point before the main sequence ends. One observation per sequence.
4. **Giving up**: whether the participant gives up the sequence, losing its reward. One observation per sequence.

### 31. Primary Outcomes (explanation)

All four come from the per-sequence records described in the data dictionary. For every card at which a participant could decide, we can reconstruct exactly what they saw: the cards opened, the keys held, the orange and white cards still ahead and the alternative's length. From this we compute the number of main cards expected to remain if they stay, switching later or not as is best, and the number expected if they never switch. Comparing the first with the alternative's length gives the time saved, or lost, by switching in expectation.

The keys already made, and the keys held, enter none of these comparisons: by construction the four versions of a sequence have the same cards ahead at the offer. A participant who decides only on what lies ahead should not respond to them, and the four versions, which share everything ahead, should behave the same.

### 32. Secondary Outcomes (end points)

1. When participants switch: the card at which they switch, and whether they switch at the offer or later.
2. Deliberation: how long the pause lasted before the participant switched, unlocked or let it run out, and how much of it the browser tab was hidden; how often they opened the switch confirmation and then kept going; time taken to confirm a switch.
3. Keys left unused when the main sequence is left; keys made by choice after the offer while a key was already in hand (inefficient time, also when the next card to unlock was orange), and the time spent on them; how often the participant moves between unlocking and making keys; and the time spent on the keys deck, the main deck and the alternative before and after the offer.
4. Deck choice: which deck the participant chooses when two or three are offered, how often they change their selection, and the time spent choosing.
5. Effort and attention on the grid task: targets found, wrong clicks, missed targets, penalties, cards with no activity, time with the tab hidden.
6. Giving up across the session: how many sequences are given up, and when the first one is.
7. Reloads: sequences restarted after the participant left and came back.
8. Risk tolerance and patience (self-reported, 0–10) and the background covariates in §33.

### 33. Secondary Outcomes (explanation)

Before the training, a two-screen survey asks about education, employment, monthly labour income (if employed), marital status, household size, whether other people contribute to household expenses, and how easily the household makes ends meet now, a year ago and a year from now. Approximate location and device type are recorded at consent. If a participant leaves in the middle of a sequence and returns in a new session, that sequence is redrawn, so nobody can learn how a sequence ends by leaving and coming back; the abandoned attempt is kept in the data and flagged.

### 34. Experimental Design (Public)

Each participant plays five sequences. Within each sequence, the pattern of orange and white cards, the keys made before the offer, the length of the alternative and the reward are drawn at random, independently for every sequence. Every sequence is played in four versions by four participants: with keys made before the offer or not, and with keys received at the start or not. The comparison between the versions of the same sequence makes the keys made and the keys held random, while everything ahead is held fixed.

At the end of every sequence, all participants are shown the whole sequence: the cards they completed, where the winning card was and, if they took the alternative, its cards. This tells them what would have happened had they chosen differently, and is announced in the training.

Three features are randomized within participants, sequence by sequence: the version (each participant plays every version, one twice), whether some keys of the other kind are added in the full and the truncated-with-gift versions (one sequence in five), and whether a deck choice precedes the sequence (half of the sequences in the versions with keys). One is randomized across participants, once for the whole session:

- **Sequence-count framing (2 arms, 50/50).** Participants are told the study has four or five sequences. All play five; those told four receive the fifth as an unannounced bonus.

After consent and the survey, a walkthrough on the real task screen explains the grid task, the keys, orange and white cards, the winning card, the offer and the alternative. It ends with three comprehension questions that must be answered correctly to continue; wrong answers are recorded. The walkthrough is not paid.

### 35. Experimental Design (Hidden) **[HIDDEN]**

Simulated with the instrument's own code, 2,000 sequences:

| | |
|---|---|
| Length of the deck: full and truncated with gift / mixed / truncated | 16–30 / 15–32 / 12–26 cards |
| Length of the alternative: median (5th–95th percentile) | 13 (8–18) |
| Alternative relative to the fair value: median below / above | 0.89 / 1.15 |
| Offers where switching saves time on average | 50% |
| Sequences with the same choice at the offer in all four versions | 100% |

Because the alternative is set close to the fair value, the choice at the offer is close to call by construction: the alternative is on average 2 cards from the fair value. Participants are therefore not expected to all make the same decision, and small influences of the keys made and held can tip it.

The fair value is the length of the alternative at which switching and staying cost the same, when staying keeps the option of switching later: the best of the plans "check a few more orange cards, then switch if the winning card has not appeared", never switching included. It is therefore never above the effort expected from always staying, and equals it when checking a few cards and then switching never pays. The deck is built so that the effort expected from always staying stays about the same after each orange card found empty. The value of checking a few more cards and then switching, however, shrinks as the orange cards run out, so the fair value rises along the deck towards that effort (by 17% at the median before the last orange card). Since the alternative does not change once offered, switching becomes gradually more attractive the further the participant goes: in about three quarters of the sequences where staying is best at the offer, switching becomes best at some later point. No pattern of orange cards avoids this within the task's limits. Classifying a sequence as one where switching is better or worse therefore applies to the offer only; every later decision is compared with the best move at that point, which is recorded card by card.

In a simulation of 300 participants on the pooling code itself, with deck choices and 5% of sequences abandoned, 97% of the sequences played belonged to sequences completed in all four versions, and no participant played two versions of the same sequence.

### 36. Randomization Method

Randomization is done by the participant's browser at consent and recorded immediately: the framing by a fair coin. The version of each sequence is set by the grouping: each participant has one of each version and one at random, assigned to their five sequences in random order, and plays either a missing version of a sequence other participants have already played or a new sequence in the version required. Whether each sequence is preceded by a deck choice, and with how many decks (fair coins, in the versions with keys), and whether the full or truncated-with-gift version gets extra keys (one in five, and how many), are drawn at the same time. All are saved and restored if the page is reloaded.

### 37. Randomization Unit — Individual participant (framing); the sequence (version within a group of four, deck choice).

### 38. Was the treatment clustered? — No.

### 39. Planned Number of Clusters — Not applicable: no treatment is assigned to groups. The version of a sequence is assigned within groups of four, which are blocks (about 2,400), each containing all four versions. For inference, standard errors are clustered by participant (about 2,000; five sequences each).

### 40. Planned Total Number of Observations — **[PLACEHOLDER — recommended 2,000 participants]**: about 10,000 sequences and about 2,400 complete groups of four; the analysis of switching after the offer adds card-level observations for every offer that is not taken.

### 41. Sample Size by Treatment Arms

With 2,000 participants: 1,000 per framing arm; about 2,500 sequences in each version; about half of the sequences in each version with keys preceded by a deck choice, about 3,750 in all.

### 42. Power Calculation

By simulation, standard errors clustered by participant. We assume that about 20% of participants switch at the offer (in earlier builds of this task switching rose by about 2 points for every card switching was expected to save; applied to this design, this predicts 22%), and that each card of effort already spent lowers it by about 1 percentage point. With 2,000 participants, using every decision after the offer:

- **Sunk time (full versus truncated version of the same sequence):** an effect of this size (about 6 percentage points on average) is detected with near certainty.
- **Effort-free endowment (keys held without having made them):** a difference of about 3–3.5 percentage points (the full version's keys, received) is detected with 96–99% probability.
- **Earned versus received (the same keys, made or received):** a difference of about 2.5–3 percentage points is detected with 66–83% probability.
- **Deck choice (sequences with keys preceded by a choice versus not):** a difference of 3 percentage points is detected with 91% probability, one of 5 points with near certainty.

For the other margins, 80% power, 5% two-sided tests, within-participant correlation 0.1, the smallest detectable effects on the probability of switching at the offer are:

- **Previous sequences:** about 1.4–1.8 percentage points for every 10 cards completed in the previous sequence (B1), and about 3–3.5 points between participants whose previous choice turned out, once revealed, to have been the wrong one and those whose choice turned out right (B2).
- **Sequence-count framing:** about 5–6 percentage points in switching in the fourth sequence between participants told four and those told five (C2); about 7–8.5 points for the change from the fourth to the unannounced fifth sequence among those told four (C3); about 14–18 points for the difference in the effect of sunk time between the two framing arms in the fourth sequence (C1, which rests on one sequence per participant).
- **Deck choice:** about 2.5–3 percentage points between sequences with keys preceded by a choice and those with one deck shown (equation (1′)); earlier builds found 13–20 points.

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

This study goes further in two ways. First, time spent often leaves something behind that switching would throw away. Here it leaves keys, which look like a discount on finishing the task but by design are not one. Under a **sunk-effort** account, the effort already spent keeps people going; under a **waste** account, it is the keys that switching would waste. The design separates the two because keys can be held without having been made: some participants receive them for free. Second, each sequence is played by four participants, with and without keys made and with and without keys received, facing exactly the same choice ahead, so the effects are measured by comparing versions of the same situation.

The study also asks how what happened in earlier sequences, which participants see in full at the end of each one, affects later choices, and whether participants treat the session as a whole, by changing whether they believe later sequences remain in which a loss could be made up.

## 2. Design summary

Each participant plays five sequences of 12–33 orange and white cards with one winning card, equally likely to be on any orange card; the last card is always orange. Every card is opened with a key; keys are made by completing cards. Once per sequence, after the keys are made or at once, an alternative of known length is offered at the same reward; the participant can take it then or at any later card. At the end of each sequence the whole sequence is revealed. Every sequence is played in four versions by four participants. Half of the sequences are preceded by a deck choice. Across participants, half are told there are four sequences and half five. Details in Part I §28–29 and §34–35.

## 3. Identification

### 3.1 What participants see can be reconstructed exactly

At every card the participant sees the whole pattern, which cards are open, the keys held and, once offered, the length of the alternative. All of this is recorded, so we can compute what a forward-looking participant would do at every decision point, using only that information.

### 3.2 Groups of four

The four versions of a sequence share everything ahead at the moment of the offer: the same cards and costs to reach them, the same winning card, the same alternative. They differ only in what lies behind: the keys made before the offer and the keys received at the start. Which participant plays which version is random. Comparing the versions of the same sequence therefore measures the effect of the keys made and the keys held, holding fixed everything a forward-looking participant should care about, with no need to model what lies ahead. The only differences on screen besides the past are the keys shown and the extra white cards that come with them.

### 3.3 What varies at random within the sunk costs

The keys made before the offer vary across sequences (2 to 10). Within each sequence, the full version and the truncated version with gift hold the same keys at the offer, made in one and received in the other; in the mixed version both are drawn at random, independently, and in one sequence in five the full version also receives, and the truncated version with gift also makes, some extra keys. So the keys held and the keys made vary separately, also off the diagonal on which the full and truncated versions lie.

The effect of keys made after the offer, by choice or when no key is left, comes from the cards played after it, compared at the same situation ahead.

### 3.4 Previous sequences

Every sequence is drawn independently of the previous ones. What happened in the previous sequence (how long it took, whether the reward was earned, and whether the reveal showed the participant's choice to have been the right one) is therefore unrelated to what the next sequence offers, and its effect on the next choice can be estimated holding the next sequence's situation fixed.

### 3.5 The framing

Each sequence pays only its own reward, so in a standard model the number of sequences that follow should not change any decision within a sequence: nothing lost in one can be recovered in another. Any difference between participants told four and those told five in the fourth sequence, and in particular in how much they respond to sunk costs there, therefore reflects how participants bracket their choices across the session.

### 3.6 Deck choice

Whether a sequence with keys is preceded by a deck choice is random and independent of its version. Its effect on switching is estimated alongside the versions (equation (1′)), among the versions with keys.

## 4. Hypotheses

Three confirmatory families, one for each margin of the study, with multiple testing controlled within each family (§7), and a set of exploratory analyses.

### Family A — Sunk time and its composition

> **A1 (participants respond to what lies ahead).** The more time switching is expected to save, the more likely participants are to switch, at the offer and afterwards.

This is a check on the design: if A1 fails, the other hypotheses cannot be interpreted, and we report that and stop.

> **A2 (sunk time).** Participants playing the full version of a sequence switch less than those playing its truncated version, who face the same choice with no keys made.

> **A3 (composition of sunk time).** Holding fixed what lies ahead, switching depends on (a) the keys held, made or received, and (b) whether the keys were made rather than received. For (a), a waste account predicts less switching with keys held even if received for free (truncated with gift versus truncated). For (b), a sunk-effort account predicts less switching with keys made than with the same keys received (full versus truncated with gift). With the mixed version we also test whether the two effects are proportional to the keys and whether they interact (keys held weighing more when they were made). We report whichever obtains, without claiming to have predicted it.

### Family B — Previous sequences

> **B1 (time spent).** The number of cards completed in the previous sequence affects switching in the next one, holding the next sequence's situation fixed.

> **B2 (revealed outcome).** Participants whose previous choice turned out, once the sequence was revealed, to have been the wrong one (they switched and the winning card would have come soon, or they stayed and it came late) switch differently in the next sequence from those whose choice turned out right.

Both are tested in either direction.

### Family C — Amortizing across sequences

> **C1 (sunk costs in the believed last sequence).** In the fourth sequence, the difference between the full and the truncated version of a sequence (A2) differs between participants told there are four sequences and participants told there are five.

> **C2 (behaviour in the believed last sequence).** In the fourth sequence, participants told four switch and give up at different rates from participants told five.

> **C3 (unexpected extra sequence).** For participants told four, behaviour in the unannounced fifth sequence differs from their behaviour in the fourth.

### Exploratory analyses (reported as such, without multiple-testing adjustment)

How the effects in Family A vary with risk tolerance, patience, labour income and how easily the household makes ends meet; how long participants deliberate during the pause, and whether this depends on how close the two options are; learning over the five sequences, and whether a version played earlier changes behaviour in a later one; whether switching is more likely at the offer than at later cards in the same situation; whether participants who choose among decks, or change their selection, behave differently afterwards; the effect of changes in the alternative's length and the reward from one sequence to the next; keys left unused when switching; and behaviour after reloads.

## 5. Estimating equations

Participant *i*, sequence *s*, group of four *k*. Linear probability models, with logit as a robustness check; standard errors clustered by participant throughout.

### 5.1 Switching at the offer: versions (Family A)

For grouped sequences, all versions:

**Equation (1)**
```
Switch_is = κ_k + β_F · Full_is + β_X · Mixed_is + β_TG · TruncGift_is + δ' · X_is + ε_is
```
- `κ_k`: one indicator per group of four, which absorbs everything ahead at the offer.
- `Full`, `Mixed`, `TruncGift`: the version played (truncated is the reference).
- `X`: position of the sequence in the session, reward, deck choice, framing arm.

A2: β_F < 0. A3 (a): β_TG < 0. A3 (b): β_F − β_TG < 0.

**Equation (1′)**: equation (1) adding `Choice` and its interactions with the versions, where `Choice` indicates that the participant chose among two or three decks, which measures how much choosing the deck adds to the commitment; we expect it to be negative but do not treat this as a confirmatory test.

### 5.2 Switching at the offer: composition (Family A)

**Equation (2)**
```
Switch_is = κ_k + β_H · Held_is + β_M · Made_is + δ' · X_is + ε_is
```
- `Held`: keys held at the offer; `Made`: keys made before it (both divided by the keys made in the full version of the sequence).

A3 (a): β_H < 0. A3 (b): β_M < 0.

**Equation (2′)**: equation (2) adding `Held × Made`, `Held²` and `Made²`, which the mixed version makes estimable (its keys held and made are drawn independently): whether keys held weigh more when they were made, and whether either effect levels off.

A1 is tested in equation (2) without the group indicators, adding the time expected to be saved by switching (positive coefficient).

### 5.3 Switching after the offer (Family A)

One observation per card after the offer at which the participant was still in the main sequence and could switch, until they switch, find the winning card or give up:

**Equation (3)**
```
Switch_ist = κ_k + μ_(t) + β_F · Full_is + β_X · Mixed_is + β_TG · TruncGift_is + γ' · Ahead_ist + δ' · X_is + ε_ist
```
with `μ` one indicator for each number of cards since the offer, and `Ahead` (the time expected to be saved by switching, the cards expected to remain, the keys still held) updated at card *t*. Equation (2)'s terms replace the version indicators for the composition. Sequences in which the offer was taken contribute no observations.

### 5.4 Giving up and switching at any point

**Equation (4)**
```
y_is = κ_k + β_F · Full_is + β_X · Mixed_is + β_TG · TruncGift_is + δ' · X_is + ε_is
```
for y = switched at any point and y = gave up, together with equation (2) with these outcomes. A discrete-time model of leaving the main sequence card by card, by switching or by giving up, is reported alongside.

### 5.5 Previous sequences (Family B)

For sequences 2–5, equation (1) with two additional terms describing the previous sequence: the cards completed in it (B1), and an indicator for a previous choice that the reveal showed to have been wrong (B2), controlling for whether the previous reward was earned and for the previous sequence's version. The same terms are added to equation (3).

### 5.6 Framing (Family C)

**Equation (5)**
```
y_is = κ_k + β_F · Full_is + θ · Told4_i × Seq4_s × Full_is + η · Told4_i × Seq4_s + ρ · Told4_i × Full_is + δ' · X_is + ε_is
```
over sequences 1–4, for y = switched at the offer, switched at any point, gave up, on the full and truncated versions. C1: θ ≠ 0, the difference between the two versions in the fourth sequence, between framing arms, relative to the first three sequences. C2: η ≠ 0. C3: among participants told four, the difference between the fifth and fourth sequences, against the same difference among participants told five.

## 6. Balance and controls

We regress education, employment, log labour income, household size, ends-meet (now), risk tolerance, patience, country, device type and time of day on the framing indicator, and on the versions played and the deck choices, and report joint F-tests. Any covariate imbalanced at 5% is added as a control, and both specifications are reported. Controls are those named in §5; anything else is exploratory.

## 7. Multiple testing

Within each family (A1–A3, B1–B2, C1–C3) we report unadjusted p-values and sharpened q-values controlling the false discovery rate at 5% (Benjamini, Krieger and Yekutieli 2006; Anderson 2008), using the main specification of each hypothesis (equations (1) and (2) for Family A, §5.5 for Family B, equation (5) for Family C). Exploratory analyses and robustness checks are not adjusted.

## 8. Exclusions

In order, reporting the number excluded at each step:
1. Internal test sessions.
2. Participants who did not complete all five sequences (see §9).
3. Attempts discarded because the participant left mid-sequence and returned in a new session (kept for the reload analysis).
4. From the group analysis: sequences whose other versions were never played.

No participant is excluded for inattention or poor accuracy in the main specification. As a robustness check, we exclude those who triggered the inactivity warning more than three times, and offers during which the tab was hidden for most of the pause.

## 9. Attrition

**Equation (6)** `Complete_i = π0 + π2 · Told4_i + Π' · X_i + ε_i`. If the framing significantly affects completion at 5%, we report Lee (2009) bounds on the main effects. Because groups link participants, a participant who leaves also leaves the other versions of their sequence incomplete; we report how many groups are lost this way and whether this depends on the version played. Progress is saved every 25 seconds and at the end of every sequence, so partial data exist for those who leave.

## 10. Robustness

1. Logit and complementary log-log versions.
2. Equation (1) with participant indicators added (each participant plays every version).
3. Each participant's first sequence only, where no other version has been seen.
4. Clustering by participant and by group of four.
5. Equations (1)–(3) separately by sequence position and by the keys made in the full version.
6. Excluding pauses that ran out without an active choice, and pauses during which the tab was hidden.
7. Using a comparison of the two options that weights the long outcome less (geometric mean) in place of the expected time saved.
8. Sequences without a deck choice only.
9. Controlling for the design features drawn per sequence that participants cannot see (the shape of the curve of orange cards, the strength of the correction in drawing them, the number of times the sequence was drawn again).

## 11. Known limitations, recorded before data collection

1. **Participants play every version**, so seeing a sequence with keys received and one with keys to make may draw attention to the keys. The versions come in random order, and robustness check 3 uses first sequences only.
2. **The versions differ in time on task before the offer** (the keys made, at most ten cards), besides the keys made and held.
3. **Versions with keys have longer decks**, because of the extra white cards (up to 32 cards); the choice at the offer is unchanged.
4. **The alternative's length is fixed once offered**, so switching later is mechanically less attractive than switching at once in the same situation; the variables describing what lies ahead account for this.
5. **The choice at the offer is close to call by construction**; this makes small effects detectable.
6. **The reward varies across sequences** (from £0.10, in £0.05 steps, the five summing to £1.00–£1.50), independently of everything else; it enters as a control.
7. **Revealing each sequence at the end** may change how participants approach the next one. This is part of what Family B studies, and it applies equally to every participant.
8. **The framing interaction (C1) has limited power**, since it rests on the fourth sequence only.
9. **Single online session, modest stakes**: a bonus of at most £1.50 plus a £1.50 show-up fee, for about 20 minutes.

## 12. Power: derivation

By simulation (200 synthetic samples per cell) of participants' behaviour on the instrument's own design, with the rates of earlier builds of this task (WT_E, WT_F, WT_L, WT_N): switching at the offer 20%, 2% at each later card, a participant effect with standard deviation 0.6 on the logit scale (within-participant correlation about 0.1), effects proportional to the keys made and held, and two decompositions of an effect of about 1 percentage point per key (the size found in the largest earlier build): keys held 0.6 and keys made 0.4 points per key, or 0.5 and 0.5; a deck choice lowering switching by 3 points with the first decomposition and by 5 with the second. The four versions as in Part I §29: extra keys in the full and truncated-with-gift versions in one sequence in five, a deck choice in half of the sequences with keys. Group indicators, standard errors clustered by participant.

Power (%) for: keys held (per key) / keys made versus the same keys received (per key) / deck choice. Left: switching at the offer, two-sided tests; right: every decision after the offer as well, one-sided tests. The full versus truncated contrast, the sum of the first two, is detected with near certainty in every cell.

The rate of 20% is predicted from WT_F, where switching at the offer was 17.6% when switching was expected to save nothing and rose by 2.1 points for every card it was expected to save; applied to the cards this design's alternatives are expected to save, it gives 22% on average (16–29% across designs). As a check, we also report rates of 35% and 45% (same effects in percentage points).

| Participants | Rate 20%: held 0.6 / made 0.4, choice 3 | Rate 20%: 0.5 / 0.5, choice 5 | Rate 35%: 0.6 / 0.4, choice 3 | Rate 35%: 0.5 / 0.5, choice 5 | Rate 45%: 0.6 / 0.4, choice 3 | Rate 45%: 0.5 / 0.5, choice 5 |
|---|---|---|---|---|---|---|
| 1,600 | 93 / 52 / 72 ‖ 97 / 54 / 85 | 83 / 63 / 99 ‖ 89 / 77 / 100 | 79 / 38 / 59 ‖ 88 / 46 / 72 | 63 / 59 / 95 ‖ 76 / 68 / 98 | 73 / 37 / 56 ‖ 84 / 47 / 71 | 63 / 53 / 93 ‖ 79 / 69 / 96 |
| 2,000 | 95 / 57 / 84 ‖ 99 / 66 / 91 | 89 / 76 / 100 ‖ 96 / 83 / 100 | 87 / 45 / 72 ‖ 95 / 57 / 85 | 72 / 60 / 98 ‖ 84 / 74 / 100 | 83 / 45 / 68 ‖ 93 / 59 / 78 | 70 / 62 / 98 ‖ 86 / 66 / 97 |
| 2,400 | 98 / 62 / 88 ‖ 100 / 74 / 97 | 92 / 79 / 100 ‖ 96 / 90 / 100 | 89 / 50 / 78 ‖ 97 / 64 / 86 | 84 / 70 / 99 ‖ 94 / 82 / 99 | 89 / 53 / 69 ‖ 97 / 64 / 82 | 79 / 66 / 100 ‖ 85 / 79 / 99 |

**Previous sequences.** For a coefficient on a variable, the minimum detectable effect is 2.80 × SD(outcome) / (residual SD of the variable × √n), where n is the effective number of observations. With four transitions per participant and ρ = 0.1, n = 4 × N / (1 + 3ρ) ≈ 6,150 at N = 2,000. With a switching rate at the offer of 20–45% (SD 0.40–0.50): for B1, the cards completed in a sequence have an SD of about 12 in simulation (about 10 after controls), giving about 0.14–0.18 percentage points per card; for B2, an indicator equal to one in about 40% of cases (SD 0.49) gives about 2.9–3.6 percentage points.

**Framing.** C2: two arms of 1,000, one observation each in the fourth sequence: 2.80 × √(2 × p(1 − p) / 1,000) ≈ 5.0–6.2 percentage points for p = 20–45%. C3: the change from the fourth to the fifth sequence among the 1,000 told four, against the same change among the 1,000 told five, each a within-participant difference (ρ = 0.1): 2.80 × √(4 × p(1 − p)(1 − ρ) / 1,000) ≈ 6.7–8.4 points. C1: four cells (framing × full or truncated version) of about 250 in the fourth sequence: 2.80 × √(4 × p(1 − p) / 250) ≈ 14–18 points. Using the first three sequences as a baseline (equation (5)) adds precision.

**Deck choice.** Shown in half of the 7,500 sequences with keys, at random within participant: 2.80 × SD(outcome) / (0.5 × √7,500) ≈ 2.6–3.2 percentage points.

Any revision after data collection begins is filed as an amendment.

## 13. Data, code and deviations

The experiment runs in the browser and saves to three tables: one row per participant (survey answers, framing, the versions assigned, payments), one row per sequence (everything drawn for that sequence, including its group and version, every choice made in it and every card played with its timing), and one row per sequence design (its design and which versions have been played). Variable names and definitions are in the data dictionary. All the rules that generate sequences are in the experiment's source code and are described in words in Part I §29. The figures in this document were produced by running that code. Deviations will be reported with their reason and date, and filed as amendments once data collection has begun.

## 14. Pre-launch decisions required

| # | Decision | Why it matters | Recommendation |
|---|---|---|---|
| **1** | **Per-card pay is recorded but not paid.** Each card is worth £0.025 in the data, but participants are paid only the sequence rewards net of penalties, plus the £1.50 show-up fee. | The registered payment structure must match what is paid. | Decide whether to pay it; if not, drop it from the payment description. |
| **2** | Prolific screening: countries, approval rate, exclusion of earlier participants. | Registry country field; external validity. | Exclude anyone who took part in an earlier version of this task. |
| **3** | Which documents are public at registration. | The source code reveals how sequences are generated and grouped. | Withhold the code and documentation until complete; publish the consent text. |
| **4** | **Server deployment.** The address of the data server is still empty in the code. | No data is saved, and no groups are formed, until it is set. | Deploy and test end to end in test mode before launch. |

---

## References

Anderson, M. L. 2008. "Multiple Inference and Gender Differences in the Effects of Early Intervention." *JASA* 103(484): 1481–1495.
Benjamini, Y., A. M. Krieger, and D. Yekutieli. 2006. "Adaptive Linear Step-up Procedures That Control the False Discovery Rate." *Biometrika* 93(3): 491–507.
Dohmen, T., A. Falk, D. Huffman, U. Sunde, J. Schupp, and G. G. Wagner. 2011. "Individual Risk Attitudes: Measurement, Determinants, and Behavioral Consequences." *JEEA* 9(3): 522–550.
Falk, A., A. Becker, T. Dohmen, D. Huffman, and U. Sunde. 2016. "The Preference Survey Module." IZA DP 9674.
Lee, D. S. 2009. "Training, Wages, and Sample Selection: Estimating Sharp Bounds on Treatment Effects." *REStud* 76(3): 1071–1102.
Read, D., G. Loewenstein, and M. Rabin. 1999. "Choice Bracketing." *Journal of Risk and Uncertainty* 19(1–3): 171–197.
Sweis, B. M., et al. 2018. "Sensitivity to 'Sunk Costs' in Mice, Rats, and Humans." *Science* 361(6398): 178–181.
Thaler, R. H. 1999. "Mental Accounting Matters." *Journal of Behavioral Decision Making* 12(3): 183–206.
