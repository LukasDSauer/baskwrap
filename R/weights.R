#' Weights based on Fujikawa et al.'s basket trial design
#'
#' The function `weights_fujikawa_vanilla` is a wrapper of
#' `baskexact::weights_fujikawa` and calls this with `epsilon = 1` and `tau = 0`
#' without pruning. Hence, this function returns precisely Fujikawa et al.'s
#' weights without any tuning. The function `weights_fujikawa_tuned` tunes an
#' existing weight matrix using the parameters `epsilon` and `tau` in accordance
#' with Fujikawa et al.'s tuning rules.
#'
#' Note that the function `weights_fujikawa_vanilla` changes the class of the
#' weight matrix in order to avoid a name clash. The output of
#' `baskexact::weights_fujikawa` is of class `"fujikawa"` which is identical to
#' the basket design class from `basksim`. Hence, the output of this function is
#' named `"weight_mat_fujikawa"`.
#'
#' @inheritParams baskexact::weights_fujikawa
#' @return A matrix including the weights of all possible pairwise outcomes.
#' @export
#'
#' @examples
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2, backend = "exact")
#' weight_mat <- weights_fujikawa_vanilla(design, n = 20)
#' weight_mat_tuned <- weights_fujikawa_tuned(weight_mat, epsilon = 1.25,
#'                                            tau = 0.5, logbase = 2, ...)
weights_fujikawa_vanilla <- function(design, n, ...){
  if(is.null(design$design_exact)){
    design <- set_design_exact(design)
  }
  weight_mat <- baskexact::weights_fujikawa(design = design$design_exact, n = n,
                                            lambda = NULL,
                                            epsilon = 1, tau = 0, ...)
  class(weight_mat) <- "weight_mat_fujikawa"
  return(weight_mat)
}

#' @rdname weights_fujikawa_vanilla
weights_fujikawa_tuned <- function(weight_mat, epsilon = 1.25,
                                   tau = 0.5, logbase = 2, ...){
  weight_mat <- weight_mat^epsilon
  weight_mat[weight_mat <= tau] <- 0
  return(weight_mat)
}
