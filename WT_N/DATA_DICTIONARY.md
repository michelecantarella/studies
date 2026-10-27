# WT_L — Data Dictionary

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
| training_comp_check_q1_wrong, _q2_wrong, _q3_wrong | number | Wrong attempts on each comprehension question (0 = right first time). WT_K: Q1 how to earn the reward, Q2 what happens on switching, Q3 how the alternative works |
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
| seq_len | 30–35 (up to 40 for a worse deck) | Number of cards in the main sequence (all visible from the start) |
| live_pattern | text, e.g. `SLSSLL` | Card-by-card pattern: L = orange (can be a winning card), S = white |
| n_live | number | Orange cards in the pattern |
| p_inside | 0–1 | WT_L: same as p_all |
| p_quintile | 1–5 | Band `p_inside` was drawn from. WT_M bands (uniform over the listed values): 1 = 10, 15, 20, 25, 30, 35% · 2 = 40, 45% · 3 = 50% · 4 = 55, 60% · 5 = 65, 70, 75, 80, 85, 90% (each respondent gets each band once) |
| ends | 0/1 | 1 if the winning card is in the sequence |
| end_pos | number | Card number (1-indexed) of the winning card; blank if `ends = 0` |
| n_req | number | Main cards that would be played with no switch/forfeit: `end_pos`, or `seq_len` if there is no winning card |
| pause | number | Cards completed when the offer comes (0 = before the first card). WT_L: uniform on 0 … floor(¾ × floor(`seq_len`/2)), truncated before the third winning card in regime 1 |
| pause_never_shown | 0/1 | 1 if the winning card came at or before `pause`, so the pause never happened (only possible when `sub_regime = 3`) |
| offer_out_of_bounds | 0/1 | WT_N: 1 if the offer was dropped because its fair alternative was outside 4.7–26 cards (5th–95th percentiles); only in regime 3 (regimes 1–2 redraw such sequences) |
| alt_duration | number | Length of the alternative (cards). **What the participant sees and does** if they take it — during the pause, later via the button, or after reaching the end without a winning card |
| alt_global_end | number | `pause + alt_duration` = overall card count at which the alternative ends if taken the moment it's offered |
| alt_window_lo, alt_window_hi | number | Bounds of `alt_duration`: `h = seq_len − pause` and `round(h·√2)`. `alt_duration = round(h·(cos θ + sin θ))`, θ ~ U(0°, 90°): the sum of the legs of a right triangle with hypotenuse `h`. Same rule in WT_F and WT_G |
| active_passed_at_pause, inactive_passed_at_pause | number | Orange / white cards already completed at the offer (sum = `pause`) |
| active_left_at_pause, inactive_left_at_pause | number | Orange / white cards still ahead in the sequence at the offer |
| left_pattern, right_pattern | text | `live_pattern` split at `pause` (left = already done; right = from the next card on) |
| e_rem_at_start | number | **Expected length of the main sequence at its start**, in cards: what the participant can expect knowing `seq_len`, the pattern and `p_inside` |
| e_rem_at_pause | number | **Expected main-sequence cards still to play** at the offer, if they keep going (up to the winning card, or to the end if there is none) |
| p_ahead_at_pause | 0–1 | Probability the winning card is still ahead at the offer |
| alt_minus_expected | number | `alt_duration` − expected cards to the reward if staying at the offer (`e_rem_at_pause` + (1 − `p_ahead_at_pause`) × `alt_duration`, since without a winning card they still have to do the alternative). Negative = switching at the offer is the shorter option in expectation |
| e_geo_at_pause | number | **Geometric-mean** cards to the reward if staying at the offer, `exp(E[log cards])` over the same outcomes as `e_tot_at_pause` (winning card on an orange card ahead, or the rest of the sequence + the alternative). Weighs the long no-winning-card outcome less than the arithmetic mean |
| switch_gain_geo_at_pause | number | `e_geo_at_pause` − `alt_duration`. > 0 ⇒ switching beats the geometric-mean cost of staying |
| p_card | 0.01–0.33 | WT_L: h, the chance shown in each empty tracker box that that winning card is on an orange card (with r missing, an orange card is a winner w.p. r·h), multiple of 1%. Data before 2026-10-20: q, the chance that each orange card is a winning card (0.05–0.95) |
| p_all | 0–1 | WT_L: chance of at least three winning cards within the calibration window (`half_len` cards) given `p_card` and the window's actual orange cards |
| p_all_seq | 0–1 | WT_L: chance of at least three winning cards anywhere in the sequence |
| p_band | 0.10–0.90 | WT_L: band value `p_card` was set from |
| half_len | number | WT_L: cards in the calibration window (10, the first cards of the sequence; data collected before 2026-10-20: floor(`seq_len`/2)). WT_N: = `calib_window` (4–12), on the full sequence, the same in both versions of a pair |
| n_live_first_half | number | WT_L: orange cards in the calibration window (≥ 3: the window and the tail each get 3 at random positions, the rest follow the Beta shape) |
| orange_share | 0.35–0.50 (worse decks 0.20–0.32) | WT_L: share of the Beta overlay laid on top of the 3 + 3 minimum orange cards |
| shape_family, shape_params | text | WT_L: shape of the orange cards along the sequence (`uniform`, `mass1`, `mass2`, `mass3`: uniform base plus that many mass points; data before 2026-10-20 also `beta` etc.) and its parameters (centres in cards, spread). WT_N: `pareto`, with `rho=…,tau=…,alpha=…,drift=…,W=…` (the fitted decay, the survivor-weighted drift of the fair alternative in cards, the calibration window) |
| n_winners_in_seq | number | WT_L: winning cards in the whole sequence (each orange card independently w.p. `p_card`); the game ends at the third |
| winning_cards | text | WT_L: card numbers of ALL the sequence's winning cards; the sequence ends on the third (if there are three), else at its last card, which also earns the reward |
| deck_p_all_options | text | WT_L: `p_all` of each deck shown, in display order, `a\|b\|c` |
| deck_p_all_chosen | number | WT_L: the same for the deck played |
| deck_len_options | text | WT_L: cards in each deck shown, in display order |
| deck_e_start_options | text | As WT_K: expected main cards at the start of each deck shown (to the third winning card, or to the last card), in display order, `a\|b\|c` |
| deck_e_start_chosen | number | The same for the deck played |
| deck_live_options | text | WT_N: the cards of each deck shown before the sequence, in display order (`L` orange, `S` white), `|`-separated |
| deck_d1_options | text | WT_N: initial density of each deck shown, in display order (all share the assigned deck's decay shape) |
| deck_clicks | number | WT_N: clicks on the decks shown (0 with one deck) |
| deck_changes | number | WT_N: times the selection moved to a different deck |
| deck_choice_secs | s | WT_N: from the decks being shown to Start sequence |
| winners_found_at_pause | 0–2 | WT_K: winning cards already found when the offer came |
| winners_found_at_exit | 0–3 | WT_K: winning cards found when the main sequence was left (3 = finished) |
| alt_scenario | 0–2 | WT_K: winning cards found in the scenario the alternative was centred on (drawn at random, not the actual number) |
| alt_e_scenario | number | WT_K: expected cards to the third winning card in that scenario |
| n_decks | 1–3 | WT_K: decks shown before the sequence (drawn per sequence, each equally likely) |
| deck_default_pos | 1–3 | WT_K: display position of the default deck (the sequence's own band) |
| deck_chosen_pos | 1–3 | WT_K: display position of the deck played |
| chose_default | 0/1 | WT_K: the deck played was the default (always 1 with one deck) |

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
| pause_duration_secs | 10–30 | Its countdown (random) |
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
| locked_alt_clicks | number | WT_N: presses on Alternative cards while it was still locked (before the offer) |
| inactive_resume_clicks | number | WT_N: presses on Cards left outside the offer pause (when it is not a button) |
| pause_hidden_secs | s | WT_N: time with the tab hidden while the offer pause was open (blank if no offer) |
| seq_hidden_secs | s | WT_N: time with the tab hidden while this sequence was being played |

**End of the main sequence without three winning cards.** WT_L: the sequence is complete and the reward earned (`outcome_summary` = "reached the end without three winning cards", `exit_type` = `reached_end`); no alternative is forced.

| Column | Type | Description |
|---|---|---|
| no_winning_card | 0/1 | Reached the last card of the main sequence without three winning cards |
| no_winning_card_at_time | timestamp | When |
| alt_started | 0/1 | The alternative was started: after a switch, or chosen on the "No winning card" screen |
| alt_started_at_time | timestamp | When |

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
| earnings | £ | Gross reward: `pay` if the third winning card was found, the last card reached, or the alternative completed, else 0 |
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
| `winning_card` | Found the third winning card | `n_main_tasks_done` (= `end_pos`) |
| `reached_end` | WT_L: played the last card without three winning cards (reward earned) | `seq_len` |
| `no_winning_card` | Not used in WT_L (earlier builds: ran out and had to take the alternative) | `seq_len` |
| `forfeit` | Gave up during the main sequence | Main cards completed |
| `autokick` | Penalty reached the reward during the main sequence | Main cards completed |

A forfeit or autokick *during the alternative* keeps the exit type of how the main sequence was left (`switch` or `no_winning_card`).

At a natural end the main sequence is over: `e_rem_at_exit = 0`, `p_ahead_at_exit = 0`, and `switch_gain_at_exit` is the realised comparison (`winning_card` and `reached_end` → −`alt_duration`). For switch / forfeit / autokick they are the expectations at that point.

| Column | Type | Description |
|---|---|---|
| exit_type | text | See above |
| sunk_cost_at_exit | number | Main cards completed at the exit point |
| alt_available_at_exit | 0/1 | 1 if the alternative could be chosen at the exit point (`pause_never_shown = 0` and `sunk_cost_at_exit ≥ pause`). When 0, the `switch_*_at_exit` comparisons are counterfactual |
| p_ahead_at_exit | 0–1 | As `p_ahead_at_pause`, at the exit point |
| e_rem_at_exit | number | As `e_rem_at_pause`, at the exit point: expected main-sequence cards still to play |
| penalty_at_exit | £ | Mistake penalty from the main cards completed up to the exit point (including the last one) |
| switch_gain_at_pause | number | Expected cards saved by switching at the offer: [`e_rem_at_pause` + (1 − `p_ahead_at_pause`) × `alt_duration`] − `alt_duration`. **> 0 ⇒ switching is better in expectation** (= −`alt_minus_expected`) |
| switch_better_at_pause | 0/1 | 1 iff `switch_gain_at_pause > 0` |
| switch_gain_at_exit | number | Same comparison at the exit point, with `e_rem_at_exit` and `p_ahead_at_exit` (switching at any point means doing `alt_duration` cards) |
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

### WT_M/WT_N: winning cards, pairing (Responses columns)

The single-offer columns above (`pause`, `pause_*`, `alt_duration`, `alt_window_*`, `alt_minus_expected`, `e_*_at_pause`, `switch_*_at_pause`, `winners_found_at_pause`) refer to the **first shown offer**. WT_N has one offer. Reaching the last card without all the winning cards moves the participant onto the alternative (`no_winning_card` = 1, `exit_type` = `no_winning_card`); `e_tot_*` and `switch_gain_*` count the alternative owed then.

| Column | Type | Description |
|---|---|---|
| n_winners_seq | 1–3 | Winning cards in the design |
| n_winners_needed | 1–3 | Winning cards to find in the deck played (fewer than `n_winners_seq` if truncated after one was found) |
| n_boxes | 1–3 | Boxes shown in the tracker |
| prefilled | 0–2 | Boxes already filled at the start (`gift_shown`, plus winning cards found before the truncation point) |
| gift_shown | 0/1 | With 1–2 winning cards: the tracker shows 3 boxes, the extra ones already filled |
| d1 | 0.40–0.60 (WT_N: 0.85–0.95) | Orange chance in cards 1–10 (WT_N: of the first card, the initial density) |
| densities | text | WT_N: orange chance of each card, `d1|d2|…` (Pareto decay from the initial density, fitted so that the alternative stays equally attractive; see README) |
| design_redraws | number | WT_N: draws of this sequence rejected before the one played (regimes 1–2; regime 3 is never redrawn) |
| design_redraw_reasons | text | WT_N: why, as `out_of_bounds:n,certain:n,no_room:n` (fair alternative outside 4.7–26 / ending certain / last winning card on card 1, no room for an offer) |
| draw_debt_k | 0.75–1 | WT_N: the cards are drawn one by one, card t orange w.p. its density + k × (orange cards expected so far − drawn so far); k drawn per sequence |
| calib_window | 4–12 | WT_N: cards in the calibration window: `p_band` = chance that all the winning cards fall within it |
| p_card | 0.01–0.95 | h, the chance shown in each empty box (cap 0.95 / 0.50 / 0.33 with 1 / 2 / 3 winning cards) |
| p_all | 0–1 | Chance that all the winning cards fall within the first 10 cards, given h and their actual orange cards (≈ `p_band`). WT_N: within the calibration window (`calib_window` cards of the full sequence, `n_first_half` of them orange), the same in both versions of a pair |
| seed_id | text | The design shared by a pair (`Seeds` sheet) |
| seed_version | full / trunc | The version played: whole design, or cut at its first shown offer |
| seed_role | text | `pair` (completes a design from the pool), `new` (created it; the other version goes to the pool), `unpaired` (no shown offer, or offline), `released` (another deck was chosen: back to the pool) |
| trunc_offset | number | Cards removed at the start (`trunc`: the design's first offer point; `full`: 0). The same point in the full design is `offer_pos + trunc_offset` |

## Sheet: `Seeds` (WT_M: the pairing pool)

| Column | Description |
|---|---|
| seed_id, band, study_id | The design, its p_inside band (0–4) and study (pairs are only formed within a study id) |
| created_at, created_by | When and by whom it was generated |
| design_json | The design: deck pattern, h, number of winning cards, gift display, winning cards, offers with their alternatives |
| full_status / trunc_status | `open` / `claimed` / `done` for each version (a claim older than 3 hours counts as open) |
| full_pid, full_at / trunc_pid, trunc_at | Who claimed or played each version, and when |
## Reload/attempt tracking

A **new-session** return (tab closed, other device) mid-sequence restarts that sequence with a fresh draw, so nobody can reload to peek at how it plays out. If real progress had been made, the abandoned attempt gets its own row (`outcome_summary = 'abandoned before reload — …'`, `is_latest_attempt = 0`) and the replacement gets `seq_attempt + 1`. A same-tab refresh resumes exactly where it was; if it lands past the offer point, the offer counts as lapsed and the alternative is available from the button. Filter to `is_latest_attempt = 1` and this can be ignored.

## Autokick

A sequence ends the moment its own `penalty` reaches its own `pay` (`auto_kicked = 1`, `net_earnings = 0`), distinct from a voluntary forfeit.
