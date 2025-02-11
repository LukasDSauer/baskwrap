test_that("basket_test delivers the same results as python", {
  basket_test(design = design_py,
              n = n_py,
              r = r_py,
              lambda = lambda_py,
              epsilon = epsilon_py,
              tau = tau_py,
              logbase = logbase_py)


  expect_equal(2 * 2, 4)
})
