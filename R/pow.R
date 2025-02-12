#' Calculate the Power for a Basket Trial Design
#'
#' Generic function for calculating the power of a basket trial
#' design. It defaults to the function `pow.default` which works similarly to
#' `basksim::toer` and does not rely on any `baskwrap`-specific function.
#'
#' @param design An object created with one of the `setup` functions from
#' the `basksim` package.
#' @inheritParams basksim::toer
#' @param p1 Probabilities under the alternative hypothesis. If
#' `length(p1) == 1`, then this is a common probability for all baskets.
#'
#' @inherit basksim::toer return
#' @export
#'
#' @examples
#' # Example for a basket trial with Fujikawa's Design
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2)
#' pow(design = design, n = 20, p1 = c(0.2, 0.5, 0.5), lambda = 0.95,
#'      design_params = list(epsilon = 2, tau = 0), iter = 100)
pow <- function(design, ...) {
  UseMethod("pow", design)
}
#' @rdname pow
#' @export
pow.default <- function(design, n, p1 = NULL, lambda, design_params = list(),
                        iter = 1000, data = NULL, ...) {
  res <- do.call(basksim::get_results,
                 args = c(design = list(design), n = list(n),
                          p1 = list(p1), lambda = lambda, design_params,
                          iter = iter, data = list(data), ...))
  res_sel <- res[, p1 != design$p0, drop = FALSE]
  res_all <- apply(res_sel, 1, function(x) any(x == 1))
  return(mean(res_all))
}

#' Calculate the Power for a Fujikawa et al.'s Basket Trial Design
#'
#'  This wrapper functions returns the power for Fujikawa et al.'s
#'  basket trial design. The power is calculated using backends from two
#'  different R packages:
#' * If `design$backend == "sim"`, the power is calculated using
#' `basksim::pow`.
#' * If `design$backend == "exact"`, the power is calculated using
#' `baskexact::pow`.
#'
#'
#' @inheritParams get_details.fujikawa_x
#' @inheritParams pow.default
#' @inheritParams baskexact::pow
#'
#' @inherit pow.default return
#' @export
#'
#' @examples
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2)
#' pow(design = design, n = 20, p1 = c(0.2, 0.5, 0.5), lambda = 0.95,
#'      design_params = list(epsilon = 2, tau = 0), iter = 100)
pow.fujikawa_x <- function(design, n, p1 = NULL, lambda,
                           epsilon, tau, logbase = 2,
                           design_params = list(epsilon = epsilon,
                                                tau = tau,
                                                logbase = logbase),
                           iter = 1000, data = NULL,
                           weight_fun = baskexact::weights_fujikawa,
                           weight_params = design_params,
                           globalweight_fun = NULL,
                           globalweight_params = list(),
                           results = c("ewp", "group"),...){
  if(design$backend == "sim"){
    return(NextMethod())
  } else if(design$backend == "exact"){
    return(baskexact::pow(design$design_exact, p1 = p1, n = n, lambda = lambda,
                           weight_fun = weight_fun, weight_params = weight_params,
                           globalweight_fun = globalweight_fun,
                           globalweight_params = globalweight_params,
                           results = results, ...))
  }  else {
    stop("design$backend must be 'sim' or 'exact'")
  }
}
