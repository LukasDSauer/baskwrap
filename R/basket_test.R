#' Test for the results of a basket trial
#'
#' Generic function for calculating the posterior probabilities of a basket trial
#' design.
#' @inheritParams pow
#'
#' @inherit basket_test.fujikawa_x examples
#' @export
basket_test <- function(design, ...) {
  UseMethod("basket_test", design)
}
#' Test for the results of a basket trial
#'
#' This function is a wrapper of `baskexact::basket_test()`. It returns the
#' posterior probabilities of a basket trial including borrowing.
#'
#' @inheritParams get_details.fujikawa_x
#' @param r A numeric vector of the number of responses in each stratum.
#'
#' @returns A numeric vector of posterior probabilities for all strata.
#' @export
#'
#' @examples
#' design_x <- setup_fujikawa_x(k = 3, p0 = 0.2, backend = "exact")
#' basket_test(design = design_x, n = 20, r = c(2, 7, 19), lambda = 0.95,
#'             epsilon = 2, tau = 0,
#'             logbase = exp(1))
basket_test.fujikawa_x <- function(design, n, r, lambda,
                                   epsilon, tau, logbase = 2,
                                   weight_fun = weights_jsd,
                                   weight_params = list(epsilon = epsilon,
                                                        tau = tau,
                                                        logbase = logbase),
                                   ...){
  if(is.null(design$design_exact)){
    design <- set_design_exact(design)
  }
  return(baskexact::basket_test(design = design$design_exact, n = n,
                                r = r, lambda = lambda,
                                weight_fun = weight_fun,
                                weight_params = weight_params,
                                details = TRUE, ...))
}

