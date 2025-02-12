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
