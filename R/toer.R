toer.fujikawa_x <- function(design, n, p1 = NULL, lambda, design_params = list(),
                            iter = 1000, data = NULL, weight_fun,
                            weight_params = list(), globalweight_fun = NULL,
                            globalweight_params = list(),
                            results = c("fwer", "group"),...){
  ## Hier gibt es eine toer funktion in basksim und in baskexact
  if(design$backend == "sim"){
    return(NextMethod())
  } else if(design$backend == "exact"){
    return(baskexact::toer(design$design_exact, p1 = p1, n = n, lambda = lambda,
                    weight_fun = weight_fun, weight_params = weight_params,
                    globalweight_fun = globalweight_fun,
                    globalweight_params = globalweight_params,
                    results = results, ...))
  }  else {
    stop("design$backend must be 'sim' or 'exact'")
  }
}

