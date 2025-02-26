test_that("toer() results coincide with python", {
  res <- toer(design = design_py,
             n = n_py,
             p1 = p1_py,
             lambda = lambda_py,
             epsilon = epsilon_py,
             tau = tau_py,
             logbase = logbase_py)
  ref_py <- readRDS(here::here(path_refdata, "ref_details_py.RDS"))
  expect_equal(res, ref_py$fwer,
               ignore_attr = TRUE,
               tolerance = 1e-07)
})
test_that("MC simulated toer() results are close to exact results", {
  set.seed(987)
  res <- toer(design = design_sim,
              n = n_sim,
              p1 = p1_sim,
              lambda = lambda_sim,
              epsilon = epsilon_sim,
              tau = tau_sim,
              logbase = logbase_sim,
              iter = 10000)
  res_x <- toer(design = set_backend(design_sim, "exact"),
              n = n_sim,
              p1 = p1_sim,
              lambda = lambda_sim,
              epsilon = epsilon_sim,
              tau = tau_sim,
              logbase = logbase_sim)
  expect_true(abs(res - res_x) > 0.0001)
  expect_equal(res, res_x,
               tolerance = 0.009
               )
})
test_that("wrong backend causes an error in toer()", {
  expect_error(toer(design = design_typo,
              n = n_sim,
              p1 = p1_sim,
              lambda = lambda_sim,
              epsilon = epsilon_sim,
              tau = tau_sim,
              logbase = logbase_sim,
              iter = iter_sim))
})
