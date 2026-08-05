# TC Study — Design & Architecture Reference

Two-phase Prolific study on the intention–behavior gap in tax compliance and
redistributive preferences: does recalling one's own previously stated
distributional preferences change actual redistribution behavior when real
money is on the line? Built as a single-file HTML frontend (`index.html`) on
GitHub Pages, backed by a Google Apps Script + Sheet.

**PI:** Michele Cantarella (IMT School for Advanced Studies Lucca, also DTU).
**Collaborators:** Filippo Scarparo, Gianpietro Sgaramella.

---

## 1. Research design

### Two phases, on Prolific
- **Phase 1 ("survey"):** consent → general elicitation → **stability task
  intro + 3 items** → end.
- **Phase 2 ("experiment"):** consent → matched → re-elicitation → pre-task
  debrief → real-effort task → rank reveal → redistribution decision →
  **stability/recognition task (claimed recall → framing recall →
  recognition → reveal → re-measure → redistribution-study frequency)** →
  final survey (background/beliefs) → outcome.

### Stability/recognition task (replaces the old emoji memory probe)
A robustness check on whether participants have genuinely forgotten their
Phase 1 answers by the time of the redistribution decision — now using real
survey content (attitude/preference statements) instead of an arbitrary
3-emoji sequence, and moved to the **end of the whole study** (after the
redistribution decision) rather than mid-Phase-2. See
`stability_item_pool.json` (item pool, sampling/foil rules, backend
variable shapes) and `stability_task_mockup.html` (reference
implementation of the exact sequencing/copy) — both ported into
`index.html`'s `STABILITY_POOL` block essentially verbatim.

**Phase 1 (screens 20/3):** 3 real preference/attitude items sampled and
shown with **no memory framing whatsoever** — participants answer them as
ordinary survey items, on their own domain's native 1–10 scale.
- Domain sampling: `domains_selected = ['A'] + random_sample(['B','D','E','F'], 2)`
  — domain A ("justifiable") always included, two more drawn at random.
- Row sampling: one row drawn at random per selected domain.
- Side sampling: one of the row's two statements (`a`/`b`) drawn at random
  per row — that's the actual item shown and answered.
- Persisted as `{domain, row_id, side, response}` per item
  (`stability_rows_tested` / `stability_responses` in `DATA_LOG`,
  `p1_stability_item{1,2,3}_*` + `p1_stability_rows_json` in the Sheet) —
  restored at Phase 2 entry via the same bootstrap-funnel mechanism the
  old `memory_sequence` used (Phase 1/Phase 2 are separate sessions, may be
  different devices).

**End of study (screens 21-27, after the redistribution decision, screen
8), a strictly blocked sequence — recognition always happens BEFORE any
reveal, so it's never contaminated by feedback:**
1. **Claimed recall** — "Do you remember doing a similar redistribution
   task in a previous study?" (Yes / No / Not sure).
2. **Framing recall** — only if step 1 was "Yes" (otherwise skipped via a
   `flowPos += 2` jump in `answerClaimedRecall`, straight to step 3): "Do
   you remember if it was based on luck or based on performance?".
   `framing_recall_correct` is scored against `p1_phase1_condition`
   restored from the backend (`phase1_condition_confirmed`) — the
   authoritative record — not the client's own derived `phase1Cond`.
3. **Memory-test lead-in** — plain continue, no data captured.
4. **Recognition** (screen 24) — 4AFC per item (target / similar / foil_a
   / foil_b, shuffled) plus a 5th "I don't remember" option, all 3 items
   blocked before any reveal. Foils are same-domain, different row (drawn
   fresh at this point — see `sampleStabilityFoils_` — not carried over
   from Phase 1, since foils are decoys never shown/answered there, unlike
   the target row which must be the exact one from Phase 1). `similar` =
   the untested sibling side of the target's own row; `foil_a`/`foil_b` =
   both sides of one additional, separately-drawn same-domain row — two
   structurally matched pairs, so the trial can't be solved by eliminating
   an obviously-unrelated odd one out. Logs `choice_item_id`,
   `classification`, `correct`, `rt_ms` per item.
5. **Reveal** (screen 25) — all 3 correct target statements shown together,
   "Here's the three items." No right/wrong feedback on the recognition
   answers is shown here or anywhere else.
6. **Re-measure** (screen 26) — all 3 items again, blocked, same scale as
   Phase 1, no anchor of the Phase-1 value shown, based on the just-revealed
   statements.
7. **Redistribution-study frequency** (screen 27) — "Excluding our
   studies, how often have you participated in studies in which you were
   asked to redistribute money..." (0–10). Belongs to the general
   final-survey block per the item pool's `placement_note`, but asked
   immediately after step 6 rather than folded into screens 18/19.

Deliberation time tracked as `stability_p1_time_ms` (screen 3) and
`stability_p2_time_ms` (screens 21-26 combined), same
`startSectionTimer`/`stopSectionTimer` pattern as elicitation/re-elicitation/
giving. Former screen 10 (old emoji recall) is kept as an inert empty
`<div>` placeholder rather than renumbered away — see its own comment in
`index.html` — to avoid touching every later numeric screen-index literal
in the file.

### Final survey (end of Phase 2, screens 18/19)
A two-page, condition-agnostic survey inserted right before the
outcome/debrief screen (so it's answered before `phase2_complete` fires):
- **Screen 18** — Block A (employment, marital status, household
  composition, education) and Block B (financial situation: ability to
  make ends meet, importance of Prolific income — a shared 6-point ladder
  so the two are directly comparable).
- **Screen 19** — Block C (0–10 sliders on attribution/blame for poverty,
  personal support for redistribution, perceived consensus, economic
  left–right and social authoritarian–libertarian self-placement, and
  0–100 estimates of tax waste and top-20%-income-share) and Block D (2024
  US presidential vote).
Recorded as `survey_*` fields in `DATA_LOG` / `p2_survey_*` columns in the
Sheet (see `apps_script_backend`'s `P2_FIELDS`).

### Geolocation (IP-based, both phases)
Apps Script's `doGet`/`doPost` never see the caller's IP, so this is a
client-side call to a third-party service that geolocates whoever's IP the
request itself arrives from — see `fetchGeo_` in `index.html`. Fired once
right after **each** phase's own consent screen (`consentAndNext_`), since
Phase 1 and Phase 2 are separate Prolific sessions that may run on different
devices/networks — hence two independent sets of fields (`geo_phase1_*` /
`geo_phase2_*` in `DATA_LOG`, `p1_geo_*` / `p2_geo_*` in the Sheet).

**Two independent providers, tried in order, each response validated (not
just the HTTP status):** `GEO_PROVIDERS = [ipapi.co, ipwho.is]`. This fixed a
real bug: `ipapi.co` returns HTTP 200 even when rate-limited, with a body
like `{error:true, reason:'RateLimited'}` instead of real geo fields —
treating any 200 as success (the original implementation) silently stored
that error object as "the" geolocation, so every flat `geo_*` field came
back blank with no indication why. Each provider's response is now checked
for real fields (`ipapi.co`: no `.error`, has `.country_name`; `ipwho.is`:
`.success !== false`, has `.country`) before being accepted, falling
through to the next provider otherwise — which also covers the case where
`ipapi.co` specifically is blocked by an ad-blocker/privacy extension
(common on Prolific's participant pool), without needing any further
changes if that happens. `geo_phase1_provider`/`geo_phase2_provider` (new
`p1_geo_provider`/`p2_geo_provider` columns) record which provider actually
answered.

Best-effort and non-blocking throughout: any failure (every provider
rate-limited/networked-out/CORS-blocked) just means missing geo data for
that phase, never surfaced as an error, never delays the study.

### Treatment: three independently-randomized C/T phases
Every arm sees every elicitation screen — only the *framing* differs. Each
phase is independently, uniformly randomized C (luck-framed) or T
(performance-framed) — a fresh 50/50 coin flip per phase, no additive or
monotonic constraint. All **8 arms** are possible and equally likely:

| Arm  | Phase 1 (general elicitation) | Phase 2 (re-elicitation) | Phase 3 (redistribution) |
|------|-------------------------------|--------------------------|---------------------------|
| CCC  | luck                          | luck                     | luck                      |
| CCT  | luck                          | luck                     | performance                |
| CTC  | luck                          | performance              | luck                       |
| CTT  | luck                          | performance                | performance                |
| TCC  | performance                     | luck                    | luck                       |
| TCT  | performance                     | luck                    | performance                 |
| TTC  | performance                     | performance                 | luck                    |
| TTT  | performance                     | performance                 | performance                  |

Phase 1's elicitation is deliberately framed as a **general** opinion
question ("people taking part in studies..."), decoupled from the
participant's own upcoming task. Phase 2 and 3 are explicitly about *this*
task.

**Anchors (dashed orange ghost bars showing a past allocation):**
- **Re-elicitation (Phase 2, screen 5): no anchor.** The screen is shown
  "cold" — no reference to, or overlay of, the Phase 1 allocation.
- **Redistribution (Phase 3, screen 8): anchor is randomized.** A 50/50
  coin flip per session (`redistAnchorRoll`, decided once at treatment
  assignment and held stable across reloads/resume) decides whether the
  Phase 2 re-elicitation allocation is shown as a dashed orange ghost bar
  behind each real bar on the redistribution widget. When shown, it's
  always the Phase 2 value (a full 5-value array, one $ amount per rank —
  see `reelicitAlloc` in `index.html`) — never Phase 1. Recorded in
  `redistribution_anchor_shown` / `p2_redistribution_anchor_shown`.

### Group size & pot
5 people per group, $5 pot (mean $1/person), allocated in 25c blocks (20
blocks total) via the manual allocation widget — see §1a below. No
parametric payout curve anymore; any split summing to $5 is reachable,
including non-monotonic ones (e.g. a worse-ranked person getting more than
a better-ranked one).

### 1a. Manual allocation widget (screens 2, 5, 8)
Replaces the old single 0–100 tau-slider + payoff-curve chart. Participants
build the $5 split themselves, directly: drag a bar up/down, use the
+/−25¢ buttons per person, or the **Split equally** / **Reset to $0**
shortcuts. Live stats (remaining-to-allocate, Gini) update instantly;
**Confirm** stays disabled — and, if clicked anyway, shows a red error with
the exact amount still unallocated — until the full $5 is assigned. See
`createAllocWidget()` in `index.html`.

Two modes, chosen per screen:
- **Elicitation & re-elicitation (screens 2, 5) — `fixedOrder: false`.**
  Hypothetical, no real "you". The 5 slots re-sort themselves by current
  amount (least → most, debounced ~700ms so dragging doesn't jitter), and
  **rank is simply defined as that sort position** — this is what "ranked
  from least to most lucky/skilled, sharing $5" always meant, just made
  literal instead of routed through a curve. Stored as `elicitation_alloc`
  / `reelicitation_alloc`: an array of 5 dollar amounts, index `i` = the
  amount at rank `i+1` (1=best/most‑paid … 5=worst/least‑paid — matching
  the old chart's axis convention).
- **Redistribution (screen 8) — `fixedOrder: true`.** A real "you", a real
  assigned/actual rank. Each slot is **pinned** to a real reward rank (slot
  id `i` = rank `i+1`) and **never reorders** — the highlighted `YOU` slot
  (red bar + "YOU · Rank N" label, at `YOU_RANK`) stays visually fixed no
  matter how the split changes. This is a deliberate carry-over from the
  old chart's `showYou`/red-highlight behavior, not something the
  free-form widget does by default. Stored as `giving_alloc`, same array
  shape, always in real-rank order (never resorted).

Both `elicitation_pref`/`reelicitation_pref`/`giving_pref` (the old scalar
0–100 fields) and their Sheet columns are kept for backward compatibility
with rows collected before this change, but are no longer written.
Per-rank dollar amounts get their own Sheet columns
(`p1_elicit_amt_rank1..5`, `p2_reelicit_amt_rank1..5`,
`p2_giving_amt_rank1..5`) alongside a JSON-array column and a Gini column
per phase — see `apps_script_backend`'s v14 change note. Deliberation time
per phase is unchanged: `elicitation_time_ms` / `reelicitation_time_ms` /
`giving_time_ms`, accrued via `startSectionTimer`/`stopSectionTimer` while
that screen is active.

### Payment mechanism
One group member's redistribution decision is picked at random and applied
to the whole group (disclosed to participants: "1 in 5 chance of receiving
your chosen bonus payment").

---

## 2. The real-effort task

15×15 grid, rendered on a **`<canvas>`**, not DOM elements — canvas pixels
have no text or accessibility representation, so browser Find-in-page
cannot locate the target emoji (a DOM+CSS-content approach was tried first
and found not to be reliably immune to this across browsers).

- Grid starts empty (placeholder cells only) while the participant reads
  instructions. Pressing **Ready** starts both the fast reveal
  (`GRID_REVEAL_MS = 8`, ~1.8s for all 225 cells) and a fixed **45-second**
  countdown at once.
- No manual submit. Auto-submits when the clock hits zero.
- Live counter counts **up** ("Found: N") — never discloses the total
  target count.
- No freebies. Wrong clicks flash red and never persist as selected.
- **Target count is a function of assigned rank**, doubling: position 1
  (worst assigned rank) → 2 targets, ... position 5 (best) → 32
  (`Math.pow(2, position)`). This is deliberate: it produces more
  actual/assigned-rank inversion risk at the bottom of the distribution and
  a ceiling effect at the top (both intentional, confirmed with Michele).
- **Recorded per attempt:** the target emoji (`task_target_emoji` /
  `p2_task_target_emoji`) and the distinct set of non-target ("distractor")
  emojis actually placed in that grid (`task_other_emojis` /
  `p2_task_other_emojis`) — the distinct set, not the full 225-cell array,
  since distractors repeat heavily.

---

## 3. Assigned rank vs. actual rank — the core mechanic

Two genuinely different numbers, used for different things. Getting this
distinction right (and where it went wrong once, historically) is the most
important thing in this codebase to understand before touching the rank
logic.

- **`ASSIGNED_RANK`**: decided *a priori* by the backend's cluster-chain
  queue, purely from arrival order. Fixes **task difficulty** (target
  count) before the task starts. This is the researcher's **instrument**
  for estimation — it is never shown to the participant and never
  determines payment.
- **`YOU_RANK` (= actual rank)**: what's actually **displayed and paid
  on**. Starts as a placeholder equal to `ASSIGNED_RANK`, then gets
  overwritten the instant the task auto-submits, based on real
  `task_found_count` compared against the participant's cluster-chain
  predecessors. Performance has to matter — that's the entire point of the
  task; assigned-rank-only display was a bug that shipped once and was
  corrected, not a design choice.

This is computed **client-side, instantly, with no network wait**: the
backend's `lookup` call (already made at Phase-2 entry, same call that
fetches the memory sequence and elicitation prefs) also returns
`predecessor_found_counts` — the real scores of this participant's
up-to-4 comparison-window predecessors. This is safe to send early because
of the assignment invariant below: those predecessors are guaranteed
already finished, and their scores never change afterward.

The backend *also* independently computes and stores its own authoritative
`actual_rank` server-side (not client-tamperable) as a cross-check before
any real payout — the two computations should always agree, and use the
identical tie-break formula, but the live experience runs on the instant
client-side value.

**Tie-break rule:** standard competition ranking. Tied participants share
the same, *better* (numerically lower) rank — e.g. found-counts
`[16,8,5,5,2]` produce ranks `[1,2,3,3,5]`, not an arbitrary split.

---

## 4. Backend: the cluster-chain rank assignment system

A **cluster is an endless chain**, not a fixed batch of 5. Rank cycles
`1,2,3,4,5,1,2,3,4,5,...` forever within one `cluster_id`, and each
participant's comparison group is simply their **4 immediate predecessors
in that chain** — a sliding window, found by following one pointer
backward, not a fixed group.

- **`cluster_id`**: identifies a chain *segment* — changes only when a fork
  happens. Organizational, not a bucket.
- **`cluster_slot`**: the assigned rank — position in the endless 1–5
  cycle. Drives task difficulty.
- **`prev_participant_pid`**: the real mechanism. A pointer to whoever
  immediately precedes this participant in the chain. Walking it backward
  4 times gives the comparison group — uniformly, with no special-casing
  needed for fork boundaries, because a fork's first link already points
  at the correct ancestor.

### Assignment algorithm (on each new Phase-2 entrant)
"Busy" is never stored — it's derived live, every time, by checking
whether a cluster's last entrant is task-complete.

1. **Bootstrap** (sheet has no cluster yet): cluster 1 is created with the
   real first participant at slot 1, plus **4 synthetic "perfect" rows**
   at slots 2–5 (`is_synthetic=true`, found_count == target count exactly),
   chained together, physically inserted *above* the real participant's
   row (`sheet.insertRowsBefore`) and timestamped an hour earlier, so they
   read as pre-existing predecessors, not simultaneously-created filler.
2. **Scan clusters from 1 upward.** Use the **first** cluster whose last
   entrant is already complete (this is what makes an earlier cluster
   "become active again" automatically the moment its straggler
   finishes — nothing is cached, every arrival rechecks from scratch).
3. **If every existing cluster is busy → fork.** The new participant steps
   into the busiest (most recent) cluster's stuck entrant's *exact
   position* — same slot, same `prev_participant_pid` — effectively
   replacing them in the sequence. **Nothing is copied or duplicated**; the
   stuck row is never touched. If that participant later returns and
   completes (five minutes or five days later), it's a completion like any
   other, against their own original cluster — a missing observation
   otherwise, not an error state.

### Assignment invariant (why rank can be computed instantly)
A participant can only continue a chain whose immediate predecessor was
**already** task-complete (otherwise it forks instead). By induction, this
holds transitively all the way back — so by the time *any* participant
finishes their own task, all 4 of their comparison-window predecessors are
guaranteed already done. Actual rank is never actually waiting on the
future.

### `actual_rank` computation
Once a participant is task-complete, rank them against their 4
predecessors by real `task_found_count` (descending; competition-ranking
ties). Triggered by a full sheet sweep after every `task_complete` write
(cheap at this study's scale) — a single completion can make its own rank
computable, or unblock some *other*, later participant whose window was
waiting on it.

### Data-integrity rules (followed throughout)
- Never delete or overwrite a real row. Timeouts, forks, and reassignments
  only ever add new columns or new rows — never mutate existing history.
- `flagged_incomplete`: informational only. Set once a row has been
  incomplete for over an hour (`FLAG_TIMEOUT_MS`), for **manual** research
  follow-up. No automatic email, no effect on assignment logic.
- `task_complete_at` (not `phase2_complete_at`) is what governs chain
  availability and rank-window eligibility — real task performance being
  known is what matters, not whether the participant has also finished
  recall/redistribution/everything else.

---

## 5. File inventory

| File | Purpose |
|---|---|
| `index.html` | The whole participant-facing app: single-file HTML/CSS/JS, no build step, deployed on GitHub Pages. |
| `apps_script_backend_v10.gs` | Google Apps Script Web App backend, writes to a Google Sheet (`Responses` tab). |
| `stress_test.html` | Standalone browser tool (open directly, no server) for concurrency-testing the backend: bulk assignment, forced fork scenarios, chained forks, and rigged-inversion completion races. Not part of the participant flow. |
| `stability_item_pool.json` | Reference data file: the stability/recognition task's item pool, sampling/foil rules, and backend variable shapes (`_meta`). Ported into `index.html`'s `STABILITY_POOL` — not loaded at runtime. |
| `stability_task_mockup.html` | Standalone reference implementation of the stability/recognition task's exact sequencing and copy (open directly in a browser). Ground truth used when porting the task into `index.html`; not part of the participant flow. |

### Frontend architecture notes
- **State model:** `DATA_LOG` is the single source of truth for everything
  measured about a participant — POSTed to the backend, and what
  `downloadDataBackup()` saves locally as a manual-recovery fallback.
- **Resume system:** the backend is the source of truth for resume state
  (works cross-device); `localStorage` is a same-device fast path only,
  never trusted over a missing/complete backend record.
- **Demo modes:** `demomode=1` = real phase routing, real backend
  read/writes, debug panel visible — must reflect true backend state
  (assigned rank is **not** randomized here). `demomode=2` = full synthetic
  pilot, ignores `STUDY_ID`, always starts fresh — the *only* mode where
  rank is permanently randomized, since there's no real backend record to
  be consistent with.
- **Bootstrap funnel:** a single, unconditional point in
  `bootstrapAppInner_` applies Phase-2 authoritative data
  (`STABILITY_ROWS_TESTED`, `PHASE1_CONDITION_CONFIRMED`, elicitation
  allocs, `ASSIGNED_RANK`, `predecessor_found_counts`) — this runs
  identically regardless of which of the three startup paths (fresh /
  backend-resume / local-resume) triggered it, which is what prevents the
  "correction only wired into some paths" class of bug that has bitten this
  codebase before.

### Backend architecture notes
- `LockService.getScriptLock()` wraps every request; `progress` heartbeats
  use a short `tryLock` (a missed heartbeat is harmless and superseded by
  the next one) — real completions use the full blocking lock.
- Header (`HEADER` array) is append-only by convention — new columns are
  added at the end, never inserted mid-array, so previously-written rows
  stay correctly aligned under the current schema.
- `getSheet_()` self-heals the header row if it drifts from `HEADER`, but
  only rewrites when it actually differs (not on every request).

---

## 6. Known limitations / open items

- Client-computed `actual_rank` is technically visible/inspectable via
  browser devtools before the backend's own independent value is confirmed
  — the server-side cross-check exists specifically so a discrepancy can
  be caught before any real payout, not to prevent inspection outright.
- A cluster that's abandoned (forked away from) and never returns to stays
  permanently below 5 real members — by design, an accepted missing
  observation, not a failure state requiring cleanup.
- No automated test suite — verification has been manual dry-run scripts
  (Node mocks of the backend logic) plus the `stress_test.html` tool
  against a live deployment.
