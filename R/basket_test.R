basket_test.fujikawa_x <- function(design, n, r, lambda, weight_fun, weight_params = list(),
         globalweight_fun = NULL, globalweight_params = list(),
         details = TRUE, ...){
  if(is.null(design$design_exact)){
    design <- set_design_exact(design)
  }
  return(baskexact::basket_test(design = design$design_exact, n = n,
                                r = r, lambda = lambda, weight_fun = weight_fun,
                                weight_params = weight_params,
                                globalweight_fun = globalweight_fun,
                                globalweight_params = globalweight_params,
                                details = details, ...))
}

