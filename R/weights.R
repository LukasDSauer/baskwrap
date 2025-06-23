#' Further weight functions
#'
#' A couple of weight functions additional to the ones implemented in `baskexact`
#' are supplied. The weight functions are based on the Jensen-Shannon divergence
#' (JSD) and the Hellinger distance (HLD). The function `weights_jsd` is a
#' wrapper of `baskexact::weights_fujikawa`. It can be used with both designs
#' of class
#' `fujikawa_x` (from the `baskwrap` package) and designs of class `OneStageBasket`
#' (from the `baskexact` package). The function `weights_jsd_vanilla` is a
#' convenience wrapper that calls this with `epsilon = 1` and `tau = 0`
#' without pruning. Hence, this function returns precisely Fujikawa et al.'s
#' weights without any tuning. The function `weights_fujikawa_tuned` tunes an
#' existing weight matrix using the parameters `epsilon` and `tau` in accordance
#' with Fujikawa et al.'s tuning rules. The function `weights_hld` and
#' the "convenience wrapper" `weights_hld_vanilla` are a variant of Fujikawa's
#' weights where the similarity is calculated using 1 minus
#' Hellinger distance instead of 1 minus Jensen-Shannon divergence (see Details).
#'
#' For posterior
#' beta distributions as in Fujikawa's design, the Hellinger distance can be
#' calculated "analytically", e.g. for posterior parameters \eqn{(a_1,b_1)} and
#' \eqn{(a_2,b_2)}, we have
#' \deqn{HLD(\mathrm{Beta}(a_1,b_1),\mathrm{Beta}(a_2,b_2)) = 1 - \frac{B(\frac{a_1+a_2}{2},\frac{b_1+b_2}{2})}{\sqrt{B(a_1,b_1)B(a_2,b_2)}},}
#' where \eqn{B(\cdot,\cdot)} is the beta function (Sasha 2012). The similarity
#' between strata is calculated as \eqn{1-HLD(\cdot,\cdot)}.
#'
#' @references Sasha. Answer to "Hellinger distance between Beta distributions";
#' 2012. Available from: https://math.stackexchange.com/a/165399/332808
#'
#' @inheritParams get_details.fujikawa_x
#' @param design An object of class `fujikawa_x` or of class `OneStageBasket`
#' from the `baskexact` package.
#' @param lambda The posterior probability threshold, currently only used
#' for designs with `"exact"` backend where pruning is activated. See
#' documentation of `baskexact::weights_fujikawa` for more information.
#' @param weight_mat An untuned matrix including the weights of all possible
#' pairwise outcomes.
#' @return A matrix including the weights of all possible pairwise outcomes.
#'
#' @export
#'
#' @examples
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2, backend = "exact")
#' weight_mat <- weights_jsd_vanilla(design, n = 20, logbase = 2)
#' weight_mat_tuned <- weights_fujikawa_tuned(weight_mat, epsilon = 1.25,
#'                                            tau = 0.5)
#' # In theory, this weights_function is also compatible with baskexact.
#' baskexact::toer(design$design_exact, n = 20,
#'                 lambda = 0.95, weight_fun = weights_jsd,
#'                 weight_params = list(epsilon = 2,
#'                                      tau = 0,
#'                                      logbase = 2))
#' # Use different function in get_details
#' get_details(design = design, n = 20, p1 = c(0.2, 0.5, 0.5), lambda = 0.95,
#'             epsilon = 2, tau = 0, weight_fun = weights_jsd,
#'             logbase = exp(1))
#' get_details(design = design, n = 20, p1 = c(0.2, 0.5, 0.5), lambda = 0.95,
#'             epsilon = 2, tau = 0, weight_fun = weights_hld,
#'             logbase = exp(1))
weights_jsd <- function(design, n, logbase, epsilon, tau, lambda = NULL, ...){
  if("fujikawa_x" %in% class(design)){
    if(is.null(design$design_exact)){
      design <- set_design_exact(design)
    }
    return(baskexact::weights_fujikawa(design = design$design_exact,
                                n = n,
                                lambda = lambda,
                                epsilon = epsilon,
                                tau = tau,
                                logbase = logbase, ...))
  } else if(!is.null(attr(class(design), "package"))){
    if("baskexact" %in% attr(class(design), "package")){
      if("OneStageBasket" %in% class(design)){
        return(baskexact::weights_fujikawa(
          design = design,
          n = n,
          lambda = lambda,
          epsilon = epsilon,
          tau = tau,
          logbase = logbase,
          ...
        ))
      } else {
        stop("weights_jsd is not yet implemented for designs of class ",
             class(design), " from ", attr(design, "package"))
      }
    }
  } else if ("fujikawa" %in% class(design)) {
    weights_jsd(design = convert_to_fujikawa_x(design), n = n,
                logbase = logbase, epsilon = epsilon, tau = tau,
                lambda = lambda, ...)
  } else {
    stop("weights_jsd is not yet implemented for this design object.")
  }
}
#' @export
#' @rdname weights_jsd
weights_jsd_vanilla <- function(design, n, logbase, ...){
  return(weights_jsd(design, n, logbase, epsilon = 1, tau = 0, ...))
}
#' @export
#' @rdname weights_jsd
weights_fujikawa_tuned <- function(weight_mat, epsilon = 1.25,
                                   tau = 0.5, ...){
  weight_mat <- weight_mat^epsilon
  weight_mat[weight_mat <= tau] <- 0
  return(weight_mat)
}
#' @export
#' @rdname weights_jsd
weights_hld_vanilla <- function(design, n, ...){
  if(is_baskexact_design(design, "OneStageBasket")){
    design <- convert_to_fujikawa_x(design)
  } else if(!("fujikawa_x" %in% class(design))){
    stop("design must be of class fujikawa_x or of class OneStageBasket.")
  }
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
  hld_mat <- 1 - (hld_mat + t(hld_mat))
  class(hld_mat) <- "fujikawa"
  return(hld_mat)
}
#' @export
#' @rdname weights_jsd
weights_hld <- function(design, n, epsilon, tau, ...){
  hld_mat <- weights_hld_vanilla(design, n)
  return(weights_fujikawa_tuned(hld_mat, epsilon = epsilon, tau = tau))
}
