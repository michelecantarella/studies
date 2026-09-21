# WT Study — Design & Implementation Reference

**Study title:** Value of Wasted Time
**Build:** WT_E ("mixed"/FULLRAND hands, see §6 — forked from WT_D. Defining change: the alternative offer is only available during its own timed window per hand, not for the rest of that hand afterward — see §5's "The pause and alternative offer")
**Platform:** Prolific + GitHub Pages
**Files:** `index.html` (frontend) · `backend.txt` (Google Apps Script)
**Contact:** Michele Cantarella — michele.cantarella@imtlucca.it
**Ethics approval:** Joint Ethical Committee of Scuola Superiore Sant'Anna / Scuola Normale Superiore / IMT Lucca — N. 23/2026, 30 April 2026

---

## 1. What the study measures

The study investigates how people manage sunk time and forgone earnings when facing open-ended uncertainty. Participants complete a series of grid tasks to earn a section bonus; each section's main sequence has no fixed length. The key manipulation is whether and when participants switch from this open-ended sequence to an alternative of known, fixed length, or forfeit entirely.

**The "hand" mechanic.** The main sequence is played as a series of **hands**, shown to the participant as a stack of cards. Each hand has a random total length (1–10 cards); unlike earlier iterations of this design, its cards are **not** a block of safe (white) cards followed by a block of live (orange) ones — every card in the hand is independently, randomly marked live (can end the hand) or safe (cannot), so the two colours are genuinely interspersed throughout ("mixed"). The moment a hand appears, the participant can see its total length and is told the exact probability the sequence ends somewhere inside it. If the sequence does not end, a **fresh hand loops in** — new length, new live/safe pattern, new probability — and play continues, restoring the no-fixed-length character of the earlier bounded-window/geometric-hazard designs this one supersedes. See §6 for the generative details and the four offer-placement regimes.

---

## 2. File inventory

| File | Purpose |
|---|---|
| `index.html` | Single-page frontend — all study logic, UI, and data collection |
| `backend.txt` | Google Apps Script source — paste into Apps Script editor and deploy |
| `DATA_DICTIONARY.md` | Plain-language, column-by-column reference for the Excel/Sheets output — what every field in `Meta`/`Responses`/`Hands` actually means |

These files live in this folder. The study is designed to be hosted as a static file (GitHub Pages, any web server). The backend is a Google Sheets / Apps Script deployment. Column-by-column field documentation also lives inline in §9 below, and as comments directly above `META_HEADER`/`RESP_HEADER`/`HANDS_HEADER` in `backend.txt` — `DATA_DICTIONARY.md` is the standalone version of the same information, meant to be handed to someone working with the spreadsheet output who doesn't need the rest of this design document.

---

## 3. Deployment checklist

1. Deploy `backend.txt` as a Google Apps Script web app:
   - Open Google Sheets → Extensions → Apps Script
   - Paste the contents of `backend.txt`
   - Deploy → New deployment → Execute as: Me, Who has access: Anyone
   - Copy the `/exec` URL

2. In `index.html`, set `BACKEND_URL` (near the top of the `<script>` block):
   ```js
   const BACKEND_URL = 'https://script.google.com/macros/s/…/exec';
   ```
   (Already pointed at a live deployment in this copy — repoint it if you deploy a fresh Apps Script project rather than reusing that one.)

3. Host `index.html` on GitHub Pages (or any static host).

4. Prolific study link format:
   ```
   https://<your-host>/index.html?PROLIFIC_PID={{%PROLIFIC_PID%}}&STUDY_ID={{%STUDY_ID%}}&SESSION_ID={{%SESSION_ID%}}
   ```

5. Prolific completion codes:
   - **No consent:** `C1E6TYZR` (redirect on "I do not consent" click)
   - **Study complete:** `C194BROI` (redirect after all 5 sections)

---

## 4. Study flow

```
Page load → bootstrap (backend lookup; already-completed / connection-error / resume / new-respondent branches — see §10)
  → Consent screen
  → (I do not consent) → Prolific redirect C1E6TYZR
  → (I consent) → [no PROLIFIC_PID in the link] → Enter Prolific ID screen — see §4's "Missing PROLIFIC_PID"
  → Survey (2 screens — background/household, then finances/preferences; see §5's "Background survey")
    → Training (16-screen in-context walkthrough staged on the real task screen, ends with a comprehension check and a £0.10 bonus — see §5)
      → [repeat for each of 5 sections]
          Grace period (task preview: reward amount only — no hand structure disclosed yet)
            → Grid tasks loop, played hand by hand (a survived hand loops into a fresh one, each with its own recurring offer draw — see §6)
              → [offer reached] → in-place "alternative available" banner, open ONLY for its own timed accept/refuse window (WT_E — see §5)
              → [sequence ends inside a hand] → Section result screen
      → Results screen (single earnings summary, net of penalties — no per-section table)
        → Backend complete POST (5 retries)
          → Prolific redirect C194BROI
```

On page reload at any point after consent: a same-tab refresh resumes exactly where the participant was; a new-session return restarts the current section with freshly-drawn hands. Completed sections are always preserved, and — new in this build — an in-progress section that gets restarted this way is no longer silently discarded: its already-drawn hands are logged as their own (superseded) attempt row rather than overwritten. See §10.

### Missing PROLIFIC_PID

Every backend save (`saveProgress()`) is keyed by `_prolificID`, so a respondent with no usable ID can't be identified or resumed at all. Two different cases, both logged the same way (`pid_missing_from_link=1` in `Meta`):

- **`STUDY_ID=pilot`**: `_prolificID` is auto-generated client-side, before anything else runs — `'pilot_' + Math.random().toString(36).slice(2,10)`. No participant-facing screen at all; the pilot just proceeds as if the ID had been in the URL all along.
- **Any other `STUDY_ID`**: `doConsent()` checks `_prolificID` right after consent is recorded and, if it's still empty, shows `#screen-enter-pid` ("What's your Prolific ID?") instead of moving on to the survey. `submitManualPid_()` requires a non-blank value, sets `_prolificID`, and continues into the survey exactly like `doConsent()` normally would (`proceedToSurvey_()`, the shared continuation both paths call).

**Recovering across a same-tab reload.** `_prolificID` is otherwise re-derived fresh from the URL on every page load — without special handling, a same-tab refresh would regenerate a *new* random pilot ID every time (losing the link to whatever was already saved under the old one), and would force a manual-entry respondent to retype their ID. Fixed by piggybacking on the existing same-tab-reload mechanism: `markTabSession_()`/`isSameTabSession_()` already store `_prolificID` in `sessionStorage` under `TAB_SESSION_KEY` (survives F5, cleared when the tab closes) to detect same-tab reloads at all. Right at the top of the script, before the pilot auto-gen check even runs, a stored non-`'anon'` value is recovered into `_prolificID` first. `submitManualPid_()` calls `markTabSession_()` again immediately after setting `_prolificID` (bootstrap already called it once under `'anon'`, before any ID was known) so this recovery works from the very next reload onward. This only works within the same browser tab — a genuinely new tab/session has no `sessionStorage` to recover from, consistent with every other same-tab-only resume behaviour in this app (§10).

**Why `pid_missing_from_link` needed its own durable copy.** The top-level `_pidMissingFromLink` flag only reflects *this* page load — true on the load where the ID was first generated/entered, but false again on every subsequent reload (recovery restores `_prolificID` itself, not the fact that it was originally missing). Sending that flag straight to the backend on every heartbeat would flip the column back to `0` on the very next save. `SESSION.pidMissingFromLink` is the fix: set once (`doConsent()`/`submitManualPid_()`), included in `buildSnapshot_()`/restored in `applyResume_()` exactly like `SESSION.consentAt`, so it survives every reload and heartbeat afterward once set.

### Background survey

Replaced the original three-field survey (age/gender/student). Split across two screens (`#screen-survey`, `#screen-survey2`) — nothing is saved until the final Continue on screen 2, which is when `submitSurvey()` reads every field (from both screens' DOM, both still present, just hidden) and moves on to training.

**Screen 1 — background/household** (`#screen-survey`), in order:
- Education (select) → `education` — first question on the screen.
- Employment status (select) → `employment_status`. If it's one of the employed/self-employed options, a conditional monthly-income field appears (`onEmploymentChange_()`) → `labor_income`.
  - **Digits only** — `onLaborIncomeInput_()` strips anything non-numeric on every keystroke, so the field can't hold letters, decimals, or signs.
  - **Unrealistic-value check**: `£8,000`/month (`LABOR_INCOME_WARN_THRESHOLD`) is an unusual figure for this population and far more likely someone typed their *annual* income into a *monthly* field. Doesn't block the value outright (a few respondents genuinely do earn this much) — crossing the threshold reveals a warning box with an explicit "Yes, this is my correct monthly income after tax" checkbox (`#labor-income-confirm`), and `surveyScreen1Valid_()` won't accept the field as answered until that's ticked. Dropping back under the threshold clears the checkbox automatically, so it can't get carried past a later edit unnoticed.
- Marital status (select) → `marstat`.
- "Including yourself, how many people live in your household?" — a dropdown (`s-hh-others` → `hh_others`, still storing the *other-than-respondent* headcount despite the total-including-self wording): "I live alone" (0 others), 2 (1 other), 3 (2), 4 (3), or "5 and more" (4 — the study doesn't need exact headcounts above that). Deliberately skips "1" as an option — with "including yourself" phrasing, "1" would just mean "I live alone" again under a different label, which is what that option already says.
- Family contributors (select) — hidden by default, only revealed once `hh_others > 0` (`onHhOthersChange_()`). Left blank whenever it's hidden.

**Screen 2 — finances/preferences** (`#screen-survey2`):
- "Ends meet" — the same 7-point SOEP scale asked for three time frames (this month / one year ago / one year from now), built from a single `ENDS_MEET_OPTIONS` array (`buildEndsMeetSelects_()`) rather than repeating the option list three times in markup.
- Risk (Dohmen et al. 2011) and patience (Falk et al. 2016) — single-item 0–10 sliders, live-updating their numeric readout on `oninput`. Both start showing "—", not a default number: a range input always carries *some* value (5, the initial `value` attribute) even if the respondent never touches it, so silently trusting that would let an unanswered slider submit as a real "5". `onSliderInput_()` sets a `sliderTouched.{risk,patience}` flag the first time each slider actually fires an `input` event, and `surveyScreen2Valid_()` requires both flags before accepting the screen — the underlying value (still just `el('s-risk').value` etc. in `submitSurvey()`) is unaffected by this; it only gates whether Continue is allowed to fire at all.

**Every question is required, unless `demomode` is 1 or 2.** `surveyScreen1Valid_()`/`surveyScreen2Valid_()` gate the Continue buttons (`goToSurvey2_()`/`submitSurveyGuarded_()`) and short-circuit to `true` when `_demoMode>=1`; on failure they show an inline red "Please answer every question before continuing." message instead of navigating. The household question counts as answered once `s-hh-others` has a selection (0/"I live alone" is a valid answer).

In debug mode (`demomode>=1`), the shared debug bar's "Skip survey" button (`debugSkipSurvey()`, not an inline button on the screens themselves — see §11) calls `submitSurvey()` directly, bypassing validation entirely — blank/default fields fall back the same way they would for a real respondent leaving them empty.

`age`/`gender`/`student` stay in `META_HEADER` (backend.txt) as permanently-blank legacy columns — removing them outright would shift every column after them for rows already written under the old survey, which is the one thing the append-only header convention exists to prevent. All new fields are appended at the end of `META_HEADER` instead (see §9).

**`STUDY_ID=pilot` skips almost all of this.** `proceedToSurvey_()`/`applyResume_()` route through a shared `showSurveyScreen_()` helper: for a pilot respondent it hides screen 1 entirely and the ends-meet grid on screen 2 (`#row-ends-meet`), landing straight on just the risk/patience sliders (the label reads "Short Survey" instead of "(2 of 2)", and the "← Back" button is hidden since there's nothing on screen 1 to go back to). `surveyScreen2Valid_()` skips the ends-meet check accordingly. `submitSurvey()` itself is unchanged — the hidden screen-1 fields and ends-meet selects are simply never touched, so they fall back to their normal empty-answer values (`'—'`/`''`) exactly as if a real respondent had left them blank.

### Student version (`STUDY_ID=studentpilot`)

A separate in-class mode, distinct from `pilot` (`_isStudentPilot`, not folded into `_isPilotStudy` — `pilot` keeps behaving exactly as documented above). Shares `pilot`'s trimmed survey (`_isAnyPilot = _isPilotStudy || _isStudentPilot` gates `showSurveyScreen_()`/`surveyScreen2Valid_()`), but differs in several other ways:

- **Bypasses welcome/consent entirely.** Consent is already collected in class through a separate paper/form process. `firstScreen_()` returns `'student-id'` instead of `'consent'` for every "start fresh" bootstrap branch — a new screen (`#screen-student-id`, "Enter your student ID or name") that has nothing to do with `#screen-enter-pid` above. `submitStudentId_()` sets `_prolificID` to whatever was typed (reusing the existing identifier plumbing wholesale — no separate backend column needed) and calls `doConsent()` directly, which still runs its usual state setup (`SESSION.consentAt`, `nSeqFrame`, `regime`, `pQuintileOrder`, `fetchGeo_()`) before continuing into the (trimmed) survey.
- **The tutorial is NOT skipped** — students go through the full 16-screen walkthrough exactly like everyone else.
- **Currency is "Points," not "£."** Every reward/penalty display goes through `money_(n)`, which renders `£X.XX` normally or `X.XX Points` when `_isStudentPilot` — one helper, no scattered `if` checks. Backend numbers are unaffected either way; this is presentation-only.
- **Simplified, Prolific-free results screen.** No show-up fee line (`SHOW_UP_FEE` doesn't apply — students aren't paid through Prolific), no training/penalty explanation or "manually approved" note; instead: *"Wait for your responses to be registered before closing the window,"* and — since the Points earned feed into a later in-class auction — a highlighted reminder to write down and remember the total (`#res-note-student-auction`). On a failed save: *"tap Share... or Copy... to `micant@dtu.dk`"* instead of the Prolific-messaging instructions, and no `prolificRedirect_()` call on success (there is nowhere to redirect a student back to).
- **The consent form itself is unaffected** — its text (including the researcher's own contact email, `michele.cantarella@imtlucca.it`) is simply never shown to a student respondent, since they never reach `#screen-consent` at all.

---

## 5. Task mechanics

### The grid task

Each task presents a **3×3 grid** of emoji symbols that **reveal progressively** from left to right, one cell every **500 ms** (4.5 s total for all 9 cells). Once fully revealed, a **2.5-second countdown** begins. The participant must click all instances of the **target emoji** shown above the grid. The task auto-submits at countdown end.

- Grid size: 3×3 = 9 cells (was 5×5 = 25 — shrunk to make each task quicker, per direct instruction)
- Target emoji: drawn at random from a pool of ~65 emojis
- Number of targets per grid: uniform over {2, 3, 4}
- Total time per grid: ~7 s (4.5 s reveal + 2.5 s countdown — was ~15 s at 5×5). Since `CFG.submitSecs` (2.5) doesn't divide evenly into whole seconds, the countdown display (`showSubmit()`/`trainShowCountdown_()`) ticks every 500ms internally and shows `Math.ceil()` of what's left, so it still reads as a clean "3…2…1" on screen while ending at exactly 2.5s.
- Errors (missed targets or false positives) incur a small penalty (£0.01 each) but do not stop the sequence
- **No-activity detection** is gated on whether the cursor moved at all during the subtask (a standard `mousemove` listener, `S.mouseMoved`/`S.firstMoveAt`), **not** on whether any cell was checked — checking nothing can be a genuine, active submission (e.g. a grid the participant correctly judged had no matches left to find). The normal missed/false-positive penalty always applies regardless; if no cursor movement was detected, a **blocking** "Are you still there?" screen then takes precedence over whatever would normally happen next (next subtask, offer, completion) — it does not regenerate a new grid/target, it just holds progress at the current point until acknowledged (`showNoActivityScreen_()`/`acknowledgeNoActivity_()`). Each grid record in `tasks_json` carries a `no_activity` flag and a `first_move_at` timestamp (first cursor movement since that subtask started, or `null`).

### The sequence structure — mixed hands

Each section's main sequence is a chain of **hands**. A hand is drawn fresh each time:

```
length ~ Uniform[1, 10]                      total cards in this hand
live[k] ~ Bernoulli(0.5), independently, for each of the `length` cards
          (at least one card is forced live if the coin flips came up all-safe —
          drawLiveMask_() — otherwise a real pInside>0 would have nowhere to end)
pInside  ~ Normal(0.5, 0.20), clamped [0.10, 0.90], rounded to nearest 5%
```

Unlike earlier iterations (WT_C, WT_geo, the block-structured "classic" build), a hand's live/safe pattern is **not** a run of safe cards followed by a run of live ones — every card is independently, randomly marked, so the colours are genuinely interspersed (e.g. `SSLSLS`, not `SSSLLL`). The disclosed end-probability `pInside` is shown from the instant the hand appears and does **not** update as cards pass — "the probability the sequence ends in this hand is clear from the start."

**Resolving a hand.** With probability `pInside` the hand ends: the ending card is drawn **uniformly** over whichever of the hand's cards turned out live, the sequence stops there, and the cards after it are simply never reached. With probability `1 - pInside` the hand is survived — every card is played — and a **fresh hand loops in** (new length, new live/safe mask, new `pInside`).

**Known, accepted consequence.** Within a single hand, as live cards pass without ending, the conditional chance of ending on a remaining card does shift — the small-scale version of the shrinking-horizon effect a pure geometric hazard avoids. This is deliberate here: hands are short (1–10 cards) and the *looping* is what carries the open-endedness.

**An undisclosed hand cap.** If the sequence survives `CFG.maxHands` (currently **6**) hands, the last one is forced to end on one of its own live cards. This is a safety ceiling on session length, **not disclosed** to the participant (per direct instruction, for now). Treat `cap_bound=1` rows as right-censored at `n_req`.

**Nothing about a hand is disclosed before it appears.** The pre-sequence screen states only the reward. Each hand's length, live/safe pattern, and end-probability are shown on the card stack and the caption above it only once that hand is dealt.

### The pause and alternative offer — a timed window, recurring per hand

Unlike the earlier "one offer, drawn only for the first hand" designs, **every hand in this build draws its own offer** (`drawLoopOffer_()`, called once per hand in `generateTasks()`). The task-level `pause`/`pauseMax` fields (on `Responses`) describe the **first** hand's own offer (what the pre-section disclosure and the initial panel state are built around); the `Hands` sheet's own `pause` column records every hand's own recurring offer position (first and later alike, one row per hand), and `offerAt` (client-side only, not a logged column) is the flat list of global task numbers at which the offer (re)fires, one entry per hand — a hand whose own offer was wasted (see regime 3 below) contributes `null` rather than a stale position.

**WT_E's defining change: the alternative can only be accepted while its own offer banner is actually on screen.** The moment the *current* hand's own offer fires, the in-place banner reads "The alternative sequence is now available" (blue, flashing) with a "Do you accept the offer? *N* cards" line and two buttons: **Accept and switch** / **Refuse and stay** — plus its own timed countdown below ("The offer ends in *N*s", `pause_secs` — Uniform[10, 45] seconds, drawn fresh per hand, see §6).

**Pressing either button is only step one — a two-step accept flow, not an immediate commit.** Clicking "Accept and switch" or "Refuse and stay" swaps the banner to a follow-up: "Do you confirm your choice? / You have decided to switch to the alternative." (or "...to stay in the main sequence.") with **Confirm** / **Undo** buttons. The *same* countdown from step one keeps running underneath this follow-up, uninterrupted — pressing Undo goes back to the two original buttons with whatever time is left, not a fresh window. If the countdown reaches zero:
- **On step one** (no tentative choice made yet) — the offer lapses, defaulting to stay in the main sequence, logged as `auto_refused=1` for that hand (`Hands` sheet).
- **On step two** (a tentative choice is pending confirmation) — that choice is auto-committed instead of reverted, logged as `auto_confirmed=1`.

Either way, once resolved (deliberately or by timeout) the offer closes and does **not** reopen for the rest of that hand: the right-hand panel is purely informational (constant blue border, never clickable, never greyed out) and simply reads `Locked` outside this window and `Available` during it, showing the alternative's fixed length (`alt_duration` cards) throughout. A **later** hand's own fresh offer can still open a brand new window; only the current one closes for good. How many times "Undo" was pressed on the follow-up screen is logged per hand too (`undo_count`), as a measure of indecision.

Decisions available on the offer banner itself, while its window is open:

| Decision | Outcome |
|---|---|
| **Accept and switch** → **Confirm** | Moves to the alternative sequence (`alt_duration` cards, fixed) — `switch_taken = 1` |
| **Refuse and stay** → **Confirm** (or the countdown running out on step one) | Main sequence carries on; this hand's own offer is gone for good — the panel locks again until a later hand's own offer fires |
| **Undo** | Back to step one, same window, same remaining countdown — no commitment either way yet |

Giving up the whole sequence (`forfeit_taken = 1`) is unaffected by this change — it stays available throughout the main sequence via the separate, always-visible "Give up sequence" panel, whether or not an offer window happens to be open at the time.

`alt_duration` is drawn from a bounded bell ("beta-normal") whose **endpoint** is centred on `E[remaining]` **at the first hand's own offer** (`e_end_at_pause`), with support width equal to the mean hand length. This keeps switching a genuine ~50/50 call in expectation. `pay_tasks`/`pay` are instead centred on the **whole-experiment** expected length (`POP_MEAN_END`, see §6) — never on this section's own realised chain — so the bonus amount never leaks how long this particular sequence will actually run.

### Training walkthrough (in-context, staged on the real task screen)

16 screens (`trainScreenN_()` in `index.html`, one function per step; `TRAIN_LAST_STEP=16`), staged on the real task screen. `#screen-subtask` is dimmed by default (`.train-dim`) and each step lights up (`.train-lit`) exactly the panel(s) it's explaining; a wide blue tip box (`#train-tip`) sits below the board in normal document flow, with a "← Back" button on every step but the first. The demo **card-stack** (`renderTrainHand_()`) is shown alongside the grid throughout, using a fixed, deliberately readable demo hand (`TRAIN`: length 6, live mask `[S,S,L,S,L,S]`, `pInside=40%`, `altDuration=4`, `pay=£0.10`) rather than a real per-hand draw, so nobody mistakes the walkthrough's numbers for their own first section's.

Walk-through order, roughly: the grid task and one real practice round; "that was a task"; the sequence/reward/penalty/forfeit panels; the hand and its safe cards with the disclosed end-chance caption; the live cards and the loop into a fresh hand (with its own new probability); the alternative offer appearing, accepting it, that its own window is only open for a short time (declining or timing out sends it back to the main sequence until a later hand's own offer fires) and is irreversible once taken; a closing "ready / you've earned £0.10" screen; then the comprehension check below. See `index.html`'s `trainScreen1_()` through `trainScreen15_()` for the exact staged copy.

**End-of-training comprehension check (screen 16, `trainScreen16_()`/`trainCompAnswer_()`).** Three questions — "how do I win my reward" (main sequence or the alternative), "what happens if I don't find a winning card in a hand" (a fresh hand, not the end of the sequence), "what happens if I switch to the alternative" (progress resets, no switching back) — shown one at a time in a sliding carousel with a 3-dot progress indicator (`#train-comp-block`), reusing the app's existing blue tip-box styling. Must be answered correctly **in order**: a wrong answer is rejected in place (no advance, a fixed "Not quite" message), the count of incorrect attempts is recorded per question (`training_comp_check_q1_wrong`/`_q2_wrong`/`_q3_wrong` in `Meta` — see §9), and that question's option order is reshuffled before the next attempt. The reshuffle (`shuffleAvoidingIndex_`) never puts the correct option back at the position the participant just picked — e.g. options `[A,B,C]` with `C` correct: picking `B` at position 2 can only reshuffle `C` to position 1 or 3, never back to 2 — so repeatedly clicking the same slot can never eventually land on the right answer by pure chance. `finishTraining()` only runs once all three are correct; there is no separate "Start the study" button on this screen.

`training_choice`/`training_choice_at` remain permanently blank (legacy columns, same treatment as `age`/`gender`/`student`) — the walkthrough stages both the switch and the forfeit paths for every participant rather than recording one free decision.

In debug mode (`demomode>=1`), "Skip task"/"Skip section" both route through the training equivalent of the production debug shortcuts. "Stop" is disabled during training, as before.

---

## 6. Parameter generation

`regime` (the META regime) is drawn **once per respondent** at consent (`SESSION.regime`, from `{0, 1, 2, 3}` equally likely, a `?regime=` URL override wins for testing) and reused for all 5 sections.

### Per-hand primitives

Each hand draws, independently (see `drawHandParams_`/`drawLiveMask_`):

```
length  ~ Uniform[1, 10]
live[k] ~ Bernoulli(0.5) for each of the `length` cards, independently
          (at least one forced live if all came up safe)
pInside = round( clamp(Normal(0.5, 0.20), 0.10, 0.90) × 20 ) / 20   (disclosed, to nearest 5%)
```

A hand ends inside itself with probability `pInside`; if it does, the ending card is uniform over whichever cards turned out live. Otherwise the hand is survived (all its cards played) and a fresh hand is drawn. This repeats until a hand ends or `CFG.maxHands` (6) is reached, at which point the last hand is **forced** to end. `n_req` is the total number of main tasks — the sum of played cards across all hands.

**The first hand's `pInside` is quintile-stratified per respondent.** `SESSION.pQuintileOrder` is a shuffled `[0..4]` drawn once at consent; section `i`'s first hand draws its `pInside` from quintile bin `pQuintileOrder[i % 5]` of the `Normal(0.5, 0.20)` distribution (`drawPInsideFromQuintile_`/`P_QUINTILES_`) — so across a respondent's 5 sections, every quintile of the `pInside` distribution is used exactly once. Every hand after the first (and every respondent's `live` mask) draws plainly, without stratification.

### Four regimes: placing the offer relative to each hand's own ending

Regimes govern only the draw order of a hand's own offer (`pause`) versus **that hand's own** ending — this now applies to **every hand**, not just the first (`drawLoopOffer_`, called once per hand). `pauseMax = hand.length - 1` for whichever hand is being drawn.

```
REGIME 1  (this hand's ending FIRST, offer AFTER — LEAKS)
  ends   ~ Bernoulli(pInside);  if so  endPos ~ Uniform(liveTaskNumbers)
  pause ~ Uniform[0, min(pauseMax, endPos-1)]   if the hand ends
  pause ~ Uniform[0, pauseMax]                  if it survives

REGIME 2  (offer FIRST, this hand's ending conditional on surviving it — no waste)
  pause ~ Uniform[0, pauseMax]
  aheadLive = live task numbers still ahead of `pause`
  insideMass    = pInside · (|aheadLive| / |liveTaskNumbers|)
  pInGivenPause = insideMass / (insideMass + (1 − pInside))
  ends   ~ Bernoulli(pInGivenPause);  if so  endPos ~ Uniform(aheadLive)

REGIME 3  (independent — flat, but can waste this hand's own offer)
  ends   ~ Bernoulli(pInside);  if so  endPos ~ Uniform(liveTaskNumbers)
  pause ~ Uniform[0, pauseMax]     (independent of the ending)
  wasted = ends AND endPos < pause     (this hand ended before its own offer's card)

REGIME 0  ("mixed" — the META regime, not to be confused with the hand's own
           live/safe pattern) — EACH HAND independently re-rolls which of
  {1, 2} governs it (never 3). The Hands sheet's own sub_regime column
  records which one actually applied to that specific hand — constant across
  all hands (equal to the META regime) when regime is 1, 2, or 3; varies
  hand-to-hand only under META regime 0.
```

**Worked example for regime 2's conditional draw** (why `pInGivenPause` is correct): a hand with `pInside=50%` and exactly 2 live cards total, where 1 of them is already behind the pause (1 still ahead) — the chance this hand still ends, *given it survived to the pause*, is not 50%: half the hand's original "mass" of ending (the live card already passed) can no longer happen, so conditioning on survival past it raises the relative weight of "doesn't end at all" from `(1-0.5)` to `(1-0.5)/((1-0.5)+0.5·(1/2)) = 0.5/0.75 = 2/3`, leaving exactly `1/3` for "still ends on the remaining card" — precisely `insideMass/(insideMass+(1-pInside))` with `insideMass=0.5·(1/2)=0.25`. This recomputation happens fresh from whatever survives the pause, in every hand, so conditional probabilities are always consistent after a pause, regardless of which hand it's in.

**Wasted offers.** Only reachable under sub_regime 3 (either META regime 3, or a hand that happened to re-roll sub_regime 3 — which never happens, since regime 0's per-hand pool is `{1,2}` only; sub_regime 3 is only ever a *constant* META regime, applying identically to every hand of that respondent). `offer_wasted` (Responses, section-level) is 1 iff **any** hand in the chain wasted its own offer — see the `Hands` sheet's own `wasted` column for exactly which hand(s). No switch decision exists for a wasted hand's own pause.

### Expected end, alternative length, and pay (FULLRAND)

Because every hand after the first re-rolls fresh random parameters, this section's own numbers only describe its *first* hand — there's no meaningful "this section's E[end]" from the start the way a single-offer, first-hand-only design would have. Instead:

- **`e_end_at_start` (`POP_MEAN_END`)** is a **whole-experiment population constant** — the same value for every section of every respondent — computed once at script load as `E[total tasks]` for a hand-chain with the population mean hand length, averaged over the `pInside` distribution **restricted to `[altPMin, altPMax] = [0.30, 0.70]`** (so the alternative is sized off typical sequences, not the extreme-low-`pInside` tail that would otherwise inflate it). See `expectedTotalTasksSame_`/`POP_MEAN_END`.
- **Every hand also gets its own two GENUINELY hand-specific figures** (`Hands` sheet, not `Responses` — see §9), via `eRemFullrandWith_(hand, localPos, POP_MEAN_END)`, which walks that hand's **real** length/live positions/`pInside` from `localPos` forward, conditioning on survival to that point, plus `POP_MEAN_END` for whatever uncertain hands might still follow if this one is survived:
  - **`e_remaining_at_hand_start`/`e_end_at_hand_start`** (`localPos=0`) — before any of this hand's own cards are known to have passed: what the sequence's expected total length looks like the moment this hand is dealt.
  - **`e_remaining_at_pause`/`e_end_at_pause`** (`localPos=pause`) — conditional on having survived to this hand's own pause: accounts for only what remains in THIS hand from there, plus uncertain future hands. `e_end_at_pause = hand.globalStart + pause + e_remaining_at_pause`.
  
  (An earlier version of this exposed only the *first* hand's own `e_remaining`/`e_end_at_pause`, directly on the `Responses` row — removed as pure duplication of that hand's own row on `Hands`, `hand_n=1`, once every hand got the same treatment.)

```
altDuration = max(ALT_MIN=2, round( betaNormal(firstHand.e_remaining_at_pause, meanHandLength) ))
altEnd      = pause + altDuration
payTasks    = max(1,          round( betaNormal(POP_MEAN_END, meanHandLength) ))
pay         = round(payTasks × BONUS_RATE_PER_TASK, 2)   (£0.0375/task)
```

The alternative's **endpoint** is centred on the first hand's own `e_end_at_pause` (so its *length* is centred on that hand's own `e_remaining_at_pause`) — this keeps switching a genuine ~50/50 call in expectation. **Pay** is centred on the population constant `POP_MEAN_END`, independent of anything realised in this particular section, so it never leaks how long this sequence will actually run.

`GRID_PAY_PER_TASK = £0.025/task` (£6/hr ÷ 3600s × 15s) is paid on every real grid completed, regardless of outcome — see §8.

---

## 7. Hidden sequence-count framing treatment

A between-subjects treatment, independent of the per-section parameter draws in §6.

- On consent, each participant is assigned `nSeqFrame` — **50/50, drawn once, persisted for the rest of the session** (survives reload via the resume snapshot, never re-rolled): either `4` or `5`.
- **Everyone actually completes all `CFG.numTasks` (5) sections, regardless of `nSeqFrame`.** Only what's *communicated* changes:
  - `nSeqFrame = 5`: told there are 5 sections, throughout (status quo / untreated).
  - `nSeqFrame = 4`: told there are 4 sections. The real 5th section is never announced in advance — the grace screen instead opens with a **generic** bonus-offer message ("You're being offered an additional bonus sequence!") behind its own Continue click, with the section's reward and no-fixed-length disclosure kept hidden behind that click.
- Implemented via `SESSION.nSeqFrame`, `isBonusIdx_()`, `sectionLongLabel_()`, `sectionShortLabel_()` in `index.html`.
- Recorded per-respondent (`seq_frame_treatment` in `Meta`) and per-sequence (`seq_frame_treatment`, `seq_is_bonus` in `Responses`).
- The debug bar (`?demomode=1/2`) shows the sequence-frame treatment and flags `(bonus)` on the relevant section.

---

## 8. Payment structure

| Component | Amount | Condition |
|---|---|---|
| Section bonus | `pay` | Paid if **main sequence completed OR switched to alternative**. Lost on **forfeit** or **autokick** (see below). |
| Task completion pay | £0.025 per task done | **All** tasks done in the section, regardless of outcome |
| Mistake penalty | -£0.01 per missed/false-positive click | Deducted from the section's own bonus specifically (see "Autokick" below), not from task completion pay |
| Training bonus | £0.10 flat | Once, on completing the training walkthrough |
| Prolific base pay | Set separately in Prolific | Fixed, paid by Prolific |

**The section bonus is earned on both `completed` and `switched` outcomes** — switching to the alternative sequence does not cost the participant the bonus. `forfeited` and `autokicked` sequences lose it.

**Task completion pay is always earned** regardless of outcome, and is never touched by penalties. This is not communicated to the participant during the task (the UI says "no bonus earned" on forfeit, referring only to the section bonus) — it is only reflected in the final results screen.

**Mistake penalties are deducted from that section's own bonus, not from task completion pay.** `penalty` is snapshotted per section at the moment it ends and logged (`penalty`, per-section; `total_penalty`, per-respondent). The actual net amount owed is logged explicitly too, not left for downstream analysis to reconstruct — `net_earnings` (`Responses`, per-section) and `total_bonus_owed` (`Meta`, whole-study), both `= earnings − penalty`, clamped at 0. The per-section completion screen shows this net figure too now (`"You earned £X (after £Y in penalties: £Z net)"`) whenever that section actually had a penalty — it used to show only the gross `pay`.

### Autokick — a sequence ends itself once its own penalty reaches its own reward

A sequence is force-ended (`outcome = 'autokicked'`) the instant its own accumulated `penalty` reaches its own `pay` — checked in `index.html`'s `submitMatrix()`, right after each mistake's penalty is added, in both the main and alt phase. This is a hard stop: `net_earnings` for that section is `0` (the clamp above is defensive; in practice this should always be the reason it's ever needed), and the participant moves on to the next section exactly as they would from a voluntary forfeit, but with a distinct message ("Your mistakes in this sequence used up its entire reward, so it ended here") and a distinct flag — `auto_kicked=1` on the `Responses` row (`Hands` rows for that section are otherwise unaffected; whichever hand was open when it triggered still gets its `hand_ended_at` stamped normally). `outcome_summary` gets its own auto-kicked variants (see §14).

### Results screen: two payment streams, no per-section table

The results screen presents **one summary, no per-section table**, split into two distinct lines:

- **"Your bonus reward"** = training bonus + section completion bonuses, net of mistake penalties, clamped at 0. Manually approved — the screen states this takes a couple of weekdays.
- **"Your show up fee"** = a fixed **£1.50** (`SHOW_UP_FEE` in `index.html`) — the flat Prolific base payment, identical for every respondent regardless of performance or how many grids they completed. Hidden for the student version (see §4's "Student version"), which has no Prolific show-up fee at all.

```
bonusReward = max(0, round(trainingBonus + Σ section.earnings − Σ section.penalty, 2))
            = Meta.total_bonus_owed  // same formula, logged to the backend
showUpFee   = SHOW_UP_FEE  // fixed 1.50, never computed from task pay
```

Full copy: *"Study complete. Your bonus reward: £X. Your show up fee: £Y. The bonus reward includes the training bonus and mistake penalties. Your show up fee will be paid immediately. Bonus payments are manually approved so please allow a couple of weekdays as we process it."*

---

## 9. Backend architecture

### Three Google Sheets tabs

**`Meta`** — one row per respondent. **Respondent-level data only** — anything that varies per sequence belongs on `Responses`, anything that varies per hand belongs on `Hands` (see the note at the top of each table below). Cleaned up as a dedicated pass (fields removed outright, not just marked legacy-blank, and reorganised into logical groups) — safe only because no real respondent data had been collected under the previous layout yet; from here on the append-only convention applies again:

| Field | Description |
|---|---|
| prolific_pid, study_id, session_id, demo_mode | Identifiers |
| consent_at | ISO timestamp of consent (never overwritten once set). Blank for the student version (`STUDY_ID=studentpilot`), which collects consent in class instead — see §4's "Student version". |
| training_started_at, training_ended_at | Bracket the tutorial walkthrough (`submitSurvey()`/`finishTraining()`) |
| experiment_started_at, experiment_ended_at | Bracket the 5 real sections. `training_ended_at` and `experiment_started_at` are set together and will almost always be the same instant — kept as two separate columns anyway since they answer two different questions. `experiment_ended_at` is when the LAST section actually finished playing (`showResults()`), distinct from `study_complete_at` below (when the final save is *confirmed* — those two can be seconds, or with a flaky connection much longer, apart). |
| study_complete_at | Set when `action=complete` POST succeeds |
| last_updated_iso | Updated on every write |
| sections_done, total_earnings, total_grid_pay, total_grids_completed | Running totals. `total_earnings` is GROSS (not yet net of `total_penalty`) — see `total_bonus_owed` below. |
| training_bonus | £0.10 fixed bonus, credited once the training walkthrough is completed; already included in `total_earnings` |
| total_penalty | Sum of per-section mistake penalties across the whole session (see `Responses.penalty` for the per-section breakdown) |
| total_bonus_owed | **The actual amount owed at the end of the whole study** — `total_earnings` net of `total_penalty`, clamped at 0 (see §8's "Autokick"). Same figure shown as "Your bonus reward" on the results screen. |
| reload_count, reload_log_json | Resume tracking (session-level — how many times this respondent returned in a new session; see also §10 and the per-section `seq_reload_count`/`seq_attempt` in `Responses` below) |
| resume_snapshot_json | Full resume snapshot (cleared on completion) |
| seq_frame_treatment | Hidden 4-vs-5 sequence-count framing treatment (see §7); 4 or 5 |
| employment_status, labor_income, marstat | Employment status, monthly labor income (blank unless employed/self-employed), marital status |
| hh_others | Headcount of people besides the respondent living in their household (0 = living alone) |
| family_contributors, education | Who contributes to household expenses (blank unless `hh_others > 0`), highest education completed |
| ends_meet_now, ends_meet_past, ends_meet_future | SOEP-style 7-point "able to make ends meet" scale, for this month / one year ago / one year from now |
| risk, patience | 0–10 single-item risk (Dohmen et al. 2011) and patience (Falk et al. 2016) measures |
| geo_country, geo_region, geo_city, geo_ip, geo_provider, geo_json | IP-based geolocation (see "Geolocation" below) |
| device_type, browser, user_agent | Best-effort device/browser classification, captured once at consent (`detectDeviceBrowser_()`, called from `doConsent()` — never overwritten after first set). `device_type` is `Desktop`/`Mobile`/`Tablet` and `browser` a short name (`Chrome`/`Safari`/`Firefox`/`Edge`/`Opera`/`Other`), both from a handful of `navigator.userAgent` substring checks — no library, not pixel-perfect UA parsing. `user_agent` is the full raw string for anything the other two don't capture. |
| pid_missing_from_link | 1 if `prolific_pid` wasn't in the study link and had to be auto-generated (`STUDY_ID=pilot`) or manually entered by the respondent — see §4's "Missing PROLIFIC_PID" |
| training_scenario_order, training_scenarios_viewed | The training finish hub's two optional scenario buttons (see §5) — the randomised order they were shown in (`'inside,outside'`/`'outside,inside'`, fixed once per respondent), and which one(s) the participant actually tried, in order (blank if neither) |
| training_comp_check_q1_wrong, training_comp_check_q2_wrong, training_comp_check_q3_wrong | End-of-training comprehension check (see §5) — the number of **incorrect** attempts on each of the 3 questions before answering it correctly, in order. `0` means correct on the first try. |

### Geolocation

Fetched once, client-side, right after the participant clicks "I consent" (`fetchGeo_()`, called from `doConsent()`) — for production and debug-bar mode only (`demomode` 0/1; `demomode=2` bypasses the backend entirely, so there's nowhere to send it, and the fetch is skipped outright). **Google Apps Script's `doGet`/`doPost` never receive the caller's IP address** — there's no way to do this server-side with this backend — so it's a call to a third-party IP-geolocation API that geolocates whoever's IP the request itself arrives from (the participant's, since it's called from their own browser).

**Two independent providers, tried in order, each response validated (not just the HTTP status):** `GEO_PROVIDERS = [ipapi.co, ipwho.is]`. `ipapi.co` returns HTTP 200 even when rate-limited, with a body like `{error:true, reason:'RateLimited'}` instead of real geo fields — each provider's response is checked for real fields (`ipapi.co`: no `.error`, has `.country_name`; `ipwho.is`: `.success !== false`, has `.country`) before being trusted, falling through to the next provider otherwise. The second provider also covers the case where `ipapi.co` is blocked by an ad-blocker/privacy extension.

`SESSION.geo` is a normalised `{country, region, city, ip, provider, raw}` object regardless of which provider answered — `raw` is the untouched provider response (logged in full to `geo_json`), the rest feed the flat columns and `geo_provider`.

Fire-and-forget and best-effort: it never blocks moving on to the survey screen, and if *every* provider fails that respondent simply has no `geo_*` data. If it resolves, the result triggers its own `saveProgress()` call.

**Note:** this collects IP-derived location data, which is personal data under GDPR (the consent form's own text invokes GDPR 679/2016). Confirmed with the researcher that this is already within the scope of the study's existing ethics approval (N. 23/2026) and that participants are informed.

**`Responses`** — one row per respondent × sequence **× attempt** (see "Reload/attempt tracking" below). **Sequence-level data only** — anything that varies per respondent belongs on `Meta` instead (e.g. `total_penalty`, the whole-study sum of this sheet's own `penalty` column); anything that varies per hand belongs on `Hands` (e.g. a specific hand's own pattern/offer/timing — this sheet used to repeat the FIRST hand's `hand_len`/`live_pattern`/`p_inside_first`/`pause`/`pause_max`/`pause_secs` here too, which was pure duplication of that hand's own row on `Hands`, `hand_n=1`; removed in the same cleanup pass that added the timestamp columns below):

| Field | Description |
|---|---|
| prolific_pid, study_id, session_id, demo_mode | Identifiers (repeated per row) |
| seq_n, seq_attempt, is_latest_attempt | Sequence number 1–5; which attempt this is; see "Reload/attempt tracking" below |
| pay, pay_tasks, regime | Reward, the task count it was rolled from, and the respondent's META regime (0/1/2/3, fixed for all their sections — see §6). |
| n_hands, n_req | How many hands the section actually ran, and the total main-sequence task count. |
| alt_duration, alt_end | The alternative's fixed length and endpoint. |
| alt_base, alt_width, alt_minus_expected | `alt_base` = the population constant `POP_MEAN_END` (identical to `e_end_at_start`), `alt_width` = the mean hand length (the beta-normal support width), and `alt_duration` minus the FIRST hand's own `e_remaining_at_pause` (`Hands` sheet, `hand_n=1`) — negative means the alternative was the shorter option in expectation at that offer. |
| e_end_at_start | A **whole-experiment population constant** (`POP_MEAN_END` — same for every section of every respondent, see §6), NOT computed from this section's own hands. The equivalent figure genuinely specific to a real hand's own parameters now lives only on the `Hands` sheet, for every hand (`e_remaining_at_hand_start`/`e_end_at_hand_start`/`e_remaining_at_pause`/`e_end_at_pause`) — this row used to repeat just the FIRST hand's own version as `e_remaining`/`e_end_at_pause`, removed as pure duplication of that hand's own row on `Hands`. |
| cap_bound | 1 iff the UNDISCLOSED hand cap (`CFG.maxHands=6`) forced the last hand to end. Treat as right-censored at `n_req`, not a natural ending. |
| offer_wasted | 1 iff **any** hand in the realised chain wasted its own offer (only reachable when that hand's `sub_regime` was 3 — see the `Hands` sheet's own `wasted` column for exactly which hand(s)). No switch decision exists for a wasted hand's own pause. |
| card_order | The FULL card-by-card order actually presented across the whole main sequence: every hand's live/safe pattern, truncated to how many of its cards were actually played, joined with `"|"` — e.g. `"SSLSLS|LSL"` = a 6-card hand that survived, then a 3-card hand that ended on its 3rd card. A whole-sequence aggregate (not any single hand's own data) — reconstructable from the `Hands` sheet too, kept here as one flat, directly-readable field. |
| seq_frame_treatment, seq_is_bonus | Hidden 4-vs-5 framing treatment (see §7) |
| start_at, end_at, seq_start_at_time | ISO timestamps — sequence-level start/end (see also `Hands.hand_started_at`/`hand_ended_at` for the per-hand breakdown) |
| briefing_ended_at | The moment the pre-sequence briefing (the "grace" screen — reward, alternative length, reminders) actually ended: "Start sequence" pressed. Distinct from `start_at`, stamped an instant later once the first real card is actually being set up. |
| seq_reload_count | Reloads recorded (session-level `reloadLog`) whose `seq_index` matches this section — how many times the respondent returned in a new session while this section number was current. Distinct from `seq_attempt` above, which counts only reloads that actually discarded drawn hands. |
| outcome | `completed` / `switched` / `forfeited` / `autokicked` for a real section (see §8's "Autokick" for the last); `abandoned_reload` for a superseded attempt (see "Reload/attempt tracking"). |
| outcome_summary | A fixed, human-readable label summarising the section's behaviour, purely derived from the other columns here, never a new source of truth — see §14, "Outcome taxonomy," for the full derivation table. |
| switch_offered_at_task, switch_offered_at_time | Task number and timestamp when the very FIRST offer of the section opened |
| switch_taken, switch_taken_at_task, switch_taken_at_time | Whether the participant switched, and the task/time at which they pressed **"Confirm"** on the confirm popup (or a timeout auto-committed it — see `auto_confirmed` in the `Hands` sheet) — step 2 of the accept flow |
| switch_pressed_at_task, switch_pressed_at_time | Step 1: the task/time at which **"Accept and switch"** was first pressed, opening the confirm popup. Re-recorded on every press if the participant Undoes and presses it again later, so it always reflects whichever press actually led to confirming. Also lets `outcome_summary` tell "accepted the very first offer" apart from "declined an earlier hand's offer and accepted a later one" (see `computeOutcomeSummary_`). Only populated if `switch_taken=1`. |
| switch_decision_secs | The real gap, in seconds, between `switch_pressed_at_time` (step 1) and `switch_taken_at_time` (step 2) — how long they sat on the confirm popup before it was resolved. Blank unless `switch_taken=1`. |
| alt_phase_started_at | When the alternative sequence actually began. Blank if it was never reached (a `completed`, `forfeited`, or `autokicked` outcome). |
| forfeit_taken, forfeit_taken_at_task, forfeit_taken_at_time | Whether the participant forfeited, and the task/timestamp at which they did |
| auto_kicked | 1 iff this section was force-ended because its own accumulated `penalty` reached its own `pay` — see §8's "Autokick". Distinct from `forfeit_taken`, which is voluntary. |
| n_tasks_done, earnings, grid_pay, penalty | Outcomes. `earnings` is the section's GROSS bonus (`pay` if completed/switched, 0 otherwise) — not yet net of `penalty`. `penalty` is per-section, logged separately (see §8). |
| net_earnings | **The actual amount owed for THIS section** — `earnings` net of `penalty`, clamped at 0 (see §8's "Autokick" — in practice a section is force-ended before this clamp would ever actually bind). |
| total_targets, total_found, total_false_pos, total_missed | Aggregated grid accuracy |
| tasks_json | JSON array — one object per completed grid, including `no_activity`/`first_move_at` (see §5) |

**`Hands`** — one row per respondent × sequence × attempt × **hand** (superseded the old `hands_json` blob column on `Responses`, which no longer exists at all). **Hand-level data only** — anything that varies per sequence or respondent belongs on the other two sheets instead:

| Field | Description |
|---|---|
| prolific_pid, study_id, session_id, demo_mode | Identifiers (repeated per row, same convention as `Responses`) |
| seq_n, seq_attempt, is_latest_attempt | Which sequence and attempt this hand belongs to — joins back onto `Responses` via `(prolific_pid, seq_n, seq_attempt)`. `is_latest_attempt` mirrors the parent `Responses` row (same rule, same key) — computed server-side in `upsertHandRows_()` (backend.txt), never trusted from the client. Filter to `is_latest_attempt=1` for one row per real, non-superseded hand. |
| hand_n | This hand's 1-based order within the sequence attempt. The hand with `hand_n = n_hands` (from the matching `Responses` row) is the one that ended the sequence. |
| hand_len, live_pattern, p_inside | This hand's own disclosed structure — total length, live/safe pattern (one char per task, e.g. `"SSLSLS"`), and end-probability |
| sub_regime, wasted | Which of `{1,2,3}` governed THIS hand's own offer placement (only varies hand-to-hand when the respondent's META `regime` is 0 — see §6); `wasted=1` only under `sub_regime=3`, meaning this hand's own offer never fired because the hand had already ended before reaching its own pause card |
| ends, end_pos, played_len | Whether THIS hand was the one that ended the sequence, and if so at which of its own cards (0-indexed among its live cards); `played_len` is how many of its cards were actually shown |
| pause | This hand's own offer position (0-indexed count of this hand's own cards completed when its offer fires), fixed at generation time like everything else in this group. |
| sunk_cost_at_pause | **"Sunk cost" at this hand's own pause** — total tasks (live+safe) already completed across the WHOLE sequence by that moment, not just within this hand (= `active_passed_in_seq + inactive_passed_in_seq` below, summed — kept as its own explicit column since it's the single number that actually matters for a sunk-cost analysis). Also fixed at generation time, tied to `pause` — unlike `pause_secs`/`offer_fired_at` below, **not** blank when `wasted=1`. |
| left_pattern, right_pattern | This hand's own `live_pattern` (above) split at its own `pause`: `left_pattern` is the `pause` cards already completed (0-indexed positions `0..pause-1`); `right_pattern` is position `pause` onward — **including the card not yet completed** at the moment the pause is offered (`pause` is a COUNT of completed cards, not an index past the uncompleted one — see `index.html`'s `pushLoop`). `left_pattern + right_pattern` always reproduces `live_pattern` exactly, no gap, no overlap. Same generation-time, not-blank-when-`wasted=1` treatment as `pause`/`sunk_cost_at_pause`. |
| e_remaining_at_hand_start, e_end_at_hand_start | Expected total main-sequence length as anticipated **the moment this hand is dealt** (before any of its own cards are known to have passed) — genuinely accounts for THIS hand's own real `p_inside`/length (unlike `Responses.e_end_at_start`, a flat population constant that never varies by hand), plus `POP_MEAN_END` for whatever uncertain hands might still follow. `e_remaining_at_hand_start` is the further-tasks figure alone; `e_end_at_hand_start` adds this hand's own `globalStart` (its position in the sequence) to get the total. See §6. |
| e_remaining_at_pause, e_end_at_pause | Same idea, but conditional on having **survived to this hand's own `pause`** — accounts for only what remains in THIS hand from there, plus uncertain future hands (`eRemFullrandWith_()`, walking this hand's real live positions). `e_end_at_pause = ` this hand's `globalStart + pause + e_remaining_at_pause`. For the FIRST hand of a section, this is exactly the figure `alt_duration`/`alt_minus_expected` (`Responses` sheet) are built around. |
| pause_secs, offer_fired_at | Set at RUNTIME, NOT fixed at generation time like `pause`/`sunk_cost_at_pause`/`left_pattern`/`right_pattern`/the `e_*` fields above — the moment this hand's own offer screen actually shows (`showOfferScreen()` in `index.html`): `pause_secs` is how long that screen's countdown ran (Uniform[10,45]s, redrawn independently on every offer) — the ENTIRE accept/refuse window for this hand, spanning both the initial ask step and its own follow-up confirm step (the same countdown runs underneath both, uninterrupted — see the next row), `offer_fired_at` is the real wall-clock ISO timestamp of that same moment — `Responses`' `switch_offered_at_task`/`_at_time` only ever capture the FIRST such moment across the whole section, by design, so every later hand's own firing time lives only here. Both blank iff this hand's own offer was wasted (`wasted=1`), since no offer screen was ever shown for it. |
| undo_count, auto_refused, auto_confirmed | WT_E's two-step accept flow (`tentativeChoice_`/`confirmTentative_`/`undoTentative_` in `index.html`): pressing "Accept and switch"/"Refuse and stay" only sets a *tentative* choice — nothing commits until "Confirm" is pressed on the follow-up screen, or `pause_secs`'s countdown runs out. `undo_count` is how many times "Undo" was pressed on that follow-up screen for this hand's own offer (0 if never opened or never undone) — a measure of indecision. `auto_refused=1` iff the countdown ran out on the FIRST screen (no tentative choice yet), defaulting to staying in the main sequence; `auto_confirmed=1` iff it ran out on the FOLLOW-UP screen instead (a tentative choice existed), auto-committing that choice rather than reverting it — at most one of the two is ever 1 for a given hand, and both are 0 if the participant resolved it before time ran out, or if this hand's own offer never fired (`wasted=1`). |
| active_passed_in_hand, active_passed_in_seq, inactive_passed_in_hand, inactive_passed_in_seq | Pause-context bookkeeping, computed once at generation time (never read by the game logic, purely for analysis): how many live ("active") and safe ("inactive") cards had already gone by **at that hand's own pause**, within just this hand (`_in_hand`) vs. across the whole sequence so far (`_in_seq` — see `sunk_cost_at_pause` above for their sum) |
| active_left_in_hand, active_left_in_seq, inactive_left_in_hand, inactive_left_in_seq | How many of each remain — within this hand, or across the rest of the already-realised chain |
| hand_started_at, hand_ended_at | Set at RUNTIME (`stampHandTransition_()`/`openHandTiming_()`/`closeHandTiming_()`), the moment the participant's current position actually enters/leaves this hand — unlike `pause`/`pause_secs`/`offer_fired_at` above, which are either fixed at generation time or tied specifically to this hand's own offer screen, these track actual play and cover every hand, including ones whose own offer was wasted or never opened. Blank iff this hand was never reached at all (a reload discarded the attempt before getting here). |
| hand_penalty | The mistake penalty accrued specifically **during this hand** (not the sequence's running cumulative total — see `Responses.penalty` for that) — the gap in cumulative penalty between this hand's own start and end. Same blank-iff-never-reached rule as the two timestamps above (blank, not `0` — `0` is itself a meaningful "reached it, no mistakes"). |

Written by `upsertHandRows_()` (backend.txt), called alongside `upsertRespRows_()` from both the `progress` and `complete` `doPost` branches, from the same `hands_json` array the client already builds per section (`index.html`'s `generateTasks()`/`buildAbandonedRecord_()`) — the client still sends that array as structured data (an object per hand, `hand_n` included), it is simply exploded into its own row per hand rather than serialised into one JSON-string cell.

**`tasks_json` array structure** (one element per completed grid):
```json
[
  {
    "grid_n": 1, "phase": "main", "target": "😊",
    "all_emojis": ["😊", "😅", "😂"],
    "n_targets": 4, "n_found": 4, "n_false_pos": 0, "n_missed": 0,
    "no_activity": false, "first_move_at": "2026-07-20T10:01:23.456Z"
  }
]
```

### Reload/attempt tracking

**The problem this solves.** An in-progress (not-yet-completed) section only ever reaches the `Responses` sheet once `endTask()` completes it — there was previously no record at all of a section that got abandoned partway through by a new-session reload (see §10: a new-session return restarts the current section with freshly-drawn hands, specifically so a participant can't learn `n_req` by reloading and only committing to continue/switch/forfeit once they like what they see). The hands the participant had already been shown before that reload simply vanished.

**How it works now.** Every `(seq_n, seq_attempt)` pair gets its **own row**, instead of one attempt overwriting the next:

- `seq_attempt` starts at 1 and is bumped (2, 3, ...) only when a new-session reload discards an in-progress attempt that the participant had made **real progress on** (at least one grid task completed, in either the main or alt phase). A reload that lands before the participant has done anything in the current section does not bump it — there is nothing of value to preserve.
- The discarded attempt is logged with `outcome='abandoned_reload'` and whatever hands/`card_order`/regime data it had already drawn (fully populated — those were fixed at generation time, before the participant ever saw a card; the `Hands` sheet gets its own rows for this attempt's hands too, via the same `hand_n` keying) — but its switch/forfeit timing fields are left blank, since abandonment happens before any of those could resolve into a real decision. See `index.html`'s `buildAbandonedRecord_()`.
- `is_latest_attempt` is computed **server-side**, in `upsertRespRows_()` and (one level deeper, per hand) `upsertHandRows_()` (backend.txt) — never trust a client-sent value for it — by finding, for every `seq_n` touched in a given save, the row(s) with the highest `seq_attempt` and flagging only those `1`. This stays correct even if an abandoned attempt and its successor arrive in separate `progress`/`complete` calls.
- **To get one row per real section** (the view every earlier single-attempt-per-`seq_n` analysis assumed), filter to `is_latest_attempt=1` — on `Responses` for one row per section, on `Hands` for one row per real (non-superseded) hand. To audit reload/gaming behaviour instead, look at every row for a given `(prolific_pid, seq_n)` and compare `seq_attempt`s.

A completed section that was never reloaded is simply `seq_attempt=1`, `is_latest_attempt=1` — this feature adds rows only when something was actually discarded, it never changes the shape of an ordinary respondent's data.

### API endpoints

| Method | Action | Lock | Description |
|---|---|---|---|
| GET | `?action=lookup&pid=XXX` | waitLock 10 s | Returns `{found, study_complete, resume_snapshot}` |
| POST | `action: 'progress'` | tryLock 1 s (skipped if busy) | Upserts Meta + all completed/abandoned sequence-attempt rows |
| POST | `action: 'complete'` | waitLock 10 s, idempotent | Upserts Meta (sets `study_complete_at`, clears snapshot) + all sequence-attempt rows |

---

## 10. Resume system

Two genuinely different situations both land on the boot screen, and are handled differently:

- **Same-tab reload** (accidental F5, browser back/forward, `Ctrl+R`): the participant should land back exactly where they were, with zero loss of progress — no re-drawn hands, no restarted section.
- **New-session return** (closed the tab/browser and came back later, possibly on another device): the participant should resume at the correct *screen* (survey / training / experiment), but if they were mid-section, that section restarts with freshly-drawn hands — this is what stops a participant from strategically reloading to learn `n_req` before committing to continue/switch/forfeit. As of this build, that discarded attempt is no longer silently lost — see §9's "Reload/attempt tracking".

These are told apart with `sessionStorage` (key `wtstudy_tab_session`), checked at the very top of `bootstrapAppInner_()`.

On every section completion and every 25 s (heartbeat), the frontend saves a snapshot to `localStorage` and POSTs it to the backend `Meta` sheet.

### Bootstrap: what actually decides which screen loads first

`bootstrapAppInner_()` doesn't just resume-or-show-consent — it's a decision tree with several distinct outcomes, in this order:

1. `demomode=2`, or no `PROLIFIC_PID`/`BACKEND_URL` configured: skip the backend entirely, go straight to `#screen-consent`.
2. Otherwise, `GET ?action=lookup&pid=...` (`lookupBackend_`) is awaited:
   - **Lookup throws** (network/server error): fall back to `tryLocalResume_(sameTab)` (reads the same `localStorage` snapshot key used for the heartbeat save). If that also has nothing, show `#screen-conn-error` ("Something needs a second try") with a "Try again" button (`retryBootstrap()`, which just re-shows the boot overlay and re-runs `bootstrapAppInner_()`) — deliberately does **not** fall through to consent, so a participant with real backend-saved progress can never be silently dropped back to the start by a transient network blip.
   - **`prior.study_complete`**: show `#screen-already-done` ("We have already received a complete response from you for this study.") — a participant re-opening a finished study link.
   - **`prior.found && prior.resume_snapshot`**: normal resume via `applyResume_()`.
   - **`prior.found` but no snapshot** (a `Meta` row exists — e.g. consent was recorded — but nothing was ever saved past that): try `tryLocalResume_(sameTab)` as a cross-device-style fallback before giving up.
   - Anything else: `#screen-consent`, a genuinely new respondent.

`tryLocalResume_()` is the same "read `localStorage`, `applyResume_()` if present" logic used in two different branches above (backend unreachable, and backend reachable but empty) — it returns `true`/`false` so the caller knows whether it actually resumed anything or needs to fall through further.

---

## 11. Debug mode

Append `?demomode=1` or `?demomode=2` to the URL.

| Mode | Behaviour |
|---|---|
| `demomode=0` (default) | Production |
| `demomode=1` | Shows debug bar with "Skip survey" (while on either survey screen), "Skip training" (while `trainingActive`), "Skip task" / "Skip section" / "Stop" buttons; backend still active |
| `demomode=2` | Debug bar + backend completely bypassed + Prolific redirect goes to `console.log` only |

The debug bar (`updateStats()`) shows: the respondent's META regime (with its per-hand behaviour noted inline, and a note if `?regime=` overrode it), the first hand's live/safe pattern and disclosed `pInside`, the full realised chain of hands (mask, sub-regime, outcome, and `E[end]` at that hand's own pause), where every hand's offer landed (flagging any wasted ones), how many tasks and hands the main sequence ran (flagging `[hand cap forced]`), the whole-experiment `E[end]` population constant alongside `alt_duration`, pay, reloads this section, and the sequence-frame treatment.

"Skip task"/"Skip section" also work during training (`trainDebugSkip_()` — resolves whichever auto-fill task is in flight, or just advances a step) instead of crashing against the nonexistent `S.tasks` the production versions of those buttons expect — see §5's "Training walkthrough". "Stop" is disabled throughout training.

**All skip controls live in the shared debug bar, not as inline buttons on individual screens** — `#debug-skip-survey-btn` (`debugSkipSurvey()`) is shown only while `#screen-survey`/`#screen-survey2` is active (`updateDebugSurveySkipBtn_()`, called from `showScreen()` on every navigation). "Skip survey" and "Skip training" are two independent shortcuts: "Skip survey" submits the survey and lands at the start of training as normal; "Skip training" (`debugSkipTraining()`, `#debug-skip-training-btn`) jumps from *any* point in the training walkthrough straight into the real experiment (`finishTraining()`), without needing the survey shortcut first.

**Cap-forced sections are flagged inline.** A `cap_bound=1` section shows a red `[hand cap forced]` note rather than presenting it as an ordinary natural ending — see §6 for why these rows need different treatment (right-censored at `n_req`).

---

## 12. Key constants (in `index.html`)

```js
const BACKEND_URL        = '…';        // Apps Script /exec URL
const COMPLETION_CODE    = 'C194BROI'; // Prolific completion redirect
const NO_CONSENT_CODE    = 'C1E6TYZR'; // No-consent redirect
const GRID_PAY_PER_TASK   = 0.025;     // £ per completed grid — £6/hr ÷ 3600 × 15s
const BONUS_RATE_PER_TASK = 0.0375;    // £ per task, section-bonus rate (£9/hr ÷ 3600 × 15s)
const LABOR_INCOME_WARN_THRESHOLD = 8000; // £/month — see §4's "Background survey"
const SHOW_UP_FEE = 1.50; // fixed Prolific base payment shown on the results screen — see §8

const CFG = {
  numTasks:    5,     // sections per participant — always 5, regardless of the framing treatment (see §7)
  gridR:       3,     // grid rows (3×3 = 9 cells)
  gridC:       3,     // grid columns
  revealMs:    500,   // ms between cell reveals (9 cells → 4.5s reveal)
  submitSecs:  2.5,   // countdown after full reveal (~7s total per grid)
  // ── Looping "hands" (MIXED) ──
  handLenLo:   1,     // hand length ~ Uniform[handLenLo, handLenHi]
  handLenHi:   10,
  liveMarkP:   0.5,   // each task's live/safe mark is an independent coin flip at this rate
  pInsideMean: 0.50,  // per-hand end-probability ~ Normal(mean,sd) clamped [min,max], round 5%
  pInsideSd:   0.20,
  pInsideMin:  0.10,
  pInsideMax:  0.90,
  altPMin:     0.30,  // pInside band the WHOLE-EXPERIMENT E[end] (POP_MEAN_END) is averaged
  altPMax:     0.70,  // over — keeps the alternative sized off typical, not extreme-tail, sequences
  maxHands:    6,     // UNDISCLOSED cap on hands per section — last hand forced to end (see §6)
  altMin:      2,     // floor on the alternative sequence's length
};
```

---

## 13. Data download (participant-side backup)

If the backend POST fails after 5 retries, the results screen shows:
- An error reference code
- A "Download my responses" button → downloads `wt_study_backup_<pid>.json` (JSON, not CSV — deliberately chosen so the backup can't be casually hand-edited and passed off as the original)
- Instructions to contact the researcher via Prolific messaging and attach the file

There is **no unconditional CSV download** on the results screen — the JSON backup above is the only participant-facing download, and it only appears if the backend save could not be confirmed.

---

## 14. Known design decisions and rationale

- **Mixed (independently-random) live/safe pattern, not a block structure.** Earlier iterations (WT_C, WT_geo, this study's own "classic" build) drew a hand as a run of safe cards followed by a run of live ones. Here every card is independently marked (§6), so the two are interspersed throughout — this build's defining difference, hence "mixed"/FULLRAND in the code.

- **The offer recurs on every hand, not just the first.** Every reloaded hand draws its own fresh `pause` via the current regime (`drawLoopOffer_`, called once per hand) — a design difference from single-offer builds. The `Hands` sheet's `pause`/`wasted`/`sub_regime` columns carry each hand's own realised values, one row per hand (including the first — `Responses` no longer repeats the first hand's own `pause`/`pause_max`, only `offer_wasted`, describing whether *any* hand's offer was wasted).

- **Four regimes, one of them ("mixed"/META regime 0) itself a per-hand mixture of the other two.** Regime 2 (offer first, ending conditional) never wastes the offer; regime 1 (ending first, offer after) is the deliberately-leaky reference; regime 3 (independent) is flat but can waste a hand's own offer; regime 0 re-rolls `{1,2}` independently per hand rather than fixing the whole respondent to one (never reaches 3 through this per-hand pool — 3 is only ever a constant META regime of its own). See §6 for the exact per-hand math and the verified conditional-probability worked example.

- **The hand cap (`CFG.maxHands=6`) is UNDISCLOSED, per direct instruction (for now).** If a sequence survives 6 hands, the last is forced to end on one of its own live cards (`cap_bound=1`). Not stated to the participant. Treat `cap_bound=1` rows as right-censored at `n_req`.

- **A hand's structure is not disclosed before it appears.** The pre-sequence screen states only the reward. Each hand's length, live/safe pattern, and end-probability are shown on the card stack and its caption only once that hand is dealt — including its end-probability from the hand's very first card, held fixed for the whole hand.

- **`e_end_at_start` is a whole-experiment population constant (`POP_MEAN_END`), not derived from this section's own first hand.** Because every hand after the first re-rolls fresh parameters, there is no meaningful "this section's E[end] from the start" the way a single-offer, block-structured design would compute one — the population constant is what the alternative and pay are both ultimately anchored to (via `e_remaining`, which *is* first-hand-specific, and `POP_MEAN_END` itself, respectively). See §6.

- **`alt_duration` is beta-normal, its endpoint centred on the first hand's own `e_end_at_pause` (length centred on that hand's own `e_remaining_at_pause` — `Hands` sheet, `hand_n=1`), width = the mean hand length, floored at `ALT_MIN=2`.** Centring the *endpoint* keeps the switch a ~50/50 call in expectation, which centring the length on the population constant alone would not.

- **`payTasks` is beta-normal around the population constant `POP_MEAN_END`, never around the realised `n_req` or anything section-specific.** The bonus amount can never leak how long this particular sequence will actually run.

- **`offer_wasted` and `cap_bound` are independent flags on the same row, not folded into `outcome`.** A wasted-offer section (some hand under sub-regime 3 ended before its own offer's card) has no switch decision for that hand's own pause and must be excluded from any model of the switch decision at that point, not treated as an implicit decline. A capped section (`cap_bound=1`) hit the undisclosed hand cap and should be treated as right-censored at `n_req`. Both can coexist with any of the three real `outcome` values (`abandoned_reload` rows, see below, never carry a switch decision at all).

- **Reloaded/abandoned attempts are logged as their own rows, not discarded (new in this build).** A new-session reload that restarts an in-progress section with freshly-drawn hands used to just lose whatever had already been shown to the participant — there was no way to distinguish "this respondent never got offered X" from "they were offered X, reloaded, and got a different draw instead." `seq_attempt`/`is_latest_attempt` (see §9) fix this: every attempt gets its own row, and filtering to `is_latest_attempt=1` reproduces the old one-row-per-section view exactly for anyone who doesn't care about the reload history.

- **No-activity detection is gated on cursor movement, not on the answer given.** Checking zero cells is a legitimate active submission; only the complete absence of cursor movement during the subtask counts as "no activity." The penalty always applies; on top of that, a blocking "Are you still there?" screen holds progress at the current point until acknowledged.

- **Section bonus is earned on `completed` or `switched`, lost on `forfeited` or `autokicked`.** Switching to the alternative sequence is a within-budget decision (open-ended duration → known duration, same payoff), not a penalised one. There is no "forced switch" outcome — a hand always resolves on its own draw or loops into another, so there is no boundary that can push a participant into the alternative involuntarily. `autokicked` (see §8's "Autokick") is the one way a section can end involuntarily other than the participant's own choice to forfeit.

- **Regime is assigned once per respondent, not per section.** Fixing it per respondent keeps a respondent's five sections comparable. `SESSION.regime`, drawn at consent and persisted through resume.

- **`switch_taken`/`forfeit_taken` are independent, persistent flags, not derived from `outcome`.** A participant can switch and *then* forfeit the alternative sequence — the single `outcome` string cannot represent that combination on its own, which is exactly why `outcome_summary` exists (below).

- **Sequence-count framing (`nSeqFrame`) is assigned once, at consent, and never re-rolled** — see §7.

- **Training teaches the hand mechanic on the real card-stack.** Dim the real task screen, light up exactly what's being explained, with a demo card-stack (`renderTrainHand_`) beside the grid — see §5.

- **Outcome taxonomy (`outcome_summary`)**: `outcome`/`switch_taken`/`forfeit_taken` are the real, independent data — accurate but not glanceable as a single label. `computeOutcomeSummary_()` (`index.html`) derives exactly one of the following strings, purely for reading the sheet at a glance:

  | `outcome_summary` | When |
  |---|---|
  | `forfeited before offer` | Forfeited in the main phase, before the offer ever appeared |
  | `continued and forfeited` | Forfeited in the main phase, after the offer had appeared but without ever switching |
  | `continued and completed` | Never switched or forfeited; the main sequence completed naturally |
  | `switched at offer` | Switched, having accepted the very first offer of the section, at the exact task it appeared |
  | `switched after continuing` | Switched, but only after declining (or letting time run out on) an earlier hand's own offer and accepting a later hand's own offer instead — WT_E has no persistent button, so this can only happen across different hands, never within the same one |
  | `auto-kicked before offer` | Autokicked (see §8) in the main phase, before the offer ever appeared |
  | `continued and auto-kicked` | Autokicked in the main phase, after the offer had appeared but without ever switching |
  | `switched at offer and forfeited` | Same as `switched at offer`, but then forfeited during the alternative |
  | `switched after continuing and forfeited` | Same as `switched after continuing`, but then forfeited during the alternative |
  | `switched at offer and auto-kicked` | Same as `switched at offer`, but then autokicked during the alternative |
  | `switched after continuing and auto-kicked` | Same as `switched after continuing`, but then autokicked during the alternative |
  | `entered alt without switching` | Defensive label for an unreachable state under this design (no forced-switch mechanic exists) — kept rather than silently mislabelling it as a voluntary switch if it is ever observed |
  | `entered alt without switching and forfeited` | Same defensive case, with a forfeit in the alternative phase |
  | `entered alt without switching and auto-kicked` | Same defensive case, with an autokick in the alternative phase |
  | `abandoned before reload — superseded by a later attempt` | A new-session reload discarded this attempt before it reached any real outcome — see §9's "Reload/attempt tracking" |

  All values (aside from the reload one, set directly by `buildAbandonedRecord_`) are fully derivable from columns already logged (`switch_offered`/`_at_task`, `switch_taken`, `switch_pressed_at_task`, `alt_phase_started_at`, `forfeit_taken`, `auto_kicked`, `outcome`) — `outcome_summary` is a read-time convenience, never a new source of truth.
