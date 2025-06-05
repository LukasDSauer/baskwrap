#' Weights based on Fujikawa et al.'s basket trial design
#'
#' The function `weights_fujikawa` is a wrapper of `baskexact::weights_fujikawa`.
#' The function `weights_fujikawa_vanilla` is a convenience wrapper
#' that calls this with `epsilon = 1` and `tau = 0`
#' without pruning. Hence, this function returns precisely Fujikawa et al.'s
#' weights without any tuning. The function `weights_fujikawa_tuned` tunes an
#' existing weight matrix using the parameters `epsilon` and `tau` in accordance
#' with Fujikawa et al.'s tuning rules. The function `weights_hellinger` and
#' the "convenience wrapper" `weights_hellinger_vanilla` are a variant of the
#' weights defined by Fujikawa were the divergence is calculated using the
#' Hellinger distance instead of the Jensen-Shannon divergence (see Details).
#'
#' For posterior
#' beta distributions as in Fujikawa's design, the Hellinger distance can be
#' calculated "analytically", e.g. for posterior parameters \eqn{(a_1,b_1)} and
#' \eqn{(a_2,b_2)}, we have
#' \deqn{HLD(\mathrm{Beta}(a_1,b_1),\mathrm{Beta}(a_2,b_2)) = 1 - \frac{B(\frac{a_1+a_2}{2},\frac{b_1+b_2}{2})}{\sqrt{B(a_1,b_1)B(a_2,b_2)}},}
#' where \eqn{B(\cdot,\cdot)} is the beta function (Sasha 2012).
#'
#' @references Sasha. Answer to "Hellinger distance between Beta distributions";
#' 2012. Available from: https://math.stackexchange.com/a/165399/332808
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
weights_fujikawa_x <- function(design, n, logbase, epsilon, tau, ...){
  if("fujikawa_x" %in% class(design)){
    if(is.null(design$design_exact)){
      design <- set_design_exact(design)
    }
    return(baskexact::weights_fujikawa(design = design$design_exact,
                                n = n,
                                lambda = NULL,
                                epsilon = epsilon,
                                tau = tau,
                                logbase = logbase, ...))
  } else if(!is.null(attr(class(design), "package"))){
    if("baskexact" %in% attr(class(design), "package")){
      if("OneStageBasket" %in% class(design)){
        return(baskexact::weights_fujikawa(
          design = design,
          n = n,
          lambda = NULL,
          epsilon = epsilon,
          tau = tau,
          logbase = logbase,
          ...
        ))
      } else {
        stop("weights_fujikawa_x is not yet implemented for designs of class ",
             class(design), " from ", attr(design, "package"))
      }
    }
  }
}
#' @export
#' @rdname weights_fujikawa_x
weights_fujikawa_vanilla <- function(design, n, logbase, ...){
  return(weights_fujikawa_x(design, n, logbase, epsilon = 1, tau = 0, ...))
}
#' @export
#' @rdname weights_fujikawa_x
weights_fujikawa_tuned <- function(weight_mat, epsilon = 1.25,
                                   tau = 0.5, ...){
  weight_mat <- weight_mat^epsilon
  weight_mat[weight_mat <= tau] <- 0
  return(weight_mat)
}
#' @export
#' @rdname weights_fujikawa_x
weights_hellinger_vanilla <- function(design, n, ...){
  shape1_post <- design$shape1 + c(0:n)
  shape2_post <- design$shape2 + c(n:0)
  n_sum <- n + 1
  hld_mat <- matrix(0, nrow = n_sum, ncol = n_sum)
  for (i in 1:n_sum) {
    for (j in i:n_sum) {
      if (i == j) {
        next
      } else {
        hld_mat[i, j] <- 1 - beta((shape1_post[i] + shape1_post[j])/2,
                                  (shape2_post[i] + shape2_post[j])/2)/
          sqrt(beta(shape1_post[i], shape2_post[i])*
                 beta(shape1_post[j], shape2_post[j]))
      }
    }
  }
  hld_mat <- hld_mat + t(hld_mat)
  return(hld_mat)
}
#' @export
#' @rdname weights_fujikawa_x
weights_hellinger <- function(design, n, epsilon, tau, ...){
  browser()
  hld_mat <- weights_hellinger_vanilla(design, n)
  return(weights_fujikawa_tuned(hld_mat, epsilon = epsilon, tau = tau))
}
