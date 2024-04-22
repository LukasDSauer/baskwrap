#' Weights Based on Fujikawa et al.'s Design
#'
#' This wrapper functions returns the borrowing weights defined for Fujikawa
#' et al's basket trial design using the function `baskexact::weights_fujikawa`
#' (changing the attribute `design$backend` doesn't change anything here).
#' For future adaptations, this function is an S3 generic.
#'
#' @inheritParams get_details.fujikawa_x
#' @inherit baskexact::weights_fujikawa return
#'
#' @export
#'
#' @examples
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2, backend = "exact")
#' toer(design, n = 15, epsilon = 2, lambda = 0.99,
#'      weight_fun = baskexact::weights_fujikawa)
weights_fujikawa <- function(design, ...) {
  UseMethod("weights_fujikawa", design)
}
#' @rdname weights_fujikawa
#' @export
weights_fujikawa.fujikawa_x <- function(design, n, lambda, epsilon = 1.25,
                                        tau = 0.5, logbase = 2,
                                        prune = FALSE, globalweight_fun = NULL,
                                        globalweight_params = list(), ...){
  if(is.null(design$design_exact)){
    design <- set_design_exact(design)
  }
  return(baskexact::weights_fujikawa(design = design$design_exact, n = n,
                                     lambda = lambda, epsilon = epsilon,
                                     tau = tau, logbase = logbase,
                                     prune = prune,
                                     globalweight_fun = globalweight_fun,
                                     globalweight_params = globalweight_params))
}
