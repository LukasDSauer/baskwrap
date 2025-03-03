set.seed(169)
k <- 3
n <- 24
p0 <- 0.2
shape1 <- 1
shape2 <- 1
lambda <- 0.99
epsilon <- 2
tau_i <- 0
tau_ii <- 0.5
iter <- 1000
logbase <- exp(1)
design_sim <- setup_fujikawa_x(k = k, p0 = p0, shape1 = shape1,
                              shape2 = shape2, backend = "sim")

design_x <- setup_fujikawa_x(k = k, p0 = p0, shape1 = shape1,
                             shape2 = shape2, backend = "exact")
test_that("results coincide with published results by Fujikawa et al.", {
  p1 <- c(0.2, 0.2, 0.2)
  details_sim_i <- get_details(design = design_sim, n = n, p1 = p1,
                               lambda = lambda, epsilon = epsilon, tau = tau_i,
                               logbase = logbase,
                               iter = iter)
  details_sim_ii <- get_details(design = design_sim, n = n, p1 = p1,
                                lambda = lambda, epsilon = epsilon,
                                tau = tau_ii, logbase = logbase, iter = iter)
  details_x_i <- get_details(design = design_x, n = n, p1 = p1,
                                            lambda = lambda,
                             epsilon = epsilon, tau = tau_i, logbase = logbase,
                             iter = NULL,
                             verbose = FALSE)
  details_x_ii <- get_details(design = design_x, n = n, p1 = p1,
                              lambda = lambda, epsilon = epsilon,
                              tau = tau_ii, logbase = logbase, iter = NULL,
                              verbose = FALSE)
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
test_that("code returns message if the power is 0 per definition", {
  p1 <- c(0.2, 0.2, 0.2)
  expect_message(get_details(design = design_x, n = n, p1 = p1,
                             lambda = lambda,
                             epsilon = epsilon, tau = tau_i, logbase = logbase,
                             iter = NULL,
                             verbose = TRUE),
                 "No true alternative hypotheses, hence the power is 0.")
})
test_that("code returns message if the toer is 0 per definition", {
  p1 <- c(0.5, 0.5, 0.5)
  expect_message(get_details(design = design_x, n = n, p1 = p1,
                             lambda = lambda,
                             epsilon = epsilon, tau = tau_i, logbase = logbase,
                             iter = NULL,
                             verbose = TRUE),
                 "No true null hypotheses, hence the type 1 error rate is 0.")
})
test_that("get_details() results coincide with python", {
  res <- get_details(design = design_py,
                     n = n_py,
                     p1 = p1_py,
                     lambda = lambda_py,
                     epsilon = epsilon_py,
                     tau = tau_py,
                     logbase = logbase_py,
                     iter = NULL,
                     verbose = TRUE)
  ref_py <- readRDS(test_path(path_refdata_rel, "ref_details_py.RDS"))
  expect_equal(res$FWER, ref_py$fwer,
               ignore_attr = TRUE, tolerance = 1e-7)
  expect_equal(res$EWP, ref_py$ewp,
               ignore_attr = TRUE)
  expect_equal(res$ECD, ref_py$ecd,
               ignore_attr = TRUE)
  expect_equal(res$Rejection_Probabilities, ref_py$rejection_probabilities,
               ignore_attr = TRUE)
  expect_equal(res$Mean, ref_py$mean,
               ignore_attr = TRUE)
  expect_equal(res$MSE, ref_py$mse,
               ignore_attr = TRUE)
})

test_that("get_details() results coincide with python when requesting FWER only",
          {
  res <- get_details(design = design_py,
                     n = n_py,
                     p1 = p1_py,
                     lambda = lambda_py,
                     epsilon = epsilon_py,
                     tau = tau_py,
                     logbase = logbase_py,
                     which_details = c("Rejection_Probabilities", "FWER"),
                     verbose = FALSE)
  res_only_rej <- get_details(design = design_py,
                     n = n_py,
                     p1 = p1_py,
                     lambda = lambda_py,
                     epsilon = epsilon_py,
                     tau = tau_py,
                     logbase = logbase_py,
                     which_details = c("Rejection_Probabilities"),
                     verbose = FALSE)
  ref_py <- readRDS(test_path(path_refdata_rel, "ref_details_py.RDS"))
  expect_equal(res$FWER, ref_py$fwer,
               ignore_attr = TRUE, tolerance = 1e-7)
  expect_equal(res_only_rej$FWER, ref_py$fwer,
               ignore_attr = TRUE, tolerance = 1e-7)
})
test_that("get_details() results coincide between backend when requesting EWP only",
          {
            which_details_test <- "EWP"
            res <- get_details(design = design_py,
                                     n = n_py,
                                     p1 = p1_py,
                                     lambda = lambda_py,
                                     epsilon = epsilon_py,
                                     tau = tau_py,
                                     logbase = logbase_py,
                                     which_details = which_details_test,
                                     verbose = FALSE)
            res_sim <- get_details(design = design_py_sim,
                                         n = n_py,
                                         p1 = p1_py,
                                         lambda = lambda_py,
                                         epsilon = epsilon_py,
                                         tau = tau_py,
                                         logbase = logbase_py,
                                         which_details = which_details_test,
                                         verbose = FALSE)
            res_toer0 <- get_details(design = design_py,
                               n = n_py,
                               p1 = p1_py_toer_eq0,
                               lambda = lambda_py,
                               epsilon = epsilon_py,
                               tau = tau_py,
                               logbase = logbase_py,
                               which_details = which_details_test,
                               verbose = FALSE)
            res_sim_toer0 <- get_details(design = design_py_sim,
                                  n = n_py,
                                  p1 = p1_py_toer_eq0,
                                  lambda = lambda_py,
                                  epsilon = epsilon_py,
                                  tau = tau_py,
                                  logbase = logbase_py,
                                  which_details = which_details_test,
                                   verbose = FALSE)
            expect_equal(res$EWP, res_sim$EWP,
                         ignore_attr = TRUE, tolerance = 0.01)
            expect_equal(res_toer0$EWP, res_sim_toer0$EWP,
                         ignore_attr = TRUE, tolerance = 1e-3)
            expect_equal(res_toer0$FWER, 0)
            expect_equal(res_sim_toer0$FWER, 0)
          })
test_that("get_details() results coincide between backend when requesting FWER only",
          {
            which_details_test <- "FWER"
            res <- get_details(design = design_py,
                               n = n_py,
                               p1 = p1_py_pow_eq0,
                               lambda = lambda_py,
                               epsilon = epsilon_py,
                               tau = tau_py,
                               logbase = logbase_py,
                               iter = NULL,
                               which_details = which_details_test,
                               verbose = FALSE)
            res_sim <- get_details(design = design_py_sim,
                                   n = n_py,
                                   p1 = p1_py_pow_eq0,
                                   lambda = lambda_py,
                                   epsilon = epsilon_py,
                                   tau = tau_py,
                                   logbase = logbase_py,
                                   which_details = which_details_test,
                                   verbose = FALSE)
            expect_equal(res$FWER, res_sim$FWER,
                         ignore_attr = TRUE, tolerance = 0.09)
            expect_equal(res$EWP, 0)
            expect_equal(res_sim$EWP, 0)
          })
test_that("get_details returns error for wrong backend", {
  p1 <- c(0.5, 0.5, 0.5)
  design <- setup_fujikawa_x(k = 3, p0 = 0.2)
  design$backend <- "typo"
  expect_error(get_details(design = design, n = n, p1 = p1,
                           lambda = lambda,
                           epsilon = epsilon, tau = tau_i, logbase = logbase,
                           iter = NULL,
                           verbose = TRUE))
})
