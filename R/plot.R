#' Plot Weights of a Basket Trial Design
#'
#' Generic function for plotting the weights of a basket trial design. Currently
#' only implemented for designs of class `fujikawa_x`.
#'
#' @inheritParams pow
#' @inherit plot_weights.fujikawa_x examples
#' @export
plot_weights <- function(design, ...) {
  UseMethod("plot_weights", design)
}
#' Plot Weight Functions of Fujikawa et al.'s Basket Trial Design
#'
#' This function is a wrapper of `baskexact::plot_weights()`. It visualizes
#' the weight functions defined for Fujikawa et al.'s design.
#'
#' @inheritParams plot_weights
#' @inheritParams baskexact::plot_weights
#' @export
#'
#' @examples
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2, backend = "exact")
#' # Default weight function is weights_jsd, which is identical
#' # to the Jensen-Shannon weights
#' plot_weights(design = design, n = 20, r1 = 11,
#'              weight_params = list(tau = 0, epsilon = c(0.25, 0.5, 1, 2)))
#' # Explicitly compare Jensen-Shannon and Hellinger weights
#' plot_weights(design = design, n = 20, r1 = 11,
#'              weight_fun = baskexact::weights_fujikawa,
#'              weight_params = list(tau = 0, epsilon = c(0.25, 0.5, 1, 2),
#'                                   logbase = 2))
#' plot_weights(design = design, n = 20, r1 = 11, weight_fun = weights_hld,
#'              weight_params = list(tau = 0, epsilon = c(0.25, 0.5, 1, 2)))
plot_weights.fujikawa_x <- function(design,
                                    n,
                                    r1,
                                    weight_fun = weights_jsd,
                                    weight_params = list(),
                                    ...) {
  if(is.null(design$design_exact)){
    design <- set_design_exact(design)
  }
  return(baskexact::plot_weights(design = design$design_exact,
                                 n = n, r1 = r1,
                                 weight_fun = weight_fun,
                                 weight_params = weight_params))
}
