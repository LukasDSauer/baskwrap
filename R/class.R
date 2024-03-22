setup_fujikawa_x <- function(k, p0, shape1 = 1, shape2 = 1, backend = "sim") {
  design <- validate_fujikawa_x(structure(
    list(k = k, p0 = p0, shape1 = shape1, shape2 = shape2, backend = backend,
         design_exact = NULL),
    class = c("fujikawa_x", "fujikawa")
  ))
  design <- set_backend(design, backend)
  return(design)
}

set_design_exact <- function(design){
  design$design_exact <- baskexact::setupOneStageBasket(k = design$k,
                                                        p0 = design$p0,
                                                        shape1 = design$shape1,
                                                        shape2 = design$shape2)
  return(design)
}

set_backend <- function(design, backend){
  design$backend = backend
  if(design$backend == "exact"){
    design <- set_design_exact(design)
  }
  return(design)
}
