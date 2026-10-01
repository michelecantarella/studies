# WT Study — Design & Implementation Reference

**Study title:** Value of Wasted Time
**Build:** WT_F
**Platform:** Prolific + GitHub Pages
**Files:** `index.html` (frontend) · `backend.txt` (Google Apps Script) · `DATA_DICTIONARY.md` (column-by-column reference for the spreadsheet output)
**Contact:** Michele Cantarella — michele.cantarella@imtlucca.it
**Ethics approval:** Joint Ethical Committee of Scuola Superiore Sant'Anna / Scuola Normale Superiore / IMT Lucca — N. 23/2026, 30 April 2026

---

## 1. What the study measures

How people manage sunk time when a task has an uncertain end. In each of 5 sections, participants work through a **sequence of cards** (each card is a short grid task) to earn the section's reward. The sequence may or may not contain a **winning card**: finding it ends the sequence and pays the reward. At some point an **alternative sequence** of known, fixed length is offered at the same reward; once offered it stays available. If the sequence runs out without a winning card, the participant is **moved onto the alternative automatically** and still earns the reward by completing it. Giving up (forfeit) loses the reward.

Every card is marked **orange** (it can be the winning card) or **white** (it can't), mixed at random, so the time already spent in a sequence splits into time spent under genuine risk of finishing (orange) and time that could never have finished it (white).

---

## 2. Deployment checklist

1. Create a **new** Google Sheet → Extensions → Apps Script → paste `backend.txt` → Deploy → New deployment → Execute as: Me, Who has access: Anyone → copy the `/exec` URL. Use a spreadsheet of its own: `ensureSheet_` rewrites any header row that doesn't match.
2. In `index.html`, set `BACKEND_URL` to that URL. It is currently the placeholder `PASTE_WT_F_APPS_SCRIPT_URL_HERE`: while it is, nothing is ever sent (the study still runs, locally only).
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

When the offer point is reached (§5), the instruction line is replaced by a banner: "The alternative sequence is now available — Do you accept the offer? *N* cards", with **Accept and switch** / **Refuse and stay** and a countdown of Uniform[10, 45] s. Pressing either button opens a confirm popup (**Confirm** / **Undo**) while the same countdown keeps running. If time runs out with no choice, the participant stays (`auto_refused`); if it runs out on the confirm popup, the pending choice is committed (`auto_confirmed`). No card runs while the banner is open.

### The alternative

- **Its length is unknown until offered.** Before that, the Alternative panel is grey, shows "?" and "Locked"; the briefing screen doesn't mention its length.

### Briefing screen (before each sequence)

Section label, then two equal panels side by side in the task screen's panel style — **Reward** over £x (green) and **Chance of a winning card** over y% (orange) — appearing one after the other, then "Earn your reward by finding the winning card or by completing the alternative sequence.", and:

> Remember:
> • Only orange cards can be the winning card.
> • If you reach the end without finding the winning card, you are moved to the alternative automatically: you still earn your reward by completing it.
> • Once offered, the alternative remains available until the end of the sequence.

then "Start sequence". For the unannounced 5th sequence of the "4" framing group, a bonus-sequence message comes first (§7).
- When the offer fires, the panel turns **blue** with the length.
- After the banner closes (refused or lapsed), the blue panel is a **button**: clicking it opens a dialog ("Switch to the alternative? You will complete *N* cards…" — **Confirm switch** / **Keep going**). It stays available until the main sequence ends.
- Taking the alternative, by any route, restarts progress on a fixed run of `alt_duration` cards; there is no switching back.

### Give up

The "Give up sequence" panel is always available (main sequence and alternative). Confirming loses the sequence's reward; other earnings are unaffected.

### Dialogs that keep the card running

The "Give up" dialog and the Alternative button's dialog don't pause the card underneath (it keeps auto-submitting behind an opaque overlay). If the sequence ends meanwhile (winning card, auto-switch, finishing the alternative, autokick), that is only revealed after "Keep going" — so the participant can't tell from the dialog whether the card behind it was the last. A confirmed give-up or switch always wins over whatever happened in the background.

### Autokick

A sequence ends immediately when its own mistake penalty reaches its own reward: "Your mistakes in this sequence used up its entire reward". Logged as `auto_kicked = 1`, distinct from a voluntary forfeit.

---

## 5. Parameter generation

### Per respondent (drawn once at consent, kept through reloads)

- `regime ∈ {0, 1, 2, 3}`, uniform — **`{0, 1, 2}` in the `pilot` and `studentpilot` versions** (no regime 3 there; `allowedRegimes_()`). A `?regime=` URL parameter overrides it, for testing only.
- **Reward pool**: `reward_pool ~ Uniform{£1.00, £1.05, …, £1.50}`, split at random across the 5 sequences — each starts at £0.10 and the rest of the pool is handed out in £0.05 units, each to a uniformly random sequence, until the pool is used up (`drawRewardSplit_()`). Sequence *i*'s reward is `split[i]`. So the five rewards always add up to the pool (never more than £1.50), each is ≥ £0.10 and a multiple of £0.05 (mean £0.25; range seen in 5,000 draws £0.10–£0.70).
- `nSeqFrame ∈ {4, 5}`, 50/50 (§7).
- `pQuintileOrder`: a shuffle of the 5 quintile bins of the `pInside` distribution; section *i* draws its `pInside` from bin *i*, so every respondent gets each bin exactly once.

### Per sequence

```
L        ~ Uniform{10..15}
live[k]  ~ Bernoulli(0.4) for k = 1..L-1;  live[L] = true
pInside  ~ Normal(0.5, 0.2) clamped [0.10, 0.90], rounded to 5%, drawn within this section's quintile bin
```

**Offer position.** `pause` = cards completed when the offer appears (0 … L−1), drawn from a **Beta(2, 2)** over the sequence, discretised into one slice per card: `P(pause = k) ∝ Beta(2,2) mass on [k/L, (k+1)/L]`. Offers are centred; at the very start or end they are rarer (for L = 12: 0 or 11 about 1.6% each, 5 or 6 about 12% each). When the regime draws the ending first, this distribution is **truncated** to the cards before the winning one and renormalised.

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

**Alternative.** Its end is drawn uniformly from a hidden "shadow window" right after the main one, of the same length:

```
alt_global_end ~ Uniform{L+1 … 2L}        (overall card number where it ends if taken at the offer)
alt_duration   = alt_global_end - pause   (the cards the participant actually sees and does)
```

So switching the moment it is offered always finishes after the main sequence's last card, whatever `pInside` is. Staying is a gamble: finish earlier if the winning card is still ahead, or later (rest of the sequence plus the alternative) if it isn't. Example: L = 10, offer after 7 cards → global end ∈ [11, 20] → alternative ∈ [4, 13] cards.

**Pay.** `pay` = this sequence's share of the respondent's reward pool (above). Drawn independently of the sequence's own draw, so it can't leak anything about it.

**Logged benchmarks.** At the offer: `p_ahead_at_pause` (probability the winning card is still ahead, given the disclosed `pInside`, the visible pattern, and the orange cards already passed) and `e_rem_at_pause` (expected further cards if staying: winning card ahead, else rest of the sequence + the alternative); `alt_minus_expected = alt_duration − e_rem_at_pause`. `e_rem_at_start` is the same formula at card 0 with the same alternative, so `e_rem_at_pause − e_rem_at_start` is the update from the cards passed before the offer. `penalty_at_pause` is the sequence's penalty when the offer fired. The same quantities are also logged at the **exit point**, the last stay-or-leave decision in the main sequence (`exit_type`, `sunk_cost_at_exit`, `p_ahead_at_exit`, `e_rem_at_exit`, `penalty_at_exit`). The rationality benchmark at both points is `switch_gain_at_* = e_rem_at_* − alt_duration` (> 0 ⇒ switching is better in expectation), with dummies `switch_better_at_*` — definitions in `DATA_DICTIONARY.md`.

**Simulated design moments** (15,000 sequences per regime, generated by the study's own code):

| | P(winning card) | offer wasted | E[L] | E[alt_duration] | alt_minus_expected mean / SD | P(alternative shorter in expectation) | E[cards to reward, never switching] |
|---|---|---|---|---|---|---|---|
| Regime 0 | 0.46 | 0 | 12.5 | 14.0 | −0.04 / 3.9 | 0.56 | 18.0 |
| Regime 1 | 0.52 | 0 | 12.5 | 14.5 | 0.09 / 4.1 | 0.55 | 16.4 |
| Regime 2 | 0.40 | 0 | 12.5 | 13.4 | −0.23 / 3.7 | 0.58 | 19.4 |
| Regime 3 | 0.53 | 0.22 | 12.5 | 13.6 | −0.20 / 3.7 | 0.57 | 19.7 |

Composition of elapsed time at the offer (orange − white cards already done): total SD ≈ 2.2–2.4 cards, of which 86–91% of the variance is within cells of (L, pause, pInside) — i.e. random given everything the participant sees that matters for the forward-looking choice.

---

## 6. Training walkthrough

Staged on the real task screen: everything is dimmed except what the current step explains, with a demo sequence (10 cards, orange at 3, 6 and 10, 40%, alternative of 11 cards, £0.10) and a tip box with Back/Continue.

1. The grid task · 2. one practice round · 3. the sequence as a stack of cards (10–15, all visible) · 4. sequence counter (says 4 or 5 per the framing treatment) · 5. reward (earned by the winning card or by completing the alternative) · 6. penalties · 7. give up · 8. the probability of a winning card · 9. white cards · 10. orange cards, the last one always orange · 11. the offer — the alternative's length is revealed only then · 12. accept or refuse · 13. the offer screen is short, but the alternative stays available from the blue button; switching can't be undone · 14. no winning card → moved onto the alternative automatically, reward kept · 15. ready (no payment for the walkthrough) · 16. comprehension check.

**Comprehension check** (must be answered correctly in order; wrong answers are counted per question and the options reshuffled, never putting the right answer back where the participant just clicked):
1. How do I win my reward? → *By finding a winning card or by completing the alternative.*
2. What happens if I reach the end of the sequence without finding a winning card? → *I am moved to the alternative automatically, and I still earn my reward by completing it.*
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
| Show-up fee | £1.50 | Fixed, paid by Prolific |

Results screen: "Your bonus reward" = rewards − penalties, never negative, so at most £1.50 (`Meta.final_bonus`), approved manually; "Your show up fee" = £1.50. Section result screen shows the net amount when there were penalties, and confetti for a paid sequence.

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
| `continued and found the winning card` | Saw the offer, stayed, found the winning card |
| `found the winning card before the offer` | The winning card came before the offer point (offer wasted, regime 3) |
| `switched at offer` | Accepted on the offer banner, completed the alternative |
| `switched later via button` | Refused / let the offer lapse, later switched with the button, completed the alternative |
| `auto-switched (no winning card)` | No winning card, moved onto the alternative, completed it |
| `forfeited before offer` / `continued and forfeited` | Gave up in the main sequence |
| `auto-kicked before offer` / `continued and auto-kicked` | Autokick in the main sequence |
| any of the three alternative labels + ` and forfeited` / ` and auto-kicked` | Reached the alternative, then gave up / was auto-kicked |
| `abandoned before reload — superseded by a later attempt` | Discarded by a new-session reload |

---

## 13. Key constants (`index.html`)

```js
const BACKEND_URL = 'PASTE_WT_F_APPS_SCRIPT_URL_HERE'; // Apps Script /exec URL (§2)
const COMPLETION_CODE = 'C194BROI', NO_CONSENT_CODE = 'C1E6TYZR';
const GRID_PAY_PER_TASK = 0.025, SHOW_UP_FEE = 1.50;
const LABOR_INCOME_WARN_THRESHOLD = 8000;

const CFG = {
  numTasks: 5,              // sections (always 5, whatever the framing)
  gridR: 3, gridC: 3,       // 3×3 grid
  revealMs: 500, submitSecs: 2.5,
  winLo: 10, winHi: 15,     // sequence length
  liveMarkP: 0.4,           // orange-card probability (last card always orange)
  pInsideMean: 0.50, pInsideSd: 0.20, pInsideMin: 0.10, pInsideMax: 0.90,
  pauseBetaA: 2,            // offer position ~ Beta(2,2) slices (§5)
  rewardPoolLo: 1.00, rewardPoolHi: 1.50,  // per-respondent reward pool (§5)
  rewardMin: 0.10, rewardStep: 0.05,       // split: each sequence ≥ £0.10, in £0.05 units
};
// offer countdown Uniform[10,45] s; alternative end Uniform{L+1..2L}
```

---

## 14. Participant backup

If the final save can't be confirmed after 8 attempts, the results screen shows an error reference code and Share (where supported) / Copy / Download buttons for a JSON backup (`wt_study_backup_<pid>.json`), with instructions to send it to the research team via Prolific (students: by email).
