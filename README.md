
<!-- README.md is generated from README.Rmd. Please edit that file -->

# baskwrap

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/LukasDSauer/baskwrap/graph/badge.svg)](https://app.codecov.io/gh/LukasDSauer/baskwrap)
[![R-CMD-check](https://github.com/LukasDSauer/baskwrap/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/LukasDSauer/baskwrap/actions/workflows/R-CMD-check.yaml)
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
#> [1] 0.153 0.965 0.968
#> 
#> $FWER
#> [1] 0.153
#> 
#> $EWP
#> [1] 0.998
#> 
#> $Mean
#> [1] 0.2304727 0.4991730 0.4951854
#> 
#> $MSE
#> [1] 0.009554403 0.010389972 0.009465521
#> 
#> $Lower_CL
#> [1] 0.09109817 0.34099585 0.33751286
#> 
#> $Upper_CL
#> [1] 0.3842372 0.6570925 0.6527386
#> 
#> $ECD
#> [1] 2.78
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
