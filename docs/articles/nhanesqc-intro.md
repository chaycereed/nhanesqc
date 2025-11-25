# nhanesqc: Introduction

  

## Overview

`nhanesqc` provides quick, structured quality control tools for NHANES
datasets, including:

- support for CSV, XPT, and in-memory data frames  
- variable-level summaries  
- detection of NHANES-style special missing codes (7, 9, 77, 99, 777,
  999, etc.)  
- custom [`print()`](https://rdrr.io/r/base/print.html),
  [`summary()`](https://rdrr.io/r/base/summary.html), and
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html) methods

This vignette walks through a simple QC workflow using a real NHANES
table.

``` r

library(nhanesqc)
```

  

## Getting a NHANES table

In this example, we use the `nhanesA` package to download the `DEMO_H`
(demographics) table:

``` r

demo_h <- nhanesA::nhanes("DEMO_H")

dim(demo_h)
#> [1] 10175    47
head(demo_h)
#>    SEQN                        SDDSRVYR                          RIDSTATR
#> 1 73557 NHANES 2013-2014 public release Both interviewed and MEC examined
#> 2 73558 NHANES 2013-2014 public release Both interviewed and MEC examined
#> 3 73559 NHANES 2013-2014 public release Both interviewed and MEC examined
#> 4 73560 NHANES 2013-2014 public release Both interviewed and MEC examined
#> 5 73561 NHANES 2013-2014 public release Both interviewed and MEC examined
#> 6 73562 NHANES 2013-2014 public release Both interviewed and MEC examined
#>   RIAGENDR RIDAGEYR RIDAGEMN           RIDRETH1           RIDRETH3
#> 1     Male       69       NA Non-Hispanic Black Non-Hispanic Black
#> 2     Male       54       NA Non-Hispanic White Non-Hispanic White
#> 3     Male       72       NA Non-Hispanic White Non-Hispanic White
#> 4     Male        9       NA Non-Hispanic White Non-Hispanic White
#> 5   Female       73       NA Non-Hispanic White Non-Hispanic White
#> 6     Male       56       NA   Mexican American   Mexican American
#>                      RIDEXMON RIDEXAGM DMQMILIZ DMQADFC
#> 1 November 1 through April 30       NA      Yes     Yes
#> 2 November 1 through April 30       NA       No    <NA>
#> 3    May 1 through October 31       NA      Yes     Yes
#> 4 November 1 through April 30      119     <NA>    <NA>
#> 5 November 1 through April 30       NA       No    <NA>
#> 6 November 1 through April 30       NA      Yes      No
#>                                 DMDBORN4                           DMDCITZN
#> 1 Born in 50 US states or Washington, DC Citizen by birth or naturalization
#> 2 Born in 50 US states or Washington, DC Citizen by birth or naturalization
#> 3 Born in 50 US states or Washington, DC Citizen by birth or naturalization
#> 4 Born in 50 US states or Washington, DC Citizen by birth or naturalization
#> 5 Born in 50 US states or Washington, DC Citizen by birth or naturalization
#> 6 Born in 50 US states or Washington, DC Citizen by birth or naturalization
#>   DMDYRSUS  DMDEDUC3                               DMDEDUC2  DMDMARTL RIDEXPRG
#> 1     <NA>      <NA> High school graduate/GED or equivalent Separated     <NA>
#> 2     <NA>      <NA> High school graduate/GED or equivalent   Married     <NA>
#> 3     <NA>      <NA>              Some college or AA degree   Married     <NA>
#> 4     <NA> 3rd grade                                   <NA>      <NA>     <NA>
#> 5     <NA>      <NA>              College graduate or above   Married     <NA>
#> 6     <NA>      <NA>              Some college or AA degree  Divorced     <NA>
#>   SIALANG SIAPROXY SIAINTRP FIALANG FIAPROXY FIAINTRP MIALANG MIAPROXY MIAINTRP
#> 1 English       No       No English       No       No English       No       No
#> 2 English       No       No English       No       No English       No       No
#> 3 English       No       No English       No       No English       No       No
#> 4 English      Yes       No English       No       No English       No       No
#> 5 English       No       No English       No       No English       No       No
#> 6 English       No       No English       No       No English       No       No
#>   AIALANGA DMDHHSIZ DMDFMSIZ DMDHHSZA DMDHHSZB DMDHHSZE DMDHRGND DMDHRAGE
#> 1  English        3        3        0        0        2     Male       69
#> 2  English        4        4        0        2        0     Male       54
#> 3     <NA>        2        2        0        0        2     Male       72
#> 4  English        4        4        0        2        0     Male       33
#> 5     <NA>        2        2        0        0        2     Male       78
#> 6  English        1        1        0        0        0     Male       56
#>                                 DMDHRBR4                           DMDHREDU
#> 1 Born in 50 US states or Washington, DC High School Grad/GED or Equivalent
#> 2 Born in 50 US states or Washington, DC High School Grad/GED or Equivalent
#> 3 Born in 50 US states or Washington, DC          Some College or AA degree
#> 4 Born in 50 US states or Washington, DC High School Grad/GED or Equivalent
#> 5 Born in 50 US states or Washington, DC          College Graduate or above
#> 6 Born in 50 US states or Washington, DC          Some College or AA degree
#>    DMDHRMAR                           DMDHSEDU WTINT2YR WTMEC2YR SDMVPSU
#> 1 Separated                               <NA> 13281.24 13481.04       1
#> 2   Married                Less Than 9th Grade 23682.06 24471.77       1
#> 3   Married High School Grad/GED or Equivalent 57214.80 57193.29       1
#> 4   Married          Some College or AA degree 55201.18 55766.51       2
#> 5   Married          College Graduate or above 63709.67 65541.87       2
#> 6  Divorced                               <NA> 24978.14 25344.99       1
#>   SDMVSTRA           INDHHIN2           INDFMIN2 INDFMPIR
#> 1      112 $15,000 to $19,999 $15,000 to $19,999     0.84
#> 2      108 $35,000 to $44,999 $35,000 to $44,999     1.78
#> 3      109 $65,000 to $74,999 $65,000 to $74,999     4.51
#> 4      109 $55,000 to $64,999 $55,000 to $64,999     2.52
#> 5      116  $100,000 and Over  $100,000 and Over     5.00
#> 6      111 $55,000 to $64,999 $55,000 to $64,999     4.79
```

  

## Running QC

You can pass the data frame directly to
[`nhanes_qc()`](../reference/nhanes_qc.md):

``` r

qc <- nhanes_qc(demo_h)

qc
#> NHANES QC result
#> 
#> File:   <data.frame input>
#> Rows:   10175
#> Cols:   47
#> 
#> Variable summary (preview):
#> # A tibble: 6 × 5
#>   variable class   n_missing prop_missing n_unique
#>   <chr>    <chr>       <int>        <dbl>    <int>
#> 1 seqn     numeric         0        0        10175
#> 2 sddsrvyr factor          0        0            1
#> 3 ridstatr factor          0        0            2
#> 4 riagendr factor          0        0            2
#> 5 ridageyr numeric         0        0           81
#> 6 ridagemn numeric      9502        0.934       26
#> ... (41 more variables)
#> 
#> Missingness / special codes (preview):
#> # A tibble: 4 × 6
#>   variable  n_na prop_na n_special prop_special special_codes_found
#>   <chr>    <int>   <dbl>     <int>        <dbl> <chr>              
#> 1 ridageyr     0   0           484      0.0476  7, 77, 9           
#> 2 ridagemn  9502   0.934        76      0.00747 7, 9               
#> 3 ridexagm  5962   0.586       110      0.0108  7, 77, 9, 99       
#> 4 dmdhrage     0   0            46      0.00452 77                 
#> 
#> Use:
#>   qc$variables    # full variable summary
#>   qc$missingness  # full missingness / special-code summary
```

The printed output shows:

- source (data frame input)  
- number of rows and columns  
- a preview of the variable summary  
- a preview of variables with special missing codes

  

## Detailed summary

For a more detailed text summary:

``` r

summary(qc)
#> Summary of NHANES QC result
#> 
#> Dimensions:
#>   Rows:   10175
#>   Cols:   47
#> 
#> Overall missingness (across all cells):
#>   Total missing values: 82092
#>   Proportion missing:   0.172
#> 
#> Variables with missing values:      26
#> Variables with special codes found: 4
#> 
#> Top variables by proportion missing (up to 10):
#> # A tibble: 10 × 3
#>    variable  n_na prop_na
#>    <chr>    <int>   <dbl>
#>  1 dmqadfc   9632   0.947
#>  2 ridagemn  9502   0.934
#>  3 ridexprg  8866   0.871
#>  4 dmdyrsus  8267   0.812
#>  5 dmdeduc3  7372   0.725
#>  6 ridexagm  5962   0.586
#>  7 dmdhsedu  4833   0.475
#>  8 dmdeduc2  4406   0.433
#>  9 dmdmartl  4406   0.433
#> 10 dmqmiliz  3914   0.385
#> 
#> Variables with NHANES-style special codes (up to 10):
#> # A tibble: 4 × 4
#>   variable n_special prop_special special_codes_found
#>   <chr>        <int>        <dbl> <chr>              
#> 1 ridageyr       484      0.0476  7, 77, 9           
#> 2 ridexagm       110      0.0108  7, 77, 9, 99       
#> 3 ridagemn        76      0.00747 7, 9               
#> 4 dmdhrage        46      0.00452 77
```

This reports:

- overall proportion of missing values  
- how many variables have missing data  
- how many variables have NHANES-style special codes  
- the top variables by missingness and by special-code frequency

  

## Visualizing missingness and special codes

You can also visualize the QC results using the
[`plot()`](https://rdrr.io/r/graphics/plot.default.html) method.

### Proportion missing by variable

``` r

plot(qc, type = "missing")
```

![Proportion missing by
variable](nhanesqc-intro_files/figure-html/plot-missing-1.png)

Proportion missing by variable

### Proportion special codes by variable

``` r

plot(qc, type = "special")
```

![Proportion NHANES-style special codes by
variable](nhanesqc-intro_files/figure-html/plot-special-1.png)

Proportion NHANES-style special codes by variable

These plots highlight variables with the most missingness or
special-code usage.

  

## Interpretation and next steps

`nhanesqc` focuses on **detection, not automatic recoding**:

- NHANES uses different special codes for different variables  
- Blindly recoding 7/9/77/99/etc. to `NA` risks removing valid values
  (e.g., age = 77)

The goal of this package is to:

- help you quickly identify potential missingness patterns  
- surface NHANES-style special codes  
- provide a clean starting point before downstream modeling, recoding,
  and analysis

Future versions will explore **codebook-aware recoding** based on NHANES
documentation, so that variable-specific rules can be applied safely and
transparently.
