# WT_G — Data Dictionary

Two sheets (tabs): `Meta` and `Responses`. Each section is **one sequence**, and everything about it lives on its `Responses` row.

- **`Meta`** — one row per respondent (survey answers, running totals, milestones).
- **`Responses`** — one row per respondent × sequence (1–5) × attempt.

**Join:** `Responses` → `Meta` on `prolific_pid`.

**Before analysing `Responses`: filter to `is_latest_attempt = 1`** (one row per real sequence — see "Reload/attempt tracking" below).

Columns marked **£** hold a plain number (£ for Prolific, "Points" on screen for the in-class student version — same number).

---

## Sheet: `Meta` (one row per respondent)

| Column | Type | Description |
|---|---|---|
| prolific_pid | text | Prolific ID (student version: the ID/name typed in) |
| study_id | text | `pilot`, `studentpilot`, or the real Prolific study ID |
| session_id | text | Prolific session ID |
| demo_mode | 0/1/2 | 0 = real respondent; 1/2 = internal testing |
| consent_at | timestamp | "I consent" clicked (blank for the student version) |
| training_started_at, training_ended_at | timestamp | Walkthrough start / end (comprehension check passed) |
| experiment_started_at, experiment_ended_at | timestamp | First real sequence started / last one finished |
| study_complete_at | timestamp | Final save succeeded. Blank = not finished |
| last_updated_iso | timestamp | Most recent save |
| sections_done | number | Sequences finished (0–5); attempts discarded by a reload are not counted |
| total_earnings | £ | Gross bonus so far (sequence rewards), before penalties |
| total_grid_pay | £ | Running total of per-card pay |
| total_grids_completed | number | Running total of cards completed |
| training_bonus | £ | Always 0: the walkthrough is not paid (column kept so it can be switched back on via `TRAINING_BONUS`) |
| total_penalty | £ | Sum of mistake penalties |
| final_bonus | £ | **Amount owed**: total_earnings − total_penalty, never negative (≤ `reward_pool` ≤ £1.50). Penalties from every row count, including forfeited, auto-kicked and abandoned attempts — so this is generally *not* the sum of `net_earnings` |
| reload_count, reload_log_json | number, JSON | New-session returns, and which section each happened in |
| resume_snapshot_json | JSON | Technical resume state (cleared at the end) |
| seq_frame_treatment | 4 or 5 | Told the study has 4 or 5 sequences (everyone plays 5) |
| employment_status, labor_income, marstat, hh_others, family_contributors, education | — | Background survey (labor_income only if employed/self-employed; family_contributors only if hh_others > 0) |
| ends_meet_now, ends_meet_past, ends_meet_future | text | SOEP 7-point "make ends meet" scale |
| risk, patience | 0–10 | Dohmen et al. (2011) / Falk et al. (2016) single items |
| geo_country, geo_region, geo_city, geo_ip, geo_provider, geo_json | text | IP geolocation, best-effort |
| device_type, browser, user_agent | text | Best-effort device classification at consent |
| pid_missing_from_link | 0/1 | 1 if the ID was typed in / auto-generated |
| training_scenario_order, training_scenarios_viewed | text | Legacy, always blank |
| training_comp_check_q1_wrong, _q2_wrong, _q3_wrong | number | Wrong attempts on each comprehension question (0 = right first time). Q2 is now "what happens if you reach the end without a winning card" |
| reward_pool | £ | Total of the five sequence rewards, drawn once per respondent: Uniform{1.00, 1.05, …, 1.50}. Split at random across the sequences (each ≥ £0.10, in £0.05 units) — see `pay` in `Responses` |
| regime | 0/1/2/3 | Offer-placement rule, drawn once per respondent: uniform on {0,1,2,3}, or on {0,1,2} in `pilot` / `studentpilot`. Same as `Responses.regime` |

---

## Sheet: `Responses` (one row per respondent × sequence × attempt)

### The sequence's own draw (fixed before it starts)

| Column | Type | Description |
|---|---|---|
| prolific_pid, study_id, session_id, demo_mode | — | As in `Meta` |
| seq_n | 1–5 | Which sequence |
| seq_attempt | number | 1 normally; 2, 3… only after a reload discarded an earlier attempt |
| is_latest_attempt | 0/1 | **Filter to 1** |
| pay | £ | The sequence's reward: its share of the respondent's `reward_pool` (≥ £0.10, multiple of £0.05; the five add up to the pool), independent of the sequence's own draw |
| regime | 0/1/2/3 | Respondent's offer-placement rule, fixed for all 5 sequences (never 3 in `pilot` / `studentpilot`) |
| sub_regime | 1/2/3 | Rule that actually governed THIS sequence (differs from `regime` only when regime = 0, which re-rolls 1 or 2 per sequence) |
| seq_len | 7–15 | Number of cards in the main sequence (all visible from the start) |
| live_pattern | text, e.g. `SLSSLL` | Card-by-card pattern: L = orange (can be the winning card), S = white. Last card always L |
| n_live | number | Orange cards in the pattern |
| p_inside | 0.10–0.90 | Disclosed chance the sequence contains the winning card |
| p_quintile | 1–5 | Band `p_inside` was drawn from: [10%, 90%] cut into 5 of equal width → 1 = 10–25, 2 = 30–40, 3 = 45–55, 4 = 60–70, 5 = 75–90 (each respondent gets each band once) |
| ends | 0/1 | 1 if the winning card is in the sequence |
| end_pos | number | Card number (1-indexed) of the winning card; blank if `ends = 0` |
| n_req | number | Main cards that would be played with no switch/forfeit: `end_pos`, or `seq_len` if there is no winning card |
| pause | number | Cards completed when the pause starts and the alternative is offered (0 = before the first card); uniform over the positions where the cards left are at least the cards done (`seq_len − pause ≥ pause`, up to half the sequence), truncated before the winning card when the ending is drawn first |
| pause_never_shown | 0/1 | 1 if the winning card came at or before `pause`, so the pause never happened (only possible when `sub_regime = 3`) |
| alt_duration | number | The alternative's own (blue) cards = `alt_global_end − pause`, shown at the offer and fixed afterwards; added at the start of the deck. Taking it after `k` main cards means going back over those `k` cards first (`alt_back`), then these cards |
| alt_global_end | number | `pause + alt_duration` = the switching route at the offer (going back + blue cards), between `seq_len` and `1.5·seq_len` |
| alt_window_lo, alt_window_hi | number | Bounds of `alt_duration`: `h = seq_len − pause` and `round(h·√2)`. `alt_duration = round(h·(cos θ + sin θ))`, θ ~ U(0°, 90°): the sum of the legs of a right triangle with hypotenuse `h`. Same rule in WT_F and WT_G |
| active_passed_at_pause, inactive_passed_at_pause | number | Orange / white cards already completed at the offer (sum = `pause`) |
| active_left_at_pause, inactive_left_at_pause | number | Orange / white cards still ahead in the sequence at the offer |
| left_pattern, right_pattern | text | `live_pattern` split at `pause` (left = already done; right = from the next card on) |
| e_rem_at_start | number | **Expected length of the main sequence at its start**, in cards: what the participant can expect knowing `seq_len`, the pattern and `p_inside` |
| e_rem_at_pause | number | **Expected main-sequence cards still to play** at the offer, if they keep going (up to the winning card, or to the end if there is none) |
| p_ahead_at_pause | 0–1 | Probability the winning card is still ahead at the offer |
| alt_minus_expected | number | Switching cost at the offer (`pause + alt_duration`) − expected cards to the reward if staying (`e_rem_at_pause` + (1 − `p_ahead_at_pause`) × (`seq_len` + `alt_duration`), since without a winning card they go back over the whole sequence and then do the alternative). Negative = switching at the offer is the shorter option in expectation |
| e_geo_at_pause | number | **Geometric-mean** cards to the reward if staying at the offer, `exp(E[log cards])` over the same outcomes as `e_tot_at_pause` (winning card on an orange card ahead, or rest of the sequence + back over all of it + the alternative). Weighs the long no-winning-card outcome less than the arithmetic mean. The benchmark `altHypAdd` is calibrated on |
| switch_gain_geo_at_pause | number | `e_geo_at_pause` − (`pause` + `alt_duration`). > 0 ⇒ switching beats the geometric-mean cost of staying (~50% of offers by design) |

**How the expectations are computed.** All `e_rem_*` / `p_ahead_*` columns use the beliefs participants are given, and never depend on the regime (participants know nothing about regimes): the winning card is in the sequence with probability `p_inside` and, if it is, equally likely to be on any orange card; at a given point, the orange cards already passed without a win are ruled out (Bayes). With `W` orange cards, `k` cards done and `a` orange cards still ahead: P(no win so far) = 1 − (W − a)·p/W; `p_ahead` = (a·p/W) / P(no win so far); `e_rem` = [Σ over orange cards m > k of (p/W)(m − k) + (1 − p)(seq_len − k)] / P(no win so far).
| seq_frame_treatment | 4/5 | As in `Meta` |
| seq_is_bonus | 0/1 | 1 for the unannounced 5th sequence of respondents told "4" |

### Timing, outcome, decisions

| Column | Type | Description |
|---|---|---|
| start_at | timestamp | Sequence started |
| briefing_ended_at | timestamp | "Start sequence" pressed on the briefing screen |
| end_at | timestamp | Sequence ended |
| seq_reload_count | number | New-session returns while this sequence was current |
| outcome_summary | text | **The outcome** — see the table below |
| card_order | text | Main cards actually played, in order (`live_pattern` truncated to `n_main_tasks_done`) |
| alt_revealed | 0/1 | The alternative's length was shown (the pause happened, or a same-tab reload landed past the pause point) |

**The pause.** At card `pause` the task stops, the alternative's length is revealed, and its button turns blue and flashes. The pause ends when the participant switches (Alternative button → Confirm switch), presses **Resume now**, or its countdown runs out. All blank if the pause never happened.

| Column | Type | Description |
|---|---|---|
| pause_started_at_time | timestamp | When the pause started |
| pause_duration_secs | 10–45 | Its countdown (random) |
| pause_elapsed_secs | seconds | How long it actually lasted (start → end) |
| pause_outcome | text | How it ended: `switched` / `resume_now` / `timeout` |
| penalty_at_pause | £ | This sequence's mistake penalty when the pause started. The full per-card record is in `tasks_json` |

**Switching** is done only with the Alternative button (during the pause or at any later card of the main sequence), which opens a dialog: Confirm switch / Keep going.

| Column | Type | Description |
|---|---|---|
| switched | 0/1 | **Switched to the alternative** before the main sequence ended |
| switched_at_pause | 0/1 | 1 if that switch happened during the pause |
| switched_at | number | Main cards completed when switching (blank if no switch) |
| switched_at_time | timestamp | When the switch was confirmed |
| switch_pressed_at, switch_pressed_at_time | number, timestamp | The click on the Alternative button that led to the switch (opening the dialog) |
| switch_decision_secs | seconds | That click → Confirm switch |
| switch_dialog_opens | number | Times the switch dialog was opened in this sequence (during the pause and later) |
| switch_dialog_cancels | number | …and closed with "Keep going" |

**End of the main sequence without a winning card.** A "No winning card" screen asks the participant to choose: switch to the alternative (Alternative button) or give up.

| Column | Type | Description |
|---|---|---|
| no_winning_card | 0/1 | Reached the end of the main sequence without a winning card |
| no_winning_card_at_time | timestamp | When |
| alt_started | 0/1 | The alternative was started: after a switch, or chosen on the "No winning card" screen |
| alt_started_at_time | timestamp | When |
| alt_back | number | Main cards walked back over before the alternative (`switched_at`, or `seq_len` after no winning card). Blank if the main sequence was never left for the alternative. `n_alt_tasks_done` counts these plus the alternative's cards |

**Giving up / autokick.**

| Column | Type | Description |
|---|---|---|
| forfeited | 0/1 | Gave up the sequence |
| forfeited_in | text | `main` (main sequence) or `alt` (alternative, including the "No winning card" screen) |
| forfeited_at | number | Cards completed in that part when giving up |
| forfeited_at_time | timestamp | When |
| auto_kicked | 0/1 | Ended because the sequence's own mistake penalty reached its reward |

**Effort and earnings.**

| Column | Type | Description |
|---|---|---|
| n_main_tasks_done, n_alt_tasks_done, n_tasks_done | number | Cards completed in the main sequence, in the alternative, total |
| earnings | £ | Gross reward: `pay` if the winning card was found or the alternative completed, else 0 |
| grid_pay | £ | Per-card pay for this sequence |
| penalty | £ | Mistake penalty (£0.01 per misclick) |
| net_earnings | £ | This sequence's earnings − penalty, never negative. What is actually paid is `Meta.final_bonus` (penalties of unpaid sequences still count there) |
| total_targets, total_found, total_false_pos, total_missed | number | Grid accuracy, summed over the whole sequence |
| tasks_json | JSON | Every card played, main and alternative (see below) |
### Exit point and expected-duration benchmarks

The **exit point** is where the participant left the main sequence; `sunk_cost_at_exit` is the number of main cards **completed** at that moment. Switching while on card 2 → 1; finding the winning card on card 2 → 2.

| `exit_type` | How the main sequence was left | `sunk_cost_at_exit` |
|---|---|---|
| `switch` | Switched with the Alternative button (during the pause or later) | Main cards completed at the switch (= `switched_at`) |
| `winning_card` | Found the winning card | `n_main_tasks_done` (= `end_pos`) |
| `no_winning_card` | Reached the end without a winning card (then switched to the alternative, or gave up) | `seq_len` |
| `forfeit` | Gave up during the main sequence | Main cards completed |
| `autokick` | Penalty reached the reward during the main sequence | Main cards completed |

A forfeit or autokick *during the alternative* keeps the exit type of how the main sequence was left (`switch` or `no_winning_card`).

At a natural end the main sequence is over: `e_rem_at_exit = 0`, `p_ahead_at_exit = 0`, and `switch_gain_at_exit` is the realised comparison (`winning_card` → −(`end_pos` + `alt_duration`); `no_winning_card` → 0, since going back and the alternative had to be done anyway). For switch / forfeit / autokick they are the expectations at that point.

| Column | Type | Description |
|---|---|---|
| exit_type | text | See above |
| sunk_cost_at_exit | number | Main cards completed at the exit point |
| alt_available_at_exit | 0/1 | 1 if the alternative could be chosen at the exit point (`pause_never_shown = 0` and `sunk_cost_at_exit ≥ pause`). When 0, the `switch_*_at_exit` comparisons are counterfactual |
| p_ahead_at_exit | 0–1 | As `p_ahead_at_pause`, at the exit point |
| e_rem_at_exit | number | As `e_rem_at_pause`, at the exit point: expected main-sequence cards still to play |
| penalty_at_exit | £ | Mistake penalty from the main cards completed up to the exit point (including the last one) |
| switch_gain_at_pause | number | Expected cards saved by switching at the offer: [`e_rem_at_pause` + (1 − `p_ahead_at_pause`) × (`seq_len` + `alt_duration`)] − (`pause` + `alt_duration`). **> 0 ⇒ switching is better in expectation** (= −`alt_minus_expected`) |
| switch_better_at_pause | 0/1 | 1 iff `switch_gain_at_pause > 0` |
| switch_gain_at_exit | number | Same comparison at the exit point, with `e_rem_at_exit` and `p_ahead_at_exit`; switching there costs `sunk_cost_at_exit + alt_duration` |
| switch_better_at_exit | 0/1 | 1 iff `switch_gain_at_exit > 0` |

Reading them together: `switched = 1` with `switch_better_at_exit = 0` is a switch that costs cards in expectation. For sequences that ran to a natural end, `switch_*_at_exit` reflect the realised outcome, not a decision; the benchmark at any earlier position (e.g. before the last card played, `n_main_tasks_done − 1`) can be rebuilt from `live_pattern`, `p_inside` and `alt_duration` with the same formula.

### `outcome_summary`

| Label | Meaning |
|---|---|
| `found the winning card` | Stayed after the pause, found the winning card |
| `found the winning card before the pause` | The winning card came before the pause point (no pause; regime 3 only) |
| `switched at the pause` | Switched during the pause, completed the alternative |
| `switched after the pause` | Switched later with the Alternative button, completed the alternative |
| `no winning card, took the alternative` | No winning card; chose the alternative and completed it |
| `no winning card, gave up` | No winning card; gave up on the "No winning card" screen |
| `gave up before the pause` / `gave up after the pause` | Gave up during the main sequence |
| `auto-kicked before the pause` / `auto-kicked after the pause` | Penalty reached the reward during the main sequence |
| any of the three alternative labels + `, then gave up` / `, then auto-kicked` | Started the alternative, then gave up / was auto-kicked |
| `abandoned before reload — superseded by a later attempt` | Attempt discarded by a new-session reload |

**Data collected before 2026-10-07** used older column names (`switch_taken`, `offer_choice`, `auto_switched`, `forfeit_phase`, …) and labels. `tools/convert_to_current.R` converts them to the columns above (the mapping is at the top of that file); `tools/decrypt_backups.R` does it automatically for older backups. In that older data the pause had "Accept and switch" / "Refuse and stay" buttons: "Refuse and stay" is converted to `pause_outcome = resume_now`, and dialogs opened during the pause were not counted in `switch_dialog_opens`.
### `tasks_json` structure

```json
[
  { "grid_n": 1, "phase": "main", "target": "😊", "all_emojis": ["😊", "😅", "…"],
    "n_targets": 4, "n_found": 4, "n_false_pos": 0, "n_missed": 0,
    "no_activity": false, "first_move_at": "2026-10-01T10:01:23.456Z" }
]
```
`phase` is `main` or `alt`; `grid_n` counts within its phase. `no_activity` = no click/movement during that card.

---

## Reload/attempt tracking

A **new-session** return (tab closed, other device) mid-sequence restarts that sequence with a fresh draw, so nobody can reload to peek at how it plays out. If real progress had been made, the abandoned attempt gets its own row (`outcome_summary = 'abandoned before reload — …'`, `is_latest_attempt = 0`) and the replacement gets `seq_attempt + 1`. A same-tab refresh resumes exactly where it was; if it lands past the offer point, the offer counts as lapsed and the alternative is available from the button. Filter to `is_latest_attempt = 1` and this can be ignored.

## Autokick

A sequence ends the moment its own `penalty` reaches its own `pay` (`auto_kicked = 1`, `net_earnings = 0`), distinct from a voluntary forfeit.
