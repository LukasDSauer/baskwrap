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
