# WT_S — Data Dictionary

Three sheets: `Meta` (one row per respondent), `Responses` (one row per respondent × sequence × attempt), `Seeds` (the pool of quartets: every design played in four versions by four different participants).

**Join:** `Responses` → `Meta` on `prolific_pid`. **Filter `Responses` to `is_latest_attempt = 1`** (see Reload/attempt tracking).

Columns marked **£** hold a plain number (£ for Prolific, "Points" on screen for the unpaid versions). Columns not listed are as WT_P (`WT_P/DATA_DICTIONARY.md`).

## Sheet: `Meta`

| Column | Description |
|---|---|
| training_comp_check_q1_wrong, _q2_wrong, _q3_wrong | Wrong attempts on each comprehension question: Q1 how to earn the reward, Q2 what happens on switching, Q3 what keys are for (the main deck's cards only) |
| version_plan, seed_plan | The versions assigned to the five sequences, in order (`full` / `full_gift` / `trunc` / `trunc_gift`, separated by a vertical bar), and their designs (`seed_id`) |

## Sheet: `Responses`

Card numbers count from 1 in the deck played. Four versions of each design (`seed_version`): **full** (x keys made before the offer), **full_gift** (g keys gifted at the start, then the x made: x + g at the offer), **trunc** (the truncated deck, x/2 cards shorter, no keys, the offer at the start), **trunc_gift** (g keys gifted, the offer at the start). Every key, made or gifted, comes with an extra white card in front of each covered pair (`seq_len`: the deck played), so the keys save nothing: all four face the same decision at the offer (`quartet_lab.html`).

### The design

| Column | Type | Description |
|---|---|---|
| seq_n, seq_attempt, is_latest_attempt | number | Sequence 1–5; attempt (bumped by a new-session reload); 1 on the latest attempt |
| pay | £ | The sequence's reward |
| seq_len, live_pattern, n_live, winning_card | — | The deck played (L = orange, S = white), its orange cards, the winning card |
| pause | number | Key cards made before the offer: x in full and full_gift, 0 in trunc and trunc_gift (the offer at the start) |
| keys_at_offer | number | The design's x (every version): the keys made in full and full_gift (2, 4, 6, 8 or 10) |
| keys_gifted | number | Keys in hand at the start, shown as **Starting keys** on the briefing screen: g in full_gift and trunc_gift, 0 in full and trunc |
| keys_in_hand_at_offer | number | Keys in hand (cards covered) when the offer comes: full x, full_gift x + g, trunc 0, trunc_gift g |
| design_gift | number | The design's g (both gift versions): even (an extra white card for every two keys), x × U(25%, 75%), at least 2, no more than the slots allow; the same for all four versions |
| alt_duration, alt_geo, alt_fair, alt_quad, alt_u, alt_good, alt_m | — | The alternative and how it was set. At the offer, three values where staying (switching allowed later) and switching break even, by the power mean of the cost of staying: geometric (`alt_geo`, the lower bound), arithmetic (`alt_fair`, the fair value) and quadratic (`alt_quad`, the upper bound). Half the designs (`alt_good` = 1, switching better) draw the alternative uniformly in the half of [geometric, fair] nearer the fair value, the other half in the half of [fair, quadratic] nearer it: fair ∓ `alt_u` × 0.5 × (fair − bound), `alt_u` in 0–1; `alt_m` = the value before rounding (rounded strictly on its side of the fair value) |
| switch_best_at_offer | 0/1 | Switching is the best move at the offer (= alt_good) |
| stay_cost_at_offer | number | The model at the offer: cards expected staying, switching allowed later (the best way). The same in all four versions of a design. Blank if the offer never came |
| effort_expected_at_offer | number | Cards expected to the winning card from the offer, never switching (the effort expected; as `expected` in `shape_params`) |
| switch_gain_at_offer | number | `stay_cost_at_offer` − `alt_duration`: cards saved by switching at the offer (> 0: switching better) |
| shape_params, densities | — | E, K, debtK, flat_mean, flat_dev, expected (the effort expected at the offer, then after each empty orange card, `/`-separated); each card's chance of being orange (0 for the extra white cards in the first x) |
| design_redraws, design_gen | — | Decks drawn before this one; `S2` (quartets, with `design_gift`; `S1` before) |
| seed_id, seed_version, seed_role | — | The design shared by the quartet; `full` / `full_gift` / `trunc` / `trunc_gift`; `pair` (completes a design from the pool) / `new` (created it: its other three versions go to the pool) / `unpaired` |
| n_decks, deck_default_pos, deck_chosen_pos, chose_default, deck_live_options, deck_clicks, deck_changes, deck_choice_secs | — | The deck choice, in every version: 1 deck in half the sequences, else 2 or 3 (n_decks > 1 = a choice was shown). The default is the first design claimed for the sequence; all decks shown are valid designs in this version |
| deck_seed_options, deck_new_options | text | The designs shown as decks, in display order (`seed_id`), and whether each was new (1) or from the pool (0) |

### The sequence

| Column | Type | Description |
|---|---|---|
| card_order | text | The main cards played, in order: `P` a key before the offer, `K` a key card after it (none left: played automatically), `C<n>` card n unlocked |
| alt_revealed | 0/1 | The offer came |
| pause_*, penalty_at_pause | — | The offer's pause. `pause_outcome`: `unlock` (the cards bar clicked), `timeout` (the countdown ran out: unlocking too), `switched` |
| switched, switched_at_pause, switched_at, switched_at_time | — | Switched; during the pause; main cards played then; when |
| exit_type | text | `winning_card`, `switch`, `forfeit`, `autokick` |
| sunk_cost_at_exit | number | Main cards played (keys included) when the main sequence was left |
| unlocked_at_exit | number | Cards unlocked then (the one being unlocked included) |
| stay_cost_at_exit, switch_best_at_exit, best_move_at_exit | — | The model there: effort expected staying (the best way); switching best; the best move (`switch`, `card`, `key`). Blank if the winning card was found or before the offer |
| steps_after_offer, steps_switch_best | number | Main cards played after the offer; before how many switching was best |

### Keys (WT_S)

After the offer the only choice is switching: the cards are unlocked in order, and a card with no key left gets a key card first, played automatically (the efficient path, the only one).

| Column | Type | Description |
|---|---|---|
| keys_made_pre | number | Keys made before the offer (x in full and full_gift, 0 in trunc and trunc_gift) |
| keys_made_after | number | Key cards after the offer (automatic, none being left) |
| keys_at_exit | number | Keys in hand when the main sequence was left (made or gifted, for nothing) |
| keys_pre_secs, keys_post_secs, cards_post_secs, alt_secs | number | Seconds on each deck: key cards before the offer, key cards after it, cards unlocked, the alternative. Sum of the cards' own times (`tasks_json` `started_at` → `submitted_at`): the offer's pause and the dialogs are not included |
| tasks_json | JSON | Every card played (below) |

### `tasks_json`

As WT_P, plus for main cards: `step` (`key_pre` a key before the offer, `key` a key after it, `card` a card unlocked), `card` (its number), `keys` (keys in hand when it started; a card: after using its key), `mode` (`cards` after the offer), `is_winner`, and after the offer `best_move` (the model's best move before this card: `switch`, `card` with a key in hand, `key` with none), `switch_best` (1 = switching was best), `stay_cost` (effort expected staying); `started_at`, `submitted_at` (when the card started and was submitted). Every decision point after the offer is a card here: switching before it (`best_move`, `stay_cost`, `keys`) and its time, so a table with one row per decision can always be rebuilt from `tasks_json` with `switched_at`.

## Sheet: `Seeds`

One row per design; for each version (`full`, `full_gift`, `trunc`, `trunc_gift`) its status (`open` / `claimed` / `done`), participant and time (`<version>_status`, `_pid`, `_at`). A participant is never given two versions of the same design, nor two designs with the same partner. `design_json` is the WT_S design (`drawSequence` in `index.html`: the deck, x, the alternative and how it was set, plus `gift`).

## Reload/attempt tracking

As WT_P. A same-tab reload during the offer's pause counts it as lapsed: the participant goes on unlocking, and the alternative stays available from its bar.
