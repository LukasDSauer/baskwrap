estim.fujikawa_x <- function(design, n, p1, lambda = NULL, epsilon, tau,
                             logbase = 2, iter = 1000,
                             weight_fun = baskexact::weights_fujikawa,
                             weight_params = list(epsilon = epsilon,
                                                  tau = tau,
                                                  logbase = logbase),
                             globalweight_fun = NULL,
                             globalweight_params = list(), ...){
  res <- list()
  if(design$backend == "sim"){
    res <- get_details(design = design, n = n, p1 = p1, lambda = lambda,
                       epsilon = epsilon, tau = tau,
                       logbase = logbase, iter = iter)
    return(c(NextMethod(), backend = "sim"))
  } else if(design$backend == "exact"){
    res <- baskexact::estim(design = design$design_exact, p1 = p1, n = n,
                            lambda = lambda, weight_fun = weight_fun,
                            weight_params = weight_params,
                            globalweight_fun = globalweight_fun,
                            globalweight_params = globalweight_params, ...)
  } else {
    stop("design$backend must be 'sim' or 'exact'")
  }
  return(list(
    Mean = res$Mean,
    MSE = res$MSE,
    backend = "exact"
  ))
}
