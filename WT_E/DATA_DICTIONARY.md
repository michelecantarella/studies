# WT_E — Data Dictionary

One row per column, in the exact left-to-right order it appears in the Google Sheet / Excel export. There are **three sheets** (tabs): `Meta`, `Responses`, `Hands`.

- **`Meta`** — one row per respondent (their background survey answers + running totals).
- **`Responses`** — one row per respondent × sequence (1–5) × **attempt** (almost always just 1 attempt — see "Reload/attempt tracking" below).
- **`Hands`** — one row per respondent × sequence × attempt × **hand** (a "hand" is one card-stack draw within a sequence — see §5/§6 of `README.md` for the full mechanic). This is the fine-grained breakdown behind each `Responses` row.

**Join keys:**
- `Responses` → `Meta`: match on `prolific_pid`.
- `Hands` → `Responses`: match on `prolific_pid` + `seq_n` + `seq_attempt`.

**Before analysing `Responses` or `Hands`: filter to `is_latest_attempt = 1`.** This gives one row per real section (or per real hand) — see "Reload/attempt tracking" at the end of this document for why the column exists at all. For the vast majority of respondents every row already has `is_latest_attempt = 1`, since a reload discarding real progress is rare.

Columns marked **LEGACY** are permanently blank going forward — they exist only so that columns added later never shift position relative to rows already written under an older version of the study. Safe to ignore/hide.

---

## Sheet: `Meta` (one row per respondent)

| Column | Type | Description |
|---|---|---|
| prolific_pid | text | Prolific ID (or, for the in-class student version, whatever ID/name the student typed in) |
| study_id | text | The study's `STUDY_ID` — `pilot`, `studentpilot`, or the real Prolific study ID |
| session_id | text | Prolific's session ID for this respondent |
| demo_mode | 0/1/2 | 0 = real respondent; 1/2 = internal testing (debug bar), never a genuine participant |
| consent_at | timestamp | When "I consent" was clicked. Never overwritten once set. Blank for the student version, which collects consent in class instead. |
| study_complete_at | timestamp | Set the moment the final save succeeds. Blank means the respondent has not (yet, or ever) finished. |
| last_updated_iso | timestamp | Updated on every single save — the most recent activity timestamp for this respondent |
| age | — | **LEGACY.** Original short survey's field; replaced by the fuller survey (`employment_status` onward). |
| gender | — | **LEGACY.** See `age` above. |
| student | — | **LEGACY.** See `age` above. |
| sections_done | number | How many of the 5 sequences this respondent has finished |
| total_earnings | £ | Running total bonus earnings so far (training bonus + section bonuses, net of penalties) |
| total_grid_pay | £ | Running total of the guaranteed per-grid pay (independent of the bonus above) |
| total_grids_completed | number | Running total of individual emoji-grids completed |
| reload_count | number | How many times this respondent came back in a **new browser session** (closed tab/different device) — same-tab refreshes don't count |
| reload_log_json | JSON (text) | One entry per reload above: which section number was current, and when |
| resume_snapshot_json | JSON (text) | The full state needed to resume mid-study. Cleared once the respondent finishes. Not generally useful for analysis — it's a technical resume mechanism, not data. |
| training_bonus | £ | Fixed bonus (£0.10) credited once the tutorial is completed. Already included in `total_earnings`. |
| seq_frame_treatment | 4 or 5 | Hidden framing treatment: whether this respondent was told they'd complete "4" or "5" sequences (both actually run 5) |
| total_penalty | £ | Sum of all mistake penalties (misclicks on the grids) across every sequence |
| training_choice | — | **LEGACY.** Was going to record a free practice decision during training; the tutorial now walks everyone through both branches instead, so there's nothing to record. |
| training_choice_at | — | **LEGACY.** See `training_choice` above. |
| geo_country, geo_region, geo_city, geo_ip | text | IP-based location, best-effort (see "Geolocation" note below). Blank if the lookup failed or was skipped. |
| geo_json | JSON (text) | The full raw response from whichever geolocation provider answered (lat/long, timezone, ISP, currency, etc.) — the four fields above are just convenience copies of its most-used values |
| employment_status | text | Current main activity status (employed / self-employed / student / retired / not employed / other) |
| labor_income | number | Usual monthly income after tax. Blank unless `employment_status` is one of the employed/self-employed categories. |
| marstat | text | Marital status |
| hh_others | number | How many people besides the respondent live in their household (0 = living alone) |
| family_contributors | text | Who contributes to household expenses. Blank whenever `hh_others = 0` (question doesn't apply). |
| education | text | Highest level of education completed |
| ends_meet_now, ends_meet_past, ends_meet_future | text (7-point scale) | SOEP-style "how easily do you make ends meet" — for this month / a year ago / a year from now |
| risk | 0–10 | Single-item risk-tolerance measure (Dohmen et al. 2011) |
| patience | 0–10 | Single-item patience measure (Falk et al. 2016) |
| geo_provider | text | Which geolocation service actually answered — `ipapi.co` or `ipwho.is` |
| pid_missing_from_link | 0/1 | 1 if `prolific_pid` had to be typed in by hand (or auto-generated for `pilot`) rather than arriving in the study link itself — always 1 for `studentpilot` |
| training_scenario_order | text | Order the tutorial's two optional end-of-training scenario buttons were shown in |
| training_scenarios_viewed | text | Which of those optional scenarios the respondent actually opened, in order. Blank if neither. |
| training_comp_check_q1_wrong, _q2_wrong, _q3_wrong | number | End-of-tutorial comprehension check — number of **wrong** attempts on each of the 3 questions before getting it right. `0` = correct first try. |

**Geolocation note:** fetched client-side (right after consent) from a third-party IP-lookup service, since Google Apps Script never sees the respondent's real IP address. Best-effort only — it never blocks or delays the study, and simply stays blank if it fails.

---

## Sheet: `Responses` (one row per respondent × sequence × attempt)

| Column | Type | Description |
|---|---|---|
| prolific_pid, study_id, session_id, demo_mode | — | Same as `Meta`, repeated on every row for convenience filtering |
| seq_n | 1–5 | Which of the respondent's 5 sequences this row is |
| pay | £ | This sequence's fixed reward |
| pay_tasks | number | The (hidden) task count `pay` was calibrated around |
| regime | 0/1/2/3 | This respondent's fixed offer-placement rule for the whole study (0 = "mixed", re-rolled per hand — see `Hands.sub_regime`) |
| hand_len | number | The FIRST hand's total length (cards) |
| live_pattern | text, e.g. `SSLSLS` | The FIRST hand's live(`L`)/safe(`S`) pattern, one character per card — genuinely mixed, not blocked |
| card_order | text, e.g. `SSLSLS\|LSL` | The full card-by-card order across **every** hand actually played this sequence, one hand's pattern per `\|`-separated segment, each truncated to however many of its cards were actually shown |
| p_inside_first | 0–1 | The FIRST hand's disclosed probability that the sequence ends inside it |
| n_hands | number | How many hands this sequence actually ran through |
| n_req | number | Total main-sequence card count it actually took to end (or, if it never ended naturally, the hand-cap cutoff — see `cap_bound`) |
| pause | number | The FIRST hand's own offer position (which card, within that hand, its offer appeared on) |
| pause_max | number | The largest `pause` could have been for that hand (`hand_len − 1`) |
| alt_duration | number | The alternative sequence's fixed length (in cards) |
| alt_end | number | The alternative's fixed endpoint |
| pause_secs | number (seconds) | How long the FIRST hand's own offer countdown ran for (10–45s, redrawn every time an offer fires — every later hand's own value is in the `Hands` sheet instead). Blank if that hand's offer never fired (see `Hands.wasted`). |
| outcome | text | `completed` / `switched` / `forfeited` for a real, finished attempt; `abandoned_reload` for a superseded attempt (see "Reload/attempt tracking") |
| switch_offered | — | **LEGACY.** Superseded by `switch_offered_at_task`/`_time` below. |
| switch_at | — | **LEGACY.** See `switch_offered` above. |
| n_tasks_done | number | How many cards were actually completed in this sequence attempt |
| earnings | £ | This sequence's actual bonus payout (0 if forfeited) |
| grid_pay | £ | Guaranteed per-grid pay earned this sequence (independent of `earnings`) |
| total_targets, total_found, total_false_pos, total_missed | number | Aggregated grid-click accuracy across the whole sequence |
| seq_reload_count | number | How many of the respondent's session-level reloads happened while this sequence number was current |
| start_at, end_at | timestamp | When this sequence attempt started and ended |
| tasks_json | JSON (text) | One entry per individual grid completed — see "`tasks_json` structure" below |
| seq_frame_treatment | 4 or 5 | Same hidden framing treatment as in `Meta`, repeated here |
| seq_is_bonus | 0/1 | 1 if this was the hidden 6th "bonus" sequence (only exists for respondents told "4", to keep real completion time equal — see `README.md` §7) |
| switch_offered_at_task, switch_offered_at_time | number, timestamp | The card position and timestamp when the very FIRST offer of this sequence appeared |
| switch_taken | 0/1 | Whether the respondent switched to the alternative this sequence |
| switch_taken_at_task, switch_taken_at_time | number, timestamp | Card position and timestamp of **step 2** — pressing "Confirm" on the confirm pop-up (or a timeout auto-committing it). Blank unless `switch_taken = 1`. |
| forfeit_taken | 0/1 | Whether the respondent gave up this sequence |
| forfeit_taken_at_task, forfeit_taken_at_time | number, timestamp | Card position and timestamp of the forfeit, if any |
| seq_start_at_time | timestamp | Same value as `start_at` (explicit alias, kept for naming consistency with other `_at_time` columns) |
| e_remaining | number | Expected further cards remaining, calculated from the first hand's own offer position |
| e_end_at_start | number | A fixed population constant (same across all respondents/sequences) — the expected total main-sequence length if nothing were known yet |
| e_end_at_pause | number | `pause + e_remaining` |
| penalty | £ | Mistake penalty (£0.01 per misclick) for this sequence, already deducted from `earnings` |
| cap_bound | 0/1 | 1 if the sequence hit the hidden maximum-hands safety cap rather than ending on its own — treat `n_req` as right-censored for these rows |
| offer_wasted | 0/1 | 1 if any hand in this sequence never got to show its offer at all (its own end came first — see `Hands.wasted`) |
| alt_base | number | Population constant, identical to `e_end_at_start` |
| alt_width | number | The average hand length used when drawing `alt_duration` |
| alt_minus_expected | number | `alt_duration − e_remaining`. Negative = the alternative was the shorter option in expectation, at the moment of the first offer. |
| hands_json | — | **LEGACY.** Superseded by the `Hands` sheet (one row per hand, much easier to work with than this JSON blob). |
| switch_pressed_at_task, switch_pressed_at_time | number, timestamp | **Step 1** — card position and timestamp when "Accept and switch" was first pressed, opening the confirm pop-up. If the respondent pressed Undo and tried again later, this reflects whichever press actually led to confirming. Blank unless `switch_taken = 1`. |
| switch_decision_secs | number (seconds) | How long the respondent sat on the confirm pop-up: the gap between `switch_pressed_at_time` (step 1) and `switch_taken_at_time` (step 2). Blank unless `switch_taken = 1`. |
| alt_phase_started_at | timestamp | When the alternative sequence actually began. Blank if never reached. |
| outcome_summary | text | A ready-made, human-readable label (e.g. "switched at offer", "continued and forfeited") summarising this row — purely derived from the other columns, see `README.md` §14 for the full derivation table |
| seq_attempt | number | 1 for a normal, un-interrupted attempt; 2, 3, … only if an earlier attempt at this `seq_n` was abandoned by a reload (see "Reload/attempt tracking") |
| is_latest_attempt | 0/1 | **Filter to 1** to get one row per real sequence — see the top of this document |

**`tasks_json` structure** (one object per completed grid within that sequence):
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
`phase` is `"main"` or `"alt"`. `no_activity` is true if the respondent clicked/moved nothing at all during that grid (they still saw the "Are you still there?" prompt before moving on). `first_move_at` is when they first clicked or moved the cursor on that grid.

---

## Sheet: `Hands` (one row per respondent × sequence × attempt × hand)

The fine-grained breakdown behind each `Responses` row — every hand that was actually drawn during that sequence attempt, not just the first one.

| Column | Type | Description |
|---|---|---|
| prolific_pid, study_id, session_id, demo_mode | — | Same as the other sheets, repeated for convenience |
| seq_n, seq_attempt | — | Which sequence/attempt this hand belongs to — matches the same columns on `Responses` |
| hand_n | number | This hand's 1-based position within the sequence attempt (the hand with `hand_n = n_hands` on the matching `Responses` row is the one that ended the sequence) |
| hand_len | number | This hand's total length (cards) |
| live_pattern | text, e.g. `SSLSLS` | This hand's own live(`L`)/safe(`S`) pattern |
| p_inside | 0–1 | This hand's own disclosed end-probability |
| sub_regime | 1/2/3 | Which offer-placement rule governed THIS hand specifically (only varies hand-to-hand when the respondent's `Responses.regime` is 0) |
| wasted | 0/1 | 1 if this hand ended before its own offer ever got the chance to fire (only possible under `sub_regime = 3`) |
| ends | 0/1 | 1 if this was the hand that ended the sequence |
| end_pos | number | If `ends = 1`, which of this hand's own live cards it ended on (0-indexed) |
| played_len | number | How many of this hand's cards were actually shown (all of them, unless it ended early) |
| pause | number | This hand's own offer position — which card, within this hand, its offer appears on |
| pause_secs | number (seconds) | How long THIS hand's own offer countdown actually ran for when shown (10–45s, redrawn independently every time). This is the entire accept/refuse-and-confirm window for this hand — the same countdown runs underneath both the initial ask step and the follow-up confirm step, uninterrupted. Blank if `wasted = 1`. |
| offer_fired_at | timestamp | The real moment this hand's own offer screen appeared. Blank if `wasted = 1`. |
| undo_count | number | How many times "Undo" was pressed on this hand's own confirm pop-up (a measure of indecision). 0 if the offer never opened or was never undone. |
| auto_refused | 0/1 | 1 if this hand's countdown ran out while the respondent still hadn't picked anything on the FIRST (ask) screen — defaults to staying in the main sequence |
| auto_confirmed | 0/1 | 1 if this hand's countdown ran out on the FOLLOW-UP (confirm) screen instead, auto-committing whichever choice was pending. At most one of `auto_refused`/`auto_confirmed` is ever 1 for a given hand. |
| active_passed_in_hand, active_passed_in_seq | number | How many live ("active") cards had already gone by at this hand's own offer position — within just this hand, vs. across the whole sequence so far |
| inactive_passed_in_hand, inactive_passed_in_seq | number | Same, for safe ("inactive") cards |
| active_left_in_hand, active_left_in_seq | number | How many live cards remain — within this hand, vs. across the rest of the already-drawn sequence |
| inactive_left_in_hand, inactive_left_in_seq | number | Same, for safe cards |
| is_latest_attempt | 0/1 | Mirrors the parent `Responses` row's value — **filter to 1** for one row per real hand |

---

## Reload/attempt tracking (why `seq_attempt` / `is_latest_attempt` exist)

If a respondent closes the study and comes back in a **new browser session** (not just refreshing the same tab) while partway through a sequence, that in-progress sequence restarts from scratch with freshly-drawn hands — this is deliberate, so nobody can reload to "peek" at how a sequence will play out before committing to it.

Rather than silently losing the abandoned attempt, it gets its **own row**, marked `outcome = 'abandoned_reload'`, with `seq_attempt` bumped up for the row that replaces it. This only happens if the respondent had made genuine progress (completed at least one grid) before the reload — an early reload with nothing done yet leaves no trace.

**In practice:** almost every respondent has exactly one attempt per sequence (`seq_attempt = 1`, `is_latest_attempt = 1`) for all 5 rows. Just filter to `is_latest_attempt = 1` and this whole mechanism can be ignored — it only matters if you specifically want to study reload/abandonment behaviour.

---

*See `README.md` for the full study design, mechanics, and rationale — this document only covers what each spreadsheet column means.*
