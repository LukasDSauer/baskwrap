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
  logbase <- 2
  set.seed(69)
  design_sim <- setup_fujikawa_x(k = k, p0 = p0, shape1 = shape1,
                                 shape2 = shape2, backend = "sim")
  design_x <- setup_fujikawa_x(k = k, p0 = p0, shape1 = shape1,
                               shape2 = shape2, backend = "exact")
  details_sim_i <- get_details(design = design_x, n = n, p1 = p1,
                               lambda = lambda, epsilon = epsilon, tau = tau_i,
                               logbase = logbase,
                               iter = iter)
  details_sim_ii <- get_details(design = design_x, n = n, p1 = p1,
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
  expect_equal(details_sim_i$Rejection_probabilities, c(0.019, 0.020, 0.022))
  expect_equal(details_sim_i$FWER, 0.035)
  expect_equal(details_sim_ii$Rejection_probabilities, c(0.029, 0.032, 0.034))
  expect_equal(details_sim_ii$FWER, 0.063)
})
