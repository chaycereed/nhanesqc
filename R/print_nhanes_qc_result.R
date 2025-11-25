#' Print method for nhanes_qc_result objects
#'
#' @param x An object of class `nhanes_qc_result`, as returned by [nhanes_qc()].
#' @param ... Additional arguments (currently ignored).
#'
#' @return The input object `x`, invisibly.
#' @export
#' @method print nhanes_qc_result
print.nhanes_qc_result <- function(x, ...) {
  if (!inherits(x, "nhanes_qc_result")) {
    stop("`x` must be an object of class 'nhanes_qc_result'.", call. = FALSE)
  }

  path   <- x$path %||% "<unknown>"
  n_rows <- x$n_rows %||% NA_integer_
  n_cols <- x$n_cols %||% NA_integer_

  vars_tbl <- x$variables
  miss_tbl <- x$missingness

  # --- Basic header ----------------------------------------------------------
  cat("NHANES QC result\n\n")

  cat("File:   ", path, "\n", sep = "")
  cat("Rows:   ", n_rows, "\n", sep = "")
  cat("Cols:   ", n_cols, "\n\n", sep = "")

  # --- Preview: variable summary --------------------------------------------
  if (is.data.frame(vars_tbl)) {
    cat("Variable summary (preview):\n")
    # pick a few key columns if they exist
    cols_to_show <- intersect(
      c("variable", "class", "n_missing", "prop_missing", "n_unique"),
      names(vars_tbl)
    )

    vars_preview <- vars_tbl[, cols_to_show, drop = FALSE]

    if (nrow(vars_preview) > 6) {
      vars_preview <- vars_preview[1:6, , drop = FALSE]
    }

    print(vars_preview)
    if (nrow(vars_tbl) > nrow(vars_preview)) {
      cat("... (", nrow(vars_tbl) - nrow(vars_preview),
          " more variables)\n", sep = "")
    }
    cat("\n")
  } else {
    cat("Variable summary: <unavailable>\n\n")
  }

  # --- Preview: missingness / special codes ---------------------------------
  if (is.data.frame(miss_tbl) &&
      all(c("variable", "n_special") %in% names(miss_tbl))) {

    with_special <- miss_tbl[miss_tbl$n_special > 0, , drop = FALSE]

    cat("Missingness / special codes (preview):\n")

    if (nrow(with_special) == 0) {
      cat("  No special codes detected in any variable.\n\n")
    } else {
      cols_to_show <- intersect(
        c("variable", "n_na", "prop_na", "n_special",
          "prop_special", "special_codes_found"),
        names(with_special)
      )

      miss_preview <- with_special[, cols_to_show, drop = FALSE]

      if (nrow(miss_preview) > 6) {
        miss_preview <- miss_preview[1:6, , drop = FALSE]
      }

      print(miss_preview)
      if (nrow(with_special) > nrow(miss_preview)) {
        cat("... (", nrow(with_special) - nrow(miss_preview),
            " more variables with special codes)\n", sep = "")
      }
      cat("\n")
    }
  } else {
    cat("Missingness summary: <unavailable>\n\n")
  }

  # --- Usage hints -----------------------------------------------------------
  cat("Use:\n")
  cat("  qc$variables    # full variable summary\n")
  cat("  qc$missingness  # full missingness / special-code summary\n")

  invisible(x)
}

# Small internal helper: `x %||% y`
`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}