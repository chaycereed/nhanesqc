# Detect NHANES-style special missing codes (detection only)

NHANES often uses numeric codes like 7, 9, 77, 99, 777, 999 (and
similar) to represent special missing values such as "Refused" or "Don't
know".

This function:

- scans each variable for those special codes

- counts how often they appear

- reports which codes are present per variable

IMPORTANT:

- This function does **not** modify the input data.

- It is intended as a *detection* and QC helper.

- Actual recoding to NA should be done explicitly by the user or in a
  future, more codebook-aware function.

## Usage

``` r
nhanes_missingness_summary(
  df,
  special_codes = c(7, 9, 77, 99, 777, 999, 7777, 9999),
  exclude_vars = c("seqn")
)
```

## Arguments

- df:

  A data frame or tibble, typically from
  [`read_nhanes_csv()`](https://chaycereed.github.io/nhanesqc/reference/read_nhanes_csv.md).

- special_codes:

  A vector of NHANES-style special codes. Numeric or character.

- exclude_vars:

  A character vector of variable names to exclude from detection (for
  example, ID variables like "seqn").

## Value

A list with:

- `data` - the original data frame (unchanged)

- `summary` - a tibble with one row per variable, including:

  - `variable`

  - `n_rows`

  - `n_na`

  - `prop_na`

  - `n_special`

  - `prop_special`

  - `special_codes_found`
