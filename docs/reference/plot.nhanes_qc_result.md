# Plot method for nhanes_qc_result objects

Simple visualization for NHANES QC results.

Currently supports:

- `type = "missing"`: barplot of proportion missing by variable

- `type = "special"`: barplot of proportion special codes by variable

Only the top `top_n` variables (by the chosen metric) are shown.

## Usage

``` r
# S3 method for class 'nhanes_qc_result'
plot(x, type = c("missing", "special"), top_n = 20, ...)
```

## Arguments

- x:

  An object of class `nhanes_qc_result`, as returned by
  [`nhanes_qc()`](nhanes_qc.md).

- type:

  Character; either `"missing"` or `"special"`.

- top_n:

  Integer; number of variables to show (sorted descending).

- ...:

  Additional arguments passed to
  [`graphics::barplot()`](https://rdrr.io/r/graphics/barplot.html).

## Value

The result of
[`graphics::barplot()`](https://rdrr.io/r/graphics/barplot.html),
invisibly.
