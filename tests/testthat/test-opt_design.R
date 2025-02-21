test_that("opt_design() finds optimization result for basksim and baskexact", {
  set.seed(1994)
  design <- setup_fujikawa_x(k = k_sim, p0 = 0.2)
  alpha <- 0.05
  design_params <- list(epsilon = c(1, 2), tau = c(0, 0.5))
  scenarios <- get_scenarios(design, 0.4)
  prec_digits <- 3
  res <- opt_design(design = design,
                     n = n_sim, alpha = alpha,
                     design_params = design_params,
                     scenarios = scenarios,
                     prec_digits = prec_digits,
                     iter = 1000)
  res_x <- opt_design(design = set_backend(design, "exact"),
                      n = n_sim, alpha = alpha,
                      design_params = design_params,
                      scenarios = scenarios,
                      prec_digits = prec_digits)
  expect_not_equal(res, res_x)
  expect_equal(res, res_x, tolerance = 0.1, ignore_attr = T)
})

