# WT_E — Data Dictionary

One row per column, in the exact left-to-right order it appears in the Google Sheet / Excel export. There are **three sheets** (tabs): `Meta`, `Responses`, `Hands`.

- **`Meta`** — one row per respondent. **Respondent-level data only**: their background survey answers, running totals, and study-wide milestones.
- **`Responses`** — one row per respondent × sequence (1–5) × **attempt** (almost always just 1 attempt — see "Reload/attempt tracking" below). **Sequence-level data only**: anything that varies from one sequence to the next for the same respondent.
- **`Hands`** — one row per respondent × sequence × attempt × **hand** (a "hand" is one card-stack draw within a sequence — see §5/§6 of `README.md` for the full mechanic). **Hand-level data only**: anything that varies from one hand to the next within the same sequence. This is the fine-grained breakdown behind each `Responses` row.

**These three levels are kept strictly separate — nothing is repeated across sheets.** A sequence's own data lives only on `Responses`, never copied onto `Meta`; a hand's own data lives only on `Hands`, never copied onto `Responses` (earlier versions of this study repeated the *first* hand's own pattern/offer/timing directly on `Responses`, which was pure duplication of that hand's own row on `Hands` — removed).

**Join keys:**
- `Responses` → `Meta`: match on `prolific_pid`.
- `Hands` → `Responses`: match on `prolific_pid` + `seq_n` + `seq_attempt`.

**Before analysing `Responses` or `Hands`: filter to `is_latest_attempt = 1`.** This gives one row per real section (or per real hand) — see "Reload/attempt tracking" at the end of this document for why the column exists at all. For the vast majority of respondents every row already has `is_latest_attempt = 1`, since a reload discarding real progress is rare.

Columns marked **£** always hold a plain number in the sheet — the £ sign is never stored, it's only how the participant's own screen displays it (or "Points" instead, for the in-class student version — same underlying number either way).

---

## Sheet: `Meta` (one row per respondent)

| Column | Type | Description |
|---|---|---|
| prolific_pid | text | Prolific ID (or, for the in-class student version, whatever ID/name the student typed in) |
| study_id | text | The study's `STUDY_ID` — `pilot`, `studentpilot`, or the real Prolific study ID |
| session_id | text | Prolific's session ID for this respondent |
| demo_mode | 0/1/2 | 0 = real respondent; 1/2 = internal testing (debug bar), never a genuine participant |
| consent_at | timestamp | When "I consent" was clicked. Never overwritten once set. Blank for the student version, which collects consent in class instead. |
| training_started_at | timestamp | When the tutorial walkthrough began |
| training_ended_at | timestamp | When the tutorial walkthrough finished (comprehension check passed) |
| experiment_started_at | timestamp | When the 5 real sections began. Almost always the same instant as `training_ended_at` — kept as its own column anyway since it answers a slightly different question. |
| experiment_ended_at | timestamp | When the LAST real section actually finished playing. **Not the same as `study_complete_at` below** — this is when the respondent stopped playing; `study_complete_at` is when that result was successfully saved, which can be seconds (or, with a flaky connection, much longer) later. |
| study_complete_at | timestamp | Set the moment the final save succeeds. Blank means the respondent has not (yet, or ever) finished. |
| last_updated_iso | timestamp | Updated on every single save — the most recent activity timestamp for this respondent |
| sections_done | number | How many of the 5 sequences this respondent has finished |
| total_earnings | £ | Running total GROSS bonus earnings so far (training bonus + section bonuses) — **not yet net of penalties.** See `final_bonus` below for the actual amount owed. |
| total_grid_pay | £ | Running total of the guaranteed per-grid pay (independent of the bonus above) |
| total_grids_completed | number | Running total of individual emoji-grids completed |
| training_bonus | £ | Fixed bonus (£0.10) credited once the tutorial is completed. Already included in `total_earnings`. |
| total_penalty | £ | Sum of all mistake penalties (misclicks on the grids) across every sequence — see `Responses.penalty` for the per-sequence breakdown |
| final_bonus | £ | **The actual amount owed at the end of the whole study** — `total_earnings` minus `total_penalty`, never negative. This is what "Your bonus reward" on the results screen actually shows. |
| reload_count | number | How many times this respondent came back in a **new browser session** (closed tab/different device) — same-tab refreshes don't count. See `Responses.seq_reload_count` for the per-sequence breakdown. |
| reload_log_json | JSON (text) | One entry per reload above: which section number was current, and when |
| resume_snapshot_json | JSON (text) | The full state needed to resume mid-study. Cleared once the respondent finishes. Not generally useful for analysis — it's a technical resume mechanism, not data. |
| seq_frame_treatment | 4 or 5 | Hidden framing treatment: whether this respondent was told they'd complete "4" or "5" sequences (both actually run 5) |
| employment_status | text | Current main activity status (employed / self-employed / student / retired / not employed / other) |
| labor_income | number | Usual monthly income after tax. Blank unless `employment_status` is one of the employed/self-employed categories. |
| marstat | text | Marital status |
| hh_others | number | How many people besides the respondent live in their household (0 = living alone) |
| family_contributors | text | Who contributes to household expenses. Blank whenever `hh_others = 0` (question doesn't apply). |
| education | text | Highest level of education completed |
| ends_meet_now, ends_meet_past, ends_meet_future | text (7-point scale) | SOEP-style "how easily do you make ends meet" — for this month / a year ago / a year from now |
| risk | 0–10 | Single-item risk-tolerance measure (Dohmen et al. 2011) |
| patience | 0–10 | Single-item patience measure (Falk et al. 2016) |
| geo_country, geo_region, geo_city, geo_ip | text | IP-based location, best-effort (see "Geolocation" note below). Blank if the lookup failed or was skipped. |
| geo_provider | text | Which geolocation service actually answered — `ipapi.co` or `ipwho.is` |
| geo_json | JSON (text) | The full raw response from whichever geolocation provider answered (lat/long, timezone, ISP, currency, etc.) — the fields above are just convenience copies of its most-used values |
| device_type | text | Best-effort device classification captured at consent — `Desktop`, `Mobile`, or `Tablet` |
| browser | text | Best-effort browser name captured at consent — `Chrome`, `Safari`, `Firefox`, `Edge`, `Opera`, or `Other` |
| user_agent | text | The full raw browser user-agent string, for anything the two fields above don't capture |
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
| seq_attempt | number | 1 for a normal, un-interrupted attempt; 2, 3, … only if an earlier attempt at this `seq_n` was abandoned by a reload (see "Reload/attempt tracking") |
| is_latest_attempt | 0/1 | **Filter to 1** to get one row per real sequence — see the top of this document |
| pay | £ | This sequence's fixed reward |
| pay_tasks | number | The (hidden) task count `pay` was calibrated around |
| regime | 0/1/2/3 | This respondent's fixed offer-placement rule for the whole study (0 = "mixed", re-rolled per hand — see `Hands.sub_regime`) |
| n_hands | number | How many hands this sequence actually ran through |
| n_req | number | Total main-sequence card count it actually took to end (or, if it never ended naturally, the hand-cap cutoff — see `cap_bound`) |
| alt_duration | number | The alternative sequence's fixed length (in cards) |
| alt_end | number | The alternative's fixed endpoint |
| alt_base | number | Population constant, identical to `e_end_at_start` |
| alt_width | number | The average hand length used when drawing `alt_duration` |
| alt_minus_expected | number | `alt_duration` minus the FIRST hand's own `e_end_at_pause` minus that same hand's position in the sequence (i.e. its own expected-further-cards figure — `Hands` sheet, `hand_n=1`). Negative = the alternative was the shorter option in expectation, at the moment of the first offer. |
| e_end_at_start | number | A fixed population constant (same across all respondents/sequences/hands — see `Hands.e_end_at_hand_start`/`e_end_at_pause` for the equivalent figure genuinely specific to a real hand's own parameters) — the expected total main-sequence length if nothing were known yet |
| cap_bound | 0/1 | 1 if the sequence hit the hidden maximum-hands safety cap rather than ending on its own — treat `n_req` as right-censored for these rows |
| offer_wasted | 0/1 | 1 if any hand in this sequence never got to show its offer at all (its own end came first — see `Hands.wasted`) |
| card_order | text, e.g. `SSLSLS\|LSL` | The full card-by-card order across **every** hand actually played this sequence, one hand's pattern per `\|`-separated segment, each truncated to however many of its cards were actually shown. A whole-sequence aggregate — reconstructable from the `Hands` sheet too, kept here as one flat, directly-readable field. |
| seq_frame_treatment | 4 or 5 | Same hidden framing treatment as in `Meta`, repeated here |
| seq_is_bonus | 0/1 | 1 if this was the hidden 6th "bonus" sequence (only exists for respondents told "4", to keep real completion time equal — see `README.md` §7) |
| start_at | timestamp | When this sequence attempt started |
| end_at | timestamp | When this sequence attempt ended |
| seq_start_at_time | timestamp | Same value as `start_at` (explicit alias, kept for naming consistency with other `_at_time` columns) |
| briefing_ended_at | timestamp | The moment the pre-sequence briefing (reward, alternative length, reminders) actually ended — "Start sequence" pressed. Distinct from `start_at`, stamped an instant later once the first real card is actually being set up. |
| seq_reload_count | number | How many of the respondent's session-level reloads happened while this sequence number was current |
| outcome_summary | text | **This IS the outcome column** — there is no separate plain `outcome` enum any more (removed as pure redundancy: this is strictly more informative, e.g. distinguishing "switched at offer and forfeited" from "continued and forfeited," both of which a plain enum would collapse to the same `forfeited`). A ready-made, human-readable label (e.g. `switched at offer`, `continued and forfeited`, `auto-kicked before offer`, `abandoned before reload — superseded by a later attempt`) summarising this row — purely derived from the other columns, see `README.md` §14 for the full derivation table. `completed`/`switched`/`forfeited`/`autokicked`/`abandoned_reload` are all unambiguously recoverable by matching on this text if you need the plain version. |
| switch_offered_at_task, switch_offered_at_time | number, timestamp | The card position and timestamp when the very FIRST offer of this sequence appeared |
| switch_taken | 0/1 | Whether the respondent switched to the alternative this sequence |
| switch_taken_at_task, switch_taken_at_time | number, timestamp | Card position and timestamp of **step 2** — pressing "Confirm" on the confirm pop-up (or a timeout auto-committing it). Blank unless `switch_taken = 1`. |
| switch_pressed_at_task, switch_pressed_at_time | number, timestamp | **Step 1** — card position and timestamp when "Accept and switch" was first pressed, opening the confirm pop-up. If the respondent pressed Undo and tried again later, this reflects whichever press actually led to confirming. Blank unless `switch_taken = 1`. |
| switch_decision_secs | number (seconds) | How long the respondent sat on the confirm pop-up: the gap between `switch_pressed_at_time` (step 1) and `switch_taken_at_time` (step 2). Blank unless `switch_taken = 1`. |
| alt_phase_started_at | timestamp | When the alternative sequence actually began. Blank if never reached. |
| forfeit_taken | 0/1 | Whether the respondent gave up this sequence |
| forfeit_taken_at_task, forfeit_taken_at_time | number, timestamp | Card position and timestamp of the forfeit, if any |
| auto_kicked | 0/1 | 1 if this sequence was cut short because its own mistakes (penalty) reached its own reward (`pay`) — see "Autokick" below. Distinct from `forfeit_taken`, which is voluntary. |
| n_tasks_done | number | How many cards were actually completed in this sequence attempt |
| earnings | £ | This sequence's GROSS bonus payout (`pay` if completed/switched, 0 otherwise) — **not yet net of this sequence's own penalty.** See `net_earnings` below for the actual amount owed. |
| grid_pay | £ | Guaranteed per-grid pay earned this sequence (independent of `earnings`/`penalty`) |
| penalty | £ | Mistake penalty (£0.01 per misclick) for this sequence — logged separately, not yet subtracted from `earnings` above |
| net_earnings | £ | **The actual amount owed for this sequence** — `earnings` minus `penalty`, never negative. This is the number that actually counts. |
| total_targets, total_found, total_false_pos, total_missed | number | Aggregated grid-click accuracy across the whole sequence — a genuine sum across every hand plus the alt phase, unlike `tasks_json` below (a real sequence-wide statistic, not hand-level data copied up) |
| tasks_json | JSON (text) | **The ALT PHASE's own grids only.** The main phase's own grids live on the `Hands` sheet instead, one hand's own cards per row (`Hands.tasks_json`) — this column used to mix every hand's cards together with no way to tell which hand a given card was even played in, which was the actual bug: card-level data is hand-level data, not sequence-level. The alt phase has no hand structure to attach to, so it stays here. Empty array if the alt phase was never reached. See "`tasks_json` structure" below for the shape of each entry (same shape on both sheets). |

**`tasks_json` array structure** (one object per completed grid — same shape on both `Responses` and `Hands`):
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
| is_latest_attempt | 0/1 | Mirrors the parent `Responses` row's value — **filter to 1** for one row per real hand |
| hand_len | number | This hand's total length (cards) |
| live_pattern | text, e.g. `SSLSLS` | This hand's own live(`L`)/safe(`S`) pattern |
| p_inside | 0–1 | This hand's own disclosed end-probability |
| sub_regime | 1/2/3 | Which offer-placement rule governed THIS hand specifically (only varies hand-to-hand when the respondent's `Responses.regime` is 0) |
| wasted | 0/1 | 1 if this hand ended before its own offer ever got the chance to fire (only possible under `sub_regime = 3`) |
| ends | 0/1 | 1 if this was the hand that ended the sequence |
| end_pos | number | If `ends = 1`, which of this hand's own live cards it ended on (0-indexed) |
| played_len | number | How many of this hand's cards were actually shown (all of them, unless it ended early) |
| pause | number | This hand's own offer position — which card, within this hand, its offer appears on |
| sunk_cost_at_pause | number | **"Sunk cost" at this hand's own pause** — total tasks (live+safe) already completed across the WHOLE sequence by that moment, not just within this hand (the sum of `active_passed_in_seq` + `inactive_passed_in_seq` below). Fixed at generation time, like `pause` — unlike `pause_secs`/`offer_fired_at` below, **not** blank when `wasted = 1`. |
| left_pattern | text | This hand's own `live_pattern` up to (not including) its own pause — the `pause` cards **already completed** when the offer fires (0-indexed positions `0` to `pause-1`) |
| right_pattern | text | This hand's own `live_pattern` from its own pause onward — **including the card not yet completed** at the moment the offer fires (`pause` is a count of completed cards, so the card sitting exactly at that position hasn't been played yet). `left_pattern + right_pattern` always equals `live_pattern`, with nothing skipped or duplicated. |
| e_end_at_hand_start | number | **Expected total main-sequence length (in cards), as anticipated the moment this hand is dealt** — before any of its own cards are known to have passed. Genuinely accounts for this hand's own real `p_inside`/length, plus the population constant for whatever uncertain hands might still follow. |
| e_end_at_pause | number | Same idea, but **as anticipated at this hand's own pause** — conditional on having survived to it, corrected for however many live/orange cards are already gone by within this hand, plus uncertain future hands. For the section's FIRST hand, this is the figure `Responses.alt_duration`/`alt_minus_expected` are built around. |
| pause_secs | number (seconds) | How long THIS hand's own offer countdown actually ran for when shown (10–45s, redrawn independently every time). This is the entire accept/refuse-and-confirm window for this hand — the same countdown runs underneath both the initial ask step and the follow-up confirm step, uninterrupted. Blank if `wasted = 1`. |
| offer_fired_at | timestamp | The real moment this hand's own offer screen appeared. Blank if `wasted = 1`. |
| deliberation_secs | number (seconds) | **How long the respondent actually took to decide** — real elapsed time from `offer_fired_at` to the moment a final decision was actually committed for this hand's offer (accept or refuse, manually confirmed or auto-resolved by the countdown reaching 0). Not the same as `pause_secs` (that's the *randomised length assigned* to the countdown, not how long deciding actually took) nor Responses' `switch_decision_secs` (only the switch-taken case, and only the step-1→step-2 confirm-popup gap, not the initial ask step before it). Blank if `wasted = 1`, or if the offer fired but was never resolved (reload discarded the attempt first). |
| undo_count | number | How many times "Undo" was pressed on this hand's own confirm pop-up (a measure of indecision). 0 if the offer never opened or was never undone. |
| auto_refused | 0/1 | 1 if this hand's countdown ran out while the respondent still hadn't picked anything on the FIRST (ask) screen — defaults to staying in the main sequence |
| auto_confirmed | 0/1 | 1 if this hand's countdown ran out on the FOLLOW-UP (confirm) screen instead, auto-committing whichever choice was pending. At most one of `auto_refused`/`auto_confirmed` is ever 1 for a given hand. |
| active_passed_in_hand, active_passed_in_seq | number | How many live ("active") cards had already gone by at this hand's own offer position — within just this hand, vs. across the whole sequence so far |
| inactive_passed_in_hand, inactive_passed_in_seq | number | Same, for safe ("inactive") cards |
| active_left_in_hand, active_left_in_seq | number | How many live cards remain — within this hand, vs. across the rest of the already-drawn sequence |
| inactive_left_in_hand, inactive_left_in_seq | number | Same, for safe cards |
| hand_started_at | timestamp | When the respondent's position actually entered this hand — real play time, not the offer window (`offer_fired_at` above is specifically about the offer, and can be blank even when this isn't). Covers every hand, including ones whose offer was wasted or never opened. |
| hand_ended_at | timestamp | When the respondent's position actually left this hand. Same coverage as `hand_started_at`. Both blank iff this hand was never reached (a reload discarded the attempt first). |
| hand_penalty | £ | The mistake penalty accrued specifically **during this hand** (not the sequence's running cumulative total — see `Responses.penalty` for that). Blank iff this hand was never reached (same rule as the two timestamps above) — `0` is itself a meaningful "reached it, made no mistakes," not the same as blank. |
| switched | 0/1 | **Plain flag — 1 on the ONE hand whose own offer actually led to a real switch** (`Responses.switch_taken=1`), 0 on every other hand. See `switch_at_task_hand`/`_overall` below for exactly where. |
| forfeited | 0/1 | **Plain flag — 1 on the hand the respondent was in when they forfeited**, if they forfeited during the main phase; 0 on every other hand (including if they forfeited during the alt phase instead, which has no hand to attribute it to). See `forfeit_at_task_hand`/`_overall` below for exactly where. |
| switch_at_task_hand | number | Only meaningful when `switched=1` on this row — the card position within THAT hand. |
| switch_at_task_overall | number | Same event, but the card position within the WHOLE sequence — same value as `Responses.switch_taken_at_task`. Without these two columns, finding which hand's offer was the one actually accepted means cross-referencing that timestamp against every hand's own position range instead. |
| forfeit_at_task_hand | number | Only meaningful when `forfeited=1` on this row — the card position within that hand. |
| forfeit_at_task_overall | number | Same event, but the card position within the WHOLE sequence — same value as `Responses.forfeit_taken_at_task`, just also attached to the specific hand it happened in. |
| tasks_json | JSON (text) | **Every grid actually played during THIS hand** — one object per card, same shape as `Responses.tasks_json` (see its structure above). This is where a card's own accuracy data lives now — it used to be dumped into one flat, sequence-wide array on `Responses` with no way to tell which hand a given card was even played in, which was the actual bug: which hand a card belongs to is hand-level data. Empty array if this hand was never reached. |

---

## Reload/attempt tracking (why `seq_attempt` / `is_latest_attempt` exist)

If a respondent closes the study and comes back in a **new browser session** (not just refreshing the same tab) while partway through a sequence, that in-progress sequence restarts from scratch with freshly-drawn hands — this is deliberate, so nobody can reload to "peek" at how a sequence will play out before committing to it.

Rather than silently losing the abandoned attempt, it gets its **own row**, marked `outcome_summary = 'abandoned before reload — superseded by a later attempt'`, with `seq_attempt` bumped up for the row that replaces it. This only happens if the respondent had made genuine progress (completed at least one grid) before the reload — an early reload with nothing done yet leaves no trace.

**In practice:** almost every respondent has exactly one attempt per sequence (`seq_attempt = 1`, `is_latest_attempt = 1`) for all 5 rows. Just filter to `is_latest_attempt = 1` and this whole mechanism can be ignored — it only matters if you specifically want to study reload/abandonment behaviour.

---

## Autokick (why `auto_kicked`/`net_earnings` exist)

A sequence is cut short the instant its own accumulated `penalty` reaches its own `pay` — there is nothing left it could pay out, so rather than letting the respondent keep making mistakes for no reason, it ends there and they move on to the next sequence. Logged as `outcome = 'autokicked'` and `auto_kicked = 1` on the `Responses` row, distinct from a voluntary `forfeit_taken`. `net_earnings` is `0` for that sequence (same as any other sequence that pays nothing), and whichever hand was open at that moment still gets a normal `hand_ended_at`/`hand_penalty` on the `Hands` sheet.

---

*See `README.md` for the full study design, mechanics, and rationale — this document only covers what each spreadsheet column means.*
