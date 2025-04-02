test_that("weights_fujikawa_vanilla and *_tuned deliver the same results as
           baskexact", {
  n <- 20
  design <- setup_fujikawa_x(k = 3, p0 = 0.2, backend = "sim")
  weight_mat_vanilla <- weights_fujikawa_vanilla(design, n = n, logbase = 2)
  weight_mat_tuned <- weights_fujikawa_tuned(weight_mat_vanilla, epsilon = 2.5,
                                             tau = 0.2)
  # Loading reference data
  ref_vanilla <- readRDS(test_path(path_refdata_rel,
                                   "ref_weights_fujikawa_vanilla.RDS"))
  ref_tuned <- readRDS(test_path(path_refdata_rel,
                                 "ref_weights_fujikawa_tuned.RDS"))
  # Comparison
  expect_equal(weight_mat_vanilla, ref_vanilla)
  expect_equal(weight_mat_tuned, ref_tuned)
})

test_that("weights_fujikawa_x delivers the same results as python", {
  weights_fuj <- weights_fujikawa_x(design = design_py,
                                    n = n_py,
                                    epsilon = epsilon_py,
                                    tau = tau_py,
                                    logbase = logbase_py)
  ref_py <- readRDS(test_path(path_refdata_rel, "ref_weights_py.RDS"))
  expect_equal(unclass(weights_fuj), ref_py)
})
