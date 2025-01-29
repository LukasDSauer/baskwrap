test_that("weights_fujikawa_vanilla and *_tuned deliver the same results as
           baskexact", {
  n <- 20
  design <- setup_fujikawa_x(k = 3, p0 = 0.2, backend = "sim")
  weight_mat_vanilla <- weights_fujikawa_vanilla(design, n = n, logbase = 2)
  weight_mat_tuned <- weights_fujikawa_tuned(weight_mat_vanilla, epsilon = 2.5,
                                             tau = 0.2)
  # Loading reference data
  ref_vanilla <- readRDS(paste0(testthat::test_path(),
                            "/refdata/ref_weights_fujikawa_vanilla.RDS"))
  ref_tuned <- readRDS(paste0(testthat::test_path(),
                                "/refdata/ref_weights_fujikawa_tuned.RDS"))
  # Comparison
  expect_equal(weight_mat_vanilla, ref_vanilla)
  expect_equal(weight_mat_tuned, ref_tuned)
})
