ecd.fujikawa_x <- function(design, n, p1, lambda, design_params = list(),
                           iter = 1000, data = NULL, weight_fun,
                           weight_params = design_params,
                           globalweight_fun = NULL,
                           globalweight_params = list(), ...){
  if(design$backend == "sim"){
    return(NextMethod())
  } else if(design$backend == "exact"){
    return(baskexact::ecd(design = design$design_exact, p1 = p1, n = n,
                          lambda = lambda, weight_fun = weight_fun,
                          weight_params = weight_params,
                          globalweight_fun = globalweight_fun,
                          globalweight_params = globalweight_params, ...))
  }  else {
    stop("design$backend must be 'sim' or 'exact'")
  }
}
