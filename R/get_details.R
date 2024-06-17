#' @importFrom basksim get_details
#' @export
basksim::get_details
#' Get Details of a Basket Trial Simulation with Fujikawa's Design
#'
#' This wrapper functions returns details for basket trial design.
#'
#' It calculates the details using backends from two different R packages:
#' * If `design$backend == "sim"`, the details are calculated using
#' `basksim::get_details.fujikawa`.
#' * If `design$backend == "exact"`, the details are calculated using
#' `baskexact::toer`, `baskexact::pow` and `baskexact::estim`. Note that the
#' standard weight function `baskexact::weights_fujikawa` calculates the weights
#' anew for each of the three function calls. This may compromise performance
#' and can be fixed by manually calculating the weights beforehand.
#'
#'
#' @param design An object of class `fujikawa_x`.
#' @inheritParams basksim::get_details.fujikawa
#' @param weight_fun Which functions should be used to calculated the pairwise
#' weights? Default is `baskexact::weights_fujikawa`.
#' @param weight_params A list of tuning parameters specific to `weight_fun`.
#' By default, it takes the function arguments `epsilon`, `tau` and `logbase`.
#' @param ... Further arguments.
#'
#' @inherit basksim::get_details.fujikawa return
#'
#' @examples
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2)
#' get_details(design = design, n = 20, p1 = c(0.2, 0.5, 0.5), lambda = 0.95,
#'             epsilon = 2, tau = 0, iter = 100)
#' design_x <- setup_fujikawa_x(k = 3, p0 = 0.2, backend = "exact")
#' get_details(design = design_x, n = 20, p1 = c(0.2, 0.5, 0.5), lambda = 0.95,
#'             epsilon = 2, tau = 0, weight_fun = baskexact::weights_fujikawa,
#'             logbase = exp(1))
#' # If you call get_details() with backend = "exact" multiple without
#' # changing design and n, it can make sense to save the weights and supply
#' # them separately using a custom function. This can save run time.
#' weight_mat_vanilla <- weights_fujikawa_vanilla(design_x, n = 20,
#'                                                logbase = exp(1))
#' weights_from_save <- function(epsilon,
#'                               tau,
#'                               ...) {
#'   return(weights_fujikawa_tuned(weight_mat_vanilla,
#'                                 epsilon = epsilon,
#'                                 tau = tau))
#' }
#' get_details(design = design_x,
#'             n = 20,
#'             p1 = c(0.2, 0.5, 0.5),
#'             lambda = 0.95,
#'             epsilon = 2, tau = 0,
#'             weight_fun = weights_from_save,
#'             logbase = NULL)
#' @export
get_details.fujikawa_x <- function(design, ...,
                                   n, p1 = NULL, lambda, level = 0.95,
                                   epsilon, tau, logbase = 2, iter = 1000,
                                   data = NULL,
                                   weight_fun = baskexact::weights_fujikawa,
                                   weight_params = list(epsilon = epsilon,
                                                        tau = tau,
                                                        logbase = logbase)){
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
      res_ewp <- baskexact::pow(design$design_exact, p1 = p1, n = n,
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
    res_ecd <- baskexact::ecd(design = design$design_exact, p1 = p1, n = n,
                              lambda = lambda, weight_fun = weight_fun,
                              weight_params = weight_params, ...)
    return(list(
      Rejection_Probabilities = Rejection_Probabilities,
      FWER = FWER,
      EWP = EWP,
      Mean = res_estim$Mean,
      MSE = res_estim$MSE,
      Lower_CL = numeric(),
      Upper_CL = numeric(),
      ECD = res_ecd,
      p0 = design$p0,
      p1 = p1,
      backend = "exact"
    ))
  } else {
    stop("design$backend must be 'sim' or 'exact'")
  }
}
