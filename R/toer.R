#' Calculate the Type 1 Error Rate for a Basket Trial Design
#'
#' Generic function for calculating the type-1 error rate of a basket trial
#' design. It defaults to the function `basksim::toer`.
#'
#' @param design An object created with one of the `setup` functions from
#' the `basksim` package.
#' @inheritParams basksim::toer
#'
#' @inherit basksim::toer return
#' @export
#'
#' @examples
#' # Example for a basket trial with Fujikawa's Design
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2)
#' toer(design = design, n = 20, p1 = c(0.2, 0.5, 0.5), lambda = 0.95,
#'      design_params = list(epsilon = 2, tau = 0), iter = 100)
toer <- function(design, ...) {
  UseMethod("toer", design)
}
#' @rdname toer
#' @export
toer.default <- function(design, ...) {
  return(basksim::toer(design, ...))
}

#' Calculate the Type 1 Error Rate for a Fujikawa et al.'s Basket Trial Design
#'
#'  This wrapper functions returns the type-1 error rate (TOER) for Fujikawa et al.'s
#'  basket trial design. The TOER is calculated using backends from two
#'  different R packages:
#' * If `design$backend == "sim"`, the TOER is calculated using
#' `basksim::toer`.
#' * If `design$backend == "exact"`, the TOER are calculated using
#' `baskexact::toer`.
#'
#'
#' @inheritParams get_details.fujikawa_x
#' @inheritParams basksim::toer
#' @inheritParams baskexact::toer
#'
#' @inherit basksim::toer return
#' @export
#'
#' @examples
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2)
#' toer(design = design, n = 20, p1 = c(0.2, 0.5, 0.5), lambda = 0.95,
#'      design_params = list(epsilon = 2, tau = 0), iter = 100)
toer.fujikawa_x <- function(design,
                            n,
                            p1 = NULL,
                            lambda,
                            epsilon = epsilon,
                            tau = tau,
                            logbase = logbase,
                            design_params = list(epsilon = epsilon,
                                                 tau = tau,
                                                 logbase = logbase),
                            iter = 1000,
                            data = NULL,
                            weight_fun = baskexact::weights_fujikawa,
                            weight_params = design_params,
                            globalweight_fun = NULL,
                            globalweight_params = list(),
                            results = c("fwer", "group"),...){
  if(design$backend == "sim"){
    return(NextMethod())
  } else if(design$backend == "exact"){
    return(baskexact::toer(design$design_exact, p1 = p1, n = n, lambda = lambda,
                    weight_fun = weight_fun, weight_params = weight_params,
                    globalweight_fun = globalweight_fun,
                    globalweight_params = globalweight_params,
                    results = results, ...))
  }  else {
    stop("design$backend must be 'sim' or 'exact'")
  }
}

