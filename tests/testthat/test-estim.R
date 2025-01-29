test_that("estim works", {
  design_x <- setup_fujikawa_x(k = 4, p0 = 0.3, backend = "exact")
  estim(design = design_x,
        n = 20, p1 = c(0.3, 0.3, 0.5, 0.5), lambda = 0.95,
        epsilon = 2, tau = 0, weight_fun = baskexact::weights_fujikawa,
        logbase = exp(1))
})
