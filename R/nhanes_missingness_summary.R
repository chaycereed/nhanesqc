#' Detect NHANES-style special missing codes (detection only)
#'
#' @description
#' NHANES often uses numeric codes like 7, 9, 77, 99, 777, 999 (and similar)
#' to represent special missing values such as "Refused" or "Don't know".
#'
#' This function:
#' - scans each variable for those special codes
#' - counts how often they appear
#' - reports which codes are present per variable
#'
#' IMPORTANT:
#' - This function does **not** modify the input data.
#' - It is intended as a *detection* and QC helper.
#' - Actual recoding to NA should be done explicitly by the user
#'   or in a future, more codebook-aware function.
#'
#' @param df A data frame or tibble, typically from [read_nhanes_csv()].
#' @param special_codes A vector of NHANES-style special codes. Numeric or character.
#' @param exclude_vars A character vector of variable names to exclude from detection
#'   (for example, ID variables like "seqn").
#'
#' @return A list with:
#' \itemize{
#'   \item `data` - the original data frame (unchanged)
#'   \item `summary` - a tibble with one row per variable, including:
#'     \itemize{
#'       \item `variable`
#'       \item `n_rows`
#'       \item `n_na`
#'       \item `prop_na`
#'       \item `n_special`
#'       \item `prop_special`
#'       \item `special_codes_found`
#'     }
#' }
#' @export
nhanes_missingness_summary <- function(
  df,
  special_codes = c(7, 9, 77, 99, 777, 999, 7777, 9999),
  exclude_vars = c("seqn")
) {
  if (!is.data.frame(df)) {
    stop("`df` must be a data frame or tibble.", call. = FALSE)
  }

  n_rows <- nrow(df)
  codes_chr <- as.character(special_codes)

  rows <- vector("list", length = length(names(df)))
  i <- 1L

  for (col in names(df)) {
    x <- df[[col]]

    # Basic NA info (always computed)
    n_na   <- sum(is.na(x))
    prop_na <- if (n_rows == 0L) NA_real_ else n_na / n_rows

    # Default: no special codes
    n_special        <- 0L
    prop_special     <- 0
    special_found    <- ""

    # Only scan for special codes if not excluded
    if (!(col %in% exclude_vars)) {
      x_chr <- as.character(x)
      idx_special <- !is.na(x_chr) & x_chr %in% codes_chr

      n_special    <- sum(idx_special)
      prop_special <- if (n_rows == 0L) NA_real_ else n_special / n_rows

      if (n_special > 0L) {
        special_found <- paste(
          sort(unique(x_chr[idx_special])),
          collapse = ", "
        )
      }
    }

    rows[[i]] <- tibble::tibble(
      variable           = col,
      n_rows             = n_rows,
      n_na               = n_na,
      prop_na            = prop_na,
      n_special          = n_special,
      prop_special       = prop_special,
      special_codes_found = special_found
    )
    i <- i + 1L
  }

  summary_tbl <- dplyr::bind_rows(rows)

  list(
    data    = df,        
    summary = summary_tbl
  )
}