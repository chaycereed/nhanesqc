#' Summarize variables in a NHANES-style data frame
#'
#' @description
#' Provides a high-level summary for each column in a data frame:
#' - variable name
#' - class (type)
#' - number of rows
#' - number and proportion of missing values
#' - number of unique values
#' - simple type flags (numeric / categorical)
#'
#' This is a general summary and does **not** yet apply
#' NHANES-specific missing-code logic (e.g., 7/9/77/99).
#' That will be handled in a dedicated missingness function.
#'
#' @param df A data frame or tibble, typically created by [read_nhanes_csv()].
#'
#' @return A tibble with one row per variable and summary statistics.
#' @export
nhanes_variable_summary <- function(df) {
  if (!is.data.frame(df)) {
    stop("`df` must be a data frame or tibble.", call. = FALSE)
  }

  n_rows <- nrow(df)

  purrr::map_dfr(
    .x = names(df),
    .f = function(col) {
      x <- df[[col]]

      tibble::tibble(
        variable       = col,
        class          = paste(class(x), collapse = ", "),
        n_rows         = n_rows,
        n_missing      = sum(is.na(x)),
        prop_missing   = if (n_rows == 0L) NA_real_ else sum(is.na(x)) / n_rows,
        n_unique       = dplyr::n_distinct(x),
        is_numeric     = is.numeric(x),
        is_categorical = is.factor(x) || is.character(x)
      )
    }
  )
}