# WT_S — Data Dictionary

Three sheets: `Meta` (one row per respondent), `Responses` (one row per respondent × sequence × attempt), `Seeds` (the pool of quartets: every design played in four versions by four different participants).

**Join:** `Responses` → `Meta` on `prolific_pid`. **Filter `Responses` to `is_latest_attempt = 1`** (see Reload/attempt tracking).

Columns marked **£** hold a plain number (£ for Prolific, "Points" on screen for the unpaid versions). Columns not listed are as WT_P (`WT_P/DATA_DICTIONARY.md`).

## Sheet: `Meta`

| Column | Description |
|---|---|
| training_comp_check_q1_wrong, _q2_wrong, _q3_wrong | Wrong attempts on each comprehension question: Q1 how to earn the reward, Q2 what happens on switching, Q3 what keys are for (the main deck's cards only) |
| version_plan, seed_plan | The versions assigned to the five sequences, in order, separated by a vertical bar: the version, then `:extra<share>` with extra keys and `:choice` with a choice of decks; and their designs (`seed_id`) |

## Sheet: `Responses`

Card numbers count from 1 in the deck played. Four versions of each design (`seed_version`): **full** (x keys made before the offer), **mixed** (g keys gifted at the start, then m made: g + m at the offer, g and m drawn independently), **trunc** (the truncated deck, x/2 cards shorter, no keys, the offer at the start), **trunc_gift** (the full version with all its x keys gifted, none made, the offer at the start). Every key, made or gifted, comes with an extra white card in front of each covered pair (`seq_len`: the deck played), so the keys save nothing: all four face the same decision at the offer (`quartet_lab.html`).

### The design

| Column | Type | Description |
|---|---|---|
| seq_n, seq_attempt, is_latest_attempt | number | Sequence 1–5; attempt (bumped by a new-session reload); 1 on the latest attempt |
| pay | £ | The sequence's reward |
| seq_len, live_pattern, n_live, winning_card | — | The deck played (L = orange, S = white), its orange cards, the winning card |
| pause | number | Key cards made before the offer: full x, mixed m, trunc and trunc_gift 0 (the offer at the start) |
| keys_at_offer | number | The design's x (every version): the keys made in full (2, 4, 6, 8 or 10) |
| keys_gifted | number | Keys in hand at the start, shown as **Starting keys** on the briefing screen: mixed g, trunc_gift x, full and trunc 0 |
| keys_in_hand_at_offer | number | Keys in hand (cards covered) when the offer comes: full x, mixed g + m, trunc 0, trunc_gift x |
| design_gift, design_mix_made | number | The design's mixed version: g keys gifted (x × U(25%, 75%)) and m made (x × U(25%, 100%)), drawn independently, at least 1 each, g + m even (an extra white card for every two keys) and within the slots; the same for all four versions |
| alt_duration, alt_geo, alt_fair, alt_quad, alt_u, alt_good, alt_m | — | The alternative and how it was set. At the offer, three values where staying (switching allowed later) and switching break even, by the power mean of the cost of staying: geometric (`alt_geo`, the lower bound), arithmetic (`alt_fair`, the fair value) and quadratic (`alt_quad`, the upper bound). Half the designs (`alt_good` = 1, switching better) draw the alternative uniformly in the half of [geometric, fair] nearer the fair value, the other half in the half of [fair, quadratic] nearer it: fair ∓ `alt_u` × 0.5 × (fair − bound), `alt_u` in 0–1; `alt_m` = the value before rounding (rounded strictly on its side of the fair value) |
| switch_best_at_offer | 0/1 | Switching is the best move at the offer (= alt_good) |
| stay_cost_at_offer | number | The model at the offer: cards expected staying, switching allowed later (the best way). The same in all four versions of a design. Blank if the offer never came |
| effort_expected_at_offer | number | Cards expected to the winning card from the offer, never switching (the effort expected; as `expected` in `shape_params`) |
| switch_gain_at_offer | number | `stay_cost_at_offer` − `alt_duration`: cards saved by switching at the offer (> 0: switching better) |
| fair_at_offer | number | The fair alternative at the offer, from the state there: the length A at which staying (switching allowed later, the best way) costs A cards. Equals `alt_fair`. Blank if the offer never came |
| shape_params, densities | — | E, K, debtK, flat_mean, flat_dev, expected (the effort expected at the offer, then after each empty orange card, `/`-separated); each card's chance of being orange (0 for the extra white cards in the first x) |
| design_redraws, design_gen | — | Decks drawn before this one; `S2` (quartets, with `design_gift`; `S1` before) |
| seed_id, seed_version, seed_role | — | The design shared by the quartet (2026-11-05): `trunc` (baseline: the truncated deck, no keys, one deck), `full` (x keys made; with chance 20% extra keys gifted), `mixed` (keys gifted and made: `design_gift`, `design_mix_made`), `trunc_gift` (x keys gifted; with chance 20% extra keys to make); `pair` (completes a design from the pool) / `new` (created it: its other versions go to the pool) / `unpaired` |
| treat_extra, treat_choice | — | The treated versions' draws: the extra keys' share of x in `full` and `trunc_gift`, Beta(0.5, 0.5), at least 1 key (blank: no extra keys, 80%); a choice of 2 or 3 decks (0/1, 50/50; 0 in `trunc`). The keys actually made and gifted: `pause` and `keys_gifted` (their sum made even and within the deck) |
| keys_version | text | The keys actually there: `full` (made only), `mixed` (made and gifted), `trunc_gift` (gifted only), `trunc` (none) |
| n_decks, deck_default_pos, deck_chosen_pos, chose_default, deck_live_options, deck_clicks, deck_changes, deck_choice_secs | — | The deck choice (`treat_choice` = 1: 2 or 3 decks, equally likely; else 1; n_decks > 1 = a choice was shown). The default is the first design claimed for the sequence; all decks shown are valid designs in this version |
| deck_seed_options, deck_new_options | text | The designs shown as decks, in display order (`seed_id`), and whether each was new (1) or from the pool (0) |

### The sequence

| Column | Type | Description |
|---|---|---|
| card_order | text | The main cards played, in order: `P` a key before the offer, `K` a key card after it (chosen, or automatic when unlocking with none left), `C<n>` card n unlocked |
| alt_revealed | 0/1 | The offer came |
| pause_*, penalty_at_pause | — | The offer's pause. `pause_outcome`: `unlock` (the cards bar clicked), `keys` (the keys bar clicked), `timeout` (the countdown ran out: making keys), `switched` |
| mode_changes, mode_log | — | After the offer: clicks changing the mode (the cards bar: unlocking; the keys bar: making keys), each taking effect at once; after a change the mode is locked until the next card is completed. `mode_log` = main cards completed at the click `:` the mode chosen, `!` if the card running was dropped, `|`-separated |
| cards_dropped | number | Cards dropped unfinished (and unpaid) by a change of mode; a card being unlocked gives its key back. The automatic key card (no key left) is kept when switching to keys, and a key card is kept when switching to unlocking with no key in hand |
| switched, switched_at_pause, switched_at, switched_at_time | — | Switched; during the pause; main cards played then; when |
| exit_type | text | `winning_card`, `switch`, `forfeit`, `autokick` |
| sunk_cost_at_exit | number | Main cards played (keys included) when the main sequence was left |
| unlocked_at_exit | number | Cards unlocked then (the one being unlocked included) |
| stay_cost_at_exit, switch_best_at_exit, best_move_at_exit | — | The model there: effort expected staying (the best way); switching best; the best move (`switch`, `card`, `key`). Blank if the winning card was found or before the offer |
| fair_at_exit | number | The fair alternative where the main deck was left (as `fair_at_offer`, from the state there). Blank if the winning card was found or before the offer |
| switch_gain_at_exit | number | `stay_cost_at_exit` − `alt_duration`: cards saved by switching there (> 0: switching better). Blank as `fair_at_exit` |
| steps_after_offer, steps_switch_best | number | Main cards played after the offer; before how many switching was best |

### Keys (WT_S)

From the offer on (2026-11-05) the participant chooses between unlocking the cards and making keys (the cards bar or the keys bar), at the offer and at any later point (from the next card); the offer's countdown running out makes keys. Unlocking with no key left makes one first, automatically. Making keys while a key is already in hand is inefficient: the key saves nothing and unlocking was possible.

| Column | Type | Description |
|---|---|---|
| keys_made_pre | number | Keys made before the offer (full x, mixed m, trunc and trunc_gift 0) |
| keys_made_after, keys_made_chosen | number | Key cards after the offer; of which chosen (the rest automatic: unlocking, none left) |
| keys_inefficient, keys_inefficient_secs | number | Keys made by choice after the offer with a key already in hand (an unlock was available), and their seconds |
| keys_inefficient_orange, keys_inefficient_orange_secs | number | Of these, those where the next card to unlock was orange, and their seconds |
| keys_at_exit | number | Keys in hand when the main sequence was left (made or gifted, for nothing) |
| keys_pre_secs, keys_post_secs, cards_post_secs, alt_secs | number | Seconds on each deck: key cards before the offer, key cards after it, cards unlocked, the alternative. Sum of the cards' own times (`tasks_json` `started_at` → `submitted_at`): the offer's pause and the dialogs are not included |
| tasks_json, tasks_json_2 … _4 | JSON | Every card played (below). A sheet cell holds at most 50,000 characters: the JSON is split over these columns, 45,000 characters each; join them in order before parsing. (Meta's `resume_snapshot_json` … `_8` likewise.) |

### `tasks_json`

As WT_P, plus for main cards: `step` (`key_pre` a key before the offer, `key` a key after it, `card` a card unlocked), `card` (its number), `keys` (keys in hand when it started; a card: after using its key), `mode` (after the offer: `cards` or `keys`), `key_auto` (a key after the offer: 1 automatic, 0 chosen), `unlock_ready` / `orange_ready` (a chosen key with a key already in hand / and the next card orange), `is_winner`, and after the offer `best_move` (the model's best move before this card: `switch`, `card` with a key in hand, `key` with none), `switch_best` (1 = switching was best), `stay_cost` (effort expected staying); `started_at`, `submitted_at` (when the card started and was submitted). Every decision point after the offer is a card here: switching before it (`best_move`, `stay_cost`, `keys`) and its time, so a table with one row per decision can always be rebuilt from `tasks_json` with `switched_at`.

## Sheet: `Seeds`

One row per design; for each version (`full`, `mixed`, `trunc`, `trunc_gift`) its status (`open` / `claimed` / `done`), participant and time (`<version>_status`, `_pid`, `_at`). A participant is never given two versions of the same design, nor two designs with the same partner. `design_json` is the WT_S design (`drawSequence` in `index.html`: the deck, x, the alternative and how it was set, plus `gift`).

## Reload/attempt tracking

As WT_P. A same-tab reload during the offer's pause counts it as lapsed: the participant goes on unlocking, and the alternative stays available from its bar.
