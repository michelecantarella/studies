# Preregistration — *The Value of Wasted Time* (WT_N)

**Study title:** The Value of Wasted Time: Sunk Time, Missed Chances, and Abandonment under Duration Uncertainty
**Build:** WT_N
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

> How do we value the time we have lost? We study the sunk cost fallacy in labor supply decisions with a real-effort experiment. Participants complete a sequence of tasks to find winning cards, hidden at random with a known probability. At a random point, they are offered the option to switch to an alternative of known length, which randomizes the sunk costs they have accumulated depending on the time spent, the winning cards found, and the chances missed. We study three margins. First, how sunk time and its composition affect the decisions to switch and to give up. Second, how failures and successes in earlier sequences affect behavior in later ones. Third, whether participants respond differently to sunk costs when they believe later sequences can amortize the loss than when they believe a sequence is the last.

**16. External Link(s)** — **[PLACEHOLDER]** (GitHub Pages URL of the instrument)

**17. External Link Description** — Live experimental instrument (single-page application, full source in `index.html`).

## Dates

**18. Trial Start Date** — **[PLACEHOLDER]** · **19. Intervention Start Date** — **[PLACEHOLDER]** · **20. Intervention End Date** — **[PLACEHOLDER]** · **21. Trial End Date** — **[PLACEHOLDER]**

## Experimental Details

### 28. Intervention (Public)

Participants complete five sequences of a real-effort task in a single online session of about 20 minutes. The task ("card") is a 3×3 grid of emoji revealed progressively over 4.5 s; the participant clicks every instance of a target emoji before a 2.5 s countdown auto-submits (about 7 s per card). Each error costs £0.01 but never stops the sequence.

Each sequence is a stack of 30–35 cards, all visible from the start, each marked orange or white. A sequence has one, two or three winning cards, which can only be on orange cards. Above the cards, one box per winning card shows the chance that this winning card is on any given orange card; a box fills with a gold star when its winning card is found. The sequence ends when the last winning card is found, which pays the sequence's reward.

Before each sequence, the participant sees its reward, the winning-card boxes with their chance, and either the next deck of cards or two or three decks to choose from; the deck chosen is the one played.

At a random card, the participant is offered an **alternative sequence** of a stated, fixed number of cards at the same reward, with no winning cards to find; its length is revealed only at this moment. The task pauses for 10–30 seconds: the participant can switch with the Alternative button, or resume with the Cards left button or by letting the countdown run out. From then on the alternative remains available: the same button lets the participant switch at any later card. Switching restarts progress on the alternative's cards and cannot be undone. If the participant reaches the last card without finding all the winning cards, the main sequence ends and they can still switch to the alternative to earn the reward. A participant may give up a sequence at any time, losing its reward but not other earnings. At the end of every sequence, all participants are shown the whole sequence: the cards they completed, where the winning cards were and, if they took the alternative, its cards.

Within each sequence, the number of winning cards, the pattern of orange and white cards, the chance per winning card, the moment of the offer, the length of the alternative and the reward are drawn at random, so the time already spent when the offer comes, its split between orange and white cards, and the number of winning cards already found are random. Each sequence is played by two participants: one from the start, and one starting from the moment of the offer, so that the two face the same choice with and without the time already spent. Across participants, half are told the study has four sequences and half five; all play five, and those told four receive the fifth as an unannounced bonus. Separately, the rule that places the offer relative to the winning cards (the placement regime) varies across participants as a robustness check.

### 29. Intervention (Hidden) **[HIDDEN]**

*Withhold until the trial is complete: this section describes how sequences are generated and paired, which participants are not told.*

**What participants know.** Participants see every card of the sequence and its colour from the start, and the reward. They know how many winning cards the sequence has (one box each), that winning cards can only be on orange cards, and that each winning card not yet found has the same chance, shown in its box, of being on any orange card. When the alternative is offered, they see how many cards it has. They are told that the alternative remains available until the end, that reaching the last card without all the winning cards means the main sequence ends and they can still switch to the alternative, and that at the end of each sequence they will be shown where the winning cards were. They are not told how the cards, the moment of the offer or the length of the alternative are chosen, how the decks they choose between are built, that sequences are paired across participants, nor that the sequence-count framing and the placement regimes exist. Every benchmark in the analysis (the number of cards expected to remain before all the winning cards are found, the chance of finding them all before the last card, the time expected to be saved by switching) is computed from what participants know, and nothing else: with a given number of winning cards still missing, each orange card ahead holds one of them with a chance equal to that number times the chance shown in a box, independently of the other cards.

**Winning cards, length and chance per box.** A sequence has three winning cards 75% of the time, two 20% and one 5% (the truncated version of a sequence shows only the winning cards still missing, so across both versions participants face one, two or three missing winning cards about equally often: 39 / 22 / 38%). Its length is drawn first, between 30 and 35 cards. The chance shown in each box is set so that all the winning cards fall within the first few cards of the sequence (a window of 4 to 12 cards, longer when there are more winning cards) with a given probability. That probability goes from 25% to 75%; so that every participant sees the whole range, it is split into five bands (25–35%, 40–45%, 50%, 55–60%, 65–75%), and each participant gets one sequence from each band, in random order. The window always holds at least one, four or seven orange cards (with one, two or three winning cards), so that the highest band can be reached. Participants are told only the chance per box, never this probability.

**The orange cards.** The chance that a card is orange starts at 40–60% on the first card with one winning card, or 55–65% with two or three, and then decreases from card to card along a smooth curve towards a floor. The shape of the curve is chosen for each sequence so that the alternative stays about equally attractive whenever it is offered: for a participant still in the main sequence at any card, counting the winning cards they may have found by then, the alternative that would make switching and staying equally costly in expectation should be about the same as at the moment of the offer. With a single winning card this requires no decrease at all (nothing is learned as cards pass); with two or three, the curve thins the later cards so that the progress made on the first cards is offset. The curve never drops by more than 12% from one card to the next, and never lengthens the fair alternative at the offer by more than half. The cards are then drawn one at a time: each card is orange with its chance on the curve plus a correction for the orange cards drawn so far, so that a run of white cards is followed by more orange cards and the sequence as a whole follows its curve, while long runs of either colour still happen at random. The strength of this correction is drawn for each sequence. The last card is always orange.

Because the colours are drawn at random, two participants at the same point of similar sequences can have completed different numbers of orange and white cards, and found different numbers of winning cards. This is what allows us to separate the effect of time spent on orange cards, which could have held a winning card, from time spent on white cards, which could not, and from the winning cards already found.

**The winning cards and the offer.** Winning cards are placed on orange cards one at a time, with the chance described above. The offer comes after 1 to 10 completed cards, with later cards much more likely (the chance grows with the square of the number of cards completed), and always before the last winning card: so when the offer comes, some winning cards may already have been found, and at least one is still missing. It never comes before the first card, because then the two versions of a pair (below) would be identical. A sequence is drawn again if, at the offer, there are fewer orange cards ahead than winning cards still missing (the end of the main sequence would be certain), or if the fair alternative (below) would be shorter than about 5 or longer than 26 cards, the 5th and 95th percentiles of its distribution: this keeps the alternative within a reasonable range without favouring either option.

**Length of the alternative.** When the offer comes, the alternative is set from the cards ahead: the number of cards that would make switching and staying equally costly in expectation, given that staying means completing the main sequence until the last winning card and, if it is not found before the last card, completing the alternative as well. That number is varied at random by up to 15% either way, rounded, and kept at 5 cards or more and at more than the best possible outcome of staying. Once shown, its length does not change: switching later, or after reaching the end without all the winning cards, means completing the same number of alternative cards.

**Pairs.** Every sequence is played by two participants. One plays it from the start (the full version). The other plays the same sequence from the card at which the offer comes (the truncated version): no cards completed, only the winning cards still missing in the boxes (none shown as already found), and the same cards ahead, chance per box and alternative, offered immediately. Each participant plays two sequences in the full version, two in the truncated version and one in either version at random, in random order. When a participant starts, for each of their five sequences the study looks for a sequence in that band whose other version is still to be played and matches the version required; if there is one, the participant plays it, otherwise a new sequence is drawn, played in the required version, and kept for a later participant. Two participants are never paired more than once, so each of a participant's five sequences has a different partner. At the end of data collection, a final small batch of participants plays only sequences still waiting for a partner, of either version, so that as few sequences as possible remain unpaired. The two members of a pair therefore face exactly the same choice ahead of them, and differ only in the time already spent, the winning cards already found and the orange cards already passed without one. If a participant chooses a deck other than the assigned one (below), that sequence is played outside the pairing.

**Deck choice.** Before each sequence, one, two or three decks are shown, each number equally likely, as strips of orange and white cards in random order. One of them is the deck assigned to the participant (the version of the paired sequence). The others are drawn with the same number of winning cards, chance per box and shape of the curve, but sparser (the first card's chance reduced to 45–70% of the assigned deck's) and 2–5 cards longer, and are kept only if they have fewer orange cards and are much worse: at least 6 more cards expected before the last winning card, and at least 40% more. With one deck, the screen simply shows the next deck. The deck chosen is played.

**Reward.** Each participant has a total reward between £1.00 and £1.50, drawn at random and split at random across the five sequences, with at least £0.10 per sequence. A sequence's reward is unrelated to anything else about that sequence and is shown before it starts.

**Sequence-count framing.** Half of the participants, chosen at random, are told the study has four sequences, and half five. Everyone plays five; for those told four, the fifth is introduced only when it starts, as a bonus. Nothing else about the sequences changes. Each sequence pays only its own reward, so a loss in one sequence cannot actually be recovered in another; but participants who believe more sequences follow may treat a lost or risky sequence as something later ones can make up for. Those told four believe their fourth sequence is their last opportunity to earn in the study, and the unexpected fifth shows whether their behaviour changes back once another opportunity appears.

**Placement regimes (robustness check).** Placing the offer and the winning cards independently would sometimes end a sequence before the offer, leaving no decision to observe. Each participant is therefore assigned one of four rules: winning cards first, then the offer before the last of them (regime 1: the offer's timing carries some information); offer first, then winning cards redrawn until the last comes after it (regime 2: the winning cards no longer follow exactly the chance shown); both independent, never redrawn (regime 3: about 28% of its sequences end with no offer; used only under the rule in §34); or regime 1 or 2 at random for each sequence (mixed). In regimes 2 and 3 the offer's timing follows regime 1's distribution. The main results should not depend on the regime; in particular, equal behaviour across regimes in the same situation means participants are not guessing the winning cards from the timing of the offer.

### 30. Primary Outcomes (end points)

1. **Switching at the offer**: whether the participant switches to the alternative while the task is paused at the offer. One observation per sequence in which the offer appeared.
2. **Switching after the offer**: whether the participant switches at a given later card, among those still in the main sequence. One observation per card after the offer.
3. **Switching at any point**: whether the participant switches to the alternative at any point before the main sequence ends. One observation per sequence.
4. **Giving up**: whether the participant gives up the sequence, losing its reward. One observation per sequence.

### 31. Primary Outcomes (explanation)

All four come from the per-sequence records described in the data dictionary. For every card at which a participant could decide, we can reconstruct exactly what they saw: how many orange and white cards they had completed, how many winning cards they had found, the orange and white cards still ahead, the chance per box and the alternative's length. From this we compute the number of main cards expected to remain, the chance of finding all the missing winning cards before the last card, and the number of cards expected before earning the reward if they stay, which includes the alternative if the last card is reached without all the winning cards. Comparing the last of these with the alternative's length gives the time saved, or lost, by switching in expectation.

The time already spent in a sequence, and its split into orange and white cards, enters none of these comparisons. The winning cards already found matter only through what lies ahead (fewer winning cards left to find), which the benchmarks capture. A participant who decides only on what lies ahead should not respond to any of them, and the two versions of a pair, which share everything ahead, should behave the same.

### 32. Secondary Outcomes (end points)

1. When participants switch: the card at which they switch, and whether they switch at the offer or later.
2. Deliberation: how long the pause lasted before the participant switched, resumed or let it run out, and how much of it the browser tab was hidden; how often they opened the switch confirmation and then kept going; time taken to confirm a switch; presses on the alternative before it was offered.
3. Deck choice: whether the participant chooses the assigned deck when two or three are offered, how often they change their selection, and the time spent choosing.
4. Effort and attention on the grid task: targets found, wrong clicks, missed targets, penalties, cards with no activity, time with the tab hidden.
5. Giving up across the session: how many sequences are given up, and when the first one is.
6. Reloads: sequences restarted after the participant left and came back.
7. Risk tolerance and patience (self-reported, 0–10) and the background covariates in §33.

### 33. Secondary Outcomes (explanation)

Before the training, a two-screen survey asks about education, employment, monthly labour income (if employed), marital status, household size, whether other people contribute to household expenses, and how easily the household makes ends meet now, a year ago and a year from now. Approximate location and device type are recorded at consent. If a participant leaves in the middle of a sequence and returns in a new session, that sequence is redrawn, so nobody can learn how a sequence ends by leaving and coming back; the abandoned attempt is kept in the data and flagged.

### 34. Experimental Design (Public)

Each participant plays five sequences. Within each sequence, the number of winning cards, the pattern of orange and white cards, the chance per winning card, the moment of the offer, the length of the alternative and the reward are drawn at random, independently for every sequence. Every sequence is also played by a second participant from the moment of the offer, with no time already spent. The comparison between the two versions of the same sequence, and the random moment of the offer, make the time already spent, its split between orange and white cards and the winning cards already found random, while everything ahead is held fixed.

At the end of every sequence, all participants are shown the whole sequence: the cards they completed, where the winning cards were and, if they took the alternative, its cards. This tells them what would have happened had they chosen differently, and is announced in the training.

Two features are randomized across participants, independently of each other and once for the whole session:

- **Sequence-count framing (2 arms, 50/50).** Participants are told the study has four or five sequences. All play five; those told four receive the fifth as an unannounced bonus.
- **Placement regime (mixed, 1 and 2, one third each).** The rule that places the offer relative to the winning cards. This is a robustness check; it exists because placing the two independently would sometimes end a sequence before the offer, leaving no decision to observe. The pilots and the first 1,000 participants do not use regime 3, which loses about 28% of its offers. After the first 1,000 participants we compare regimes 1 and 2 (robustness check 2 in Part II §10, jointly over the variables of Family A, at the 5% level). Only if they differ, regime 3 is added for the remaining participants, with a quarter of them assigned to it, to test whether the difference comes from what the offer's timing reveals. The decision and the test behind it will be reported either way.

After consent and the survey, a seventeen-step walkthrough on the real task screen explains the grid task, orange and white cards, the winning cards and their chance, the offer, the alternative and what happens at the end of a sequence without all the winning cards. It ends with three comprehension questions that must be answered correctly to continue; wrong answers are recorded. The walkthrough is not paid.

### 35. Experimental Design (Hidden) **[HIDDEN]**

Simulated with the instrument's own code, 1,500 sequences per regime (regime 3 only if added, see §34):

| | Mixed | Regime 1 | Regime 2 | Regime 3 |
|---|---|---|---|---|
| Sequences with no offer | 0 | 0 | 0 | 28% |
| Average cards completed when the offer comes | 6.1 | 6.2 | 6.1 | 5.6 |
| Winning cards already found at the offer (0 / 1 / 2) | 11 / 37 / 51% | 9 / 34 / 57% | 12 / 40 / 48% | 12 / 38 / 49% |
| Winning cards still missing at the offer (1 / 2 / 3) | 73 / 24 / 2% | 77 / 21 / 3% | 69 / 28 / 3% | 64 / 32 / 4% |
| Length of the alternative: median (5th–95th percentile) | 11 (6–21) | 11 (6–20) | 11 (6–20) | 11 (6–21) |
| Offers where switching saves time on average | 48% | 51% | 49% | 49% |
| Cards ahead in the truncated version (average) | 26.4 | 26.3 | 26.4 | 27.0 |
| Chance of reaching the last card without all the winning cards, at the offer | 11% | 11% | 11% | 11% |

Because the alternative is set close to the fair value, the choice at the offer is close to call by construction: on average switching saves nothing, and the expected saving has a standard deviation of about 0.9 cards. Participants are therefore not expected to all make the same decision, and small influences of the time already spent can tip it. Once the long outcome (reaching the last card and then completing the alternative as well) is weighted less, as a risk-averse participant would, staying is the better option in almost every offer.

When the offer comes, participants have completed on average 4.0 orange and 2.1 white cards. The difference between orange and white cards completed has a standard deviation of about 1.8 cards; 71% of its variance remains after holding fixed the number of cards completed, the sequence length and the band. The number of winning cards already found keeps 69% of its variance in the same comparison.

Three differences between regimes are known in advance and recorded here:

1. **Under regime 2 the winning cards are no longer placed exactly with the chance shown**, because they are drawn again until the last one comes after the offer. All the winning cards fall within the first cards of the sequence about half as often as the band indicates. Participants are told only the chance per box, so what they see is unaffected, but raw comparisons between regimes mix this with any effect of the regime itself, which is why every comparison is made holding fixed what the participant sees.
2. **Under regime 1 the moment of the offer carries information**: the offer always comes before the last winning card.
3. **Regime 3 loses about 28% of its offers**, because the last winning card came first. Those sequences carry no offer decision, cannot be paired, and drop out of the analysis of the offer, which favours sequences with later winning cards.

### 36. Randomization Method

Randomization is done by the participant's browser at consent and recorded immediately: the framing by a fair coin, the regime with equal probability over the regimes in use (§34), the order of the five bands by a random shuffle. All three are saved and restored if the page is reloaded. The version of each sequence (full or truncated) is set by the pairing: each participant has two of each and one at random, assigned to their five sequences in random order, and plays either the missing version of a sequence another participant has already played or a new sequence in the version required. A testing option can force a regime through the study link; sessions that use it are identifiable and excluded.

### 37. Randomization Unit — Individual participant (framing, regime); the sequence (version within a pair).

### 38. Was the treatment clustered? — No.

### 39. Planned Number of Clusters — Not applicable: no treatment is assigned to groups. The version of a sequence is assigned within pairs, which are blocks (about 3,800), each containing both versions. For inference, standard errors are clustered two-way, by participant (about 1,600; five sequences each) and by pair (two participants each).

### 40. Planned Total Number of Observations — **[PLACEHOLDER — recommended 1,600 participants]**: about 8,000 sequences, about 7,700 offer decisions and about 3,800 complete pairs; the analysis of switching after the offer adds card-level observations for every offer that is not taken.

### 41. Sample Size by Treatment Arms

With 1,600 participants: 800 per framing arm; about 530 per placement regime (mixed, 1, 2), or, if regime 3 is added after the first 1,000, about 480 per main regime and 150 in regime 3; within each framing arm, about half of the sequences in each version.

### 42. Power Calculation

80% power, 5% two-sided test, standard errors clustered by participant, within-participant correlation 0.3 (derivation in Part II §12). With 1,600 participants:

- **Sunk time (pairs):** a difference of about 3.5 percentage points in the probability of switching at the offer between the full and the truncated version of the same sequence.
- **Composition of sunk time:** an effect of about 1.7 percentage points per card of difference between orange and white cards completed, among full versions.
- **Previous sequences:** a difference of about 4.5 percentage points in switching between participants whose previous choice turned out, once revealed, to have been the wrong one and those whose choice turned out right.
- **Sequence-count framing:** a difference of about 7 percentage points in switching in the fourth sequence between participants told four and those told five; a difference of about 14 percentage points in how the two versions of a pair differ in the fourth sequence across the two framing arms (the interaction in the abstract's third question, which has much less power because it rests on one sequence per participant).
- **Placement regimes (robustness):** differences of about 6 percentage points between regimes 1 and 2 at the interim comparison (about 330 participants each among the first 1,000: about 7 points), and, if regime 3 is added, about 8–9 points between it and the others.

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

This study goes further in two ways. First, not all time spent is alike. Some of it is spent on steps that could have paid off and did not (an orange card that could have held a winning card); some of it on steps that could never have paid off (white cards); and some of it bought real progress (winning cards already found). All of it is sunk. Under a **missed-chance** account, orange cards passed without success make people feel invested; under a **dead-time** account, white cards are pure waste, and it is that waste that keeps people going; under a **partial-progress** account, the winning cards already found pull people towards finishing. The design separates the three because the colours and the winning cards are random and independent of what a forward-looking participant should care about. Second, each sequence is played by two participants, one with and one without the time already spent, facing exactly the same choice ahead, so the effect of sunk time is measured by comparing two versions of the same situation.

The study also asks how what happened in earlier sequences, which participants see in full at the end of each one, affects later choices, and whether participants treat the session as a whole, by changing whether they believe later sequences remain in which a loss could be made up.

## 2. Design summary

Each participant plays five sequences of 30–35 orange and white cards with one to three winning cards, each with a known chance of being on any orange card; the last card is always orange. Once per sequence, after 1–10 cards and before the last winning card, an alternative of known length is offered at the same reward; the participant can take it then or at any later card. Reaching the last card without all the winning cards leaves the choice between the alternative and giving up. At the end of each sequence the whole sequence is revealed. Every sequence is played in full by one participant and from the offer onwards by another. Across participants, half are told there are four sequences and half five; the rule placing the offer relative to the winning cards (placement regime) also varies, as a robustness check. Details in Part I §28–29 and §34–35.

## 3. Identification

### 3.1 What participants see can be reconstructed exactly

At every card the participant sees the whole pattern, which cards are done, how many winning cards have been found, the chance per box and, once offered, the length of the alternative. All of this is recorded, so we can compute what a forward-looking participant would do at every decision point, using only that information.

### 3.2 Pairs

The two versions of a sequence share everything ahead at the moment of the offer: the same cards, the same winning cards still to find, the same chance per box, the same alternative. They differ only in what lies behind: the cards completed, their split into orange and white, and the winning cards already found, all of which are zero in the truncated version. Which participant plays which version is random. Comparing the two versions of the same sequence therefore measures the effect of the whole bundle of sunk costs, holding fixed everything a forward-looking participant should care about, with no need to model what lies ahead. The only difference on screen besides the past is the number of boxes: the full version shows the winning cards already found as filled boxes, while the truncated version shows only those still missing.

### 3.3 What varies at random within the sunk costs

At the offer, the cards already completed split into orange and white at random, and so does the number of winning cards already found. Two participants who have completed the same number of cards, in sequences of the same length and band, therefore differ at random in how many of those cards were orange and how many winning cards they found. In simulation, 71% of the variation in the orange–white split, and 69% of the variation in the winning cards found, remains after holding fixed the number of cards completed, the length and the band.

There is one complication. The past also affects what lies ahead: the more winning cards already found, the fewer remain to be found, and the curve of orange cards ahead depends on the sequence. We therefore always control for what lies ahead (the cards expected to remain, the chance of finding all the missing winning cards before the last card, the alternative's length and the time expected to be saved by switching), so that the cards and winning cards already behind capture only the effect of the past. Within a pair, what lies ahead is identical and drops out.

The effect of time already spent as such comes both from the pairs and from the random moment of the offer: the same sequence is faced after a few cards by one participant and after none by the other, and across sequences the offer comes after 1 to 10 cards. In the analysis of later switching, it also comes from the cards completed after the offer, compared at the same situation ahead.

### 3.4 Previous sequences

Every sequence is drawn independently of the previous ones. What happened in the previous sequence (how long it took, whether the reward was earned, and whether the reveal showed the participant's choice to have been the right one) is therefore unrelated to what the next sequence offers, and its effect on the next choice can be estimated holding the next sequence's situation fixed.

### 3.5 The framing

Each sequence pays only its own reward, so in a standard model the number of sequences that follow should not change any decision within a sequence: nothing lost in one can be recovered in another. Any difference between participants told four and those told five in the fourth sequence, and in particular in how much they respond to sunk costs there, therefore reflects how participants bracket their choices across the session.

### 3.6 What the placement regimes are for

They check that the results do not depend on how the offer was placed: in particular, that participants are not guessing the winning cards from the moment of the offer, which is possible only under regime 1.

## 4. Hypotheses

Three confirmatory families, one for each margin of the study, with multiple testing controlled within each family (§7), and a set of exploratory analyses.

### Family A — Sunk time and its composition

> **A1 (participants respond to what lies ahead).** The more time switching is expected to save, the more likely participants are to switch, at the offer and afterwards.

This is a check on the design: if A1 fails, the other hypotheses cannot be interpreted, and we report that and stop.

> **A2 (sunk time).** Participants playing the full version of a sequence switch less than those playing its truncated version, who face the same choice with no time already spent; and, among full versions, the more cards already completed, the less likely participants are to switch, holding fixed what lies ahead.

> **A3 (composition of sunk time).** Holding fixed what lies ahead and the number of cards completed, switching depends on (a) how many of those cards were orange rather than white, and (b) how many winning cards were already found. We test (a) in both directions: if white cards make participants less likely to switch, time that could never have paid off binds more (dead time); if orange cards do, chances missed bind more. For (b), partial progress predicts less switching the more winning cards were found. We report whichever obtains, without claiming to have predicted it.

### Family B — Previous sequences

> **B1 (time spent).** The number of cards completed in the previous sequence affects switching in the next one, holding the next sequence's situation fixed.

> **B2 (revealed outcome).** Participants whose previous choice turned out, once the sequence was revealed, to have been the wrong one (they switched and the winning cards would have come soon, or they stayed and reached the last card without them) switch differently in the next sequence from those whose choice turned out right.

Both are tested in either direction.

### Family C — Amortizing across sequences

> **C1 (sunk costs in the believed last sequence).** In the fourth sequence, the difference between the full and the truncated version of a sequence (A2) differs between participants told there are four sequences and participants told there are five.

> **C2 (behaviour in the believed last sequence).** In the fourth sequence, participants told four switch and give up at different rates from participants told five.

> **C3 (unexpected extra sequence).** For participants told four, behaviour in the unannounced fifth sequence differs from their behaviour in the fourth.

### Exploratory analyses (reported as such, without multiple-testing adjustment)

How the effects in Family A vary with risk tolerance, patience, labour income and how easily the household makes ends meet; how long participants deliberate during the pause, and whether this depends on how close the two options are; learning over the five sequences; whether switching is more likely at the offer than at later cards in the same situation; whether participants who choose a worse deck, or change their selection, behave differently afterwards; the effect of changes in the chance per box, the number of winning cards, the alternative's length and the reward from one sequence to the next; and behaviour after reloads.

## 5. Estimating equations

Participant *i*, sequence *s*, pair *k*. Linear probability models, with logit as a robustness check; standard errors clustered two-way, by participant and by pair, throughout.

### 5.1 Switching at the offer: pairs (Family A)

For paired sequences in which the offer appeared, both versions:

**Equation (1)**
```
Switch_is = κ_k + β_F · Full_is + δ' · X_is + ε_is
```
- `κ_k`: one indicator per pair, which absorbs everything ahead at the offer.
- `Full`: the participant plays the full version.
- `X`: position of the sequence in the session, reward, framing arm and regime.

A2: β_F < 0.

### 5.2 Switching at the offer: composition (Family A)

For full versions (paired or not) in which the offer appeared:

**Equation (2)**
```
Switch_is = α_i + λ_(L,b) + β_E · Done_is + β_C · (Orange − White)_is + β_W · Found_is + γ' · Ahead_is + δ' · X_is + ε_is
```
- `Done`: cards completed when the offer comes; `Orange − White`: the difference between orange and white cards among them; `Found`: winning cards already found.
- `Ahead`: the time expected to be saved by switching, the cards expected to remain, the chance of finding all the missing winning cards before the last card, the alternative's length, the winning cards still missing and the orange and white cards left.
- `λ_(L,b)`: one indicator for each combination of sequence length and band; `α_i`: one indicator per participant.

A1: the coefficient on the time saved by switching is positive (also tested in the truncated versions). A2: β_E < 0. A3: β_C ≠ 0, β_W ≠ 0.

**Equation (2′)**: the same with the numbers of orange and white cards completed entered separately, and with the orange cards split into those that held a winning card and those that did not.

**Equation (2″)**: A3 with one indicator for each combination of length, band and cards completed (β_E is then absorbed).

### 5.3 Switching after the offer (Family A)

One observation per card after the offer at which the participant was still in the main sequence and could switch, until they switch, find the last winning card, reach the end or give up:

**Equation (3)**
```
Switch_ist = κ_k + μ_(t) + β_F · Full_is + γ' · Ahead_ist + δ' · X_is + ε_ist
```
with `μ` one indicator for each number of cards since the offer, and `Ahead` updated at card *t* (the two versions can diverge after the offer, as winning cards are found). The composition terms of equation (2), updated at card *t*, are added for full versions. Sequences in which the offer was taken contribute no observations.

### 5.4 Giving up and switching at any point

**Equation (4)**
```
y_is = κ_k + β_F · Full_is + δ' · X_is + ε_is
```
for y = switched at any point and y = gave up, together with the composition version of equation (2) with these outcomes. A discrete-time model of leaving the main sequence card by card, by switching or by giving up, is reported alongside.

### 5.5 Previous sequences (Family B)

For sequences 2–5, equation (2) with two additional terms describing the previous sequence: the cards completed in it (B1), and an indicator for a previous choice that the reveal showed to have been wrong (B2), controlling for whether the previous reward was earned and for the previous sequence's band and length. The same terms are added to equations (1) and (3).

### 5.6 Framing (Family C)

**Equation (5)**
```
y_is = κ_k + β_F · Full_is + θ · Told4_i × Seq4_s × Full_is + η · Told4_i × Seq4_s + ρ · Told4_i × Full_is + δ' · X_is + ε_is
```
over sequences 1–4, for y = switched at the offer, switched at any point, gave up. C1: θ ≠ 0, the difference between the two versions of a pair in the fourth sequence, between framing arms, relative to the first three sequences. C2: η ≠ 0. C3: among participants told four, the difference between the fifth and fourth sequences, against the same difference among participants told five.

## 6. Balance and controls

We regress education, employment, log labour income, household size, ends-meet (now), risk tolerance, patience, country, device type and time of day on the framing and regime indicators, and on the version played in each sequence, and report joint F-tests. Any covariate imbalanced at 5% is added as a control, and both specifications are reported. Controls are those named in §5; anything else is exploratory.

## 7. Multiple testing

Within each family (A1–A3, B1–B2, C1–C3) we report unadjusted p-values and sharpened q-values controlling the false discovery rate at 5% (Benjamini, Krieger and Yekutieli 2006; Anderson 2008), using the main specification of each hypothesis (equations (1) and (2) for Family A, §5.5 for Family B, equation (5) for Family C). Exploratory analyses and robustness checks are not adjusted.

## 8. Exclusions

In order, reporting the number excluded at each step:
1. Internal test sessions.
2. Sessions in which the regime was forced through the study link.
3. Participants who did not complete all five sequences (see §9).
4. Attempts discarded because the participant left mid-sequence and returned in a new session (kept for the reload analysis).
5. From the analysis of the offer and of later switching: sequences in which the offer never appeared.
6. From the pair analysis: sequences played outside the pairing (a deck other than the assigned one was chosen, or the other version was never played).

No participant is excluded for inattention or poor accuracy in the main specification. As a robustness check, we exclude those who triggered the inactivity warning more than three times, and offers during which the tab was hidden for most of the pause.

## 9. Attrition

**Equation (6)** `Complete_i = π0 + π1' · Regime_i + π2 · Told4_i + Π' · X_i + ε_i`. If the framing or the regimes significantly affect completion at 5%, we report Lee (2009) bounds on the main effects. Because pairs link participants, a participant who leaves also leaves their partner's sequence unpaired; we report how many pairs are lost this way and whether this depends on the version played. Progress is saved every 25 seconds and at the end of every sequence, so partial data exist for those who leave.

## 10. Robustness

**Placement regimes.**
1. Equations (1)–(3) estimated separately by regime, and with regime indicators interacted with the variables of Family A.
2. Whether, holding fixed what participants see, switching after a late offer differs between regime 1 and regimes 2 and 3: a difference would mean participants are guessing the winning cards from the timing of the offer.
3. Family A excluding regime 1, and with regime 3 only (if added).
4. Within the mixed regime, comparing sequences placed by rule 1 and rule 2 for the same participant.
5. If regime 3 is added: whether its participants, who sometimes see no offer at all, switch more readily when it does come.

**Other.**
6. Logit and complementary log-log versions.
7. Smooth functions of length, band and cards completed instead of indicators.
8. Equation (1) with participant indicators added (each participant plays several pairs, in different versions).
9. Clustering by participant only, and by sequence position as well.
10. Equations (1)–(3) separately by sequence position and by number of winning cards.
11. Excluding pauses that ran out without an active choice, and pauses during which the tab was hidden.
12. Using a comparison of the two options that weights the long outcome less (geometric mean) in place of the expected time saved.
13. Controlling for the design features drawn per sequence that participants cannot see (the shape of the curve of orange cards, the strength of the correction in drawing them, the number of times the sequence was drawn again).

## 11. Known limitations, recorded before data collection

1. **Under regime 2 the winning cards are not placed exactly with the chance shown**, and under regime 1 the moment of the offer is informative about them; raw comparisons between regimes are not clean.
2. **Regime 3 loses about 28% of its offers**, so its usable sequences lean towards later winning cards; it is used only if regimes 1 and 2 differ after the first 1,000 participants, and then only for those that follow, so its comparison with the other regimes also mixes in the time of participation.
3. **The offer never comes before the first card**, and comes mostly after several cards: very small sunk costs are under-represented in the full versions, but the truncated versions provide the zero-cost side.
4. **Sequences whose fair alternative would be very short or very long are drawn again** (regimes 1–2); this removes the 5% at each end of its distribution and slightly changes how often all the winning cards fall within the first cards in the lowest bands.
5. **The two versions of a pair differ in the number of boxes shown**: the full version shows the winning cards already found as filled boxes, the truncated version only those still missing. This is part of the sunk costs the comparison measures (partial progress), and Family A's composition analysis separates it from time spent.
6. **The alternative's length is fixed once offered**, so switching later is mechanically less attractive than switching at once in the same situation; the variables describing what lies ahead account for this.
7. **The choice at the offer is close to call by construction** (on average switching saves nothing); this makes small effects detectable but means that, under strong risk aversion, staying is almost always better.
8. **The reward varies across sequences** (from £0.10, in £0.05 steps, the five summing to £1.00–£1.50), independently of everything else; it enters as a control.
9. **Revealing each sequence at the end** may change how participants approach the next one. This is part of what Family B studies, and it applies equally to every participant.
10. **The framing interaction (C1) has limited power**, since it rests on the fourth sequence only.
11. **Single online session, modest stakes**: a bonus of at most £1.50 plus a £1.25 show-up fee, for about 20 minutes. The pilots and the first 1,000 participants do not include regime 3.

## 12. Power: derivation

**Sunk time (pairs).** About 3,800 complete pairs at N = 1,600 (five sequences per participant, two participants per pair, losing the sequences without an offer or played outside the pairing). With a switching rate at the offer around 45% (SD 0.50) and the two versions played by different participants, the within-pair difference has an SD of about 0.70; clustering by participant (each in about five pairs, ρ = 0.3) inflates the standard error by about 1.15, giving a minimum detectable effect of 2.80 × 0.70 × 1.15 / √3,800 ≈ 3.5 percentage points.

**Composition of sunk time.** For a coefficient on a continuous variable, the minimum detectable effect is 2.80 × SD(outcome) / (residual SD of the variable × √n), where n is the effective number of observations. Full versions give about 2.5 offers per participant; with ρ = 0.3, n = 2.5 × N / (1 + 1.5 ρ) ≈ 2,760 at N = 1,600. With a residual SD of 1.5 cards for the orange–white difference, the minimum detectable effect is about 1.7 percentage points per card.

**Previous sequences.** Same formula, with four transitions per participant (n ≈ 3,370) and, for B2, an indicator that is equal to one in about 40% of cases (SD 0.49): about 4.5 percentage points.

**Framing.** C2: two arms of 800, one observation each in the fourth sequence, switching rate 40%: 2.80 × √(2 × 0.4 × 0.6 / 800) ≈ 7 percentage points. C1: four cells (framing × version) of about 400: 2.80 × √(4 × 0.4 × 0.6 / 400) ≈ 14 percentage points. Using the first three sequences as a baseline (equation (5)) adds precision.

**Regimes.** Two main regimes of 480 participants each, five sequences each, ρ = 0.3: n = 2,400 / 2.2 ≈ 1,090 per regime, giving about 6 percentage points (about 7 at the interim comparison, with about 330 participants per regime); regime 3, if added (about 150 participants, about 72% of its sequences with an offer), against the others: about 8–9 points.

**[DECISION 5]**: replace these approximations with a simulation of participants' behaviour on the instrument's own draws, and recompute them with the pilot's rates (**[DECISION 4]**) before fixing N. Any revision after data collection begins is filed as an amendment.

## 13. Data, code and deviations

The experiment runs in the browser and saves to three tables: one row per participant (survey answers, framing, regime, payments), one row per sequence (everything drawn for that sequence, including its pair and version, and every choice made in it), and one row per paired sequence (its design and which versions have been played). Variable names and definitions are in the data dictionary. All the rules that generate sequences are in the experiment's source code and are described in words in Part I §29. The figures in this document were produced by running that code. Deviations will be reported with their reason and date, and filed as amendments once data collection has begun.

## 14. Pre-launch decisions required

| # | Decision | Why it matters | Recommendation |
|---|---|---|---|
| **1** | **Per-card pay is recorded but not paid.** Each card is worth £0.025 in the data, but participants are paid only the sequence rewards net of penalties, plus the £1.25 show-up fee. | The registered payment structure must match what is paid. | Decide whether to pay it; if not, drop it from the payment description. |
| **2** | Prolific screening: countries, approval rate, exclusion of earlier participants. | Registry country field; external validity. | Exclude anyone who took part in an earlier version of this task. |
| **3** | Which documents are public at registration. | The source code reveals how sequences are generated and paired. | Withhold the code and documentation until complete; publish the consent text. |
| **4** | Pilot: whether and with how many participants. | The switching and giving-up rates used for power are assumed, not observed; the pairing needs enough participants to close pairs. | 60–100 participants, then fix N and register. |
| **5** | Power by simulation. | §12 uses analytic approximations. | Simulate before fixing N. |
| **6** | **Server deployment.** The address of the data server is still a placeholder in the code. | No data is saved, and no pairs are formed, until it is set. | Deploy and test end to end in test mode before the pilot. |
| **7** | **Regime 3.** Off for the pilots and the first 1,000 participants (study link with `&noreg3=1`); added for the rest, at a quarter of them, only if regimes 1 and 2 differ at the interim comparison (§34). | It is the only regime with fully independent timing, but loses about 28% of its offers. | Confirm the 1,000 threshold and the quarter (without `&noreg3=1` the code assigns the four regimes with equal probability). |

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
