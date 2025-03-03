#' Check Within- And Between-Trial Monotonicity Of A Basket Trial Design
#'
#' Generic function for checking monotonicity conditions of a basket trial
#' design. Currently only implemented for designs of class `fujikawa_x`. In
#' that case, the functions are wrappers of `baskexact::check_mon_within()` and
#' `baskexact::check_mon_between()`.
#'
#' Details on the within- and between-trial monotonicity conditions can be found
#' in Baumann et al. 2022.
#'
#' @section References:
#' Baumann, L., Krisam, J., & Kieser, M. (2022). Monotonicity conditions for
#'  avoiding counterintuitive decisions in basket trials. Biometrical Journal,
#'  64(5), 934-947.
#'
#' @examples
#' design <- setup_fujikawa_x(k = 4, shape1 = 1, shape2 = 1, p0 = 0.2)
#' check_mon_within(design = design, n = 24, lambda = 0.99,
#'                  weight_fun = baskexact::weights_fujikawa,
#'                  weight_params = list(epsilon = 0.5, tau = 0),
#'                  details = TRUE)
#' check_mon_between(design = design, n = 24, lambda = 0.99,
#'                   weight_fun = baskexact::weights_fujikawa,
#'                   weight_params = list(epsilon = c(0.5, 1),
#'                                        tau = c(0, 0.2, 0.3)),
#'                   globalweight_fun = baskexact::globalweights_fix,
#'                   globalweight_params = list(w = c(0.5, 0.7)))
#'
#' @inheritParams pow
#' @inherit plot_weights.fujikawa_x examples
#' @export
check_mon_within <- function(design, ...) {
  UseMethod("check_mon_within", design)
}
#' @export
#' @rdname check_mon_within
check_mon_between <- function(design, ...) {
  UseMethod("check_mon_between", design)
}
#' @export
#' @inheritParams baskexact::check_mon_within
#' @rdname check_mon_within
check_mon_within.fujikawa_x <- function(design, n, lambda, weight_fun,
                                        weight_params = list(),
                                        globalweight_fun = NULL,
                                        globalweight_params = list(),
                                        details = TRUE, ...) {
  if(is.null(design$design_exact)){
    design <- set_design_exact(design)
  }
  return(baskexact::check_mon_within(design = design$design_exact, n = n,
                                     lambda = lambda, weight_fun = weight_fun,
                                     weight_params = weight_params,
                                     globalweight_fun = globalweight_fun,
                                     globalweight_params = globalweight_params,
                                     details = details, ...))
}
#' @export
#' @inheritParams baskexact::check_mon_between
#' @rdname check_mon_within
check_mon_between.fujikawa_x <- function(design, n, lambda, weight_fun,
                                         weight_params = list(),
                                         details = TRUE,
                                         globalweight_fun = NULL,
                                         globalweight_params = list(),
                                         ...) {
  if(is.null(design$design_exact)){
    design <- set_design_exact(design)
  }
  return(baskexact::check_mon_between(design = design$design_exact, n = n,
                                      lambda = lambda, weight_fun = weight_fun,
                                      weight_params = weight_params,
                                      details = details,
                                      globalweight_fun = globalweight_fun,
                                      globalweight_params = globalweight_params,
                                      ...))
}
