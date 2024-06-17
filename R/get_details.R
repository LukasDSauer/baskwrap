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
#' For the `baskexact` backend, the number of details is a relevant factor for
#' the function's runtime. Hence, one can select precisely which details should
#' be calculated:
#' * If `which_details == "all"`, everything will be calculated.
#' * If `"FWER" %in% which_details`, then FWER will be calculated.
#' * If `"EWP" %in% which_details`, then EWP will be calculated.
#' * If `"Rejection_Probabilities" %in% which_details`, then per-basket
#' rejection probabilities will be calculated.
#' * If  `"ECD" %in% which_details`, then ECD will be calculated.
#' * If `"Mean" %in% which_details`, then mean response rate and its MSE
#'   will be calculated.
#'
#' @param design An object of class `fujikawa_x`.
#' @inheritParams basksim::get_details.fujikawa
#' @param weight_fun Which functions should be used to calculated the pairwise
#' weights? Default is `baskexact::weights_fujikawa`.
#' @param weight_params A list of tuning parameters specific to `weight_fun`.
#' By default, it takes the function arguments `epsilon`, `tau` and `logbase`.
#' @param which_details A character vector specifying which details should be
#' calculated. This is used only for `backend = "exact"`, where the number of
#' details is relevant for runtime. Default is `"all"`, see details for
#' explanation.
#' @param verbose A logical, should message be shown if EWP or FWER is 0.
#' Default is `TRUE`.
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
                                                        logbase = logbase),
                                   which_details = "all", verbose = TRUE){
  if(design$backend == "sim"){
    return(c(NextMethod(), backend = "sim"))
  } else if(design$backend == "exact"){
    res <- NULL
    FWER <- numeric(0)
    EWP <- numeric(0)
    Rejection_Probabilities <- numeric(0)
    ECD <- numeric(0)
    Mean <- numeric(0)
    MSE <- numeric(0)
    if(which_details == "all"){
      which_details <- c("FWER", "EWP", "Rejection_Probabilities", "ECD",
                         "Mean")
    }
    results_pow <- "ewp"
    results_toer <- "fwer"
    # Rejection probabilities can be calculated using the results = "group"
    # argument with the toer() or pow() function.
    if("Rejection_Probabilities" %in% which_details){
      if("EWP" %in% which_details){
        results_pow <- "group"
      } else{
        # We need to use either toer() or pow() to calculate per-basket
        # rejection rates. If pow() is not called, we make sure that toer() is
        # called.
        which_details <- c(which_details, "FWER")
        results_toer <- "group"
      }
    }
    if(all(p1 != design$p0) & "EWP" %in% which_details){
      res <- baskexact::pow(design$design_exact, p1 = p1, n = n,
                            lambda = lambda, weight_fun = weight_fun,
                            weight_params = weight_params,
                            results = results_pow)
      FWER <- 0
      if(results_pow == "group"){
        EWP <- res$ewp
      } else{
        EWP <- res
      }
      if(verbose){
        message("No true null hypotheses, hence the type 1 error rate is 0.")
      }
    } else if(all(p1 == design$p0) & "FWER" %in% which_details){
      res <- baskexact::toer(design$design_exact, p1 = p1, n = n,
                             lambda = lambda, weight_fun = weight_fun,
                             weight_params = weight_params,
                             results = results_toer)
      if(results_toer == "group"){
        FWER <- res$fwer
      } else{
        FWER <- res
      }
      EWP <- 0
      if(verbose){
        message("No true alternative hypotheses, hence the power is 0.")
      }
    } else {
      if("FWER" %in% which_details){
        res_fwer <- baskexact::toer(design$design_exact, p1 = p1, n = n,
                               lambda = lambda, weight_fun = weight_fun,
                               weight_params = weight_params,
                               results = results_toer)
        if(results_toer == "group"){
          FWER <- res_fwer$fwer
          res <- res_fwer
        } else{
          FWER <- res_fwer
        }
      }
      if("EWP" %in% which_details){
        res_ewp <- baskexact::pow(design$design_exact, p1 = p1, n = n,
                                  lambda = lambda, weight_fun = weight_fun,
                                  weight_params = weight_params,
                                  results = results_pow)
        if(results_pow == "group"){
          EWP <- res_ewp$ewp
          if(is.null(res)){
            res <- res_ewp
          }
        } else{
          EWP <- res_ewp
        }
      }
    }
    if("Mean" %in% which_details){
      res_estim <- baskexact::estim(design = design$design_exact, p1 = p1, n = n,
                                    lambda = lambda, weight_fun = weight_fun,
                                    weight_params = weight_params,
                                    ...)
      Mean <- res_estim$Mean
      MSE <- res_estim$MSE
    }
    if("ECD" %in% which_details){
      ECD <- baskexact::ecd(design = design$design_exact, p1 = p1, n = n,
                            lambda = lambda, weight_fun = weight_fun,
                            weight_params = weight_params, ...)
    }
    if("Rejection_Probabilities" %in% which_details){
      Rejection_Probabilities <- res$Rejection_Probabilities
    }
    return(list(
      Rejection_Probabilities = Rejection_Probabilities,
      FWER = FWER,
      EWP = EWP,
      Mean = Mean,
      MSE = MSE,
      Lower_CL = numeric(),
      Upper_CL = numeric(),
      ECD = ECD,
      p0 = design$p0,
      p1 = p1,
      backend = "exact"
    ))
  } else {
    stop("design$backend must be 'sim' or 'exact'")
  }
}
