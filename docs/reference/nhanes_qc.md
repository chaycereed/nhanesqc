# Quick QC for a NHANES-style dataset (CSV, XPT, or data frame)

High-level helper that:

- accepts either a file path **or** an in-memory data frame

- if a path is provided:

  - reads a NHANES-style file (CSV or XPT)

- summarizes variables with
  [`nhanes_variable_summary()`](https://chaycereed.github.io/nhanesqc/reference/nhanes_variable_summary.md)

- detects NHANES-style special missing codes with
  [`nhanes_missingness_summary()`](https://chaycereed.github.io/nhanesqc/reference/nhanes_missingness_summary.md)

Supported inputs:

- Character path to `.csv` files via
  [`read_nhanes_csv()`](https://chaycereed.github.io/nhanesqc/reference/read_nhanes_csv.md)

- Character path to `.xpt` (SAS transport) files via
  [`read_nhanes_xpt()`](https://chaycereed.github.io/nhanesqc/reference/read_nhanes_xpt.md)

- A data frame or tibble already in memory (e.g., from
  [`nhanesA::nhanes()`](https://rdrr.io/pkg/nhanesA/man/nhanes.html))

## Usage

``` r
nhanes_qc(
  x,
  special_codes = c(7, 9, 77, 99, 777, 999, 7777, 9999),
  exclude_vars = c("seqn"),
  ...
)
```

## Arguments

- x:

  Either:

  - a character string giving a file path to a NHANES file (`.csv` or
    `.xpt`), or

  - a data frame / tibble containing NHANES-style data.

- special_codes:

  A vector of special missing codes to scan for. Passed to
  [`nhanes_missingness_summary()`](https://chaycereed.github.io/nhanesqc/reference/nhanes_missingness_summary.md).

- exclude_vars:

  Variables to exclude from special-code detection (for example, ID
  variables like "seqn").

- ...:

  Additional arguments passed to the underlying reader when `x` is a
  file path:
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)
  for CSV,
  [`haven::read_xpt()`](https://haven.tidyverse.org/reference/read_xpt.html)
  for XPT.

## Value

A list with:

- `path` - the file path provided, or `"<data.frame input>"`

- `n_rows` - number of rows in the data

- `n_cols` - number of columns in the data

- `data` - the loaded/processed data (tibble)

- `variables` - variable-level summary (from
  [`nhanes_variable_summary()`](https://chaycereed.github.io/nhanesqc/reference/nhanes_variable_summary.md))

- `missingness` - missingness + special-code detection summary (from
  [`nhanes_missingness_summary()`](https://chaycereed.github.io/nhanesqc/reference/nhanes_missingness_summary.md),
  `$summary` component)
