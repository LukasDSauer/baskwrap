test_that("results coincide with published results by Fujikawa et al.", {
  k <- 3
  n <- 24
  p0 <- 0.2
  p1 <- c(0.2, 0.2, 0.2)
  shape1 <- 1
  shape2 <- 1
  lambda <- 0.99
  epsilon <- 2
  tau_i <- 0
  tau_ii <- 0.5
  iter <- 1000
  logbase <- exp(1)
  set.seed(169)
  design_sim <- setup_fujikawa_x(k = k, p0 = p0, shape1 = shape1,
                                 shape2 = shape2, backend = "sim")
  design_x <- setup_fujikawa_x(k = k, p0 = p0, shape1 = shape1,
                               shape2 = shape2, backend = "exact")
  details_sim_i <- get_details(design = design_sim, n = n, p1 = p1,
                               lambda = lambda, epsilon = epsilon, tau = tau_i,
                               logbase = logbase,
                               iter = iter)
  details_sim_ii <- get_details(design = design_sim, n = n, p1 = p1,
                                lambda = lambda, epsilon = epsilon,
                                tau = tau_ii, logbase = logbase, iter = iter)
  details_x_i <- get_details(design = design_x, n = n, p1 = p1, lambda = lambda,
                             epsilon = epsilon, tau = tau_i, logbase = logbase,
                             iter = NULL)
  details_x_ii <- get_details(design = design_x, n = n, p1 = p1,
                              lambda = lambda, epsilon = epsilon,
                              tau = tau_ii, logbase = logbase, iter = NULL)
  # Comparison to Table 2 from Fujikawa et al., A Bayesian basket trial design
  # that borrows information across strata based on the similarity between the
  # posterior distributions of the response probability, Biometrical J, 2019.
  # doi:10.1002/bimj.201800404
  rej_fuj_i <- c(0.019, 0.020, 0.022)
  rej_fuj_ii <- c(0.029, 0.032, 0.034)
  fwer_fuj_i <- 0.035
  fwer_fuj_ii <- 0.063
  expect_equal(details_sim_i$Rejection_Probabilities, rej_fuj_i, tolerance = 0.1)
  expect_equal(details_sim_i$FWER, fwer_fuj_i, tolerance = 0.1)
  expect_equal(details_sim_ii$Rejection_Probabilities, rej_fuj_ii, tolerance = 0.1)
  expect_equal(details_sim_ii$FWER, fwer_fuj_ii, tolerance = 0.1)
  # Comparison for the exactly calculated results
  expect_equal(details_x_i$Rejection_Probabilities, rej_fuj_i, tolerance = 0.05)
  expect_equal(details_x_i$FWER, fwer_fuj_i, tolerance = 0.05)
  expect_equal(details_x_ii$Rejection_Probabilities, rej_fuj_ii, tolerance = 0.05)
  expect_equal(details_x_ii$FWER, fwer_fuj_ii, tolerance = 0.05)
})
