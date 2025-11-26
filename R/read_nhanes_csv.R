#' Read a NHANES-style CSV file
#'
#' @description
#' Convenience wrapper around [readr::read_csv()] for NHANES data.
#' This function:
#' - checks that the file exists
#' - reads the CSV using readr
#' - cleans column names (snake_case, lowercase) using janitor
#'
#' It does **not** do any recoding or NHANES-specific logic yet.
#' That will be layered on top in later functions.
#'
#' @param path Path to a NHANES CSV file.
#' @param ... Additional arguments passed to [readr::read_csv()].
#'
#' @return A tibble with cleaned column names.
#' @keywords internal
read_nhanes_csv <- function(path, ...) {
  if (!file.exists(path)) {
    stop("File does not exist: ", path, call. = FALSE)
  }

  # Read CSV with readr (quiet about column types)
  df <- readr::read_csv(path, show_col_types = FALSE, ...)

  # Clean column names: lower_snake_case, no spaces/symbols
  df <- janitor::clean_names(df)

  # Ensure it's a tibble
  tibble::as_tibble(df)
}