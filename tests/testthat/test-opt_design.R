test_that("opt_design() finds optimization result for basksim and baskexact", {
  set.seed(1994)
  design <- setup_fujikawa_x(k = 3, p0 = 0.2)
  alpha <- 0.05
  design_params <- list(epsilon = c(1, 2), tau = c(0, 0.5))
  scenarios <- get_scenarios(design, 0.4)
  prec_digits <- 3
  res <- opt_design(design = design,
                     n = 15, alpha = alpha,
                     design_params = design_params,
                     scenarios = scenarios,
                     prec_digits = prec_digits,
                     iter = 1000)
  res_x <- opt_design(design = set_backend(design, "exact"),
                      n = n_sim, alpha = alpha,
                      design_params = design_params,
                      scenarios = scenarios,
                      prec_digits = prec_digits)
  expect_true(any(abs(res - res_x) > 0.0001))
  expect_equal(res, res_x, tolerance = 0.1, ignore_attr = T)
})
test_that("opt_design returns error for wrong backend", {
  p1 <- c(0.5, 0.5, 0.5)
  design <- setup_fujikawa_x(k = 3, p0 = 0.2)
  design$backend <- "typo"
  expect_error(opt_design(design = design,
                          n = 15, alpha = alpha,
                          design_params = design_params,
                          scenarios = scenarios,
                          prec_digits = prec_digits,
                          iter = 1000))
})
