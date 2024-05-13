plot_weights.fujikawa_x <- function(design, n, r1, weight_fun,
                                    weight_params = list()) {
  if(is.null(design$design_exact)){
    design <- set_design_exact(design)
  }
  return(baskexact::plot_weights(design = design$design_exact, n = n, r1 = r1,
                         weight_fun = weight_fun,
                         weight_params = weight_params))
}
