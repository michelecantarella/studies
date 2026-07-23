# WT Study — Design & Implementation Reference

**Study title:** Value of Wasted Time
**Platform:** Prolific + GitHub Pages
**Files:** `index.html` (frontend) · `backend.txt` (Google Apps Script)
**Contact:** Michele Cantarella — michele.cantarella@imtlucca.it
**Ethics approval:** Joint Ethical Committee of Scuola Superiore Sant'Anna / Scuola Normale Superiore / IMT Lucca — N. 23/2026, 30 April 2026

---

## 1. What the study measures

The study investigates how people manage time and forgone earnings when facing an uncertain stopping point. Participants complete a series of grid tasks to earn a section bonus; the key manipulation is whether and when they switch from the main sequence (uncertain duration, and possibly no defined end at all) to an alternative sequence (known, fixed duration), or forfeit entirely.

---

## 2. File inventory

| File | Purpose |
|---|---|
| `index.html` | Single-page frontend — all study logic, UI, and data collection |
| `backend.txt` | Google Apps Script source — paste into Apps Script editor and deploy |

Both files live in this folder. The study is designed to be hosted as a static file (GitHub Pages, any web server). The backend is a Google Sheets / Apps Script deployment.

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
  → (I consent) → Survey (2 screens — background/household, then finances/preferences; see §5's "Background survey")
    → Training (16-step guided walkthrough on a static practice sequence, ends with a £0.10 bonus; the second-to-last step is a real, recorded Switch-vs-Continue decision — see §5)
      → [repeat for each of 5 sections]
          Grace period (task preview: timeline + P(inside window) + pay amount)
            → Grid tasks loop
              → [pause reached] → in-place "alternative available" banner + resume countdown
              → [task ends inside the window, OR forced-switched at barHi] → Section result screen
      → Results screen (single earnings summary, net of penalties — no per-section table)
        → Backend complete POST (5 retries)
          → Prolific redirect C194BROI
```

On page reload at any point after consent: a same-tab refresh resumes exactly where the participant was; a new-session return restarts the current section with freshly-drawn parameters. Completed sections are always preserved. See §10.

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

---

## 5. Task mechanics

### The grid task

Each task presents a 5×5 grid of emoji symbols that **reveal progressively** from left to right, one cell every **500 ms** (12.5 s total for all 25 cells, unchanged — this pacing is deliberately preserved even after the speed-up below). Once fully revealed, a **2.5-second countdown** begins. The participant must click all instances of the **target emoji** shown above the grid. The task auto-submits at countdown end.

- Grid size: 5×5 = 25 cells
- Target emoji: drawn at random from a pool of ~65 emojis
- Number of targets per grid: uniform over {3, 4, 5, 6}
- Total time per grid: ~15 s (12.5 s reveal + 2.5 s countdown — shortened from 17.5s/5s; only the countdown changed, not the reveal pacing between cells). Since `CFG.submitSecs` (2.5) doesn't divide evenly into whole seconds, the countdown display (`showSubmit()`/`trainShowCountdown()`/`trainLiveShowSubmit_()`) ticks every 500ms internally and shows `Math.ceil()` of what's left, so it still reads as a clean "3…2…1" on screen while ending at exactly 2.5s.
- Errors (missed targets or false positives) incur a small penalty (£0.01 each) but do not stop the sequence
- **No-activity detection** is gated on whether the cursor moved at all during the subtask (a standard `mousemove` listener, `S.mouseMoved`/`S.firstMoveAt`), **not** on whether any cell was checked — checking nothing can be a genuine, active submission (e.g. a grid the participant correctly judged had no matches left to find). The normal missed/false-positive penalty always applies regardless; if no cursor movement was detected, a **blocking** "Are you still there?" screen then takes precedence over whatever would normally happen next (next subtask, offer, completion) — it does not regenerate a new grid/target, it just holds progress at the current point until acknowledged (`showNoActivityScreen_()`/`acknowledgeNoActivity_()`). Each grid record in `tasks_json` carries a `no_activity` flag and a `first_move_at` timestamp (first cursor movement since that subtask started, or `null`).

### The sequence structure

Each section has three zones on a shared timeline:

| Zone | Notation | Description |
|---|---|---|
| Safe zone | `[0, inactive]` | Task cannot end here; `inactive ~ Uniform[0, 3]` |
| End zone (window) | `[barLo, barHi]` | If the task resolves at all, it resolves at some task number drawn uniformly from this range; `barLo = inactive + 1`, `barHi = inactive + window` (spans exactly `window` task positions) |
| Window size | — | `window ~ Uniform[7, 15]` |

**The task may never resolve inside the window at all.** Each section draws a disclosed `pInside` (see §6) — the exact, participant-facing probability that the task's completion falls inside `[barLo, barHi]`. With probability `pOutside = 1 - pInside`, the section is a "forced-outside" sequence: the participant is **automatically** moved to the alternative once `barHi` is reached, with no offer screen and no choice for that specific transition (the ordinary voluntary offer at `pause`, described below, still happens exactly as normal beforehand — forced-outside is an additional layer on top of it, not a replacement).

An internal `nReq` (drawn uniformly within `[barLo, barHi]`) is still generated for every section, inside or outside, purely for internal/analysis reference — it is never surfaced to the participant, and gameplay only ever reaches it on inside sequences.

### The pause and alternative offer

At task number `pause` (always **strictly before** `nReq` — see §6), the section pauses and an **in-place banner** replaces the "Find and click all…" instruction line (no separate screen navigation). The banner itself is deliberately terse — just "An alternative sequence is available!" (or, on a later reminder, "Reminder: an alternative sequence is still available!") — the `pInside`/`pOutside` disclosure lives in the window-zone label on the diagram, not repeated here. Below the grid:

- A "The task will resume in …s" countdown, using the same below-grid countdown element as the normal submit countdown
- An explicit **"Resume now"** button, for participants who don't want to wait out the countdown
- The grid area cleared to placeholders (no subtask is running during the pause)

The pause lasts a random `U[5, 30]` seconds (`pause_secs`). If the timer expires (or "Resume now" is clicked), it auto-selects "Continue main sequence." Before the pause is reached, a **switch button** activates (visible on the left side of the task screen) once `switch_cost = pause` tasks have been completed, letting the participant switch later even after declining the first offer. Clicking it opens a confirmation overlay.

Decisions available at the pause:

| Decision | Outcome |
|---|---|
| **Continue** | Main sequence resumes; switch button remains visible |
| **Switch** | Participant moves to the alternative sequence (fixed `alt_duration` tasks) — `switch_taken = 1` |
| **Forfeit** | Both sequences abandoned; no bonus earned |

If the participant does none of these and the section is a forced-outside sequence, reaching `barHi` triggers the automatic switch described above (`forced_outside = 1`, `switch_taken` stays `0` — these are deliberately kept as two separate flags, since forced vs. chosen have different causal meaning for the analysis).

### Training walkthrough's live practice round

The 16-step training walkthrough (`TRAIN_STEPS` in `index.html`) is otherwise a static, hard-coded explanation — but its second-to-last step, `startsLive:true` ("Let's give it a try"), hands off into a real, interactive practice round on the genuine `#screen-subtask`, not just descriptive text. Pressing Continue there calls `trainLiveStart_()` instead of advancing to the next step directly; `trainStep` itself only advances once the round concludes.

The round genuinely restarts from a fresh task 1 (`trainLiveStart_()` → `trainLiveRunSubtask_()`) — real grid reveal, real autosubmit countdown, ungraded (clicks toggle cells but nothing is scored). Once that first subtask completes (`TRAIN.pause:1`), the real offer-banner UI appears (`trainLiveShowOffer_()`): same flash, same "An alternative sequence is available!", same Resume-now button, just a fixed 10s pause instead of production's random 5-30s. From there:
- **Switch** (`trainLiveChoice_('switch')`) ends the practice round immediately — switching is itself the recorded terminal event, so there's no need to grind through a full alternative sequence just for a quick practice run.
- **Continue**, or letting the 10s pause run out, runs one more real subtask (task 2 — real grid, real autosubmit, ungraded), which then ends the practice once it autosubmits.

The top progress bar's alt line is kept hidden until the offer is actually reached — `drawTrainingProg()` only draws it once `trainLive.offerShown` is true (mirroring production's `offerActive:S.switchAvailable` gating in `redrawProg()`), rather than the static `step>=7` rule the rest of the walkthrough uses. Otherwise the bar would leak the alternative's existence before the participant has actually been offered it.

Either way the outcome is recorded as `SESSION.trainingChoice` (`'switch'`/`'continue'`) and `SESSION.trainingChoiceAt`, and `trainLiveFinish_()` advances to the final "You're ready to go" step, whose body branches on that choice. Both are included in the resume snapshot and sent to the backend as `training_choice`/`training_choice_at` on `Meta` (§9) — purely a check that the mechanic was understood before the real study begins, not tied to any pay or real section (the flat £0.10 training bonus is unconditional either way).

In debug mode (`demomode>=1`), the debug bar's existing "Skip task"/"Skip section" buttons also work during this round — both call `trainLiveFinish_('continue')` to jump straight to the end, since the production logic they'd otherwise run (`proceedAfterSubmit()`/`endTask()`) assumes a real `S.tasks` entry that doesn't exist yet during training and would crash. "Stop" is disabled during the round instead (`trainLive`'s timers aren't tracked by the production `kill()`/`startSubtask()` pair it relies on).

Two things this needed care around:
- **`#st-left-panel` normally has `pointer-events:none` during training** (so the switch/forfeit buttons can't be clicked before they're explained). Re-enabling the whole panel for this round would also make Forfeit clickable — which would crash, since `S.tasks` doesn't exist yet during training. Only the switch button's own `pointer-events` are overridden, and the Forfeit button is kept at `opacity:0` throughout, out of scope for this round.
- **Timers must not stomp on the switch-button rebind mid-round.** The shared `trainKill()` (used elsewhere on every training navigation) does a full defensive reset — offer banner hidden, switch button's `onclick`/`pointer-events` restored — which would undo the round's own rebinding if called between subtasks. The live round's internal transitions (`trainLiveRunSubtask_`, `trainLiveShowOffer_`, `trainLiveChoice_`) instead use the lighter `trainClearTimers_()` (timers only), reserving the full `trainKill()` for the round's actual start/end and for leaving the walkthrough entirely (e.g. clicking Back mid-round, which also clears `trainLive` so no state leaks into later steps).

---

## 6. Parameter generation

Every parameter except `regime` is drawn independently per section. `regime` is drawn **once per respondent** (at consent, stored in `SESSION.regime`) and reused for all 5 sections — deliberately not redrawn per section, so a within-subject comparison across a respondent's sections isn't confounded by regime switching under them.

### Core parameters

```
inactive   ~ Uniform[0, 3]          (integer; safe zone length)
window     ~ Uniform[7, 15]         (integer; end-zone width, i.e. number of task positions in it)
barLo      = inactive + 1
barHi      = inactive + window      ([barLo,barHi] spans exactly `window` task positions)
pauseMax   = inactive + ceil(window/2)
```
`pauseMax` caps the pause at halfway through the window. This is a reinstated cap — it briefly widened to `barHi - 1` (every task up to, not including, the last one in the window), but a pause landing that late leaves almost no window remaining, so staying in the main sequence barely costs anything and the switch decision stops being a real one too often. Shared by all three regimes (each just draws `pause ~ Uniform[0, pauseMax]`, or further capped by `nReq-1` in regime 1's inside case — see below), so the cap applies consistently everywhere `pause` is drawn, not just to some regimes.

### P(inside window) / forced switch

```
pInsideRaw = Normal(mean=0.5, sd=0.20), clamped to [PINSIDE_MIN=0.10, PINSIDE_MAX=0.90]
pInside    = round(pInsideRaw × 20) / 20   // rounded to the nearest 5%
pOutside   = 1 - pInside
```
`pInside` is a continuous draw, rounded to the nearest multiple of 5% (not a fixed discrete set — an earlier iteration used one, {10%,30%,50%,70%,90%} then narrower ranges, before switching to a continuous draw; the 5% rounding is only there so the disclosed number itself reads clean, e.g. "65%" rather than "63.4%" — it doesn't change the shape of the underlying distribution). It's centred at 50% deliberately: the 50%-ish region is where switching is a genuinely live decision; at the extremes (`pInside` near 10% or 90%) it's basically always rational to switch (or not) regardless of anything else about the section, so those cases are only interesting as occasional edge cases, not as a full third of the design. With `sd=0.20`, about 38% of draws land in `[40%,60%]`, and only ~2.3% get clamped to exactly `PINSIDE_MIN` or `PINSIDE_MAX` (verified in simulation — see `randNormal_()`, a Box-Muller transform, since JS has no built-in normal RNG).

`pInside` is disclosed to the participant exactly (grace screen, in-window zone label, offer banner).

### Three regimes (respondent-level, drawn 1/3 each once)

Regimes 1 and 2 enforce `pause <= nReq - 1` (strictly at least one task before the task can end) — `pause` can never equal or exceed `nReq`, so the offer/decision point can never coincide with (or trail) the task already being over. **Regime 3 does not enforce this** — see below.

The three regimes realise `isForcedOutside`/`nReq`/`pause` via genuinely different generative procedures, not just a reordering of the same draws — inside/outside and position are causally upstream of the pause in regime 1, downstream of it in regime 2, and fully independent of it in regime 3. Regimes 1 and 2 exist in parallel with regime 3 as a check that participant behaviour doesn't depend on which of the (belief-equivalent, in regimes 1/2) reveal orders they happened to get — not as a way of changing the underlying probabilities.

**Regime 1** — inside/outside first, then position (if inside), then pause:
```
isForcedOutside ~ Bernoulli(pOutside)                          (unconditional — nothing to condition on yet)
nReq  ~ Uniform[barLo, barHi]                                   (drawn regardless; internal reference only if outside)
pause ~ Uniform[0, pauseMax]                    if isForcedOutside
pause ~ Uniform[0, min(nReq - 1, pauseMax)]     otherwise        (capped by nReq only when that cap is meaningful)
```

**Regime 2** — pause first, then inside/outside (using pInside *reduced* to reflect survival past pause), then position:
```
pause ~ Uniform[0, pauseMax]
nInsideRemaining = window            if pause < barLo
nInsideRemaining = barHi - pause     if pause >= barLo          (tasks up to and including pause can no longer be the end point)
insideMass   = pInside × (nInsideRemaining / window)
survivalMass = insideMass + pOutside                             (an outside sequence always "survives" any pause, by definition)
pInsideGivenPause = insideMass / survivalMass
isForcedOutside ~ Bernoulli(1 - pInsideGivenPause)
nReq  ~ Uniform[barLo, barHi]                   if isForcedOutside   (internal reference only)
nReq  ~ Uniform[barLo, barHi]                   if pause < barLo and not isForcedOutside
nReq  ~ Uniform[pause + 1, barHi]               if pause >= barLo and not isForcedOutside
```
This is the same survival-conditional logic already used for `expectedEndGivenSurvival_`/`computePMainFirst_` (§6 below), applied here to decide the *actual* realisation rather than just to describe it to the participant.

**Known, accepted consequence of regime 2:** because `pause` is drawn independently of `pInside` in regime 2, and `pInsideGivenPause` is a nonlinear function of `pause`, the *marginal* (pause-integrated) probability of `isForcedOutside` under regime 2 runs measurably higher than the disclosed `pOutside` — e.g. disclosed 50% realises around 63% outside in simulation, disclosed 70% realises around 44%. This is a deliberate point of comparison against regime 3 below (whose marginal matches the disclosure exactly), not a bug to fix — see the framing note at the top of this section.

**Regime 3** — two truly independent flips, no interaction between them at all:
```
isForcedOutside ~ Bernoulli(pOutside)     (unconditional — identical mechanism to regime 1's first step)
nReq  ~ Uniform[barLo, barHi]              (drawn regardless, same as regime 1)
pause ~ Uniform[0, pauseMax]               (independent of nReq — NOT capped by nReq-1)
```
Because `pause` is not capped by `nReq` here, **it is genuinely possible for the task to already have ended before the pause is reached.** No special-casing is needed for this in gameplay: `proceedAfterSubmit()`/`startTask()` already check nReq-completion independently of wherever the pause point is, so if `nReq` comes first, the offer for that section's `pause` simply never fires — the section just completes normally. In simulation, this happens for roughly 13% of regime 3's "inside" sections. Regime 3's realised marginal `P(outside)` matches the disclosed `pOutside` exactly (verified in simulation), unlike regime 2's — see above.

### Alternative sequence duration

`alt_duration` is a single, independent draw per section — it drives **both** the in-window voluntary alternative (`altEnd = pause + altDuration`) and the forced alternative if the section is forced-outside (`forcedAltEnd = barHi + altDuration`).

This went through five iterations before landing on the current approach, and since the third one is genuinely two-part (a stable centre, then a deliberate, bounded jitter), it's worth walking through the whole history in full.

**Iteration 1 — solve against the section's true `pInside`.** `altEnd` was made to exactly match the pause-conditional expected end, `E[end|pause]`, computed with the section's real, disclosed `pInside`/`pOutside`. This was unstable at the extremes: median `altDuration` around 17 tasks at `pInside=30%` (not a rare tail — the *typical* case), and down to 1-2 tasks (trivially short) at `pInside=70%`. The instability comes from `altDuration` appearing on both sides of the equation being solved — when `pOutside` is large, the outside term dominates the average, and balancing the equation forces `altDuration` very large; when `pInside` is large, there's almost no "inside" mass left to average over near the end of the window, so almost no `altDuration` is needed at all.

**Iteration 2 — solve against a fixed 50% instead (`ALTDUR_PINSIDE`).** At `pInside=50%` the exact same equation is well-behaved at every `pause` value (verified in simulation: mean ~9, min 2, max 23, identical regardless of the section's actual `pInside`). This removed the instability, but at the cost of the section's real `pInside` no longer affecting `altDuration` **at all** — which loses a real, desired relationship (lower `pInside` plausibly *should* mean a longer alternative, and vice versa), it just can't be implemented as a direct equation solve without reintroducing the instability.

**Iteration 3 — fixed 50% centre, plus a bounded, directional jitter.** The centre is computed exactly as in iteration 2. The section's real `pInside` then shifts `altDuration` away from that centre — bounded so it can never reintroduce the instability:

```
altDurStar  = solveAltDurationForPauseMatch_(barLo, barHi, pmf, pause, ALTDUR_PINSIDE, 1-ALTDUR_PINSIDE)
deviationFrac = (ALTDUR_PINSIDE - pInside) / (ALTDUR_PINSIDE - PINSIDE_MIN)
altDuration = max(1, round(altDurStar + deviationFrac × altDurStar))
altEnd       = pause + altDuration
forcedAltEnd = barHi + altDuration
```

`solveAltDurationForPauseMatch_()` is the same pause-conditional-E[end] solver from iteration 1/2 — see the formula and code comment in `index.html` for its derivation; the point here is only what's plugged into it and what happens to its output.

`deviationFrac` is the jitter, expressed as a fraction of `altDurStar` itself:
- **`pInside` below 50%** → `deviationFrac > 0` → `altDuration` shifts **longer** (right, on a number line running low-to-high `altDuration`).
- **`pInside` above 50%** → `deviationFrac < 0` → `altDuration` shifts **shorter** (left).
- **`pInside` exactly 50%** → `deviationFrac = 0` → `altDuration = altDurStar`, unchanged from the centre.
- **Bound:** `deviationFrac` is exactly `+1` at `pInside = PINSIDE_MIN` (10%) and exactly `-1` at `pInside = PINSIDE_MAX` (90%) — both bounds are equidistant from 50% (`0.5-0.10 = 0.40 = 0.90-0.5`), so the jitter is symmetric. Since `|deviationFrac| <= 1` always, the jitter's magnitude can never exceed `altDurStar` itself — i.e. `altDuration` ranges from `0` (floored to `1`) up to `2×altDurStar`, and never further. This is the literal implementation of "the jitter cannot be larger or smaller than the expected conditional task end at 50% probability."

Because `pInside` is now a continuous Normal draw rather than a handful of fixed points, the jitter varies continuously too — most sections get a small nudge (since most `pInside` draws land near 50%), and only the rare, clamped `pInside=10%/90%` sections get the full ±100% swing. Verified in simulation (Normal(0.5,0.20) `pInside`, this jitter): `altDuration` mean ~9.2, median 8, only 0.66% reach ≥30, only ~2% hit the floor of 1 — a real but genuinely rare edge case, not a systematic bias in either direction the way iteration 1 was.

**What this changed for the other computed values:** `expectedStartEnd`/`expectedMainEnd`/`e_end_at_start`/`e_end_at_pause` still used the section's TRUE `pInside`/`pOutside` (never `ALTDUR_PINSIDE`) — only the `altDuration` *draw itself* was computed via the fixed-centre-plus-jitter approach above. This meant `altEnd` no longer exactly equalled `expectedMainEnd`; that exact-match property was the source of iteration 1's instability, and dropping it was the point of iteration 2/3.

**Iteration 4 — plain uniform draw over the sequence's own geometry, no `pInside` calibration at all.** Iterations 2/3 tied `altDuration` to a *solved* expected-value equation (stable at the 50% centre, then jittered by `pInside`) — correct, but opaque, and coupled `altDuration` to `pInside` in a way that turned out not to be wanted going forward. Iteration 4 dropped the solve entirely in favour of a plain integer `Uniform[low, high]` draw:

```
altDuration = Uniform[barHi - pause, 2 × window]     (integer, inclusive both ends)
```

- Low bound, `barHi - pause`: the number of task positions still remaining from the pause to the end of the window.
- High bound, `2 × window`: twice the window's own length, independent of `pause` entirely — the same ceiling applied no matter when the offer fired, so the range's *width* grew with `pause` (wider the later the offer fired).

**Iteration 5 (current) — same idea, but a constant-width range tied to `pause` at both ends.**

```
altDuration = Uniform[(barHi - pause) + 1, (barHi - pause) + 1 + window]     (integer, inclusive both ends)
altEnd       = pause + altDuration
forcedAltEnd = barHi + altDuration
```

- **Low bound, `(barHi - pause) + 1`:** one more than the number of task positions still remaining from the pause to the end of the window — so the alternative always takes strictly longer than simply riding out the rest of the window would. Always `>= 2`, since `pause <= pauseMax = inactive + ceil(window/2)`, itself always `< barHi`.
- **High bound, `low + window`:** a full window's worth of additional spread on top of that floor.
- **Range width is now always exactly `window`, regardless of `pause`** — iteration 4's width instead grew with `pause` (`2×window - (barHi-pause)`, wider the later the offer fired), which wasn't an intentional design choice, just a side effect of the high bound being flat. Iteration 5 fixes that: both ends now move together with `pause`, so the *spread* of possible `altDuration` values is consistent no matter when the offer happens to fire.
- `pInside`/`PINSIDE_MIN`/`PINSIDE_MAX`/`ALTDUR_PINSIDE`/`solveAltDurationForPauseMatch_()` still play **no role** in this draw — `pInside` still governs whether the section resolves inside/outside the window at all (unchanged), it just doesn't calibrate `altDuration`'s length. `ALTDUR_PINSIDE` and `solveAltDurationForPauseMatch_()` were removed from `index.html` as dead code back in iteration 4; `expectedEndGivenSurvival_()` (used for `expectedStartEnd`/`expectedMainEnd`/the pay band) is unaffected — it still just takes `altDuration` as a plain input, whatever produced it.

**The old solve is still logged, just no longer acted on.** Even though the indifference-point solve no longer picks the realised `altDuration`, its output is still worth having for post-hoc analysis (e.g. how far the random `altDuration` landed from the value that would have made a participant exactly indifferent). `computeIndifferentAltDuration_()` — the same math as the old `solveAltDurationForPauseMatch_()`, using the section's real, disclosed `pInside`/`pOutside` — is called once per section purely to compute and log `alt_duration_indifferent` (see the field table in §9). It has no other effect: the realised `altDuration` above is drawn independently of it. (Fixed a real gap here: `alt_duration_indifferent` was being computed and stored in `S.log` but `buildFullData_()` — the function that actually builds the POST payload — didn't forward it, so it was silently never reaching the backend. Now included in that mapping alongside `alt_duration`/`alt_end`.)

**The diagram's worst-case tick length** (`visMaxK_()`, §5) is sized consistently with this: the uniform's high bound, `(barHi-pause)+1+window`, is maximised when `pause=0` (the earliest possible pause, which maximises `barHi-pause`), giving `barHi+1+window` as the true worst case across every possible `pause` draw. This still depends only on `barHi`/`window` — never the section's real `pause` or realised `altDuration` — so there's nothing for it to leak.

### Reward

The bonus rate is derived from a target hourly wage: `£9/hour ÷ 3600s × 15s per task ≈ £0.0375/task` (was `× 17.5s ≈ £0.043/task` before the task-speed change — see §5's "The grid task"). `GRID_PAY_PER_TASK` was scaled down proportionally alongside it, from `£0.03` to `£0.026` (`0.03 × 15/17.5`).

`payTasks` is **not** the realised `nReq` — it is rolled between the section's own unconditional `E[end|start]` evaluated at the two ends of the `pInside` set (10% and 90%), using the section's real `barLo`/`barHi`/`altDuration` throughout and only swapping `pInside`/`pOutside`, then trimmed to the middle 60% of that band (cutting the top and bottom 20%):

```
eAtPInsideMin = expectedEndGivenSurvival_(barLo, barHi, pmf, barLo, PINSIDE_MIN, 1-PINSIDE_MIN, altDuration)
eAtPInsideMax = expectedEndGivenSurvival_(barLo, barHi, pmf, barLo, PINSIDE_MAX, 1-PINSIDE_MAX, altDuration)
payBandLo = min(eAtPInsideMin, eAtPInsideMax)
payBandHi = max(eAtPInsideMin, eAtPInsideMax)
payLo = payBandLo + 0.2×(payBandHi-payBandLo)
payHi = payBandLo + 0.8×(payBandHi-payBandLo)
payTasks = round(Uniform[payLo, payHi])
pay = round(payTasks × 0.0375, 2)            (rounded to the nearest £0.01)
```
This ties the reward to the actual span the study's own `pInside` range can produce for that section, rather than to an arbitrary trim of the window — an earlier iteration (trimming `payTasks` to the 30th–70th percentile of the window directly) still produced bonuses that were sometimes too low. `payTasks` never uses the respondent's actual regime, the realised `pause`, or the section's actual `pInside`/`isForcedOutside` — only `barLo`/`barHi`/`altDuration`, which are already fixed before any of those are relevant — so bonus pay stays statistically identical across both regimes and doesn't leak information about `nReq`.

**Effective hourly rate, checked by simulation, not just the £9/hr formula it's nominally derived from.** The `£9/hr` figure only ever went into deriving `BONUS_RATE_PER_TASK` in isolation — it says nothing about the combined effective rate once `GRID_PAY_PER_TASK` (paid per real grid completed, on top of the bonus) is added in, and `payTasks` (what the bonus is actually paid on) isn't the same thing as the real number of grids a participant ends up doing. A 300k-section Monte Carlo across all 3 regimes, assuming a participant never voluntarily switches (i.e. rides every section to its natural conclusion — the longest-plausible-time case, so this is a conservative/lower-bound estimate of £/hr, not an optimistic one), gives:
- Mean real grids per section ≈ 12.8 (forced-outside sections run much longer on average — `barHi + altDuration` — than sections that resolve inside the window on their own; forced-outside happens ~54% of the time, close to `pInside`'s ~50% mean)
- Effective rate (bonus + grid pay, divided by real grids × 15s) ≈ **£14.9–15.0/hr** at the current `BONUS_RATE_PER_TASK=0.0375`/`GRID_PAY_PER_TASK=0.026` — comfortably above the £9/hr target, not below it, so no further rate increase was applied. (The pre-speed-up rates, `0.043`/`0.03` at 17.5s/task, worked out to the same ≈£14.7/hr — the proportional scaling preserved the existing effective rate rather than changing it.)

### P(main ends before alt) — shown in debug mode

The probability that the main sequence would finish before the alternative would, given only the information available at the moment being evaluated — used to gauge how rational it is to stay in the main sequence vs. switch. `computePMainFirst_(atTask, altDuration, task)` in `index.html` implements this and is shared by two fields:

- **`p_main_first`** — evaluated at `atTask = pause` (when the offer was first shown).
- **`p_main_at_switch`** — evaluated at `atTask = switchTakenAtTask` (when the participant actually switched, which can be later than the initial offer if it was declined at first). `null` if the participant never switched.

The formula accounts for `pInside`/`pOutside`: the "surviving" probability mass at `atTask` is `pInside × (share of the in-window positions still ahead)` **plus** `pOutside` (an outside sequence never finishes inside the window at all, so it always "survives" past `atTask`). Without this weighting the ratio could read 100% purely because `altDuration` is large relative to the window, even when a real chance of going outside means the main sequence is nowhere near certain to actually beat the alternative.

---

## 7. Hidden sequence-count framing treatment

A between-subjects treatment, independent of the per-section parameter draws in §6.

- On consent, each participant is assigned `nSeqFrame` — **50/50, drawn once, persisted for the rest of the session** (survives reload via the resume snapshot, never re-rolled): either `4` or `5`.
- **Everyone actually completes all `CFG.numTasks` (5) sections, regardless of `nSeqFrame`.** Only what's *communicated* changes:
  - `nSeqFrame = 5`: told there are 5 sections, throughout (status quo / untreated).
  - `nSeqFrame = 4`: told there are 4 sections. The real 5th section is never announced in advance — the grace screen instead opens with a **generic** bonus-offer message ("You're being offered an additional bonus sequence!") behind its own Continue click, with the section's actual timeline/probability/pay details kept hidden until that click is made (previously these details were visually present, just unlabelled, underneath the bonus-offer message — now genuinely hidden via `#grace-details-block`).
- Implemented via `SESSION.nSeqFrame`, `isBonusIdx_()`, `sectionLongLabel_()`, `sectionShortLabel_()` in `index.html`.
- Recorded per-respondent (`seq_frame_treatment` in `Meta`) and per-sequence (`seq_frame_treatment`, `seq_is_bonus` in `Responses`).
- The debug bar (`?demomode=1/2`) shows `Seq frame: 4/5` and flags `(bonus)` on the relevant section.

---

## 8. Payment structure

| Component | Amount | Condition |
|---|---|---|
| Section bonus | `pay` | Paid if **main sequence completed OR switched to alternative** (voluntary or forced). Lost only on **forfeit**. |
| Task completion pay | £0.026 per task done | **All** tasks done in the section, regardless of outcome |
| Mistake penalty | -£0.01 per missed/false-positive click | Deducted from the section's total |
| Training bonus | £0.10 flat | Once, on completing the training walkthrough |
| Prolific base pay | Set separately in Prolific | Fixed, paid by Prolific |

**The section bonus is earned on both `completed` and `switched` outcomes** (including forced switches) — switching to the alternative sequence does not cost the participant the bonus. Only `forfeited` sequences lose it.

**Task completion pay is always earned** regardless of outcome, and is never touched by penalties. This is not communicated to the participant during the task (the UI says "no bonus earned" on forfeit, referring only to the section bonus) — it is only reflected in the final results screen.

**Mistake penalties are deducted from the bonus reward, not from task completion pay.** Previously, penalties were tracked and displayed live during a section (the in-task "Penalty" stat row) but were never actually logged to the backend or subtracted from any total — a real gap, now fixed: `penalty` is snapshotted per section at the moment it ends and both logged (`penalty` field, per-section and `total_penalty` per-respondent) and subtracted from the bonus reward on the results screen.

### Results screen: two payment streams, no per-section table

The results screen presents **one summary, no per-section table** (an earlier iteration showed one; the participant only sees the aggregate), split into two distinct lines:

- **"Your bonus reward"** = training bonus + section completion bonuses, net of mistake penalties. Manually approved — the screen states this takes a couple of weekdays.
- **"Your show up fee"** = a fixed **£1.50** (`SHOW_UP_FEE` in `index.html`) — the flat Prolific base payment, identical for every respondent regardless of performance or how many grids they completed.

```
bonusReward = round(trainingBonus + Σ section.earnings − Σ section.penalty, 2)
showUpFee   = SHOW_UP_FEE  // fixed 1.50, never computed from task pay
```

Full copy: *"Study complete. Your bonus reward: £X. Your show up fee: £Y. The bonus reward includes the training bonus and mistake penalties. Your show up fee will be paid immediately. Bonus payments are manually approved so please allow a couple of weekdays as we process it."*

---

## 9. Backend architecture

### Two Google Sheets tabs

**`Meta`** — one row per respondent:

| Field | Description |
|---|---|
| prolific_pid, study_id, session_id, demo_mode | Identifiers |
| consent_at | ISO timestamp of consent (never overwritten once set) |
| study_complete_at | Set when `action=complete` POST succeeds |
| last_updated_iso | Updated on every write |
| age, gender, student | The original short survey's three fields — kept blank going forward, never populated by the new survey below, purely so later columns don't shift (see "Background survey" in §5) |
| employment_status, labor_income, marstat | Employment status, monthly labor income (blank unless employed/self-employed), marital status |
| hh_others | Headcount of people besides the respondent living in their household (0 = living alone) |
| family_contributors, education | Who contributes to household expenses (blank unless `hh_others > 0`), highest education completed |
| ends_meet_now, ends_meet_past, ends_meet_future | SOEP-style 7-point "able to make ends meet" scale, for this month / one year ago / one year from now |
| risk, patience | 0–10 single-item risk (Dohmen et al. 2011) and patience (Falk et al. 2016) measures |
| sections_done, total_earnings, total_grid_pay, total_grids_completed | Running totals |
| training_bonus | £0.10 fixed bonus, credited once the training walkthrough is completed; already included in `total_earnings` |
| training_choice, training_choice_at | The training walkthrough's one recorded practice decision (`'switch'`/`'continue'`) and its timestamp — see §5's "Training walkthrough's live practice round" |
| seq_frame_treatment | Hidden 4-vs-5 sequence-count framing treatment (see §7); 4 or 5 |
| total_penalty | Sum of per-section mistake penalties across the whole session |
| reload_count, reload_log_json | Resume tracking |
| resume_snapshot_json | Full resume snapshot (cleared on completion) |
| geo_country, geo_region, geo_city, geo_ip | IP-derived geolocation (convenience copies of the most-used fields) — see "Geolocation" below |
| geo_json | Full raw response from the geolocation lookup (lat/long, timezone, ISP/org, currency, languages, ASN, ...) |

### Geolocation

Fetched once, client-side, right after the participant clicks "I consent" (`fetchGeo_()`, called from `doConsent()`) — for production and debug-bar mode only (`demomode` 0/1; `demomode=2` bypasses the backend entirely, so there's nowhere to send it, and the fetch is skipped outright). **Google Apps Script's `doGet`/`doPost` never receive the caller's IP address** — there's no way to do this server-side with this backend — so it's a call to a third-party IP-geolocation API (`https://ipapi.co/json/`) that geolocates whoever's IP the request itself arrives from (the participant's, since it's called from their own browser).

Fire-and-forget and best-effort: it never blocks moving on to the survey screen, and any failure (rate limit, network error, CORS) just means that respondent has no `geo_*` data — never surfaced as an error, never retried. If it resolves, the result triggers its own `saveProgress()` call (since `doConsent()` has already saved once without it by the time the response comes back).

**Note:** this collects IP-derived location data, which is personal data under GDPR (the consent form's own text invokes GDPR 679/2016). The current consent form text does not explicitly mention this. Confirmed with the researcher (2026-07) that this is already within the scope of the study's existing ethics approval (N. 23/2026) — flagging here for anyone revisiting this later, since it's a departure from the "disclose exactly" standard the rest of this study holds itself to.

**`Responses`** — one row per respondent × sequence (long-form panel):

| Field | Description |
|---|---|
| prolific_pid, study_id, session_id, demo_mode | Identifiers (repeated per row) |
| seq_n | Sequence number 1–5 |
| pay, regime, inactive, window, bar_lo, bar_hi, n_req | Task design parameters. `n_req` is drawn/logged for every section, inside or outside, for internal reference — never surfaced to the participant when the section is forced-outside. |
| pause, alt_duration, alt_end, p_main_first, pause_secs | Offer design parameters |
| outcome | `completed` / `switched` / `forfeited` — the row's final state. `switched` covers both voluntary and forced switches; use `switch_taken`/`forced_outside` to tell them apart. |
| switch_offered, switch_at | Legacy fields, kept for backward compat. `switch_at` is the same value as `switch_offered_at_task` — not when the participant actually switched, only when the offer first appeared. |
| switch_offered_at_task, switch_offered_at_time | Task number and timestamp when the offer/switch button first became available |
| switch_taken, switch_taken_at_task, switch_taken_at_time | Whether the participant *voluntarily* switched. **Always 0 for a forced-outside switch** — see `forced_outside` below; conflating the two would corrupt the extensive-margin analysis, since forced and chosen switches have completely different causal meaning. |
| forfeit_taken, forfeit_taken_at_task, forfeit_taken_at_time | Whether the participant forfeited, and the task/timestamp at which they did |
| p_main_first, p_main_at_switch | P(main sequence ends before the alternative) — see §6 |
| n_tasks_done, earnings, grid_pay, penalty | Outcomes. `penalty` (per section) was previously tracked live but never logged — now both logged and deducted from the final total (see §8). |
| total_targets, total_found, total_false_pos, total_missed | Aggregated grid accuracy |
| seq_reload_count | Reloads during this specific sequence |
| start_at, end_at, seq_start_at_time | ISO timestamps |
| tasks_json | JSON array — one object per grid task, including `no_activity`/`first_move_at` (see §5) |
| seq_frame_treatment, seq_is_bonus | Hidden 4-vs-5 framing treatment (see §7) |
| p_inside | The disclosed P(inside window) value for this section |
| forced_outside | 1 iff the task never resolved inside the window and the participant was auto-switched at `bar_hi` — kept strictly separate from `switch_taken` |
| e_end_at_start, e_end_at_pause | Computed expected-end values (unconditional / pause-conditional), logged directly so they don't need to be re-derived post-hoc |
| penalty | Mistake penalty accrued during this section |
| alt_duration_indifferent | **Descriptive only — not used to pick the realised `alt_duration`.** The `altDuration` at which a participant would be exactly indifferent between switching and not, at the moment the offer was shown (i.e. where `altEnd` would exactly equal `e_end_at_pause`), computed with the section's real, disclosed `pInside`/`pOutside`. See §6, "Alternative sequence duration" (iterations 4-5) for why this is logged even though it no longer drives gameplay. |

**`tasks_json` array structure** (one element per completed grid):
```json
[
  {
    "grid_n":     1,
    "phase":      "main",
    "target":     "😊",
    "all_emojis": ["😊", "😅", "😂", ...],
    "n_targets":  4,
    "n_found":    4,
    "n_false_pos": 0,
    "n_missed":   0,
    "no_activity": false,
    "first_move_at": "2026-07-20T10:01:23.456Z"
  },
  ...
]
```

### API endpoints

| Method | Action | Lock | Description |
|---|---|---|---|
| GET | `?action=lookup&pid=XXX` | waitLock 10 s | Returns `{found, study_complete, resume_snapshot}` |
| POST | `action: 'progress'` | tryLock 1 s (skipped if busy) | Upserts Meta + all completed sequence rows |
| POST | `action: 'complete'` | waitLock 10 s, idempotent | Upserts Meta (sets `study_complete_at`, clears snapshot) + all sequence rows |

---

## 10. Resume system

Two genuinely different situations both land on the boot screen, and are handled differently:

- **Same-tab reload** (accidental F5, browser back/forward, `Ctrl+R`): the participant should land back exactly where they were, with zero loss of progress — no re-drawn parameters, no restarted section.
- **New-session return** (closed the tab/browser and came back later, possibly on another device): the participant should resume at the correct *screen* (survey / training / experiment), but if they were mid-section, that section restarts with freshly-drawn parameters — this is what stops a participant from strategically reloading to learn `nReq` before committing to continue/switch/forfeit.

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

The debug bar shows: Regime, Safe zone, End zone `[barLo, barHi]`, Window, P(inside window) (and whether *this* section is inside/outside), Pause at, Main ends at, Alt duration, Alt end (if switched @pause), Forced/effective alt end, E[end] @start/@pause, P(main ends before alt) (green if ≥50%, red if <50%), P(main first) @ switch, Pay, Reloads this seq, Seq frame.

"Skip task"/"Skip section" also work during the training walkthrough's live practice round (`trainLiveFinish_('continue')`) instead of crashing against the nonexistent `S.tasks` the production versions of those buttons expect — see §5's "Training walkthrough's live practice round". "Stop" is disabled during that round.

**All skip controls live in the shared debug bar, not as inline buttons on individual screens** — "Skip survey" was originally a button on each survey screen, moved into the debug bar so every debug shortcut lives in one place. `#debug-skip-survey-btn` (`debugSkipSurvey()`) is shown only while `#screen-survey`/`#screen-survey2` is active (`updateDebugSurveySkipBtn_()`, called from `showScreen()` on every navigation, so it tracks screen changes automatically without needing its own explicit call sites).

**Skipping the survey and skipping training are two independent shortcuts**, not one combined "skip past onboarding" button: "Skip survey" submits the survey and lands at the start of training as normal; "Skip training" (`debugSkipTraining()`, `#debug-skip-training-btn`) jumps from *any* point in the training walkthrough — before the live round, during it, doesn't matter — straight into the real experiment (`finishTraining()`), without needing to have used the survey shortcut first. It only shows while `trainingActive` is true (`updateDebugTrainingSkipBtn_()`, called whenever `trainingActive` flips in `submitSurvey()`, `applyResume_()`, and `finishTraining()` — screen-based tracking doesn't work here since training can flip in/out of the live round without ever leaving `#screen-subtask`).

**"Main ends at" and "Forced alt end" are conditioned on `isForcedOutside`, not shown as flat labels regardless of it.** An earlier version always showed `Main ends at (if inside): <nReq>` even for forced-outside sections — where `nReq` is just an internal-reference draw with no real meaning (see §6's note on `n_req`), so a forced-outside section could confusingly read "this seq: OUTSIDE" right next to a specific-looking "ends at 4". Now: forced-outside sections show `Main ends at: never (forced outside) — internal-only reference draw: N`, and the "effective end" line shows `forcedAltEnd` in red as the number that actually matters; inside sections show the plain `nReq` and label `forcedAltEnd` as not applicable.

---

## 12. Key constants (in `index.html`)

```js
const BACKEND_URL        = '…';        // Apps Script /exec URL
const COMPLETION_CODE    = 'C194BROI'; // Prolific completion redirect
const NO_CONSENT_CODE    = 'C1E6TYZR'; // No-consent redirect
const GRID_PAY_PER_TASK  = 0.026;      // £ per completed grid (scaled down from 0.03 — see §6's "Reward")
const BONUS_RATE_PER_TASK = 0.0375;    // £ per task, section-bonus rate (£9/hr ÷ 3600 × 15s)
const PINSIDE_MIN = 0.10, PINSIDE_MAX = 0.90;   // clamp bounds for pInside, and the payTasks reward band (see §6)
const PINSIDE_MEAN = 0.5, PINSIDE_SD = 0.20;    // pInside ~ Normal(PINSIDE_MEAN, PINSIDE_SD), clamped to [MIN,MAX]
// altDuration is now Uniform((barHi-pause)+1, (barHi-pause)+1+window) — see §6's "Alternative
// sequence duration" iteration 5 writeup. No dedicated constant: both bounds are derived from
// each section's own barHi/pause/window, not a fixed centre like ALTDUR_PINSIDE (removed) was.
const LABOR_INCOME_WARN_THRESHOLD = 8000; // £/month — above this, the survey asks the respondent to confirm it's not their yearly income (see §4's "Background survey")
const SHOW_UP_FEE = 1.50; // fixed Prolific base payment shown on the results screen — see §8

const CFG = {
  numTasks:   5,     // sections per participant — always 5, regardless of the framing treatment (see §7)
  gridR:      5,     // grid rows
  gridC:      5,     // grid columns
  revealMs:   500,   // ms between cell reveals — unchanged by the speed-up (see §5's "The grid task")
  submitSecs: 2.5,   // countdown after full reveal (was 5 — ticked in 500ms steps internally so the 2.5s isn't lost to integer-second rounding, see showSubmit())
  winLo:      7,     // minimum window size
  winHi:      15,    // maximum window size
  payLevels:  [1.0, 1.5, ..., 10.0], // unused — no code reads this array; a leftover from an earlier, discrete pay-level scheme since superseded by the continuous payTasks/pay formula in §6. Left in place rather than removed since its origin/intent wasn't clear.
};
// Pause timer: U[5, 30] seconds (drawn when the offer banner is shown)
// inactive: U[0, 3] tasks
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

- **P(inside window) / forced switch**: the task may never resolve inside its window at all. `pInside` is disclosed exactly; if the section draws "outside," the participant is automatically switched at `barHi` with no offer screen and no error state. This coexists with, and does not replace, the ordinary voluntary pause/offer mechanic.
- **`pInside` is a continuous `Normal(0.5, 0.20)` draw, clamped to `[10%,90%]`, not a fixed discrete set** — two earlier iterations used discrete sets (first `{10,30,50,70,90}%`, then narrower ranges as a workaround for the `altDuration` instability below); centring at 50% concentrates sections in the range where switching is a genuinely live decision, and makes the extremes (where the "right" choice is obvious regardless) rare edge cases (~2.3% clamped at each bound) instead of a full stratum — see §6.
- **`altDuration` has a stable centre (solved at a fixed `ALTDUR_PINSIDE=0.5`, not the section's real `pInside`) plus a bounded, directional jitter that reintroduces the real `pInside`'s effect** — see §6 for the full 3-iteration writeup. In short: solving directly against the true `pInside` was unstable (typical `altDuration` ~17 tasks at `pInside=30%`, as low as 1-2 at `pInside=70%`); fixing the solve at 50% removed the instability but also removed `pInside`'s effect entirely; the current jitter (`deviationFrac`, capped at ±1, i.e. `altDuration` never more than double or less than zero relative to the 50%-based centre) restores a bounded version of that effect — longer alternatives when `pInside` is low, shorter when high — without reintroducing the blowup.
- **`payTasks` is rolled between the section's `E[end|start]` at the two ends of the `pInside` set (10%/90%), trimmed to the middle 60% of that band** (cutting the top and bottom 20%), not trimmed to a fixed percentile of the window directly (an earlier iteration did the latter and still produced bonuses that were sometimes too low) — see §6.
- **`pause <= nReq - 1` is enforced in both regimes**: previously `pause` could equal `nReq`, meaning the offer could appear at the exact moment (or after) the task was already over, leaving no real decision runway.
- **`computePMainFirst_` accounts for `pInside`/`pOutside`**: without this weighting, the ratio could read 100% purely from `altDuration` being large relative to the window, even when a real chance of going outside meant the main sequence was nowhere near certain to actually beat the alternative.
- **No-activity detection is gated on cursor movement, not on the answer given**: checking zero cells is a legitimate active submission; only the complete absence of cursor movement during the subtask counts as "no activity." A standard `mousemove` listener is what this relies on — fully reliable, no workaround needed. The penalty always applies; on top of that, a **blocking** "Are you still there?" screen takes precedence over whatever would normally happen next — it holds progress at the current point (does not regenerate a new grid/target) until acknowledged. An earlier iteration made this non-blocking, which was a misreading — the screen is meant to gate progress, not just notify.
- **The offer is a terse in-place banner on the subtask screen, not a separate screen**: replaces the old full-screen "You can now switch…" navigation. The banner says only "An alternative sequence is available!" — the `pInside`/`pOutside` disclosure lives in the diagram's window-zone label, not repeated in the banner text (an earlier iteration over-explained the mechanic inside the banner itself). The instruction line is replaced by the banner, the grid is cleared to placeholders, the below-grid countdown is relabelled to count down to resumption, and an explicit "Resume now" button sits below it for participants who don't want to wait out the countdown. The banner flashes on appearance (reusing the same `.switch-flash` animation as the switch button). Both `#st-instr-normal` and `#st-instr-offer` share identical padding/border/`min-height` and are both flex-centered — matching the box-model alone wasn't enough, since the banner's longer text can wrap to a second line on narrower viewports while the short instruction text never does; the fixed `min-height` (reserving room for 2 lines) is what actually stops that from shifting the grid/table below, regardless of wrapping.
- **Switch-confirm overlay text was trimmed**: it no longer states "Your bonus reward for this sequence is unaffected. This cannot be undone." — just the task count.
- **The task-complete screen distinguishes a forced switch from a voluntary one, and no longer says "Alternative complete"**: the heading for any `switched` outcome (voluntary or forced) is now "Sequence complete"; the body text branches on `task.forcedOutside` — a forced switch explicitly says the main sequence didn't end within the window and the participant was automatically moved to the alternative, rather than using the same generic "you completed the alternative sequence" text as a voluntary switch.
- **The debug bar's "Main ends at"/"Forced alt end" lines are conditioned on `isForcedOutside`**, not shown as flat labels regardless of it — see §11.
- **IP geolocation is fetched client-side, not on the backend**: Google Apps Script's `doGet`/`doPost` don't expose the caller's IP at all, so a third-party API (`ipapi.co`) is called directly from the participant's browser instead, right after consent. Best-effort (never blocks the study, never surfaces an error on failure) and only runs for `demomode` 0/1, since `demomode=2` never touches the backend anyway — see §9.
- **The forced-alt-end point is not shown on the participant-facing diagram**: an earlier iteration drew a persistent marker for it, which worked against the study's framing of an open-ended main sequence; the diagram's scale is anchored to the main sequence (`barHi`), matching its pre-mechanic appearance, and only the disclosed `pInside` percentage communicates the possibility of going outside.
- **The diagram's axis tick count (`visMaxK_()`) is sized to the worst case `barHi`/`window` could produce, not to the section's actual realised `altDuration` or its real `pInside`**: since the axis is drawn before the offer is ever shown, sizing it to the real `altDuration` would itself leak "this section's alternative is long/short" ahead of time. `altDuration`'s upper bound, `(barHi-pause)+1+window`, is maximised at `pause=0` — so `visMaxK_()` uses `barHi+1+window` regardless of what the section's real `pause`/`altDuration`/`pInside` turn out to be. Depends only on `barHi`/`window` — the section's real, disclosed `pInside` plays no part in it at all. (Earlier iterations used a flat 20-tick cap, then a `pInside`/`ALTDUR_PINSIDE`-calibrated solve — both superseded once `altDuration` itself became a plain uniform draw; see §6.)
- **The results screen splits into "bonus reward" vs. "show up fee," no per-section table** — see §8.
- **Mistake penalties are deducted from the final total and logged** — previously tracked live in the UI but silently dropped at the end (never logged, never subtracted). This was a real gap; `penalty` is now part of every section's log row, `total_penalty` is part of the respondent-level summary, and the results screen's grand total nets it out.
- **`pauseMax = inactive + ceil(window/2)`**: caps the pause at halfway through the window, so staying in the main sequence always carries a real cost — see §6. This briefly widened to `barHi - 1` (every task up to, not including, the last one in the window) before being reverted back to the halfway cap.
- **Regimes 1, 2, and 3 realise `isForcedOutside`/`nReq`/`pause` via genuinely different generative procedures** (not just a reordering) — see §6. Regime 3's two draws are truly independent (pause can land after `nReq`, and its marginal `P(outside)` matches the disclosure exactly); regimes 1 and 2 exist in parallel with it as a check that behaviour doesn't depend on reveal order, and regime 2's marginal drift from the disclosed `pOutside` is a known, accepted consequence of that framing, not a bug.
- **Section bonus is earned on completed or switched (voluntary or forced), lost only on forfeit**: switching to the alternative sequence is a within-budget decision (uncertain/absent duration → known duration, same payoff), not a penalized one.
- **Bonus uses an independent second draw, not the realised `nReq`**: preserves the statistical properties needed for `pay` without leaking `nReq` or `pInside`/`isForcedOutside`.
- **Resume only regenerates the current section on a genuinely new session, never on a same-tab reload** (see §10).
- **Regime (1 of 3, 1/3 each) is assigned once per respondent, at consent, not redrawn per section**: mixing regimes within a respondent's own 5 sections would confound any within-subject comparison of whether they learn the task's structure over repeated exposure.
- **`switch_taken`/`forfeit_taken`/`forced_outside` are independent, persistent flags, not derived from `outcome`**: a participant can switch and *then* forfeit the alt sequence, or be forced-switched rather than choosing to — the single `outcome` string cannot represent these distinctions on its own.
- **Sequence-count framing (`nSeqFrame`) is assigned once, at consent, and never re-rolled**; the bonus-round grace screen (4-treatment only) now genuinely hides the section's timeline/probability/pay details behind the generic "bonus sequence" message until the participant clicks Continue — previously those details were visually present (just unlabelled) underneath the message, which looked unfinished and could leak information before the framing message was read.
