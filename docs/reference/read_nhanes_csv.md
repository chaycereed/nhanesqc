# Read a NHANES-style CSV file

Convenience wrapper around
[`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html)
for NHANES data. This function:

- checks that the file exists

- reads the CSV using readr

- cleans column names (snake_case, lowercase) using janitor

It does **not** do any recoding or NHANES-specific logic yet. That will
be layered on top in later functions.

## Usage

``` r
read_nhanes_csv(path, ...)
```

## Arguments

- path:

  Path to a NHANES CSV file.

- ...:

  Additional arguments passed to
  [`readr::read_csv()`](https://readr.tidyverse.org/reference/read_delim.html).

## Value

A tibble with cleaned column names.
