
<!-- README.md is generated from README.Rmd. Please edit that file -->

# baskwrap <img src="man/figures/logo.png" align="right" height="139" />

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/LukasDSauer/baskwrap/graph/badge.svg)](https://app.codecov.io/gh/LukasDSauer/baskwrap)
[![R-CMD-check](https://github.com/LukasDSauer/baskwrap/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/LukasDSauer/baskwrap/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/baskwrap)](https://CRAN.R-project.org/package=baskwrap)
<!-- badges: end -->

The baskwrap package supplies a unified wrapper to several basket trial
packages (`basksim` and `baskexact`) using a unified syntax.

## Installation

You can install the development version of baskwrap from
[GitHub](https://github.com/LukasDSauer/baskwrap) with:

``` r
# install.packages("pak")
pak::pak("LukasDSauer/baskwrap")
```

## Example

The baskwrap package provides a simple interface to switch between two
methods for calculating basket trial characteristics, numerical
integration (“exact”) and Monte Carlo simulation (“simulated”).

``` r
library(baskwrap)
# INPUT PARAMETERS
n <- 20
p1 <- c(0.2, 0.5, 0.5)
lambda <- 0.95
epsilon <- 2
tau <- 0.5
design <- setup_fujikawa_x(k = 3, p0 = 0.2, backend = "exact")
# DETAILS USING EXACT BACKEND
get_details(design = design, n = n, p1 = p1, lambda = lambda,
            epsilon = epsilon, tau = tau)
#> $Rejection_Probabilities
#> [1] 0.1656753 0.9623016 0.9623016
#> 
#> $FWER
#> [1] 0.1656753
#> 
#> $EWP
#> [1] 0.9983541
#> 
#> $Mean
#> [1] 0.2358052 0.4958199 0.4958199
#> 
#> $MSE
#> [1] 0.009524536 0.009835315 0.009835315
#> 
#> $Lower_CL
#> numeric(0)
#> 
#> $Upper_CL
#> numeric(0)
#> 
#> $ECD
#> [1] 2.758928
#> 
#> $p0
#> [1] 0.2
#> 
#> $p1
#> [1] 0.2 0.5 0.5
#> 
#> $backend
#> [1] "exact"
# DETAILS USING MC BACKEND
get_details(design = set_backend(design, "sim"),
            n = n, p1 = p1, lambda = lambda,
            epsilon = epsilon, tau = tau)
#> $Rejection_Probabilities
#> [1] 0.146 0.967 0.958
#> 
#> $FWER
#> [1] 0.146
#> 
#> $EWP
#> [1] 0.999
#> 
#> $Mean
#> [1] 0.2319132 0.4989091 0.4931409
#> 
#> $MSE
#> [1] 0.009404904 0.009455926 0.009624520
#> 
#> $Lower_CL
#> [1] 0.09135332 0.34169623 0.33677898
#> 
#> $Upper_CL
#> [1] 0.3866402 0.6558876 0.6494963
#> 
#> $ECD
#> [1] 2.779
#> 
#> $Rejection_Probabilities_SE
#> [1] 0.011166199 0.005648982 0.006343185
#> 
#> $FWER_SE
#> [1] 0.0111662
#> 
#> $EWP_SE
#> [1] 0.0009994999
#> 
#> $ECD_SE
#> [1] 0.01327913
#> 
#> $p0
#> [1] 0.2
#> 
#> $p1
#> [1] 0.2 0.5 0.5
#> 
#> $backend
#> [1] "sim"
```
