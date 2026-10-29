# WT_N — analysis notes (pairs)

Working notes, 2026-10-29. Not the pre-analysis plan (that is PREREGISTRATION.md, Part II); this is the minimal setup to start from.

## Minimal pair equation

```
Switch_ik = α_k + β · Full_ik + ε_ik
```

- *i* participant, *k* pair (the sequence played in two versions, `seed_id`).
- `Switch_ik` = 1 if the participant switches at the offer (`switched_at_pause`).
- `Full_ik` = 1 for the full version (`seed_version` = full), 0 for the truncated one.
- `α_k` = pair fixed effect: absorbs everything the two versions share at the offer (cards ahead, winning cards still missing, chance per box, alternative).

With two observations per pair, β = average over pairs of (switch of the full player − switch of the truncated player): the effect of the whole bundle of sunk costs (cards completed, orange cards without a winning card, winning cards found), holding everything ahead exactly fixed. Forward-looking participants: β = 0; sunk costs that hold people back: β < 0.

Sample: complete pairs only — drop `seed_role` = released (another deck was chosen) and sequences whose other version was never played. Standard errors two-way clustered by participant and pair.

```r
library(fixest)
feols(switched_at_pause ~ full | seed_id,
      data = subset(resp, seed_role != "released" & paired),
      cluster = ~ prolific_pid + seed_id)
```

Stata: `reghdfe switched full, absorb(seed_id) vce(cluster pid seed_id)`.

## Intensity of the sunk cost

Separate the pair fixed effect from how much sunk cost there is:

```
Switch_ik = α_k + β_E · Done_ik + ε_ik
```

`Done` = cards completed at the offer (`pause` in the full version; 0 in the truncated one). Since the offer comes after 1–10 cards, β_E is the effect of each extra card already spent. Next step: split `Done` into orange cards without a winning card, white cards and winning cards found (Family A of the prereg).

## Deck choice as part of the sunk cost (from 2026-10-29)

Only the full version is preceded by a deck choice, so the full player also carries the choice made before the sequence. Only sequences whose full player kept the assigned deck are paired (a worse deck is played unpaired). Split β:

```
Switch_ik = α_k + β · Full_ik + γ · Full_ik × Choice_ik + ε_ik
```

- `Choice` = the full player saw 2–3 decks (`n_decks` > 1) and kept the assigned one; β is then the effect of the sunk cost with no choice.
- Selection: full players who pick a worse deck leave the pairs; report how many, and compare their switching (unpaired) with the others'.
- Robustness: drop the first 8 participants (truncated rows with `n_decks` > 1).

```r
feols(switched_at_pause ~ full + full:I(n_decks > 1) | seed_id,
      data = subset(resp, seed_role != "released" & paired),
      cluster = ~ prolific_pid + seed_id)
```

## First pilot look (2026-10-28, 10 participants, 36 offers — noise, not results)

- Switching at the offer 31%; nobody switched after the pause; 25% of pauses ran out on the timer.
- Full 36% vs truncated 27%; in 10 complete pairs: 3 only-full switch, 3 only-truncated switch, 4 neither → β = 0.
- Switching did not track the expected gain (25% when better, 35% when worse): the alternative is set at the fair value ±15%, so the gain varies by only about ±1 card. If this persists in the 50-person pilot, widen the variation (e.g. ±30–40%) before the main study, so that A1 (response to what lies ahead) can be estimated.
