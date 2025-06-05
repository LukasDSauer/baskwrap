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

test_that("weights_hellinger delivers the expected results", {
  weights_hld <- weights_hellinger(design = design_py,
                                    n = n_py,
                                    epsilon = epsilon_py,
                                    tau = tau_py,
                                    logbase = logbase_py)

  hld <- function(r1, r2){
    a1 <- design_py$shape1 + r1
    b1 <- design_py$shape2 + (n_py - r1)
    a2 <- design_py$shape1 + r2
    b2 <- design_py$shape2 + (n_py - r2)
    return(1- beta((a1 + a2)/2, (b1 + b2)/2)/sqrt(beta(a1, b1)*beta(a2, b2)))
  }
  r1 <- 9
  r2 <- 4
  expect_equal(weights_hld[r1 + 1, r2 + 1], hld(r1, r2)^epsilon_py)
  # If hld^epsilon is less than tau, the weight should be 0.
  r1 <- 6
  r2 <- 7
  expect_equal(weights_hld[r1 + 1, r2 + 1], 0)
  expect_true(hld(r1, r2)^epsilon_py <= tau_py)
})
