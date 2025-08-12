#' Calculate the Expected Number of Correct Decisions for a Basket Trial Design
#'
#' Generic function for calculating the expected number of correct decisions
#' of a basket trial design. It defaults to the function `basksim::ecd`.
#'
#' @param design An object created with one of the `setup` functions from
#' the `basksim` package.
#' @inheritParams basksim::ecd
#'
#' @inherit basksim::ecd return
#' @inherit ecd.fujikawa_x examples
#' @export
ecd <- function(design, ...) {
  UseMethod("ecd", design)
}
#' @rdname ecd
#' @export
ecd.default <- function(design, ...) {
  return(basksim::ecd(design, ...))
}

#' Calculate the Expected Number of Correct Decisions for Fujikawa et al.'s Basket Trial Design
#'
#'  This wrapper functions returns the expected number of correct decisions
#'  (ECD) for Fujikawa et al.'s  basket trial design. The ECD is calculated
#'  using backends from two  different R packages:
#' * If `design$backend == "sim"`, the ECD is calculated using
#' `basksim::ecd`.
#' * If `design$backend == "exact"`, the ECD are calculated using
#' `baskexact::ecd`.
#'
#'
#' @inheritParams get_details.fujikawa_x
#' @inheritParams basksim::ecd
#' @inheritParams baskexact::ecd
#'
#' @inherit basksim::ecd return
#' @export
#'
#' @examples
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2)
#' ecd(design = design, n = 20, p1 = c(0.2, 0.5, 0.5), lambda = 0.95,
#'      design_params = list(epsilon = 2, tau = 0), iter = 100)
ecd.fujikawa_x <- function(design, n, p1, lambda,
                           epsilon, tau, logbase = 2,
                           design_params = list(epsilon = epsilon,
                                                tau = tau,
                                                logbase = logbase),
                           iter = 1000, data = NULL,
                           weight_fun = weights_jsd,
                           weight_params = design_params,
                           globalweight_fun = NULL,
                           globalweight_params = list(), ...){
  if(design$backend == "sim"){
    return(NextMethod())
  } else if(design$backend == "exact"){
    return(baskexact::ecd(design = design$design_exact, p1 = p1, n = n,
                          lambda = lambda, weight_fun = weight_fun,
                          weight_params = weight_params,
                          globalweight_fun = globalweight_fun,
                          globalweight_params = globalweight_params, ...))
  }  else {
    stop("design$backend must be 'sim' or 'exact'")
  }
}
