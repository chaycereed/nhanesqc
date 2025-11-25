# Summary method for nhanes_qc_result objects

Summary method for nhanes_qc_result objects

## Usage

``` r
# S3 method for class 'nhanes_qc_result'
summary(object, top_n = 10, ...)
```

## Arguments

- object:

  An object of class `nhanes_qc_result`, as returned by
  [`nhanes_qc()`](nhanes_qc.md).

- top_n:

  Integer; how many variables to show in the "top missing" tables.

- ...:

  Additional arguments (currently ignored).

## Value

A list with summary components (invisibly), after printing a
human-readable summary to the console.
