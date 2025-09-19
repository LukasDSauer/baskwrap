#' Calculate the Posterior Mean and Mean Squared Error for a Basket Trial Design
#'
#' Generic function for calculating the posterior mean and
#' mean squared error of a basket trial design. It defaults to the function
#' `estim.default` which does not rely on any `baskwrap`-specific function.
#'
#' `estim.default` is in fact just a wrapper of `basksim::get_details()` that
#' select posterior mean and mean squared error.
#'
#' @inheritParams pow
#' @inheritParams get_details.fujikawa_x
#'
#' @return A list containing means of the posterior distribution and
#' the mean squared errors for all baskets.
#'
#' @export
#'
#' @examples
#' # Example for a basket trial with Fujikawa's Design
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2)
#' estim(design = design, n = 20, p1 = c(0.2, 0.5, 0.5), lambda = 0.95,
#'      epsilon = 2, tau = 0, iter = 100)
estim <- function(design, ...) {
  UseMethod("estim", design)
}
#' @rdname estim
#' @export
estim.default <- function(design, ...) {
  res <- get_details(design = design, ...)
  return(list(
    Mean = res$Mean,
    MSE = res$MSE))
}
#' @rdname estim
#' @export
estim.fujikawa_x <- function(design, n, p1, lambda = NULL, epsilon, tau,
                             logbase = 2, iter = 1000,
                             weight_fun = weights_jsd,
                             weight_params = list(epsilon = epsilon,
                                                  tau = tau,
                                                  logbase = logbase),
                             globalweight_fun = NULL,
                             globalweight_params = list(), ...){
  res <- list()
  if(design$backend == "sim"){
    return(c(NextMethod(), backend = "sim"))
  } else if(design$backend == "exact"){
    res <- baskexact::estim(design = design$design_exact, p1 = p1, n = n,
                            lambda = lambda, weight_fun = weight_fun,
                            weight_params = weight_params,
                            globalweight_fun = globalweight_fun,
                            globalweight_params = globalweight_params, ...)
  } else {
    stop("design$backend must be 'sim' or 'exact'")
  }
  return(list(
    Mean = res$Mean,
    MSE = res$MSE,
    backend = "exact"
  ))
}
