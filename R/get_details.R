#' Title
#'
#' @param design
#' @param n
#' @param p1
#' @param lambda
#' @param level
#' @param epsilon
#' @param tau
#' @param logbase
#' @param iter
#' @param data
#' @param ...
#'
#' @return
#'
#' @import basksim
#'
#' @export
#'
#' @examples
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2)
#' get_details(design = design, n = 20, p1 = c(0.2, 0.5, 0.5), lambda = 0.95,
#'             epsilon = 2, tau = 0, iter = 100)
get_details.fujikawa_x <- function(design, n, p1 = NULL, lambda, level = 0.95,
                                 epsilon, tau, logbase = 2, iter = 1000,
                                 data = NULL,
                                 weight_fun = baskexact::weights_fujikawa,
                                 weight_params = list(epsilon = epsilon,
                                                      tau = tau,
                                                      logbase = logbase),
                                 ...){
  if(design$backend == "sim"){
    return(c(NextMethod(), backend = "sim"))
  } else if(design$backend == "exact"){
    FWER <- numeric(0)
    EWP <- numeric(0)
    Rejection_Probabilities <- numeric(0)
    if(all(p1 != design$p0)){
      res <- baskexact::pow(design$design_exact, p1 = p1, n = n,
                            lambda = lambda, weight_fun = weight_fun,
                            weight_params = weight_params, results = "group")
      FWER <- 0
      EWP <- res$ewp
      Rejection_Probabilities <- res$rejection_probabilities
      message("No true null hypotheses, hence the type 1 error rate is 0.")
    } else if(all(p1 == design$p0)){
      res <- baskexact::toer(design$design_exact, p1 = p1, n = n,
                             lambda = lambda, weight_fun = weight_fun,
                             weight_params = weight_params, results = "group")
      FWER <- res$fwer
      EWP <- 0
      Rejection_Probabilities <- res$rejection_probabilities
      message("No true alternative hypotheses, hence the power is 0.")
    } else {
      res <- baskexact::toer(design$design_exact, p1 = p1, n = n,
                             lambda = lambda, weight_fun = weight_fun,
                             weight_params = weight_params, results = "group")
      res_ewp <- baskexact::toer(design$design_exact, p1 = p1, n = n,
                             lambda = lambda, weight_fun = weight_fun,
                             weight_params = weight_params, results = "ewp")
      FWER <- res$fwer
      EWP <- res_ewp
      Rejection_Probabilities <- res$rejection_probabilities
    }
    res_estim <- baskexact::estim(design = design$design_exact, p1 = p1, n = n,
                                  lambda = lambda, weight_fun = weight_fun,
                                  weight_params = weight_params,
                                  ...)
    return(list(
      Rejection_Probabilities = Rejection_Probabilities,
      FWER = FWER,
      EWP = EWP,
      Mean = res_estim$Mean,
      MSE = res_estim$MSE,
      Lower_CL = numeric(),
      Upper_CL = numeric(),
      backend = "exact"
    ))
  } else {
    stop("design$backend must be 'sim' or 'exact'")
  }
}
