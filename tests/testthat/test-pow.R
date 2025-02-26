test_that("pow() results coincide with python", {
  res <- pow(design = design_py,
             n = n_py,
             p1 = p1_py,
             lambda = lambda_py,
             epsilon = epsilon_py,
             tau = tau_py,
             logbase = logbase_py)
  ref_py <- readRDS(here::here(path_refdata, "ref_details_py.RDS"))
  expect_equal(res, ref_py$ewp,
               ignore_attr = TRUE)
})
test_that("MC simulated pow() results are close to exact results", {
  set.seed(3465)
  res <- pow(design = design_sim,
             n = n_sim,
             p1 = p1_sim,
             lambda = lambda_sim,
             epsilon = epsilon_sim,
             tau = tau_sim,
             logbase = logbase_sim,
             iter = iter_sim)
  res_x <- pow(design = set_backend(design_sim, "exact"),
               n = n_sim,
               p1 = p1_sim,
               lambda = lambda_sim,
               epsilon = epsilon_sim,
               tau = tau_sim,
               logbase = logbase_sim)
  expect_true(res - res_x > 0.0001)
  expect_equal(res, res_x,
               tolerance = 0.01
  )
})
test_that("wrong backend causes an error in pow()", {
  expect_error(pow(design = design_typo,
                   n = n_sim,
                   p1 = p1_sim,
                   lambda = lambda_sim,
                   epsilon = epsilon_sim,
                   tau = tau_sim,
                   logbase = logbase_sim,
                   iter = iter_sim))
})
