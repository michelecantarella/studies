# WT Study — Design & Implementation Reference

**Study title:** Value of Wasted Time  
**Platform:** Prolific + GitHub Pages  
**Files:** `index.html` (frontend) · `backend.txt` (Google Apps Script)  
**Contact:** Michele Cantarella — michele.cantarella@imtlucca.it  
**Ethics approval:** Joint Ethical Committee of Scuola Superiore Sant'Anna / Scuola Normale Superiore / IMT Lucca — N. 23/2026, 30 April 2026

---

## 1. What the study measures

The study investigates how people manage time and forgone earnings when facing an uncertain stopping point. Participants complete a series of grid tasks to earn a section bonus; the key manipulation is whether and when they switch from the main sequence (uncertain duration) to an alternative sequence (known, fixed duration), or forfeit entirely.

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

2. In `index.html`, set `BACKEND_URL` (line ~468):
   ```js
   const BACKEND_URL = 'https://script.google.com/macros/s/…/exec';
   ```
   Currently set to: `https://script.google.com/macros/s/AKfycbzBPsqbko0qRJ3378n-Qm8rY1DPOEZF1BR2nb3wc0f1GHK7EhUslxSDg-wmIxEHfeTf/exec`

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
Consent screen
  → (I do not consent) → Prolific redirect C1E6TYZR
  → (I consent) → Survey (age, gender, student status)
    → Training (11-step guided walkthrough on a static practice sequence, ends with a £0.10 bonus)
      → [repeat for each of 5 sections]
          Grace period (task preview: timeline + pay amount)
            → Grid tasks loop
              → [pause triggers offer screen]
              → [task ends] → Section result screen
      → Results screen (earnings table)
        → Backend complete POST (5 retries)
          → Prolific redirect C194BROI
```

On page reload at any point after consent: the current section restarts with new random parameters; completed sections are preserved.

---

## 5. Task mechanics

### The grid task

Each task presents a 5×5 grid of emoji symbols that **reveal progressively** from left to right, one cell every **500 ms** (12.5 s total for all 25 cells). Once fully revealed, a **5-second countdown** begins. The participant must click all instances of the **target emoji** shown above the grid. The task auto-submits at countdown end.

- Grid size: 5×5 = 25 cells
- Target emoji: drawn at random from a pool of ~65 emojis
- Number of targets per grid: uniform over {3, 4, 5, 6}
- Total time per grid: ~17.5 s (12.5 s reveal + 5 s countdown)
- Errors (missed targets or false positives) incur a small penalty (£0.01 each) but do not stop the sequence

### The sequence structure

Each section has three zones on a shared timeline:

| Zone | Notation | Description |
|---|---|---|
| Safe zone | `[0, inactive]` | Task cannot end here; `inactive ~ Uniform[0, 5]` |
| End zone | `[barLo, barHi]` | Task ends at some task number drawn uniformly from this range; `barLo = inactive + 1`, `barHi = inactive + 1 + window` |
| Window | — | Size of the end zone; `window ~ Uniform[5, 15]` |

The **actual end task** (`nReq`) is the realisation from `Uniform[barLo, barHi]`. Participants see the end zone but not the specific draw.

### The pause and alternative offer

At task number `pause`, the section pauses and an **offer screen** is shown. The participant sees:

- How many tasks they have completed
- The full timeline including the alternative sequence (blue line)
- A countdown timer before the screen auto-dismisses back to the main sequence

The offer screen lasts a random `U[5, 30]` seconds (`pause_secs`). If the timer expires, it auto-selects "Continue main sequence."

Before the pause is reached, a **switch button** activates (visible on the left side of the task screen) when `switch_cost = pause` tasks have been completed. Clicking it opens a confirmation overlay. The button first appears with a flash animation and a brief blue flicker of the alternative timeline.

Decisions available at the pause:

| Decision | Outcome |
|---|---|
| **Continue** | Main sequence resumes; switch button remains visible |
| **Switch** | Participant moves to the alternative sequence (fixed `alt_duration` tasks) |
| **Forfeit** | Both sequences abandoned; no bonus earned |

---

## 6. Parameter generation

Every parameter except `regime` is drawn independently per section. `regime` is drawn **once per respondent** (at consent, stored in `SESSION.regime`) and reused for all 5 sections — deliberately not redrawn per section, so a within-subject comparison across a respondent's sections isn't confounded by regime switching under them.

### Core parameters

```
inactive   ~ Uniform[0, 5]          (integer; safe zone length)
window     ~ Uniform[10, 15]        (integer; end-zone width)
barLo      = inactive + 1
barHi      = inactive + 1 + window
pauseMax   = inactive + ceil(window / 2)
```
`pauseMax` caps the offer to the first half of the window (rounded up), not (as before) anywhere up to `barHi - 3`. A late-landing offer made it obvious the main sequence was about to end, trivialising the switch decision.

### Two regimes (respondent-level, drawn 50/50 once)

**Regime 1** — nReq drawn first, pause second:
```
nReq  ~ Uniform[barLo, barHi]
pause ~ Uniform[0, min(nReq, pauseMax)]
```

**Regime 2** — pause drawn first, nReq second:
```
pause ~ Uniform[0, pauseMax]
nReq  ~ Uniform[barLo, barHi]        if pause < barLo
nReq  ~ Uniform[pause, barHi]        if pause >= barLo
```

### Alternative sequence duration

`alt_duration` is no longer drawn from however many window slots happen to be left after the offer — that routinely produced alternatives so short or so long relative to the main sequence's likely end that the "right" choice was obvious. Instead it's tightly centred on the main sequence's **expected** end, from the participant's own information set at the moment the offer is made:

```
expectedMainEnd = (barLo + barHi) / 2        if pause < barLo   (still uniform over the full visible range)
expectedMainEnd = (pause + barHi) / 2        if pause >= barLo  (offer landed inside the red zone; range narrows to [pause, barHi])

altDuration = max(2, round(expectedMainEnd) + Uniform{-1, 0, 1} - pause)
altEnd      = pause + altDuration             (global task number when alt sequence ends)
```
The `±1` jitter keeps `altDuration` from being perfectly predictable from `barLo`/`barHi` alone; the `max(2, …)` floor preserves the existing "no single-task alternatives" rule.

### Reward

The bonus rate is derived from a target hourly wage: `£9/hour ÷ 3600s × 17.5s per task ≈ £0.043/task`.

`payTasks` is **not** the realised `nReq` — it is a second, independent draw using the exact same regime-conditional procedure as `nReq`, so its distribution matches `nReq`'s distribution without ever exposing (or being derivable from) the actual realised value. This keeps the displayed bonus from leaking information that would let a participant predict when the main sequence will end.

```
payTasks ~ same draw procedure as nReq, independent realisation:
             regime 1        → barLo + Uniform[0, window]
             regime 2, pause <  barLo → barLo + Uniform[0, window]
             regime 2, pause >= barLo → Uniform[pause, barHi]

pay = round(payTasks × 0.043, 2)      (rounded to the nearest £0.01)
```
With `window ~ Uniform[10, 15]`, `payTasks` ranges roughly 1–21, so `pay` ranges roughly **£0.04–£0.90** per section. (Note: this is the range the formula has always produced — the `£1.00–£10.00` figure and the unused `CFG.payLevels` array in `index.html` do not match the actual formula and should not be treated as current.)

### P(main ends before alt) — shown in debug mode

This is the probability that the main sequence would have ended before the alternative, given only the information available at the moment being evaluated. `computePMainFirst_(atTask, altDuration, task)` in `index.html` implements this and is shared by two fields:

- **`p_main_first`** — evaluated at `atTask = pause` (when the offer was first shown).
- **`p_main_at_switch`** — evaluated at `atTask = switchTakenAtTask` (when the participant actually switched, via the persistent switch button, which can be later than the initial offer if it was declined at first). `null` if the participant never switched.

Formula, given `atTask`:
- **If `atTask < barLo`** (still in the safe zone): nReq is uniform over `[barLo, barHi]` (window+1 values). Result = fraction of those values ≤ `atTask + altDuration - 1`.
- **If `atTask >= barLo`** (already in the end zone): nReq is uniform over `[atTask, barHi]`. Result = `min(altDuration, total) / total` where `total = barHi - atTask + 1`.

---

## 7. Hidden sequence-count framing treatment

A between-subjects treatment, independent of the per-section parameter draws in §6.

- On consent, each participant is assigned `nSeqFrame` — **50/50, drawn once, persisted for the rest of the session** (survives reload via the resume snapshot, never re-rolled): either `4` or `5`.
- **Everyone actually completes all `CFG.numTasks` (5) sections, regardless of `nSeqFrame`.** Only what's *communicated* changes:
  - `nSeqFrame = 5`: told there are 5 sections, throughout (status quo / untreated).
  - `nSeqFrame = 4`: told there are 4 sections. Sections 1–4 are labelled normally against a denominator of 4 (`Section 2 of 4`, counter `2/4`). The real 5th section is never announced in advance — the grace screen instead opens with an explicit invitation ("You are now invited to take part in a bonus round!") gated behind its own Continue click before the normal grace-screen flow (end-zone graphic, bonus amount, Start section) proceeds, and the in-task counter shows `Bonus` instead of a fraction, rather than the self-contradictory `Section 5 of 4`.
- Implemented via `SESSION.nSeqFrame`, `isBonusIdx_()`, `sectionLongLabel_()`, `sectionShortLabel_()` in `index.html`. Training's step 1 also states the treated total (4 or 5) so the framing is consistent from the very first thing the participant reads.
- A compact section counter (`n/total`, or `Bonus`) is shown as the "Sequence" row in the task screen's stat table (`#s-seq`), in addition to the existing fuller "Section N of M" label on the grace screen.
- Recorded per-respondent (`seq_frame_treatment` in `Meta`) and per-sequence (`seq_frame_treatment`, `seq_is_bonus` in `Responses`), so analysis can condition on treatment arm and identify the bonus-framed row without recomputing it.
- The debug bar (`?demomode=1/2`) shows `Seq frame: 4/5` and flags `(bonus)` on the relevant section.

---

## 8. Payment structure

| Component | Amount | Condition |
|---|---|---|
| Section bonus | `pay` (~£0.04–£0.90 per section) | Paid if **main sequence completed OR switched to alternative**. Lost only on **forfeit**. |
| Grid pay | £0.03 per grid | **All** grids done in the section, regardless of outcome |
| Prolific base pay | Set separately in Prolific | Fixed, paid by Prolific |

**The section bonus is earned on both `completed` and `switched` outcomes** — switching to the alternative sequence does not cost the participant the bonus, since the alternative simply trades an uncertain remaining duration for a known one. Only `forfeited` sequences lose the bonus (`task.earnings = (completed || switched) ? pay : 0`).

**Grid pay is always earned** regardless of outcome — completed, switched, or forfeited. `nTasksDone = pause + subtaskDone` when on the alternative path; `subtaskDone` when on the main path. This is not communicated to the participant during the task (the UI says "no bonus earned" on forfeit, referring only to the section bonus) — it is only reflected in the final results table, to avoid confounding the switch/continue/forfeit decision with the guaranteed grid pay.

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
| age, gender, student | Survey responses |
| sections_done, total_earnings, total_grid_pay, total_grids_completed | Running totals |
| training_bonus | £0.10 fixed bonus, credited once the training walkthrough is completed; already included in `total_earnings` |
| seq_frame_treatment | Hidden 4-vs-5 sequence-count framing treatment (see §7); 4 or 5 |
| reload_count, reload_log_json | Resume tracking |
| resume_snapshot_json | Full resume snapshot (cleared on completion) |

**`Responses`** — one row per respondent × sequence (long-form panel):

| Field | Description |
|---|---|
| prolific_pid, study_id, session_id, demo_mode | Identifiers (repeated per row) |
| seq_n | Sequence number 1–5 |
| pay, regime, inactive, window, bar_lo, bar_hi, n_req | Task design parameters |
| pause, alt_duration, alt_end, p_main_first, pause_secs | Offer design parameters |
| outcome | `completed` / `switched` / `forfeited` — the row's final state. Kept for convenience, but **cannot** represent "switched, then later forfeited the alt sequence" (a real, possible combination) — use `switch_taken`/`forfeit_taken` for that. |
| switch_offered, switch_at | Legacy fields, kept for backward compat. `switch_at` is the same value as `switch_offered_at_task` below — it is **not** when the participant actually switched, only when the offer first appeared. |
| switch_offered_at_task, switch_offered_at_time | Task number and timestamp when the offer/switch button first became available |
| switch_taken, switch_taken_at_task, switch_taken_at_time | Whether the participant ever actually switched (persists even if they later forfeit — see `outcome` caveat above), and the task/timestamp at which they did. Can be later than `switch_offered_at_*` if the first offer was declined and the persistent switch button was used afterward. |
| forfeit_taken, forfeit_taken_at_task, forfeit_taken_at_time | Whether the participant forfeited, and the task/timestamp at which they did. `forfeit_taken_at_task` counts total tasks across both legs (main + alt), same convention as `n_tasks_done`. |
| p_main_first, p_main_at_switch | P(main sequence ends before the alternative), evaluated at the offer (`p_main_first`) vs. at the actual switch moment (`p_main_at_switch`, `null` if never switched) — see §6. |
| n_tasks_done, earnings, grid_pay | Outcomes. `n_tasks_done` is the true total across both legs — main-phase tasks completed *before the actual switch* (not `pause`, which can predate a delayed switch) plus alt-phase tasks completed. |
| total_targets, total_found, total_false_pos, total_missed | Aggregated grid accuracy |
| seq_reload_count | Reloads during this specific sequence |
| start_at, end_at, seq_start_at_time | ISO timestamps. `seq_start_at_time` is an explicit alias of `start_at`, set the moment the participant clicks "Start section" (i.e. after the grace/preview screen, not including it) |
| tasks_json | JSON array — one object per grid task (see below) |
| seq_frame_treatment | Hidden 4-vs-5 framing treatment (see §7); repeated per row for convenience |
| seq_is_bonus | 1 if this row is the unannounced 5th "bonus" section under the 4-treatment; 0 otherwise |

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
    "n_missed":   0
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

These are told apart with `sessionStorage` (key `wtstudy_tab_session`): it survives a same-tab reload but is cleared when the tab/browser closes, so `isSameTabSession_()` checked at the very top of `bootstrapAppInner_()` (before the tab is (re-)marked) is a reliable same-tab-vs-new-session signal, independent of the backend.

On every section completion and every 25 s (heartbeat), the frontend:
1. Saves a **snapshot** to `localStorage` (key: `wtstudy_resume_<pid>`)
2. POSTs the snapshot to the backend `Meta` sheet

Snapshot contents:
```json
{
  "v": 2,
  "phase":        "experiment",
  "taskIdx":      3,
  "tasks":        [ ... full per-section parameter objects, incl. in-progress grids ... ],
  "subtaskDone":  4,
  "seqPhase":     "main",
  "altStartPos":  0,
  "penalty":      0.02,
  "trainStep":    1,
  "survey":       { "age": "28", "gender": "female", "student": "no" },
  "consentAt":    "2026-07-15T10:00:00.000Z",
  "sectionsLog":  [ ... completed sections ... ],
  "totalReloads": 1,
  "reloadLog":    [ { "seq_index": 2, "at": "..." } ]
}
```

On page load, `bootstrapApp()` runs:
1. `isSameTabSession_()` is checked, then the tab is (re-)marked via `markTabSession_()`.
2. Backend `lookup` GET is called (if PID present and backend configured)
3. If `study_complete = true` → show "already completed" screen
4. If `resume_snapshot` present → call `applyResume_(snapshot, sameTab)`:
   - `phase === 'survey'` (or consent never completed) → show the survey screen again
   - `phase === 'training'` → resume the training walkthrough — at the exact `trainStep` if same-tab, or restarted from step 1 on a new session (training is unincentivized, so a full restart there is cheap and simple)
   - `phase === 'experiment'`, same-tab → restore `S.tasks` **unregenerated** and jump straight into the current section via `startTask(subtaskDone)`, picking up exactly where the participant was (same `nReq`/`pause`/`altDuration`, same grids-completed count, same main/alt leg)
   - `phase === 'experiment'`, new session → **current section regenerates fresh random parameters**, same as before; reload is logged (`reloadLog` entry + `totalReloads++` — only for new-session reloads, so accidental same-tab refreshes don't inflate this counter)
5. Fallback: check `localStorage` (same-device cross-session fallback)
6. If nothing found → show consent screen

---

## 11. Debug mode

Append `?demomode=1` or `?demomode=2` to the URL.

| Mode | Behaviour |
|---|---|
| `demomode=0` (default) | Production |
| `demomode=1` | Shows debug bar (regime, params, P(main ends before alt), etc.) + "Skip task" / "Skip section" buttons; backend still active |
| `demomode=2` | Debug bar + backend completely bypassed + Prolific redirect goes to `console.log` only |

The debug bar also shows: Regime, Safe zone, End zone [barLo, barHi], Window, Pause at, Main ends at (nReq), Alt duration, Alt global end, P(main ends before alt) (green if ≥50%, red if <50%), Pay, Reloads this seq, Seq frame (4/5, flagged `(bonus)` on the relevant section).

---

## 12. Key constants (in `index.html`)

```js
const BACKEND_URL        = '…';        // Apps Script /exec URL
const COMPLETION_CODE    = 'C194BROI'; // Prolific completion redirect
const NO_CONSENT_CODE    = 'C1E6TYZR'; // No-consent redirect
const GRID_PAY_PER_TASK  = 0.03;       // £ per completed grid
const BONUS_RATE_PER_TASK = 0.043;     // £ per task, section-bonus rate (£9/hr ÷ 3600 × 17.5s)

const CFG = {
  numTasks:   5,     // sections per participant — always 5, regardless of the framing treatment (see §7)
  gridR:      5,     // grid rows
  gridC:      5,     // grid columns
  revealMs:   500,   // ms between cell reveals
  submitSecs: 5,     // countdown after full reveal
  winLo:      10,    // minimum window size
  winHi:      15,    // maximum window size
};
// Pause timer: U[5, 30] seconds (drawn at offer screen display)
// inactive: U[0, 5] tasks
```

---

## 13. Data download (participant-side backup)

If the backend POST fails after 5 retries, the results screen shows:
- An error reference code
- A "Download my responses" button → downloads `wt_study_backup_<pid>.json`
- A "Download CSV" button → downloads `wt_study_data.csv` (one row per sequence, `tasks_json` as a nested JSON string column)
- Instructions to contact the researcher via Prolific messaging and attach the file

---

## 14. Known design decisions and rationale

- **pauseMax = inactive + ceil(window/2)**: caps the offer to the first half of the window, so there's always substantial genuine uncertainty left in the main sequence when the decision is made. (Superseded the original `barHi − 3`, which let the offer land so close to `barHi` that the switch decision became trivial — see §6.)
- **Alt duration minimum = 2**: single-task alternatives are considered too trivial to present as a meaningful choice.
- **Alt duration is centred on the expected main-sequence end, not spread over the leftover window** (see §6): the original approach (uniform over however many slots were left after the offer) routinely produced alternatives obviously shorter or longer than the main sequence was likely to run, making the "right" choice too easy to read off the visible zone alone.
- **P(main ends before alt)** is computed at the moment of the pause using only the information visible to the participant (the end zone and the alt duration); it does not use the realised `nReq`.
- **Grid pay is always earned** regardless of section outcome, to ensure participants are compensated for effort even when they forfeit or switch. The UI deliberately does not reveal this during the task (it says "no bonus earned" for the section bonus specifically) to avoid confounding incentives.
- **Section bonus is earned on completed or switched, lost only on forfeit**: switching to the alternative sequence is a within-budget decision (uncertain duration → known duration, same payoff), not a penalized one. Forfeiting is the only decision that costs the bonus. The UI states this explicitly in the instructions, grace screen, and offer/confirm screens.
- **Bonus uses an independent second draw, not the realised `nReq`**: `payTasks` is drawn using the same regime-conditional procedure as `nReq` (same distribution) but as a fresh, independent `Math.random()` call. If the bonus were computed directly from the realised `nReq` — which is shown to the participant up front via the pay amount — a participant could work backward from the displayed pay to infer how many tasks the main sequence actually requires, undermining the uncertain-stopping-point manipulation. Drawing an independent value from the same distribution preserves the statistical properties needed for `pay` without leaking `nReq`.
- **Resume only regenerates the current section on a genuinely new session, never on a same-tab reload** (see §10): completed sections are always preserved exactly. A same-tab F5 must be indistinguishable from not having reloaded at all, or participants would be punished (lost grid progress) for an accidental refresh; but resuming days later in a fresh tab must still regenerate the in-progress section's parameters, or a participant could learn `nReq` by strategically abandoning and returning.
- **Regime 1 vs 2**: regime 1 draws `nReq` first (so `pause ≤ nReq` always), regime 2 draws `pause` first (so `pause` may exceed `nReq`, creating a case where the task could already be over when the offer appears — edge case handled by checking `subtaskDone >= nReq` on resume from offer screen).
- **Sequence-count framing (`nSeqFrame`) is assigned once, at consent, and never re-rolled**: it's persisted through the resume snapshot specifically so a participant can't end up seeing "4" in one section and "5" in another after a reload — the treatment must stay constant for the whole session. `CFG.numTasks` (the actual number of sections run) is never changed; only what's displayed changes.
- **Regime is assigned once per respondent, at consent, not redrawn per section** (see §6): mixing regimes within a respondent's own 5 sections would confound any within-subject comparison of whether they learn the task's structure over repeated exposure.
- **`switch_taken`/`forfeit_taken` are independent, persistent flags, not derived from `outcome`**: a participant can switch to the alt sequence and *then* forfeit it — a real, reachable combination the single `outcome` string cannot represent (it would just show `forfeited`, silently losing the fact that they'd switched first). Both flags are set at the moment of the respective decision and are never overwritten by what happens afterward.
- **`n_tasks_done` on a switched/forfeited-after-switching row counts from `S.altStartPos`, not `task.pause`**: these were previously conflated. `task.pause` is where the offer first *appeared*; a participant can decline it and switch later via the persistent switch button, at which point the true number of main-phase tasks completed is `S.subtaskDone` at the moment of switching, not `task.pause`. Using `task.pause` silently undercounted `n_tasks_done` (and thus `grid_pay`) whenever a switch was delayed past the first offer.
- **A resumed snapshot with no `phase` field is not assumed to be mid-experiment**: an earlier version of the resume logic defaulted any phase-less (pre-this-feature) snapshot straight to `'experiment'`, on the assumption that anything old enough to predate phase-tracking must already have been in the real task. That assumption was wrong — a participant who'd only reached the survey screen under old code hit this same fallback and got dropped straight into the experiment on their next visit, skipping training entirely. The fallback now infers conservatively from what's actually present in the old snapshot (completed sections or an awarded training bonus → experiment; a populated `survey` object → training; otherwise → survey) instead of defaulting to the riskiest option.
