opt_design.fujikawa_x <- function(design, n, alpha, design_params = list(), scenarios,
                                  prec_digits, iter = 1000, data = NULL,
                                  weight_fun, weight_params = list(),
                                  globalweight_fun = NULL,
                                  globalweight_params = list(), ...){
  if(design$backend == "sim"){
    return(NextMethod())
  } else if(design$backend == "exact"){
    return(baskexact::opt_design(design = design$design_exact, n = n,
                          alpha = alpha, weight_fun = weight_fun,
                          weight_params = weight_params,
                          globalweight_fun = globalweight_fun,
                          globalweight_params = globalweight_params,
                          scenarios = scenarios, prec_digits = prec_digits,
                          ...))
  }  else {
    stop("design$backend must be 'sim' or 'exact'")
  }
}

