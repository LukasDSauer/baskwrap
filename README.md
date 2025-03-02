
<!-- README.md is generated from README.Rmd. Please edit that file -->

# baskwrap

<!-- badges: start -->

[![Codecov test
coverage](https://codecov.io/gh/LukasDSauer/baskwrap/graph/badge.svg)](https://app.codecov.io/gh/LukasDSauer/baskwrap)
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
#> [1] 0.155 0.954 0.965
#> 
#> $FWER
#> [1] 0.155
#> 
#> $EWP
#> [1] 0.998
#> 
#> $Mean
#> [1] 0.2370808 0.4933225 0.4953923
#> 
#> $MSE
#> [1] 0.009863588 0.010143816 0.009251075
#> 
#> $Lower_CL
#> [1] 0.09590743 0.33650811 0.33765503
#> 
#> $Upper_CL
#> [1] 0.3919698 0.6500348 0.6529790
#> 
#> $ECD
#> [1] 2.764
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
