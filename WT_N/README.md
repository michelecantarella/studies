# WT Study — Design & Implementation Reference

**Study title:** Value of Wasted Time
**Build:** WT_N (from WT_M: ONE offer, fixed alternative; 25–35-card sequences whose later 10-card sections thin out so that the alternative stays as fair over time as at the offer; reaching the last card without all the winning cards means doing the alternative, as WT_F; paired full/truncated sequences through the backend). **Read §5 "WT_N" first: it supersedes the older sections where they differ.**
**Platform:** Prolific + GitHub Pages
**Files:** `index.html` (frontend) · `backend.txt` (Google Apps Script) · `DATA_DICTIONARY.md` (column-by-column reference for the spreadsheet output)
**Contact:** Michele Cantarella — michele.cantarella@imtlucca.it
**Ethics approval:** Joint Ethical Committee of Scuola Superiore Sant'Anna / Scuola Normale Superiore / IMT Lucca — N. 23/2026, 30 April 2026

---

## 1. What the study measures

How people manage sunk time when a task has an uncertain end. In each of 5 sections, participants work through a **sequence of cards** (each card is a short grid task) to earn the section's reward. The sequence may or may not contain a **winning card**: finding it ends the sequence and pays the reward. At some point an **alternative sequence** of known, fixed length is offered at the same reward; once offered it stays available. If the sequence runs out without a winning card, the participant **can still switch to the alternative** (or give up) and earns the reward by completing it. Giving up (forfeit) loses the reward.

Every card is marked **orange** (it can be the winning card) or **white** (it can't), mixed at random, so the time already spent in a sequence splits into time spent under genuine risk of finishing (orange) and time that could never have finished it (white).

---

## 2. Deployment checklist

1. Create a **new** Google Sheet → Extensions → Apps Script → paste `backend.txt` → Deploy → New deployment → Execute as: Me, Who has access: Anyone → copy the `/exec` URL. Use a spreadsheet of its own: `ensureSheet_` rewrites any header row that doesn't match.
2. In `index.html`, set `BACKEND_URL` to that URL. It is currently the placeholder `PASTE_WT_N_APPS_SCRIPT_URL_HERE`: while it is, nothing is ever sent (the study still runs, locally only).
3. Host `index.html` on GitHub Pages (or any static host).
4. Prolific study link: `https://<host>/index.html?PROLIFIC_PID={{%PROLIFIC_PID%}}&STUDY_ID={{%STUDY_ID%}}&SESSION_ID={{%SESSION_ID%}}`
5. Prolific completion codes: no consent `C1E6TYZR`; study complete `C194BROI`.

---

## 3. Study flow

```
Page load → bootstrap (backend lookup: already completed / connection error / resume / new respondent — §10)
  → Consent  (no consent → Prolific redirect C1E6TYZR)
  → [no PROLIFIC_PID in the link → "What's your Prolific ID?" screen]
  → Survey (2 screens)
  → Training walkthrough (16 steps, comprehension check, unpaid — §6)
  → 5 × [ Briefing screen (reward + reminders) → sequence → section result ]
  → Results (bonus + show-up fee) → backend 'complete' POST → Prolific redirect C194BROI
```

### Missing PROLIFIC_PID

- `STUDY_ID=pilot`: an ID `pilot_xxxxxxxx` is generated automatically.
- Any other study: right after consent a screen asks for the Prolific ID.
- Both cases are logged as `pid_missing_from_link = 1`. A same-tab refresh recovers the ID from `sessionStorage`.

### Background survey

Screen 1: education; employment status (with monthly income after tax if employed/self-employed — digits only, and a confirmation checkbox above £8,000/month, `LABOR_INCOME_WARN_THRESHOLD`); marital status; household size ("I live alone", 2, 3, 4, "5 and more" — stored as `hh_others`, the number of *other* people); who contributes to household expenses (only if not living alone).
Screen 2: SOEP "make ends meet" 7-point scale for this month / a year ago / a year from now; risk (Dohmen et al. 2011) and patience (Falk et al. 2016) 0–10 sliders, which must be moved at least once.
Every question is required (except in debug mode). `STUDY_ID=pilot` and `studentpilot` only ask risk and patience.

### Student version (`STUDY_ID=studentpilot`)

For in-class use: no welcome/consent screens (consent collected in class) — a "student ID or name" screen instead; the full training; amounts shown in **Points** instead of £; a results screen without the show-up fee that asks students to write down their Points total and wait for the save; no Prolific redirect.

---

## 4. Task mechanics

### The grid task (one card)

A 3×3 grid of emoji revealed left to right, one cell every 500 ms (4.5 s), then a 2.5 s countdown auto-submits: ~7 s per card. The participant clicks every instance of the target emoji (2–4 per grid). Each missed target or wrong click costs £0.01 but never stops the sequence. If there was no mouse movement or click at all during a card, a blocking "Are you still there?" screen holds progress until acknowledged (the penalty still applies).

### The sequence

- Length `L ~ Uniform{10..15}` cards. **All cards are visible from the start** as a fanned stack around the grid: upcoming cards to the right, completed ones greyed to the left. However many cards there are, all of them are drawn (the fan compresses to fit the card, on phones too).
- Every card but the last is orange with probability 0.4, independently; **the last card is always orange**.
- `pInside` — the chance the sequence contains the winning card — is shown on the briefing screen next to the reward, and on top of the card throughout. If it does, the winning card is one of the orange cards, uniformly.
- The strip at the bottom of the card says whether the current card can be the winning one; a panel shows cards left.
- **Winning card found** → the sequence ends, reward earned.
- **Last card played without a winning card** → a short note ("No winning card — you are now on the alternative"), then the alternative starts (blue cards). The reward is earned by completing it.

### The offer

When the offer point is reached (§5) the task **pauses**: the instruction line is replaced by a banner "The alternative sequence is now available", with "The task will resume in *N* seconds" (Uniform[10, 30] s) and a **Resume now** button, and the Alternative button turns blue, shows its length and flashes. **Switching is done only with the Alternative button** (now or later), which opens a dialog (**Confirm switch** / **Keep going**). A switch confirmed during the pause is logged as `switched_at_pause = 1`, `pause_outcome = switched`; Resume now = `pause_outcome = resume_now`; the countdown running out = `timeout`. If it runs out while the dialog is open, the task resumes only when the dialog is closed with Keep going. Every opening of the switch dialog is counted in `switch_dialog_opens` (and "Keep going" in `switch_dialog_cancels`). No card runs while the banner is open; when it closes without a switch the Alternative button flashes again.

### The alternative

- **Its length is unknown until offered.** Before that, the Alternative panel is grey, shows "?" and "Locked"; the briefing screen doesn't mention its length.

### Briefing screen (before each sequence)

Section label, then two equal panels side by side in the task screen's panel style — **Reward** over £x (green) and **Chance of a winning card** over y% (orange) — appearing one after the other, then "Earn your reward by finding the winning card or by completing the alternative sequence.", and:

> Remember:
> • Only orange cards can be the winning card.
> • If you reach the end without finding the winning card, you can still switch to the alternative: you still earn your reward by completing it.
> • Once offered, the alternative remains available until the end of the sequence.

then "Start sequence". For the unannounced 5th sequence of the "4" framing group, a bonus-sequence message comes first (§7).
- When the offer fires, the panel turns **blue** with the length.
- After the pause, the blue panel stays a **button**: clicking it opens the same dialog ("Switch to the alternative? You will complete *N* cards…" — **Confirm switch** / **Keep going**). It stays available until the main sequence ends.
- Taking the alternative, by any route, restarts progress on a fixed run of `alt_duration` cards; there is no switching back.

### Give up

The "Give up sequence" panel is always available (main sequence and alternative). Confirming loses the sequence's reward; other earnings are unaffected.

### Dialogs that keep the card running

The "Give up" dialog and the Alternative button's dialog don't pause the card underneath (it keeps auto-submitting behind an opaque overlay). If the sequence ends meanwhile (winning card, auto-switch, finishing the alternative, autokick), that is only revealed after "Keep going" — so the participant can't tell from the dialog whether the card behind it was the last. A confirmed give-up or switch always wins over whatever happened in the background.

### Autokick

A sequence ends immediately when its own mistake penalty reaches its own reward: "Your mistakes in this sequence used up its entire reward". Logged as `auto_kicked = 1`, distinct from a voluntary forfeit.

---

## 5. Parameter generation

> **WT_J supersedes the per-sequence draw, offer and alternative rules below** (kept from WT_F for reference): see *WT_J: two mass points* at the end of this section.

### Per respondent (drawn once at consent, kept through reloads)

- `regime ∈ {0, 1, 2, 3}`, uniform — **`{0, 1, 2}` in the `pilot` and `studentpilot` versions** (no regime 3 there; `allowedRegimes_()`). A `?regime=` URL parameter overrides it, for testing only.
- **Reward pool**: `reward_pool ~ Uniform{£1.00, £1.05, …, £1.50}`, split at random across the 5 sequences — each starts at £0.10 and the rest of the pool is handed out in £0.05 units, each to a uniformly random sequence, until the pool is used up (`drawRewardSplit_()`). Sequence *i*'s reward is `split[i]`. So the five rewards always add up to the pool (never more than £1.50), each is ≥ £0.10 and a multiple of £0.05 (mean £0.25; range seen in 5,000 draws £0.10–£0.70).
- `nSeqFrame ∈ {4, 5}`, 50/50 (§7).
- `pQuintileOrder`: a shuffle of the 5 equal-width `pInside` bands; section *i* draws its `pInside` from band `pQuintileOrder[i]`, so every respondent gets each band exactly once (drawn without replacement).

### Per sequence

```
L        ~ Uniform{10..15}
live[k]  ~ Bernoulli(0.4) for k = 1..L-1;  live[L] = true
pInside  ~ uniform within this section's band, rounded to 5%
           bands = [0.10, 0.90] cut into 5 of equal width (16 points):
           10–25 | 30–40 | 45–55 | 60–70 | 75–90  (each 5% value in exactly one band, all values in a band equally likely)
```

**Offer position.** `pause` = cards completed when the offer appears, drawn **uniformly** over the positions where the cards left are at least the cards already done (`L − pause ≥ pause`, i.e. up to half the sequence; pause 0 always qualifies), and truncated to the cards before the winning one when the regime draws the ending first. E[pause] ≈ 2.5 (≈ 22% of the sequence, max 50%). Same rule in WT_F and WT_G.

**Offer and ending, by regime:**

```
REGIME 1  ending first, offer before it
  ends ~ Bernoulli(pInside);  endPos ~ Uniform(orange cards)
  pause ~ Beta-slices truncated to {0 … endPos-1}  if it ends,  Beta-slices on {0 … L-1} otherwise
REGIME 2  offer first, ending conditional on surviving to it
  pause ~ Beta-slices on {0 … L-1}
  ends ~ Bernoulli( pInside·a/W / (pInside·a/W + 1 - pInside) )   (a = orange cards after pause, W = all orange cards)
  endPos ~ Uniform(orange cards after pause)
REGIME 3  independent
  ends, endPos as regime 1;  pause ~ Beta-slices on {0 … L-1}
  wasted = ends AND endPos <= pause   (the winning card comes before the offer point, so no offer appears)
REGIME 0  each SEQUENCE re-rolls regime 1 or 2 (logged as sub_regime); never 3
```

Regime 1 leaks information (a later offer implies a later or no ending); regime 2 is flat and never wastes the offer; regime 3 is flat but can waste it.

**Alternative.** Drawn at the offer with a right triangle: the distance from the pause to the last card is the hypotenuse, the alternative is the sum of the two legs; it stays fixed for the rest of the sequence:

```
h              = L - pause
theta          ~ Uniform(0, 90°)
alt_duration   = round( h · (cos theta + sin theta) )   ∈ [h, round(h·√2)] = [alt_window_lo, alt_window_hi]
alt_global_end = pause + alt_duration
```

Never shorter than the rest of the sequence. Same rule as WT_G. Example: L = 10, offer after 4 cards → alternative ∈ [6, 8] cards. Both the arithmetic (`e_tot_at_pause`) and the geometric-mean (`e_geo_at_pause`) cost of staying are logged.

**Pay.** `pay` = this sequence's share of the respondent's reward pool (above). Drawn independently of the sequence's own draw, so it can't leak anything about it.

**Logged benchmarks.** Computed with the beliefs participants are given — winning card in the sequence with probability `pInside`, equally likely on any orange card, independent of the offer — and **never with the regime**, which participants don't know about. Participants see `seq_len`, the pattern and `pInside` from the start; orange cards passed without a win are ruled out (Bayes).
- `e_rem_at_start`: expected length of the main sequence at its start.
- `e_rem_at_pause`, `p_ahead_at_pause`: expected main cards still to play, and probability the winning card is still ahead, at the offer.
- `e_rem_at_exit`, `p_ahead_at_exit`: the same where the main sequence was left (**exit point**: `exit_type`, `sunk_cost_at_exit`); 0 at a natural end.
- `penalty_at_pause`, `penalty_at_exit`: the sequence's penalty at those points.
- Rationality: staying costs `e_rem + (1 − p_ahead) × alt_duration` cards in expectation (without a winning card they are moved onto the alternative); switching costs `alt_duration`. `switch_gain_at_pause/exit` = staying − switching (> 0 ⇒ switching is better in expectation), with dummies `switch_better_at_*`; `alt_minus_expected = −switch_gain_at_pause`. Definitions in `DATA_DICTIONARY.md`.

**Simulated design moments** (200,000 offers, all regimes pooled, generated by the study's own code): switching at the offer is the shorter option in expectation in **72%** of offers and beats the geometric-mean cost of staying in **48%**. Alternative: median 10 cards (5–95%: 6–18), max 21. By `pInside` (EV / geometric): 30% 100/97, 40% 100/69, 50% 100/37, 60% 73/17, 70% 33/8, 80% 9/3.

Composition of elapsed time at the offer (orange − white cards already done): the earlier figures (10–15 cards, centred offer) are not yet recomputed for the current rules.

---

### WT_J: two windows, two peaks

- **Sequence.** Two sections of 7–12 cards each (WT_K; 10–15 in WT_J), joined directly. First the share of orange cards in the whole sequence is drawn (25–50%); then each section gets one uniform density, set so that the expected share of orange cards in the left section is `p_band`: every card is orange independently with its section's density (card 1 never; no card above 75%). The last card is always orange (made orange if drawn white), so a sequence has 14–24 cards (median 20). The draw is repeated until the realised share falls inside the sequence's band (±2.5 points) and each section has at least 2 orange cards.
- **Winning card.** Always exists, uniform over all orange cards: the chance it is in the first window is `p_first = n_first/(n_first + n_second)` ≈ `p_band`. **No number is shown**: participants are told only that every orange card is equally likely.
- **Offer.** Uniform on 0 … min(round(0.35·length), E1 − 1) cards completed: from before the first card up to 35% of the whole sequence, always before the left section's last orange card, so the time already spent at the offer varies from zero. Regimes as WT_F.
- **Alternative.** Always longer than the longest white stretch anywhere in the sequence, and than the best outcome (E1 − pause cards), and always shorter than the worst (length − pause cards); a sequence where this is impossible is redrawn. Let E = expected cards still to play at the offer: a coin (probability 0.75) decides whether it is shorter than E or longer, then its distance from E is E·|e|, e ~ N(0, 0.15) truncated to ±0.30, within the bounds. In about a third of offers no alternative shorter than E fits, which is why the coin is 0.75: overall switching is the shorter option in expectation in 50% of offers (regimes 2 and 3; 48% in regime 1).
- **Simulated** (30,000 sequences): realised share ending in the first window ≈ `p_band` (bands 1 and 5 move inwards to 22% and 78% because of the 2-card minimum); no peak with a single orange card; mean end card 10–18 by band; ends by card 3 in 1–8%; offer after 4–4.5 cards on average (5–95%: 1–9); alternative 11 cards (5–95%: 6–17); switching is the shorter option in expectation in 50–51% of offers in regimes 2 and 3 (47% in regime 1; geometric mean 6–7%); regime 3 loses 16% of offers; actual minus expected remaining cards at the offer −1.2 in regime 1 (leak), +0.02 in regime 2, −0.01 in regime 3.
### WT_K: three winning cards, deck choice

- **Winning cards.** Three per sequence, a uniform set of three of its orange cards (participants are told every orange card is equally likely to be one of them). The sequence ends when the third is found. Above the deck, a tracker shows three slots, dashed until each winning card is found, then gold with a star (the one just found pops). Benchmarks (`e_rem_*`, `switch_gain_*`, geometric mean) use these beliefs: with j found, the remaining 3 − j are a uniform set among the orange cards still ahead, and the end is the largest of them.
- **Offer and regimes.** Regime 1: the three winning cards w1 < w2 < w3 first, then the offer uniform on 0 … floor(w2 + (w3 − w2)/2) cards completed (before w3): on average around the first winning card. Regime 2: the offer first, drawn from that rule's distribution averaged over every possible set of winning cards of the sequence (`pauseDistR1_`), then a uniform set whose third card comes after it. A deck is redrawn if, at the offer, the main sequence's ending is certain (as many orange cards ahead as winning cards still to find). Regime 3: offer as regime 2 and winning cards independent; lost if all three come before the offer (about 4%). 0: 1 or 2 per sequence. The 35%-of-sequence cap of WT_J no longer applies.
- **Orange cards.** 35–50% of all cards (drawn first), then uniform densities per section from `p_band`, as WT_J.
- **Alternative.** A scenario is drawn: 0, 1 or 2 winning cards already found, with weights depending on the number actually found (`CFG.altScenW`: the actual scenario 70% / 50% / 60% with 0 / 1 / 2 found, the other two sharing the rest equally). The alternative is the expected cards from the pause to the third winning card in that scenario (`eRemainingIf_`), rounded, nothing added; kept longer than the longest white stretch of the sequence and than the best outcome, shorter than the worst. Switching is the shorter option in expectation in 49–50% of offers (63% / 46–49% / 13–14% with 0 / 1 / 2 found). Deck tiles highlight on hover. Training: step 11 shows a winning card being found; the two switching steps are merged; the walkthrough has 16 steps.
- **Deck choice.** Before each sequence 1, 2 or 3 decks are shown (equally likely), as strips of orange and white cards, in random order. One is the default (the sequence's own band); the others are drawn separately (any band, sometimes longer sections) and kept only if their expected cards to the third winning card are at least 4 more and 25% more than the default's (median 1.36 times; non-default sections at most 3 cards longer, so no deck exceeds 30 cards; if 150 draws fail, the worst found is kept if at least 2 expected cards more, else one deck fewer is shown: under 1% of non-default decks). Decks are drawn to scale on a 30-column grid (one column per card of the longest possible deck). With one deck the screen says "Your next deck"; with more, "Choose your next deck" and Start is enabled once one is selected. The deck chosen is the one played (offer, alternative and winning cards drawn for it). Logged: `n_decks`, `deck_default_pos`, `deck_chosen_pos`, `chose_default`, `deck_e_start_options`, `deck_e_start_chosen`; also `winning_cards`, `winners_found_at_pause`, `winners_found_at_exit`, and `is_winner` per card in `tasks_json`.
- **Simulated** (12,000 sequences per regime, 7–12-card sections): sequence 14–24 cards (median 20); offer after 5.6 cards on average (0–13), on average on the first winning card; 0 / 1 / 2 winning cards already found at the offer in 48 / 32 / 20% of offers; 2.3 orange cards before the offer; alternative 10 cards (5–16); third winning card on card 16–17 (median, 5–95%: 8–22); regime 3 loses 4–5% of offers; regime 1 leak −0.5 cards, regimes 2 and 3 none.

### WT_L: shown chance per orange card, long sequence that pays at its end

> Supersedes the WT_J/WT_K sequence, offer-band and alternative sections above where they differ.

- **Sequence.** 30–35 cards (uniform; worse decks up to 5 more, so at most 40). Calibration window = the first 10 cards (`CFG.calibCards`), tail = the rest. **Each side gets 3 orange cards at random positions (uniform), as a minimum.** On top, every other card is orange with its chance under a shape drawn per sequence over **all** its cards (`drawShape_`), uniform (`CFG.shapeFamilies = ['uniform']`; mass-point shapes kept in the code, unused), at a share drawn in 70–85% (worse decks 20–32%), so white runs stay short (longest median 2, 95%: 3). At least 5 orange cards in the first 10 (`CFG.minOrangeWindow`) and 3 in the tail, at random positions. No card above 85% (`CFG.cardPMax`). q is now calibrated on the first 10 cards' **actual** orange cards (`CFG.qFreq = 'realized'`), so three winning cards fall there in `p_band`% of the cases sequence by sequence; q shown median 15 / 25 / 30 / 35 / 45% by band. Switching better in 47–48% of offers (49–50 / 49–51 / 39–42% with 0 / 1 / 2 found). Logged: `orange_share`, `shape_family`, `shape_params`.
- **Winning cards — current model (`CFG.hazard = 'split'`, supersedes the q paragraph below).** Each winning card not yet found has the same chance h of being on the orange card in play, and a card holds at most one: with r still missing, an orange card is a winning card w.p. r·h (h ≤ 33%, `CFG.hMax`). Winners are drawn card by card from the start; finding one removes it, so the chance per orange card falls from 3h to 2h to h. **h is shown inside each empty box of the winning-card tracker** (found boxes show the star); the card banners carry no number. h is calibrated on the first 10 cards' actual orange cards (at least 6, `CFG.minOrangeWindow`), rounded to 1%: three winning cards within the first 10 cards 17 / 35 / 50 / 65 / 79% by band (target 17 / 35 / 50 / 65 / 83%; the top band falls short because h is capped). h shown median 11 / 17 / 20 / 26 / 33%. Expected cards left at the offer fall less with progress (median ~14 / 11 / 7 with 0 / 1 / 2 found). Alternative ('noise') half-width ≈ 3 / 3 / 4 cards; switching better in 44–45% of offers (48–49 / 47–48 / 36–37% with 0 / 1 / 2 found), 50% at every level without the white-stretch floor. Logged `p_card` = h.
- **Winning cards and q (older 'const' model).** Every orange card is a winning card independently with probability q, the **only probability shown**. q is calibrated on the window with its **expected** orange frequency f (the 3 placed cards plus the shape's chances, not the cards actually drawn; `CFG.qFreq = 'window'`): h solves P(at least 3 winning cards in 10 cards, each w.p. h) = `p_band`, q = h / f, rounded to 5% (5–95%). So three winning cards fall within the first 10 cards in `p_band`% of sequences on average (simulated 17 / 35 / 50 / 66 / 85% by band), and q never jumps because few orange cards happened to come out. Nothing is redrawn. (`'seq'` uses the whole sequence's realised frequency instead; it over-shoots, because the window holds 3 guaranteed orange cards in only 10.) Logged: `p_card` (q), `p_all` (chance of 3 winning cards within the window given its actual orange cards), `p_all_seq` (anywhere in the sequence), `half_len` (= 10), `n_live_first_half`, `p_band`, `n_winners_in_seq`, `winning_cards`.
- **End.** The sequence ends on the third winning card or, failing that, on its last card: **reaching the end also earns the reward**, after playing every card (the bad outcome). No compulsory alternative. Benchmarks: each orange card ahead is a winning card w.p. q (negative-binomial end distribution, the rest of the mass on the last card); staying costs the expected main cards.
- **Offer and regimes.** Uniform on 0 … floor(¾ × 10) = 7 cards completed (`CFG.offerHalfShare`), whatever the winning cards. Regime 1 truncates it before the third winning card; regime 2 draws the winning cards conditional on the third coming after the offer (exactly, `pickWinnersSurviving_`, not by redrawing); regime 3 loses the offer if it comes first. A deck is redrawn if the ending is certain at the offer (fewer orange cards ahead than winning cards still to find).
- **Alternative (`CFG.altRule = 'noise'`).** Centred on E_a, the expected main cards from the offer given the winning cards actually found (to the third, or to the last card), plus a uniform variation of half-width h: with 1 found, the smaller of the gaps to the 0-found and 2-found expectations; with 0 found, the gap to 1 found; with 2 found, the gap to 1 found (× `CFG.altNoiseScale` = 1). On average it equals the expected stay. Rounded; kept longer than the longest white stretch and than the best case, and shorter than the cards left. Simulated: h median 4.5 / 3.7 / 3.8 cards with 0 / 1 / 2 found; alternative median 13 / 8 / 6; switching better in 38–39% of offers (47–48 / 38–39 / 13%); without the white-stretch floor 47% (49–50 / 47–48 / 39–40%). The floor raises the alternative in 63% of offers with 2 found. An optional cap on white runs (`CFG.maxWhiteRunCap`, off) barely helps: even at 3 cards the floor still raises it in 45% of them. (`'scen'`, WT_K's scenario draw with `CFG.altScenW`, is kept.)
- **Deck choice.** Same h for every deck shown. Worse decks: sparser (30–40% orange of all their cards, spread uniformly, 3 guaranteed in the first 10 and 3 in the tail) and always 2–5 cards longer than the default (at most 40). Kept if they have fewer orange cards than the default — a filter on the count only, so it does not favour decks with long white gaps (the old "4 more expected cards" filter did). Simulated: median 6.8 more expected cards, 17% with fewer than 4 more. No white run longer than 8 cards in any deck (`CFG.maxWhiteRunCap = 8`: a random card of a longer run turns orange). Decks drawn to scale on a 40-column bar.
- **Simulated** (`qFreq = 'seq'`): q shown median 30 / 40 / 50 / 60 / 75% by band; three winning cards within the first 10 cards 22 / 43 / 59 / 76 / 91% (`p_band` 17 / 35 / 50 / 65 / 83%), before the end of the sequence 87 / 98 / 100 / 100 / 100%; 0 / 1 / 2 found at the offer 42–47 / 33–34 / 19–25%; expected cards still to play at the offer (median) 11–12 / 7 / 3 with 0 / 1 / 2 found.

### WT_N: one offer, a Pareto decay that keeps the alternative equally attractive, the alternative owed at the end

> Supersedes the WT_M section below (and the older ones) where they differ. Tuned with `deck_lab.html` (same model; it rolls decks and shows the fair alternative card by card).

#### How a WT_N sequence is generated, step by step (`designSeed_`)

1. **Draws.** Winning cards n (1 / 2 / 3 w.p. 25 / 25 / 50%), length L ~ U{30, …, 35}, initial density d0 ~ U(0.40, 0.60) with n = 1 or U(0.55, 0.65) with n = 2–3, calibration window W ~ U{2 + 2n, …, 6 + 2n}, p_band from the sequence's band, debt share k ~ U(0.75, 1).
2. **Model.** With r winning cards missing, an orange card holds one w.p. min(1, r·h) (h = the chance shown in each box). For a card-chance vector x (densities, or 0/1 for cards already drawn), backward recursion gives, from card t with r missing, the expected main cards E_t(r) and the chance P_t(r) of finding them all; forward recursion from the offer card o gives the share of those still playing with r missing, π_t(r). The fair alternative if offered at card t, for those still playing (winning cards found by then counted as expected, the alternative owed at the end), is A*(t) = Σ_r π_t(r) E_t(r) / Σ_r π_t(r) P_t(r) (`fairCurve_`).
3. **Decay curve.** d_t = max(3%, d0 · (ρ + (1 − ρ) · (1 + t/τ)^(−α))), t = 0 … L − 1: a Pareto-type decay from the first card towards the floor ρ·d0; the last card counts as certainly orange (it is forced, step 6).
4. **Fit (`fitDecay_`).** (ρ, τ, α) minimise the survivor-weighted RMS of A*(t) − A*(o) over t > o (weights Σ_r π_t(r)), with o = 1 (`decayFitOffer`), subject to (a) A*(o) ≤ 1.5 × its value with no decay (`decayMaxLonger`: a lower density later makes staying dearer at the offer too) and (b) no card more than 12% less likely to be orange than the one before (`decayMaxStep`). Search: the no-decay curve plus a grid ρ ∈ {0.1, …, 0.9}, τ ∈ {1, 2, 4, 8, 16}, α ∈ {0.5, 1, 1.5, 2, 3}, then three rounds of local refinement (ρ ± 0.05, τ × (1 ± 0.5), α ± 0.25, halved each round). With n = 1 the best curve is flat (no learning: a constant density keeps A* constant); with n = 2–3 A* must dip on the first cards (no one can finish there) and the decay wins it back later. The fitted ρ, τ, α and the RMS drift are saved in `shape_params`.
5. **h.** First set so that all n winning cards fall within the window in p_band of the cases in expectation over the window's densities (`hForPExp_`), the curve fitted, h re-set on the fitted window densities and the curve refitted.
6. **Cards.** Drawn one by one with the debt (`drawWithDebt_`): card t is orange w.p. min(97%, max(2%, d_t + k · (orange cards expected so far − drawn so far))). Then at least 1 / 4 / 7 orange cards in the window (n = 1 / 2 / 3; random positions) and the last card orange.
7. **Realized calibration.** h re-set on the window's orange cards as drawn (all n within them w.p. p_band, `hForP_`), rounded to 1% and capped at 95 / 50 / 33%; the curve refitted with the window cards as drawn and the cards after the window redrawn (debt restarting at 0), the last card orange again.
8. **Offer (`drawOffersM_`).** After 1–10 cards, P(k) ∝ k², before the last winning card, by regime (see Offer); the alternative = its fair value on the sequence as drawn × (1 ± U(0, 15%)), at least 5 and the best case + 1, at most 2 × the cards left; offers with a fair value outside 4.7–26 redrawn (regimes 1–2) or dropped (regime 3); offers with fewer orange cards ahead than winning cards missing never shown.
9. **Pair.** The full sequence is one version; the other is cut at the offer (`deckFromSeed_`): 0 cards completed, only the winning cards still missing, the same cards ahead, h and alternative.

- **Sequence.** Length drawn first, 30–35 cards (uniform). Winning cards n = 1 / 2 / 3 in 25 / 25 / 50% of the sequences (`nWinnersW`); with r missing an orange card holds one w.p. r·h. No boxes already filled at the start (`giftShowP` = 0). The last card is always orange (reaching it without all the winning cards means doing the alternative); the decay fit counts it as certainly orange. The cards are drawn one by one with a carried debt: card t is orange w.p. its density + k × (orange cards expected so far − drawn so far), k ~ U(0.75, 1) per sequence (`drawDebtKLo/Hi`, saved as `draw_debt_k`): white runs still happen at random but are made up for on the following cards (simulated with k = 1: offers out of bounds 8% → 5%, longest white run at most ~8 instead of ~20).
- **Density (`fitDecay_`).** The chance that card t is orange decays from the first card along a Pareto-type curve towards a floor: d_t = d0 · (ρ + (1 − ρ) · (1 + t/τ)^(−α)), d0 ~ U(0.40, 0.60) with 1 winning card and U(0.55, 0.65) with 2–3 (`d0By`; a denser start, 85–95%, gave almost all-orange decks and no better fit once the per-card drop is capped). ρ, τ and α are fitted on each sequence so that the **fair alternative** if it were offered at any card stays as close as possible to the one at the offer: for those still playing at card t (counting the winning cards they may have found, the future cards at their density), staying costs the main cards left + P(not all found) × A, owed at the end, and the fair alternative is the A equal to that cost. The fit minimises the survivor-weighted distance from the value at the offer, with the alternative at the offer at most 1.5 × its value with no decay (`decayMaxLonger`; a lower density later makes staying dearer at the offer too); lowest density 3% (`decayDMin`); no card more than 12% less likely to be orange than the one before (`decayMaxStep`: without it ~10% of the fits with 2–3 winning cards had a 50%+ cliff; the drift is unchanged); fitted for an offer after 1 card (`decayFitOffer`). With 1 winning card the best decay is none; with 2–3 the fair alternative must dip a little on the first cards (no one can finish there) and the decay wins it back later. Example (n = 2): 57 / 51 / 47 / 44 / 43% on cards 1–5, 38% by card 12.
- **Calibration.** h is calibrated on a **calibration window** of W ~ U(2 + 2n, 6 + 2n) cards (4–8 / 6–10 / 8–12) holding at least 1 / 4 / 7 orange cards (`minWindowBy`): all n winning cards fall within the window in `p_band`% of the cases, on the window's orange cards as drawn; the decay is then refitted with the window as drawn and the cards after it redrawn. Bands 25–35, 40–45, 50, 55–60, 65–75% (`pBandValues`; the extremes dropped).
- **End.** On the n-th winning card. Reaching the last card without all of them moves the participant onto the alternative (or give up), as WT_F: the "No winning card" note.
- **Offer.** ONE offer (`maxOffers`), after 1–10 cards completed (`offerLo/Hi`; never at 0, where the two versions of a pair would be the same), P(after k cards) ∝ k² (`offerPosPow`: mostly late, fewer low-cost pauses, since the pairs already give the zero-cost side), always **before the last winning card**; the winning cards found by then stay found, and the alternative stays available to the end. Regime 1: winning cards drawn first, then the offer from that distribution capped at the card before the last one. Regime 2: the offer first, from regime 1's distribution on the same sequence (`pauseDistDraws` draws), then the winning cards redrawn until the last one comes after it (this conditioning makes all the winning cards fall within the calibration window about half as often as in regime 1: 12 / 20 / 25 / 31 / 48% by band; only the chance per box is ever disclosed). Regime 3 (a small check): the offer from regime 1's distribution on the same sequence (`pauseDistDraws` draws), the winning cards independently, no redraw: if the last winning card comes first the offer is never made and the sequence ends there (wasted; played in full, not pairable). Participants: regimes 0 / 1 / 2 / 3 = 30 / 30 / 30 / 10% (`regimeW`; no regime 3 in the pilots, nor when the STUDY_ID contains `noreg3` or the link has `?noreg3=1`); 0–2 are the main ones, compared with each other. Simulated: offer after median 6 (regime 1) / 8 (regime 2) / 5 (regime 3) cards; 0 / 1 / 2 winning cards found at the offer 26 / 34 / 39% (regime 1), 28 / 35 / 37% (regime 2); regime 3 wastes 27% of its offers (44% with the 1–10 distribution), about 3% of all sequences. (Until 2026-10-27 WT_N wrongly kept WT_M's first-offer window, 0–3 cards before the first winning card.)
- **Alternative.** Its fair value on the sequence as drawn, A = E / p (E = expected main cards from the offer, p = chance of finding all the missing winning cards), × (1 ± U(0, 15%)) (`altNoiseShare`); at least 5 cards (`altMin`) and the best case + 1, at most 2 × the cards left. Only offers whose fair alternative is within 4.7–26 cards (its 5th–95th percentiles, `altFairLo/Hi`): outside, the sequence is redrawn (regimes 1–2) or, in regime 3, played without an offer (`offer_out_of_bounds` = 1). Simulated: alternative p5 5–6, median 10–11, p95 22, max ~30; switching better at the offer 46–51%; regime 3 without an offer 34% (7% of them out of bounds); in regime 1 all the winning cards fall within the calibration window slightly more often in bands 1–2 (34 / 51% against 30 / 43%).
- **Simulated** (150 sequences per n × band, on the page code). Alternative median by band 1→5: n = 1: 20 / 12 / 9 / 8 / 6; n = 2: 22 / 16 / 13 / 11 / 8; n = 3: 29 / 22 / 18 / 15 / 11 (above 18 cards: 56% for n = 1 and 70% for n = 2 in band 1, 93 / 75 / 47 / 21% for n = 3 in bands 1–4). Drift of the fair alternative from the one at the offer (survivor-weighted mean, from the densities, the window as drawn): 1.4–1.8 cards (n = 1), 1.3–2.1 (n = 2), 2.0–4.1 (n = 3). For those still playing on the sequence as drawn, staying minus the alternative at cards 10 / 20: −0.4 … +0.8 (n = 1), −1.3 … +0.3 (n = 2), −2.1 … 0.0 (n = 3; worst in band 1). Switching better at the offer 38–56%. Reaching the end without all the winning cards 1–21% (n = 1), 3–23% (n = 2), 5–32% (n = 3). All within the window: equal to the target ±1 point. Design time ~30 ms (slowest ~95 ms); pairing 0 mismatches; worse decks +10 expected cards (median).
- **Pairs.** Each sequence is played in full by one participant and truncated at its offer by another: the truncated version starts at 0 cards completed with only the winning cards still missing in the tracker (none shown as already found), the same cards ahead, h and alternative. `pairs_lab.html` generates any number of pairs with the page's own generator and summarises them (offer position, winning cards found, alternative, truncated length). `proto_brute.html` shows real pairs (both versions, in random order). Both pages carry a verbatim copy of the generator: after a change to `index.html` run `node WT_N/tools/sync_wtn_code.js WT_N/index.html WT_N/proto_brute.html WT_N/pairs_lab.html`.
- **Pairing, deck choice, layout.** As WT_M (full / truncated at the offer, Seeds sheet). Worse decks: same h and decay shape, initial density × 0.45–0.70, 2–5 cards longer (up to 40): median +10 expected cards. Right column: Cards completed, Cards left and Alternative cards are fixed-size tiles showing a number only; during the offer pause Cards left is the orange Resume button ("Press to resume") and the Alternative is the blue Switch button ("Press to switch"); Give up is under the Alternative.
- **Training.** As WT_L (17 steps), with 1–3 winning cards and the alternative owed at the end. The tracker shows no chance per box until screen 11, where it appears and flashes (screen 10: winning cards only on orange cards; screen 11: each has the same chance of being on any orange card, here 20%).
- **Data.** Responses: `d1` = the initial density, `densities` = each card's orange chance, `shape_family` = `pareto`, `shape_params` = ρ, τ, α, the drift and W; `calib_window`; plus WT_M's pairing / tracker columns; the single-offer columns refer to the one offer. No `Offers` sheet. `e_tot_*` and `switch_gain_*` include the alternative owed at the end.
- **Brute force.** `proto_brute.html`: real WT_N pairs (see Pairs), regime 0, the WT_N Resume / Switch tiles; data per answer: pair, version, sunk cards, winning cards, h, alternative, fair alternative, expected cost of staying.

### WT_M: decaying orange cards, 1–3 winning cards, repeated offers, paired truncated sequences

> Supersedes the WT_J/WT_K/WT_L sections above where they differ.

- **Sequence.** 30 cards (`CFG.lengthM`). Orange chance d1 ~ U(0.40, 0.60) in cards 1–10, d1·f in 11–20, d1·f² in 21–30, with f ~ U(0.75, 0.90) drawn per sequence (`d1Lo/Hi`, `decayLo/Hi`). At least 3 / 4 / 6 orange cards in the first 10 with 1 / 2 / 3 winning cards (`minOrangeWindowBy`) and at least 3 in every later 10-card section (`minOrangePerSection`; fewer in a short last section), in every deck, at random positions. Simulated orange share 56 / 43 / 38% by section. No cap on white runs.
- **Winning cards.** n = 1, 2 or 3 per sequence (uniform). Each missing winning card has chance h of being on the orange card in play (shown in its box); with r missing an orange card is a winning card w.p. r·h. h is calibrated on the first 10 cards' actual orange cards so that all n fall there in `p_band`% of the cases. `p_band` bands (`CFG.pBandValues`, one sequence per band, uniform within): 10–35% (5% steps), 40–45%, 50%, 55–60%, 65–90%. Simulated: 22–23 / 43–44 / 51–53 / 58–59 / 74–76% by band (targets 22 / 42 / 50 / 58 / 78%); with 3 winning cards the top values (85–90%) stop at ~75% because h ≤ 33%. With n < 3, in half the sequences (`giftShowP`) the tracker shows 3 boxes with 3 − n already filled; the briefing says "This sequence has 3 winning cards, k of them already found".
- **End.** On the n-th winning card or on the last card (reward earned either way). Simulated share reaching the last card without all winning cards: 16% overall; band 1 32–57% (highest with 1 winning card), band 2 11–24%, band 3 5–17%, band 4 4–12%, band 5 1–2%.
- **Offers.** Offer 1 at 0–3 cards completed (`firstOfferMax`); offer k ≥ 2 after winning card k − 1, at most 7 cards later (`offerGapMax`), under the regimes: 1 — winning cards first, offer before the next one; 2 — offer first, the next winning card drawn conditional on coming after it; 3 — independent, the offer is wasted if the next winning card comes first. An offer is not shown if the ending is certain. Each shown offer starts its own pause (10–30 s countdown, "A new alternative sequence is now available" from the second on, the Alternative panel flashing its new length) and re-sets the alternative, which stays available until the next offer. Simulated: 2.0 offers shown per sequence in regimes 1–2, 1.4 in regime 3 (0.6 wasted); switching better in expectation in 48–52% of offers, at every offer.
- **Alternative (per offer).** The expected main cards from the offer with the missing winning cards, ± a uniform variation of half-width = the gap to the nearest neighbouring state (one more or one fewer missing) × `altNoiseScale`; at least the best case + 1, at most the cards left − 1. The white-run floor of WT_K/WT_L is off (`altWhiteFloor`).
- **Pairing.** Each sequence is a design ("seed"). The full version is played by one participant; the truncated version — the same design cut at its first shown offer: the cards before it removed, any winning card found before it shown as already found, later offers shifted — by another. Same cards ahead, h, winning cards and alternatives: only the sunk cards differ (median 1 card, 0–10; the larger sunk-cost contrasts come from offers 2 and 3). Nothing about truncation is shown. Before the first sequence (`prepareSeedPlan_`) the page claims, for each of its 5 bands, an unpaired version from the backend (made by someone else); bands with none get a new design, played full or truncated at random and added to the pool. Designs with no shown offer are played unpaired. A version goes back to the pool if another deck is chosen or the sequence ends before its first offer; a claim older than 3 hours is reopened. Offline (no backend, demomode=2) every sequence is new and unpaired.
- **Deck choice.** The assigned deck is the seed's version (truncated decks are shown as they are). Worse decks: same h and number of winning cards, first-window density × 0.45–0.70, 2–5 cards longer, kept if fewer orange cards and at least max(6, 40% of E) more expected cards (simulated: median 7.7 more). In WT_L, 17 of 17 choices went to the default deck.
- **Layout (also WT_L).** Resume now sits under the Alternative panel and shows only during a pause; Give up is in the left column under Penalties.
- **Training.** As WT_L plus step 14: after the first winning card a new offer with a new pause and length (17 steps, the last is the comprehension check).
- **Data.** Responses gain `n_winners_seq`, `n_winners_needed`, `n_boxes`, `prefilled`, `gift_shown`, `d1`, `decay`, `seed_id`, `seed_version`, `seed_role`, `trunc_offset`, `n_offers_planned`, `offers_plan_json`, `n_offers_shown`, `switch_offer` (the single-offer `pause`/`alt_*` columns refer to the FIRST shown offer). New sheets: **Offers** (one row per offer shown: position = sunk cards, state, alternative, expected stay, decision, timing) and **Seeds** (the pairing pool). See DATA_DICTIONARY.md.
## 6. Training walkthrough

Staged on the real task screen: everything is dimmed except what the current step explains, with a demo sequence (10 cards, orange at 3, 6 and 10, 40%, alternative of 11 cards, £0.10) and a tip box with Back/Continue.

1. The grid task · 2. one practice round · 3. the sequence as a stack of cards (10–15, all visible) · 4. sequence counter (says 4 or 5 per the framing treatment) · 5. reward (earned by the winning card or by completing the alternative) · 6. penalties · 7. give up · 8. the probability of a winning card · 9. white cards · 10. orange cards, the last one always orange · 11. the offer — the alternative's length is revealed only then · 12. switching = clicking the Alternative button (the only way), can't be undone · 13. the pause is short (Resume now), the alternative stays available afterwards · 14. no winning card → they can still switch to the alternative and earn the reward · 15. ready (no payment for the walkthrough) · 16. comprehension check.

**Comprehension check** (must be answered correctly in order; wrong answers are counted per question and the options reshuffled, never putting the right answer back where the participant just clicked):
1. How do I win my reward? → *By finding a winning card or by completing the alternative.*
2. What happens if I reach the end of the sequence without finding a winning card? → *I can still switch to the alternative, and earn my reward by completing it.*
3. What happens if I switch to the alternative? → *My progress resets and I cannot switch back to the main sequence.*

---

## 7. Hidden sequence-count framing

Half the respondents are told the study has 5 sequences, half that it has 4. Everyone plays 5: for the "4" group the 5th opens with "You are being offered an additional bonus sequence" behind its own Continue button. Logged as `seq_frame_treatment` (Meta and Responses) and `seq_is_bonus`.

---

## 8. Payment

| Component | Amount | Condition |
|---|---|---|
| Sequence reward | `pay` (the five add up to `reward_pool`, £1.00–£1.50) | Winning card found, or alternative completed (voluntarily or after the automatic switch). Lost on give-up or autokick |
| Per-card pay | £0.025 per card | Logged (`grid_pay`), not shown on the results screen |
| Mistake penalty | −£0.01 per miss / wrong click | Subtracted from the total bonus: penalties accumulate across sequences and apply even if a sequence is forfeited, switched or abandoned by a reload (as the training says). A sequence ends by autokick when its own penalty reaches its own reward |
| Training bonus | none | `TRAINING_BONUS = 0` (Meta `training_bonus` kept, always 0), so the bonus never exceeds the £1.50 pool cap |
| Show-up fee | £1.25 | Fixed, paid by Prolific |

Results screen: "Your bonus reward" = rewards − penalties, never negative, so at most £1.50 (`Meta.final_bonus`), approved manually; "Your show up fee" = £1.25. Section result screen shows the net amount when there were penalties, and confetti for a paid sequence. **End-of-sequence reveal (everyone):** the result screen also shows the main sequence in miniature with the cards completed outlined (the path taken), the winning card in gold with an arrow, or a gold "No winning card" label, and, if the alternative was taken, its blue cards after it. Announced in the training (last screen) and in the briefing reminders, so participants know the foregone outcome will be revealed.

---

## 9. Data and backend

Two sheets, `Meta` (one row per respondent) and `Responses` (one row per respondent × sequence × attempt) — every column is described in `DATA_DICTIONARY.md`. The client sends each sequence's fields under exactly the `RESP_HEADER` names and `upsertRespRows_` maps them by name.

| Method | Action | Lock | Description |
|---|---|---|---|
| GET | `?action=lookup&pid=XXX` | waitLock 10 s | `{found, study_complete, resume_snapshot}` |
| POST | `action: 'progress'` | tryLock 1 s (skipped if busy) | Upserts Meta + all logged sequence rows |
| POST | `action: 'complete'` | waitLock 10 s, idempotent | Same, sets `study_complete_at`, clears the snapshot |

`is_latest_attempt` is computed on the server (§10).

**Geolocation.** Right after consent the browser asks an IP-geolocation service (`ipapi.co`, falling back to `ipwho.is`; each response is validated) — best-effort, never blocks the study, blank if it fails; skipped with `demomode=2`. This is personal data under GDPR, within the scope of the ethics approval.

**Device.** `device_type` (Desktop/Mobile/Tablet), `browser` and the raw `user_agent`, captured once at consent.

---

## 10. Resume and reloads

- **Same-tab refresh** (F5, back/forward): resumes exactly where the participant was. If that point is at or past the offer, the offer's timed window can't be rebuilt, so it counts as lapsed and the alternative is available from the button.
- **New-session return** (tab closed, other device): resumes on the right screen (survey / training / experiment), but a sequence in progress restarts with a fresh draw, so nobody can reload to see how a sequence plays out. If real progress had been made, the discarded attempt is logged as its own row (`outcome_summary = 'abandoned before reload — superseded by a later attempt'`) and the new one gets `seq_attempt + 1`; the server flags the highest attempt per sequence `is_latest_attempt = 1`.

The two are told apart with `sessionStorage` (key `wtstudy_tab_session`). A snapshot is saved to `localStorage` and to the backend on every section end and every 25 s.

**Bootstrap order:** `demomode=2` or no ID/backend → consent screen. Otherwise backend lookup: unreachable → local snapshot, else a "could not reach the server" screen with Try again (never silently back to consent); study complete → "Thank you, already received"; snapshot found → resume; row but no snapshot → local snapshot; otherwise consent.

---

## 11. Debug mode

| URL | Behaviour |
|---|---|
| `demomode=0` (default) | Production |
| `demomode=1` | Debug bar + Skip survey / Skip training / Skip card / Skip section / Stop; backend active |
| `demomode=2` | Same, backend bypassed, Prolific redirect only logged to the console |

The debug bar shows the regime (and this sequence's sub-regime), the card pattern, `pInside` and its quintile, where the winning card is (or "none → auto-switch after card L"), where the offer fires (or WASTED), the alternative (length, global end and its window, `E[remaining if staying]` and P(winning card ahead) at the offer), pay (with the pool and its five-way split), reloads, framing.

---

## 12. Outcomes (`outcome_summary`)

| Label | When |
|---|---|
| `found the winning card` | Stayed after the pause, found the winning card |
| `found the winning card before the pause` | The winning card came before the pause point (no pause; regime 3) |
| `switched at the pause` | Switched during the pause, completed the alternative |
| `switched after the pause` | Switched later with the Alternative button, completed the alternative |
| `no winning card, took the alternative` | No winning card, chose the alternative, completed it |
| `no winning card, gave up` | No winning card, gave up on the "No winning card" screen |
| `gave up before the pause` / `gave up after the pause` | Gave up in the main sequence |
| `auto-kicked before the pause` / `auto-kicked after the pause` | Autokick in the main sequence |
| any of the three alternative labels + `, then gave up` / `, then auto-kicked` | Started the alternative, then gave up / was auto-kicked |
| `abandoned before reload — superseded by a later attempt` | Discarded by a new-session reload |

---

## 13. Key constants (`index.html`)

```js
const BACKEND_URL = 'PASTE_WT_N_APPS_SCRIPT_URL_HERE'; // Apps Script /exec URL (§2)
const COMPLETION_CODE = 'C194BROI', NO_CONSENT_CODE = 'C1E6TYZR';
const GRID_PAY_PER_TASK = 0.025, SHOW_UP_FEE = 1.25;
const LABOR_INCOME_WARN_THRESHOLD = 8000;

const CFG = {
  numTasks: 5,              // sections (always 5, whatever the framing)
  gridR: 3, gridC: 3,       // 3×3 grid
  revealMs: 500, submitSecs: 2.5,
  winLo: 10, winHi: 15,      // sequence length
  liveMarkP: 0.4,           // orange-card probability (last card always orange)
  pInsideMin: 0.10, pInsideMax: 0.90,     // cut into 5 equal-width bands (§5)
  pauseBetaA: 1,            // offer position uniform up to half the sequence (§5)
  rewardPoolLo: 1.00, rewardPoolHi: 1.50,  // per-respondent reward pool (§5)
  rewardMin: 0.10, rewardStep: 0.05,       // split: each sequence ≥ £0.10, in £0.05 units
};
// offer countdown Uniform[10,30] s; alternative round((L−pause)·(cos θ + sin θ))
```

---

## 14. Participant backup

If the final save can't be confirmed after 8 attempts, the results screen shows an error reference code, Try again, and Download / Copy buttons for an **encrypted** backup (`wt_backup_<pid>_<code>.enc.json`), with instructions to contact the research team immediately (Prolific message or michele.cantarella@imtlucca.it) and not to lose the file.

**Encryption.** Hybrid: a fresh AES-256-GCM key per backup, encrypted with the team's RSA-3072 public key (RSA-OAEP), embedded in `index.html` as `BACKUP_PUBLIC_KEY_SPKI_B64`. The envelope keeps only `prolific_pid`, `study_id`, `error_code`, `created_at` in clear; everything else (the same `study_level` + `sections` the backend receives) can be read only with the private key, which lives outside this folder (`DATA/WastedTime/keys/WT_F_backup_private.pem`) and must never be published. A participant can't read or edit the content; since the public key is public, a determined participant could still forge a whole new file, so `tools/decrypt_backups.R` cross-checks the payoff fields (pays sum to `reward_pool`, earnings consistent with outcome and pay, `final_bonus` = rewards − penalties) — and the server's last progress save can be compared too.

**Decrypting.** `Rscript tools/decrypt_backups.R [folder] [output.xlsx]` (default folder: Downloads): decrypts every backup found (downloaded files, or copied text saved as .txt/.json; older unencrypted `wt_study_backup_<pid>.json` files are read too and flagged), saves `<name>.decrypted.json` next to each, and writes an Excel file with **Meta** and **Responses** sheets in exactly the study sheet's column order (read from `backend.txt`) plus a **Backups** sheet with the checks.
