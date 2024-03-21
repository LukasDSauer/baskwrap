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
                                 data = NULL, ...){
  if(design$backend == "sim"){
    return(NextMethod())
  } else if(design$backend == "exact"){
    res_fwer <- baskexact::toer(design$design_exact,
                                p1 = p1, n = n,
                                lambda = lambda,
                                weight_fun = baskexact::weights_fujikawa,
                                weight_params = list(epsilon = epsilon,
                                                     tau = tau,
                                                     logbase = logbase),
                                results = "group")
    ewp <- baskexact::pow(design$design_exact,
                          p1 = p1, n = n,
                          lambda = lambda,
                          weight_fun = baskexact::weights_fujikawa,
                          weight_params = list(epsilon = epsilon,
                                               tau = tau,
                                               logbase = logbase),
                          results = "ewp")
    return(list(
      Rejection_Probabilities = res_fwer$rejection_probabilities,
      FWER = res_fwer$fwer,
      EWP = ewp,
      Mean = numeric(),
      MSE = numeric(),
      Lower_CL = numeric(),
      Upper_CL = numeric()
    ))
  }
}
