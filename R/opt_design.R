#' Optimize a Basket Trial Design
#'
#' Functions for optimizing the tuning parameters of a basket trial
#' design. This defaults to the function `basksim::opt_design`.
#'
#' @param design An object created with one of the `setup` functions from
#' the `basksim` package.
#' @inheritParams basksim::opt_design
#'
#' @inherit basksim::opt_design return
#' @export
#' @inherit opt_design.fujikawa_x examples
opt_design <- function(design, ...) {
  UseMethod("opt_design", design)
}
#' @rdname opt_design
#' @export
opt_design.default <- function(design, ...) {
  return(basksim::opt_design(design, ...))
}

#' Optimize Fujikawa et al.'s Basket Trial Design
#'
#'  This wrapper function returns the optimal tuning parameters
#'  for Fujikawa et al.'s  basket trial design. The design is optimized
#'  using backends from two  different R packages:
#' * If `design$backend == "sim"`, the opt_design is calculated using
#' `basksim::opt_design`.
#' * If `design$backend == "exact"`, the opt_design are calculated using
#' `baskexact::opt_design`.
#'
#' @inheritParams get_details.fujikawa_x
#' @inheritParams basksim::opt_design
#' @inheritParams baskexact::opt_design
#'
#' @inherit basksim::opt_design return
#' @export
#'
#' @examples
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2, backend = "sim")
#' # Usually, you should increase iter in an actual application
#' opt_design(design = design,
#'            n = 20, alpha = 0.05,
#'            design_params = list(epsilon = c(1, 2), tau = c(0, 0.5)),
#'            scenarios = get_scenarios(design, 0.5),
#'            prec_digits = 3,
#'            iter = 100)
opt_design.fujikawa_x <- function(design, n, alpha,
                                  design_params = list(),
                                  scenarios,
                                  prec_digits,
                                  iter = 1000,
                                  data = NULL,
                                  weight_fun = weights_jsd,
                                  weight_params = design_params,
                                  globalweight_fun = NULL,
                                  globalweight_params = list(), ...){
  if(design$backend == "sim"){
    return(NextMethod())
  } else if(design$backend == "exact"){
    return(baskexact::opt_design(design = design$design_exact, n = n,
                          alpha = alpha, weight_fun = weight_fun,
                          weight_params = weight_params,
                          globalweight_fun = globalweight_fun,
                          globalweight_params = globalweight_params,
                          scenarios = scenarios, prec_digits = prec_digits,
                          ...))
  }  else {
    stop("design$backend must be 'sim' or 'exact'")
  }
}

