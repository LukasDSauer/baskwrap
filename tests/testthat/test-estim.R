test_that("estim produces the same results as python", {
  res <- estim(design = design_py,
                n = n_py,
                p1 = p1_py,
                lambda = lambda_py,
                epsilon = epsilon_py,
                tau = tau_py,
                weight_fun = baskexact::weights_fujikawa,
                logbase = logbase_py)
  ref_py <- readRDS(here::here(path_refdata, "ref_details_py.RDS"))
  expect_equal(res$Mean, ref_py$mean,
               ignore_attr = TRUE)
  expect_equal(res$MSE, ref_py$mse,
               ignore_attr = TRUE)
})
test_that("MC simulated estim() results are close to exact results", {
  set.seed(1999)
  res <- estim(design = design_sim,
             n = n_sim,
             p1 = p1_sim,
             lambda = lambda_sim,
             epsilon = epsilon_sim,
             tau = tau_sim,
             logbase = logbase_sim,
             iter = iter_sim)
  res_x <- estim(design = set_backend(design_sim, "exact"),
               n = n_sim,
               p1 = p1_sim,
               lambda = lambda_sim,
               epsilon = epsilon_sim,
               tau = tau_sim,
               logbase = logbase_sim)
  expect_true(abs(res$Mean - res_x$Mean) > 0.0001)
  expect_equal(res$Mean, res_x$Mean,
               tolerance = 0.1
  )
})
test_that("wrong backend causes an error in estim()", {
  expect_error(estim(design = design_typo,
                   n = n_sim,
                   p1 = p1_sim,
                   lambda = lambda_sim,
                   epsilon = epsilon_sim,
                   tau = tau_sim,
                   logbase = logbase_sim,
                   iter = iter_sim))
})
