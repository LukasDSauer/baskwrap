test_that("ecd() results coincide with python", {
  res <- ecd(design = design_py,
                     n = n_py,
                     p1 = p1_py,
                     lambda = lambda_py,
                     epsilon = epsilon_py,
                     tau = tau_py,
                     logbase = logbase_py)
  ref_py <- readRDS(here::here(path_refdata, "ref_details_py.RDS"))
  expect_equal(res, ref_py$ecd,
               ignore_attr = TRUE)
})
test_that("MC simulated ecd() results are close to exact results", {
  set.seed(333)
  res <- ecd(design = design_sim,
              n = n_sim,
              p1 = p1_sim,
              lambda = lambda_sim,
              epsilon = epsilon_sim,
              tau = tau_sim,
              logbase = logbase_sim,
              iter = iter_sim)
  res_x <- ecd(design = set_backend(design_sim, "exact"),
                n = n_sim,
                p1 = p1_sim,
                lambda = lambda_sim,
                epsilon = epsilon_sim,
                tau = tau_sim,
                logbase = logbase_sim)
  expect_true(abs(res - res_x) > 0.000001)
  expect_equal(res, res_x,
               tolerance = 0.00099
  )
})
test_that("wrong backend causes an error in ecd()", {
  expect_error(ecd(design = design_typo,
                    n = n_sim,
                    p1 = p1_sim,
                    lambda = lambda_sim,
                    epsilon = epsilon_sim,
                    tau = tau_sim,
                    logbase = logbase_sim,
                    iter = iter_sim))
})
