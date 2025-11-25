#' Summary method for nhanes_qc_result objects
#'
#' @param object An object of class `nhanes_qc_result`, as returned by [nhanes_qc()].
#' @param top_n Integer; how many variables to show in the "top missing" tables.
#' @param ... Additional arguments (currently ignored).
#'
#' @return A list with summary components (invisibly), after printing a
#'   human-readable summary to the console.
#' @export
#' @method summary nhanes_qc_result
summary.nhanes_qc_result <- function(object, top_n = 10, ...) {
  if (!inherits(object, "nhanes_qc_result")) {
    stop("`object` must be an object of class 'nhanes_qc_result'.", call. = FALSE)
  }

  df        <- object$data
  vars_tbl  <- object$variables
  miss_tbl  <- object$missingness

  n_rows <- nrow(df)
  n_cols <- ncol(df)

  # ---- Overall missingness stats -------------------------------------------
  if (is.data.frame(miss_tbl) &&
      all(c("n_na", "prop_na") %in% names(miss_tbl))) {

    total_na        <- sum(miss_tbl$n_na)
    total_cells     <- n_rows * n_cols
    overall_prop_na <- if (total_cells == 0L) NA_real_ else total_na / total_cells

    vars_with_na    <- sum(miss_tbl$n_na > 0)
    vars_with_special <- if ("n_special" %in% names(miss_tbl)) {
      sum(miss_tbl$n_special > 0)
    } else {
      NA_integer_
    }
  } else {
    total_na           <- NA_integer_
    overall_prop_na    <- NA_real_
    vars_with_na       <- NA_integer_
    vars_with_special  <- NA_integer_
  }

  # ---- Top variables by missingness ----------------------------------------
  top_missing <- NULL
  if (is.data.frame(miss_tbl) &&
      all(c("variable", "n_na", "prop_na") %in% names(miss_tbl))) {

    top_missing <- miss_tbl |>
      dplyr::arrange(dplyr::desc(prop_na)) |>
      dplyr::filter(n_na > 0) |>
      dplyr::slice_head(n = top_n) |>
      dplyr::select(variable, n_na, prop_na)
  }

  # ---- Variables with special codes ----------------------------------------
  vars_with_special_tbl <- NULL
  if (is.data.frame(miss_tbl) &&
      all(c("variable", "n_special") %in% names(miss_tbl))) {

    vars_with_special_tbl <- miss_tbl |>
      dplyr::filter(n_special > 0) |>
      dplyr::arrange(dplyr::desc(n_special)) |>
      dplyr::slice_head(n = top_n) |>
      dplyr::select(variable, n_special, prop_special, special_codes_found)
  }

  # ---- Printing -------------------------------------------------------------
  cat("Summary of NHANES QC result\n\n")

  cat("Dimensions:\n")
  cat("  Rows:   ", n_rows, "\n", sep = "")
  cat("  Cols:   ", n_cols, "\n\n", sep = "")

  cat("Overall missingness (across all cells):\n")
  cat("  Total missing values: ", total_na, "\n", sep = "")
  cat("  Proportion missing:   ",
      if (!is.na(overall_prop_na)) sprintf("%.3f", overall_prop_na) else "NA",
      "\n\n", sep = "")

  cat("Variables with missing values:      ",
      if (!is.na(vars_with_na)) vars_with_na else "NA", "\n", sep = "")
  cat("Variables with special codes found: ",
      if (!is.na(vars_with_special)) vars_with_special else "NA", "\n\n", sep = "")

  if (!is.null(top_missing) && nrow(top_missing) > 0) {
    cat("Top variables by proportion missing (up to ", top_n, "):\n", sep = "")
    print(top_missing)
    cat("\n")
  } else {
    cat("No variables with missing values detected, or missingness data unavailable.\n\n")
  }

  if (!is.null(vars_with_special_tbl) && nrow(vars_with_special_tbl) > 0) {
    cat("Variables with NHANES-style special codes (up to ", top_n, "):\n", sep = "")
    print(vars_with_special_tbl)
    cat("\n")
  } else {
    cat("No variables with NHANES-style special codes detected,\n",
        "or special-code data unavailable.\n\n", sep = "")
  }

  # ---- Return a structured summary object ----------------------------------
  out <- list(
    n_rows            = n_rows,
    n_cols            = n_cols,
    total_na          = total_na,
    overall_prop_na   = overall_prop_na,
    vars_with_na      = vars_with_na,
    vars_with_special = vars_with_special,
    top_missing       = top_missing,
    vars_with_special_tbl = vars_with_special_tbl
  )

  invisible(out)
}