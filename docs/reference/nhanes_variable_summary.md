# Summarize variables in a NHANES-style data frame

Provides a high-level summary for each column in a data frame:

- variable name

- class (type)

- number of rows

- number and proportion of missing values

- number of unique values

- simple type flags (numeric / categorical)

This is a general summary and does **not** yet apply NHANES-specific
missing-code logic (e.g., 7/9/77/99). That will be handled in a
dedicated missingness function.

## Usage

``` r
nhanes_variable_summary(df)
```

## Arguments

- df:

  A data frame or tibble, typically created by
  [`read_nhanes_csv()`](read_nhanes_csv.md).

## Value

A tibble with one row per variable and summary statistics.
