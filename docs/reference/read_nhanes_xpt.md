# Read a NHANES-style XPT (SAS transport) file

Convenience wrapper around
[`haven::read_xpt()`](https://haven.tidyverse.org/reference/read_xpt.html)
for NHANES data. This function:

- checks that the file exists

- reads the XPT file

- cleans column names (snake_case, lowercase) using janitor

## Usage

``` r
read_nhanes_xpt(path, ...)
```

## Arguments

- path:

  Path to a NHANES .xpt file.

- ...:

  Additional arguments passed to
  [`haven::read_xpt()`](https://haven.tidyverse.org/reference/read_xpt.html).

## Value

A tibble with cleaned column names.
