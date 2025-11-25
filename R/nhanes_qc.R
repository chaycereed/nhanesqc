#' Quick QC for a NHANES-style dataset (CSV, XPT, or data frame)
#'
#' @description
#' High-level helper that:
#' - accepts either a file path **or** an in-memory data frame
#' - if a path is provided:
#'   - reads a NHANES-style file (CSV or XPT)
#' - summarizes variables with [nhanes_variable_summary()]
#' - detects NHANES-style special missing codes with [nhanes_missingness_summary()]
#'
#' Supported inputs:
#' - Character path to `.csv` files via [read_nhanes_csv()]
#' - Character path to `.xpt` (SAS transport) files via [read_nhanes_xpt()]
#' - A data frame or tibble already in memory (e.g., from [nhanesA::nhanes()])
#'
#' @param x Either:
#'   - a character string giving a file path to a NHANES file (`.csv` or `.xpt`), or
#'   - a data frame / tibble containing NHANES-style data.
#' @param special_codes A vector of special missing codes to scan for.
#'   Passed to [nhanes_missingness_summary()].
#' @param exclude_vars Variables to exclude from special-code detection
#'   (for example, ID variables like "seqn").
#' @param ... Additional arguments passed to the underlying reader when `x`
#'   is a file path: [readr::read_csv()] for CSV, [haven::read_xpt()] for XPT.
#'
#' @return A list with:
#' \itemize{
#'   \item `path` - the file path provided, or `"<data.frame input>"`
#'   \item `n_rows` - number of rows in the data
#'   \item `n_cols` - number of columns in the data
#'   \item `data` - the loaded/processed data (tibble)
#'   \item `variables` - variable-level summary (from [nhanes_variable_summary()])
#'   \item `missingness` - missingness + special-code detection summary
#'     (from [nhanes_missingness_summary()], `$summary` component)
#' }
#' @export
nhanes_qc <- function(
  x,
  special_codes = c(7, 9, 77, 99, 777, 999, 7777, 9999),
  exclude_vars = c("seqn"),
  ...
) {
  # Case 1: data frame / tibble input ---------------------------
  if (is.data.frame(x)) {
    df   <- janitor::clean_names(tibble::as_tibble(x))
    path <- "<data.frame input>"

  # Case 2: character path input -------------------------------
  } else if (is.character(x) && length(x) == 1L) {
    path <- x

    if (!file.exists(path)) {
      stop("File does not exist: ", path, call. = FALSE)
    }

    ext <- tolower(tools::file_ext(path))

    df <- switch(
      ext,
      "csv" = read_nhanes_csv(path, ...),
      "xpt" = read_nhanes_xpt(path, ...),
      stop("Unsupported file extension: '", ext,
           "'. Supported: .csv, .xpt", call. = FALSE)
    )

  } else {
    stop(
      "`x` must be either:\n",
      "  - a character file path to a .csv or .xpt file, or\n",
      "  - a data frame / tibble containing NHANES-style data.",
      call. = FALSE
    )
  }

  # Variable summary
  var_summary <- nhanes_variable_summary(df)

  # Missingness / special-code detection
  miss_res <- nhanes_missingness_summary(
    df,
    special_codes = special_codes,
    exclude_vars  = exclude_vars
  )

  out <- list(
    path        = path,
    n_rows      = nrow(df),
    n_cols      = ncol(df),
    data        = df,
    variables   = var_summary,
    missingness = miss_res$summary
  )

  class(out) <- c("nhanes_qc_result", class(out))
  out
}