# nhanesqc

Welcome to **nhanesqc** — a lightweight R toolkit that performs **quick, structured quality control** on NHANES datasets (CSV, XPT, or data frames).

`nhanesqc` is built for public-health, epidemiology, biomedical, and data-science workflows that rely on NHANES and need fast, reproducible quality control before deeper analysis.

---

## Features

- **One-command QC** for NHANES files:
  ```r
  nhanes_qc("DEMO_H.xpt")
  nhanes_qc("DEMO_H.csv")
  nhanes_qc(nhanesA::nhanes("DEMO_H"))
  ```

- **Automatic format detection**
  - `.csv` → readr::read_csv()
  - `.xpt` → haven::read_xpt()
  - data frames → used directly

- **Clean column names** (snake_case) and tibble output

- **Variable summaries**, including:
  - column type
  - number of unique values
  - missingness counts
  - basic structure

- **NHANES special missing-code detection**, covering:
  - 7 / 9
  - 77 / 99
  - 777 / 999
  - 7777 / 9999
  *(no automatic recoding; detection only)*

- **Custom S3 methods**:
  - print() — preview
  - summary() — full text output
  - plot() — missingness and special-code visualizations

- **Plot options**:
  - plot(qc) → missingness
  - plot(qc, type = "special") → NHANES-style special codes

- Minimal dependencies; fast enough for large NHANES tables.

---

## Installation

```r
remotes::install_github("chaycereed/nhanesqc")
```

Then:

```r
library(nhanesqc)
```

---

## Usage

### 1. Quick QC on a CSV file

```r
qc <- nhanes_qc("DEMO_H.csv")
qc
```

### 2. Run QC directly on an XPT file

```r
qc <- nhanes_qc("DEMO_H.xpt")
summary(qc)
```

### 3. Run QC on a data frame

```r
library(nhanesA)
demo_h <- nhanesA::nhanes("DEMO_H")

qc <- nhanes_qc(demo_h)
qc
```

### 4. Plot missingness and special codes

```r
plot(qc)                     # missingness
plot(qc, type = "special")   # NHANES special codes
```

---

## Why Detection Only?

NHANES variables use *different* special-code patterns, and blind recoding can incorrectly mark real values (e.g., age = 77) as missing.

`nhanesqc` focuses on **safe detection**, not automatic recoding.

A future version will include codebook-aware recoding.

---

## License

MIT License.
