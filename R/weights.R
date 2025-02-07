#' Weights based on Fujikawa et al.'s basket trial design
#'
#' The function `weights_fujikawa` is a wrapper of `baskexact::weights_fujikawa`.
#' The function `weights_fujikawa_vanilla` is a convenience wrapper
#' that calls this with `epsilon = 1` and `tau = 0`
#' without pruning. Hence, this function returns precisely Fujikawa et al.'s
#' weights without any tuning. The function `weights_fujikawa_tuned` tunes an
#' existing weight matrix using the parameters `epsilon` and `tau` in accordance
#' with Fujikawa et al.'s tuning rules.
#'
#' @inheritParams get_details.fujikawa_x
#' @param weight_mat An untuned matrix including the weights of all possible
#' pairwise outcomes.
#' @return A matrix including the weights of all possible pairwise outcomes.
#'
#' @export
#'
#' @examples
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2, backend = "exact")
#' weight_mat <- weights_fujikawa_vanilla(design, n = 20, logbase = 2)
#' weight_mat_tuned <- weights_fujikawa_tuned(weight_mat, epsilon = 1.25,
#'                                            tau = 0.5)
weights_fujikawa <- function(design, n, logbase, epsilon, tau, ...){
  if(is.null(design$design_exact)){
    design <- set_design_exact(design)
  }
  unclass(baskexact::weights_fujikawa(design = design$design_exact, n = n,
                                     lambda = NULL,
                                     epsilon = 1, tau = 0,
                                     logbase = logbase, ...))
}
#' @export
#' @rdname weights_fujikawa
weights_fujikawa_vanilla <- function(design, n, logbase, ...){
  return(weights_fujikawa(design, n, logbase, epsilon = 1, tau = 0, ...))
}
#' @export
#' @rdname weights_fujikawa
weights_fujikawa_tuned <- function(weight_mat, epsilon = 1.25,
                                   tau = 0.5, ...){
  weight_mat <- weight_mat^epsilon
  weight_mat[weight_mat <= tau] <- 0
  return(weight_mat)
}
