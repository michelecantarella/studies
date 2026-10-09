## WT_G — decrypt participants' backup files and convert them to the
## Meta / Responses Excel layout of the study sheet.
##
## When the final save can't be confirmed, the results screen lets the
## participant download (or copy) an ENCRYPTED backup of their responses
## (index.html, encryptBackup_()). This script:
##   1. finds every backup in IN_DIR — downloaded files (*.enc.json) or
##      copied text saved as .txt/.json — and also older unencrypted
##      backups (wt_study_backup_<pid>.json);
##   2. decrypts them with the private key (RSA-OAEP + AES-256-GCM) and saves
##      the plain JSON next to each file (<name>.decrypted.json);
##   3. writes one Excel file with sheets Meta and Responses, with exactly the
##      columns, in the same order, as the study sheet (read from
##      ../backend.txt), plus a Backups sheet with consistency checks.
##
## Usage (from R or a terminal):
##   Rscript decrypt_backups.R [IN_DIR] [OUT_XLSX]
## Defaults: IN_DIR = Downloads; OUT_XLSX = IN_DIR/WT_G_backups_<timestamp>.xlsx.
## The private key path can be overridden with the WT_G_BACKUP_KEY env var.
## WT_G uses the same key pair as WT_F (same public key in index.html).
## The private key must NEVER be put in the study folder or published.

suppressMessages({ library(openssl); library(jsonlite); library(openxlsx) })

KEY_FILE <- Sys.getenv("WT_G_BACKUP_KEY",
  "C:/Users/mkliv/Desktop/Research/DATA/WastedTime/keys/WT_F_backup_private.pem")

args   <- commandArgs(trailingOnly = TRUE)
IN_DIR <- if (length(args) >= 1) args[1] else "C:/Users/mkliv/Downloads"
OUT    <- if (length(args) >= 2) args[2] else
  file.path(IN_DIR, paste0("WT_G_backups_", format(Sys.time(), "%Y%m%d_%H%M"), ".xlsx"))

# backend.txt sits one folder up from this script
script_dir <- local({
  f <- sub("^--file=", "", grep("^--file=", commandArgs(FALSE), value = TRUE))
  if (length(f)) dirname(normalizePath(f)) else
    "C:/Users/mkliv/Desktop/Research/Projects/WastedTime2026/experiment/WT_G/tools"
})
BACKEND <- file.path(script_dir, "..", "backend.txt")

## ── Column order, straight from the backend ──────────────────────────
read_header <- function(name) {
  be <- readLines(BACKEND, encoding = "UTF-8", warn = FALSE)
  s  <- grep(paste0("^var ", name, " = \\["), be)
  e  <- s + which(grepl("^\\];", be[(s + 1):length(be)]))[1]
  body <- gsub("//.*$", "", be[s:e])
  gsub("'", "", unlist(regmatches(body, gregexpr("'[^']+'", body))))
}
META_COLS <- read_header("META_HEADER")
RESP_COLS <- read_header("RESP_HEADER")
READ_COLS <- RESP_COLS

## ── Decryption ───────────────────────────────────────────────────────
key <- read_key(KEY_FILE)

decrypt_envelope <- function(env) {
  aes <- rsa_decrypt(base64_decode(env$enc_key), key, oaep = TRUE)
  ct  <- base64_decode(env$data)
  ct  <- ct[seq_len(length(ct) - 16)]  # drop the 16-byte GCM tag (R's openssl does GCM without it)
  pt  <- aes_gcm_decrypt(ct, key = aes, iv = base64_decode(env$iv))
  p   <- rawToChar(pt); Encoding(p) <- "UTF-8"
  fromJSON(p, simplifyVector = FALSE)
}

## ── Helpers ──────────────────────────────────────────────────────────
cell <- function(v) {
  if (is.null(v)) return(NA)
  if (is.list(v)) return(as.character(toJSON(v, auto_unbox = TRUE, null = "null")))  # objects/arrays → JSON text, as on the sheet
  if (length(v) == 0) return(NA)
  if (length(v) > 1) return(as.character(toJSON(v)))
  v
}
num <- function(v) suppressWarnings(as.numeric(v))
ID_COLS <- c("prolific_pid", "study_id", "session_id")

rows_to_df <- function(rows, cols) {
  if (!length(rows)) return(setNames(data.frame(matrix(nrow = 0, ncol = length(cols))), cols))
  df <- as.data.frame(lapply(setNames(cols, cols), function(cn)
    vapply(rows, function(r) { v <- r[[cn]]; if (is.null(v) || (length(v) == 1 && is.na(v))) NA_character_ else as.character(v) }, "")),
    stringsAsFactors = FALSE, check.names = FALSE)
  for (cn in setdiff(cols, ID_COLS)) df[[cn]] <- type.convert(df[[cn]], as.is = TRUE)
  df
}

## ── Find and read the backups ────────────────────────────────────────
files <- list.files(IN_DIR, pattern = "\\.(json|txt)$", full.names = TRUE)
files <- files[!grepl("\\.decrypted\\.json$", files)]

meta_rows <- list(); resp_rows <- list(); log_rows <- list()

for (f in files) {
  txt <- paste(readLines(f, encoding = "UTF-8", warn = FALSE), collapse = "\n")
  obj <- tryCatch(fromJSON(txt, simplifyVector = FALSE), error = function(e) NULL)
  if (is.null(obj)) next

  if (identical(obj$format, "WT_G-encrypted-backup-v1")) {
    p <- tryCatch(decrypt_envelope(obj), error = function(e) { message("Cannot decrypt ", basename(f), ": ", conditionMessage(e)); NULL })
    if (is.null(p)) next
    kind <- "encrypted"
  } else if (!is.null(obj$study_level) && !is.null(obj$sections)) {
    # older, unencrypted backup: no ids inside — take the pid from the file name
    p <- obj
    if (is.null(p$prolific_pid)) p$prolific_pid <- sub("^wt_study_backup_(.*)\\.json$", "\\1", basename(f))
    kind <- "UNENCRYPTED (editable by the participant)"
  } else next

  out_json <- sub("\\.(json|txt)$", ".decrypted.json", f)
  if (kind == "encrypted") writeLines(toJSON(p, auto_unbox = TRUE, pretty = TRUE, null = "null"), out_json, useBytes = TRUE)

  sl  <- p$study_level
  pid <- as.character(cell(p$prolific_pid)); sid <- cell(p$study_id); ses <- cell(p$session_id)

  ## Meta row — same mapping as the backend's upsertMeta_
  m <- setNames(vector("list", length(META_COLS)), META_COLS)
  for (cn in META_COLS) m[[cn]] <- cell(sl[[cn]])
  m$prolific_pid <- pid; m$study_id <- sid; m$session_id <- ses
  m$last_updated_iso     <- cell(p$created_at)
  m$reload_log_json      <- as.character(toJSON(if (is.null(sl$reload_log)) list() else sl$reload_log, auto_unbox = TRUE))
  m$resume_snapshot_json <- NA
  m$study_complete_at    <- NA   # never confirmed by the server
  meta_rows[[length(meta_rows) + 1]] <- m

  ## Responses rows — one per logged section (attempt)
  secs <- p$sections
  att  <- vapply(secs, function(s) if (is.null(s$seq_attempt)) 1 else num(s$seq_attempt), 0)
  seqn <- vapply(secs, function(s) num(s$seq_n), 0)
  for (k in seq_along(secs)) {
    s <- secs[[k]]
    r <- setNames(vector("list", length(READ_COLS)), READ_COLS)
    for (cn in READ_COLS) r[[cn]] <- cell(s[[cn]])
    r$prolific_pid <- pid; r$study_id <- sid; r$session_id <- ses
    r$demo_mode <- cell(sl$demo_mode); r$seq_attempt <- att[k]
    r$is_latest_attempt <- as.integer(att[k] == max(att[seqn == seqn[k]]))
    resp_rows[[length(resp_rows) + 1]] <- r
  }

  ## Consistency checks (the payoff fields should follow from the raw ones)
  latest <- secs[vapply(seq_along(secs), function(k) att[k] == max(att[seqn == seqn[k]]), TRUE)]
  pays   <- vapply(latest, function(s) num(cell(s$pay)), 0)
  earn   <- vapply(secs,   function(s) num(cell(s$earnings)), 0)
  pen    <- vapply(secs,   function(s) { v <- num(cell(s$penalty)); if (is.na(v)) 0 else v }, 0)
  # paid outcomes: winning card found, or alternative completed (current labels and older ones)
  won    <- vapply(secs,   function(s) { o <- as.character(cell(s$outcome_summary))
                                         !is.na(o) && grepl("found the winning card|switched|took the alternative|auto-switched", o) &&
                                         !grepl("gave up|forfeited|auto-kicked|abandoned", o) }, TRUE)
  pay_all <- vapply(secs, function(s) num(cell(s$pay)), 0)
  recomputed <- max(0, round(sum(earn, na.rm = TRUE) - sum(pen), 2))
  issues <- c(
    if (length(latest) == 5 && !is.na(num(sl$reward_pool)) && abs(sum(pays) - num(sl$reward_pool)) > 1e-6) "pays do not sum to reward_pool",
    if (any(abs(earn - ifelse(won, pay_all, 0)) > 1e-6, na.rm = TRUE)) "earnings inconsistent with outcome/pay",
    if (!is.na(num(sl$final_bonus)) && abs(num(sl$final_bonus) - recomputed) > 0.011) "final_bonus differs from rewards - penalties"
  )
  log_rows[[length(log_rows) + 1]] <- list(
    file = basename(f), type = kind, prolific_pid = pid, study_id = sid,
    error_code = cell(p$error_code), created_at = cell(p$created_at),
    n_rows = length(secs), sections_done = cell(sl$sections_done), reward_pool = cell(sl$reward_pool),
    final_bonus_reported = cell(sl$final_bonus), final_bonus_recomputed = recomputed,
    checks = if (length(issues)) paste(issues, collapse = "; ") else "OK")
  cat(sprintf("%-50s %-10s pid=%s rows=%d  %s\n", basename(f), if (kind == "encrypted") "decrypted" else "plain",
              pid, length(secs), if (length(issues)) paste("CHECK:", paste(issues, collapse = "; ")) else "OK"))
}

if (!length(meta_rows)) stop("No backup files found in ", IN_DIR)

meta_df <- rows_to_df(meta_rows, META_COLS)
resp_df <- rows_to_df(resp_rows, RESP_COLS)
log_cols <- names(log_rows[[1]])
log_df <- rows_to_df(log_rows, log_cols)

wb <- createWorkbook()
addWorksheet(wb, "Meta");      writeData(wb, "Meta", meta_df)
addWorksheet(wb, "Responses"); writeData(wb, "Responses", resp_df)
addWorksheet(wb, "Backups");   writeData(wb, "Backups", log_df)
saveWorkbook(wb, OUT, overwrite = TRUE)
cat("\nWritten:", OUT, "\n")
