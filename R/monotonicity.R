check_mon_within.fujikawa_x <- function(design, n, lambda, weight_fun, weight_params = list(),
         globalweight_fun = NULL, globalweight_params = list(),
         details = TRUE, ...) {
  if(is.null(design$design_exact)){
    design <- set_design_exact(design)
  }
  return(baskexact::check_mon_within(design = design$design_exact, n = n,
                                     lambda = lambda, weight_fun = weight_fun,
                                     weight_params = weight_params,
                                     globalweight_fun = globalweight_fun,
                                     globalweight_params = globalweight_params,
                                     details = details, ...))
}


check_mon_between.fujikawa_x <- function(design, n, lambda, weight_fun, weight_params = list(),
           details = TRUE, globalweight_fun = NULL,
           globalweight_params = list(),
           ...) {
  if(is.null(design$design_exact)){
    design <- set_design_exact(design)
  }
  return(baskexact::check_mon_between(design = design$design_exact, n = n,
                                      lambda = lambda, weight_fun = weight_fun,
                                      weight_params = weight_params,
                                      details = details,
                                      globalweight_fun = globalweight_fun,
                                      globalweight_params = globalweight_params,
                                      ...))
}
