test_that("basket_test delivers the same results as python", {
  res <- basket_test(design = design_py_sim,
                      n = n_py,
                      r = r_py,
                      lambda = lambda_py,
                      epsilon = epsilon_py,
                      tau = tau_py,
                      logbase = logbase_py)
  ref_py <- readRDS(test_path(path_refdata_rel, "ref_pp_py.RDS"))
  expect_equal(res$post_prob_borrow, ref_py, ignore_attr = TRUE)
})
