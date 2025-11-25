#' Read a NHANES-style XPT (SAS transport) file
#'
#' @description
#' Convenience wrapper around [haven::read_xpt()] for NHANES data.
#' This function:
#' - checks that the file exists
#' - reads the XPT file
#' - cleans column names (snake_case, lowercase) using janitor
#'
#' @param path Path to a NHANES .xpt file.
#' @param ... Additional arguments passed to [haven::read_xpt()].
#'
#' @return A tibble with cleaned column names.
#' @export
read_nhanes_xpt <- function(path, ...) {
  if (!file.exists(path)) {
    stop("File does not exist: ", path, call. = FALSE)
  }

  df <- haven::read_xpt(path, ...)

  df <- janitor::clean_names(df)

  tibble::as_tibble(df)
}