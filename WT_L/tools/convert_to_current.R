## WT_F — bring Responses data recorded with older column names (before the
## pause redesign, 2026-10-07) to the current columns (backend.txt), and
## recompute the participant-perspective benchmarks with the current formulas.
##
##   source("convert_to_current.R"); d <- convert_responses_to_current(d)
##
## Used by decrypt_backups.R (older backups) and, when run as a script, it
## converts a downloaded study sheet:
##   Rscript convert_to_current.R [IN_XLSX] [OUT_XLSX]
## Default IN_XLSX: the most recent Responses_WT_F*.xlsx in Downloads;
## default OUT_XLSX: <IN>_current.xlsx next to it. Meta is copied unchanged.
##
## Old → new (meaning in DATA_DICTIONARY.md):
##   offer_wasted → pause_never_shown
##   switch_offered_at_time → pause_started_at_time   (switch_offered_at_task dropped: = pause)
##   pause_secs → pause_duration_secs;  deliberation_secs → pause_elapsed_secs
##   offer_choice + auto_refused → pause_outcome (switched / resume_now / timeout)
##     (old "Refuse and stay" = resume_now; offer_undo_count / auto_confirmed dropped)
##   switch_taken → switched;  switch_source = offer → switched_at_pause = 1
##   switch_taken_at_task → switched_at;  switch_taken_at_time → switched_at_time
##   switch_pressed_at_task → switch_pressed_at
##   alt_button_opens / alt_button_undos → switch_dialog_opens / switch_dialog_cancels
##     (old data: dialogs opened AFTER the offer only)
##   auto_switched → no_winning_card;  auto_switch_at_time → no_winning_card_at_time
##   alt_phase_started_at → alt_started_at_time (+ alt_started)
##   forfeit_taken → forfeited;  forfeit_phase → forfeited_in;  forfeit_taken_at_time → forfeited_at_time
##   seq_start_at_time dropped (= start_at);  outcome_summary relabelled.

suppressMessages({ library(jsonlite) })

OLD_RESP_COLS <- c("offer_wasted", "seq_start_at_time", "switch_offered_at_task", "switch_offered_at_time",
  "pause_secs", "deliberation_secs", "offer_choice", "offer_undo_count", "auto_refused", "auto_confirmed",
  "switch_taken", "switch_source", "switch_taken_at_task", "switch_taken_at_time", "switch_pressed_at_task",
  "alt_button_opens", "alt_button_undos", "auto_switched", "auto_switch_at_time", "alt_phase_started_at",
  "forfeit_taken", "forfeit_phase", "forfeit_taken_at_task", "forfeit_taken_at_time")

.num <- function(x) suppressWarnings(as.numeric(x))
.blank <- function(x) is.na(x) | as.character(x) == ""

relabel_outcome <- function(o, alt_started) {
  base_map <- c("switched at offer" = "switched at the pause",
                "switched later via button" = "switched after the pause",
                "auto-switched (no winning card)" = "no winning card, took the alternative")
  plain <- c("continued and found the winning card" = "found the winning card",
             "found the winning card before the offer" = "found the winning card before the pause",
             "continued and forfeited" = "gave up after the pause",
             "forfeited before offer" = "gave up before the pause",
             "continued and auto-kicked" = "auto-kicked after the pause",
             "auto-kicked before offer" = "auto-kicked before the pause")
  out <- o
  for (i in seq_along(o)) {
    x <- o[i]; if (is.na(x)) next
    if (x %in% names(plain)) { out[i] <- plain[[x]]; next }
    if (x %in% names(base_map)) { out[i] <- base_map[[x]]; next }
    m <- regmatches(x, regexec("^(.*) and (forfeited|auto-kicked)$", x))[[1]]
    if (length(m) == 3 && m[2] %in% names(base_map)) {
      if (m[2] == "auto-switched (no winning card)" && m[3] == "forfeited" && !alt_started[i]) out[i] <- "no winning card, gave up"
      else out[i] <- paste0(base_map[[m[2]]], ", then ", if (m[3] == "forfeited") "gave up" else "auto-kicked")
    }
  }
  out
}

## Benchmarks (same formulas as index.html's eRemaining_/pAhead_/stayCost_):
## beliefs participants are given, never the regime.
.orange <- function(pat) which(strsplit(pat, "")[[1]] == "L")
.e_rem <- function(L, pat, p, lp) { o <- .orange(pat); W <- length(o); a <- o[o > lp]
  s <- 1 - (W - length(a)) * p / W; if (s <= 0) return(L - lp); (sum(p / W * (a - lp)) + (1 - p) * (L - lp)) / s }
.p_ahead <- function(pat, p, lp) { o <- .orange(pat); W <- length(o); a <- sum(o > lp)
  s <- 1 - (W - a) * p / W; if (s <= 0) 0 else (p * a / W) / s }
.stay <- function(L, pat, p, lp, alt) .e_rem(L, pat, p, lp) + (1 - .p_ahead(pat, p, lp)) * alt

convert_responses_to_current <- function(d) {
  if (!nrow(d)) return(d)
  if ("switch_taken" %in% names(d)) {
    g <- function(c) if (c %in% names(d)) d[[c]] else rep(NA, nrow(d))
    fired <- !.blank(g("switch_offered_at_time"))
    d$pause_never_shown     <- g("offer_wasted")
    d$pause_started_at_time <- g("switch_offered_at_time")
    d$pause_duration_secs   <- g("pause_secs")
    d$pause_elapsed_secs    <- g("deliberation_secs")
    d$pause_outcome <- ifelse(!fired, NA, ifelse(g("offer_choice") %in% "accept", "switched",
                         ifelse(.num(g("auto_refused")) %in% 1, "timeout", "resume_now")))
    d$switched          <- .num(g("switch_taken"))
    d$switched_at_pause <- as.integer(d$switched %in% 1 & g("switch_source") %in% "offer")
    if (!"switched_at" %in% names(d) || all(.blank(d$switched_at))) d$switched_at <- g("switch_taken_at_task")
    d$switched_at_time      <- g("switch_taken_at_time")
    d$switch_pressed_at     <- g("switch_pressed_at_task")
    d$switch_dialog_opens   <- g("alt_button_opens")
    d$switch_dialog_cancels <- g("alt_button_undos")
    d$no_winning_card         <- .num(g("auto_switched"))
    d$no_winning_card_at_time <- g("auto_switch_at_time")
    gave_up_on_screen <- d$no_winning_card %in% 1 & !(d$switched %in% 1) & g("forfeit_phase") %in% "alt" & .num(g("n_alt_tasks_done")) %in% 0
    d$alt_started_at_time <- ifelse(gave_up_on_screen, NA, g("alt_phase_started_at"))
    d$alt_started         <- as.integer(!.blank(d$alt_started_at_time))
    d$forfeited         <- .num(g("forfeit_taken"))
    d$forfeited_in      <- ifelse(d$forfeited %in% 1, g("forfeit_phase"), NA)
    if (!"forfeited_at" %in% names(d) || all(.blank(d$forfeited_at)))
      d$forfeited_at <- ifelse(d$forfeited %in% 1, ifelse(d$forfeited_in %in% "alt", .num(g("n_alt_tasks_done")), .num(g("n_main_tasks_done"))), NA)
    d$forfeited_at_time <- g("forfeit_taken_at_time")
    ab <- grepl("^abandoned", d$outcome_summary)
    d$outcome_summary <- ifelse(ab, d$outcome_summary, relabel_outcome(d$outcome_summary, d$alt_started %in% 1))
    # abandoned attempts: no decision fields
    for (c in c("switched", "switched_at_pause", "no_winning_card", "alt_started", "forfeited")) d[[c]][ab] <- NA
    d <- d[, setdiff(names(d), OLD_RESP_COLS), drop = FALSE]
  }
  ## Benchmarks, recomputed (idempotent)
  for (i in seq_len(nrow(d))) {
    L <- .num(d$seq_len[i]); pat <- d$live_pattern[i]; p <- .num(d$p_inside[i])
    pause <- .num(d$pause[i]); alt <- .num(d$alt_duration[i])
    if (anyNA(c(L, p, pause, alt)) || is.na(pat)) next
    sc <- .stay(L, pat, p, pause, alt)
    d$e_rem_at_start[i] <- round(.e_rem(L, pat, p, 0), 3)
    d$e_rem_at_pause[i] <- round(.e_rem(L, pat, p, pause), 3)
    d$p_ahead_at_pause[i] <- round(.p_ahead(pat, p, pause), 3)
    d$alt_minus_expected[i] <- round(alt - sc, 3)
    if ("switch_gain_at_pause" %in% names(d)) { d$switch_gain_at_pause[i] <- round(sc - alt, 3); d$switch_better_at_pause[i] <- as.integer(sc - alt > 0) }
    if ("exit_type" %in% names(d) && !is.na(d$exit_type[i])) {
      et <- d$exit_type[i]; pos <- .num(d$sunk_cost_at_exit[i]); nat <- et %in% c("winning_card", "no_winning_card")
      if (!is.na(pos)) {
        d$e_rem_at_exit[i]   <- if (nat) 0 else round(.e_rem(L, pat, p, pos), 3)
        d$p_ahead_at_exit[i] <- if (nat) 0 else round(.p_ahead(pat, p, pos), 3)
        sx <- if (et == "winning_card") 0 else if (et == "no_winning_card") alt else .stay(L, pat, p, pos, alt)
        d$switch_gain_at_exit[i] <- round(sx - alt, 3); d$switch_better_at_exit[i] <- as.integer(sx - alt > 0)
      }
    }
  }
  d
}

## ── As a script: convert a downloaded study sheet ───────────────────────
if (sys.nframe() == 0L) {
  suppressMessages({ library(readxl); library(openxlsx) })
  args <- commandArgs(trailingOnly = TRUE)
  IN <- if (length(args) >= 1) args[1] else {
    f <- list.files("C:/Users/mkliv/Downloads", pattern = "^Responses_WT_F.*\\.xlsx$", full.names = TRUE)
    f <- f[!grepl("_(fixed|current)\\.xlsx$", f)]
    f[which.max(file.mtime(f))]
  }
  OUT <- if (length(args) >= 2) args[2] else sub("\\.xlsx$", "_current.xlsx", IN)
  script_dir <- dirname(normalizePath(sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))))
  be <- readLines(file.path(script_dir, "..", "backend.txt"), encoding = "UTF-8", warn = FALSE)
  s <- grep("^var RESP_HEADER = \\[", be); e <- s + which(grepl("^\\];", be[(s + 1):length(be)]))[1]
  RESP_COLS <- gsub("'", "", unlist(regmatches(gsub("//.*$", "", be[s:e]), gregexpr("'[^']+'", gsub("//.*$", "", be[s:e])))))

  meta <- read_excel(IN, sheet = "Meta", col_types = "text")
  resp <- as.data.frame(read_excel(IN, sheet = "Responses", col_types = "text"), stringsAsFactors = FALSE)
  out  <- convert_responses_to_current(resp)
  missing <- setdiff(RESP_COLS, names(out)); for (m in missing) out[[m]] <- NA
  extra <- setdiff(names(out), RESP_COLS)
  out <- out[, RESP_COLS]
  for (cn in setdiff(RESP_COLS, c("prolific_pid", "study_id", "session_id"))) out[[cn]] <- type.convert(out[[cn]], as.is = TRUE)
  meta <- as.data.frame(meta, stringsAsFactors = FALSE)
  for (cn in setdiff(names(meta), c("prolific_pid", "study_id", "session_id"))) meta[[cn]] <- type.convert(meta[[cn]], as.is = TRUE)

  wb <- createWorkbook()
  addWorksheet(wb, "Meta");      writeData(wb, "Meta", meta)
  addWorksheet(wb, "Responses"); writeData(wb, "Responses", out)
  saveWorkbook(wb, OUT, overwrite = TRUE)
  cat("In: ", IN, "\nOut:", OUT, "\nRows:", nrow(out), "| columns:", ncol(out),
      "| filled with blanks (not in old data):", if (length(missing)) paste(missing, collapse = ", ") else "none",
      "| dropped:", if (length(extra)) paste(extra, collapse = ", ") else "none", "\n")
  print(table(out$outcome_summary, useNA = "ifany"))
  print(table(pause_outcome = out$pause_outcome, switched_at_pause = out$switched_at_pause, useNA = "ifany"))
}
