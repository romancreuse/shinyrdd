# shinyrdd

**Dynamic graphical tools for quantitative and longitudinal data review using R and Shiny.**

Before statistical analysis, a careful review of the data is essential to identify unexpected observations, unusual distributions, extreme values, or atypical individual trajectories.

`shinyrdd` provides interactive tools to support this process for both **quantitative** and **longitudinal data**. The package is designed to help users explore their data iteratively, investigate potentially unusual observations, and document observations requiring further review.

> **`shinyrdd` does not automatically classify observations as outliers.**
> It provides an interactive framework to support the reviewer's judgement and facilitate the documentation of observations requiring further investigation.

---

# Installation

## Development version from GitHub

The development version can be installed directly from GitHub:

```r
install.packages("remotes")
remotes::install_github(
  "romancreuse/shinyrdd",
  build_vignettes = TRUE
)
```

Then load the package:

```r
library(shinyrdd)
```

The vignette can be accessed with:

```r
browseVignettes("shinyrdd")
```

or:

```r
vignette("introduction-shinyrdd", package = "shinyrdd")
```

> **Note:** `build_vignettes = TRUE` is required when installing the package from GitHub with `remotes::install_github()` if you want the vignette to be built and installed locally.

---

## Features

`shinyrdd` provides two interactive Shiny applications and three standalone plotting functions.

### Quantitative data review

[`shiny_Qrev()`](#shiny_qrev) allows users to:

* explore the distribution of quantitative variables;
* stratify distributions according to qualitative variables;
* adjust histogram binning;
* define minimum and maximum boundaries;
* identify observations outside predefined limits;
* review potentially unusual observations;
* progressively build a list of observations requiring further investigation;
* export reviewed observations to Excel.

### Longitudinal data review

[`shiny_Lrev()`](#shiny_lrev) allows users to:

* explore individual trajectories over time;
* compare trajectories across groups;
* filter observations by group or individual;
* interactively investigate individual observations;
* isolate individual trajectories;
* visualise residuals from a linear mixed-effects model;
* build a list of observations requiring further investigation;
* export reviewed observations to Excel.

### Standalone plotting functions

The graphical components of the applications are also available as independent functions:

* [`hist_Qrev()`](#hist_qrev) — histograms for quantitative data;
* [`ridges_Qrev()`](#ridges_qrev) — ridgeline density plots;
* [`spag_Lrev()`](#spag_lrev) — spaghetti plots for longitudinal data.

These functions are particularly useful when a similar figure needs to be reproduced for a report.

---

# Getting started

The package includes two synthetic datasets that can be used to explore its functionality:

* `quanti_demo` — example quantitative data;
* `longi_demo` — example longitudinal data.

```r
data(quanti_demo)
data(longi_demo)
```

---

# Design philosophy

The identification of potentially unusual observations is often context-dependent. A value that appears extreme in one population may be entirely plausible in another, and unusual longitudinal trajectories may require investigation in light of the study design and expected biological or clinical behaviour.

`shinyrdd` therefore follows an **interactive and exploratory approach** rather than attempting to provide an automated outlier-detection algorithm.

The package is intended to help users:

* explore their data visually;
* define and adjust review criteria;
* investigate potentially unusual observations;
* document observations requiring further review;
* preserve the original dataset;
* prepare observations for further investigation before statistical analysis.

---

# Data review workflow

A typical workflow with `shinyrdd` can be summarised as:

```text
                    Raw data
                       │
                       ▼
             ┌──────────────────┐
             │   Explore data   │
             └────────┬─────────┘
                      │
             ┌────────▼─────────┐
             │ Visualise        │
             │ distributions /  │
             │ trajectories     │
             └────────┬─────────┘
                      │
             ┌────────▼─────────┐
             │ Identify         │
             │ potentially      │
             │ unusual data     │
             └────────┬─────────┘
                      │
             ┌────────▼─────────┐
             │ Investigate      │
             │ observations     │
             └────────┬─────────┘
                      │
             ┌────────▼─────────┐
             │ Document /       │
             │ export           │
             └────────┬─────────┘
                      │
                      ▼
         Verify and correct potential
              errors in data
                      │
                      ▼
            statistical analysis
```

The review criteria can be adjusted throughout this process as the characteristics of the data become better understood.

---

# Documentation

A complete introduction to the package is available in the vignette:

```r
vignette("introduction-shinyrdd", package = "shinyrdd")
```

The documentation for individual functions is available through:

```r
?shiny_Qrev
?shiny_Lrev

?hist_Qrev
?ridges_Qrev
?spag_Lrev
```

---

# Future developments

Future versions of `shinyrdd` may include additional functionality, including:

* French and English user interfaces;
* additional graphical tools for data review;
---

# Author

**Roman Creuse**

`shinyrdd` is developed and maintained by Roman Creuse.

---

# License

`shinyrdd` is released under the MIT License.

See the `LICENSE` file for details.
