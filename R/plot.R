#' Plot Weights of a Basket Trial Design
#'
#' Generic function for plotting the weights of a basket trial design. Currently
#' only implemented for designs of class `fujikawa_x`.
#'
#' @inheritParams pow
#' @inherit plot_weights.fujikawa_x examples
basket_test <- function(design, ...) {
  UseMethod("basket_test", design)
}
#' Plot Weight Functions of Fujikawa et al.'s Basket Trial Design
#'
#' This function is a wrapper of `baskexact::plot_weights()`. It visualizes
#' the weight functions defined for Fujikawa et al.'s design.
#'
#' @inheritParams baskexact::plot_weights
#' @export
#'
#' @examples
#' design_x <- setup_fujikawa_x(k = 3, p0 = 0.2, backend = "exact")
#' plot_weights(design = design_x, n = 20, r1 = c(2, 7, 19))
plot_weights.fujikawa_x <- function(design, n, r1, weight_fun,
                                    weight_params = list()) {
  if(is.null(design$design_exact)){
    design <- set_design_exact(design)
  }
  return(baskexact::plot_weights(design = design$design_exact,
                                 n = n, r1 = r1,
                                 weight_fun = weight_fun,
                                 weight_params = weight_params))
}
