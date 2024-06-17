test_that("weights_fujikawa_vanilla and *_tuned deliver the same results as
           baskexact", {
  n <- 20
  design <- setup_fujikawa_x(k = 3, p0 = 0.2, backend = "exact")
  weight_mat_vanilla <- weights_fujikawa_vanilla(design, n = n)
  weight_mat_tuned <- weights_fujikawa_tuned(weight_mat_vanilla, epsilon = 2.5,
                                             tau = 0.2, logbase = 2)
  # Reference data
  # ref <- baskexact::weights_fujikawa(design = design$design_exact, n = n,
  #                                    lambda = NULL,
  #                                    epsilon = 1, tau = 0)
  # saveRDS(ref, paste0(testthat::test_path(),
  #         "/refdata/ref_weights_fujikawa_vanilla.RDS"))
  ref_tuned <- baskexact::weights_fujikawa(design = design$design_exact,
                                           n = n,
                                           lambda = NULL,
                                           epsilon = 2.5, tau = 0.2)
  saveRDS(ref_tuned, paste0(testthat::test_path(),
          "/refdata/ref_weights_fujikawa_tuned.RDS"))
  ref_vanilla <- readRDS(paste0(testthat::test_path(),
                            "/refdata/ref_weights_fujikawa_vanilla.RDS"))
  ref_tuned <- readRDS(paste0(testthat::test_path(),
                                "/refdata/ref_weights_fujikawa_tuned.RDS"))
  # Class changed to avoid type clash
  class(ref_vanilla) <- "weight_mat_fujikawa"
  class(ref_tuned) <- "weight_mat_fujikawa"
  # TODO: Reference for weight_mat_tuned()
  expect_equal(weight_mat_vanilla, ref_vanilla)
  expect_equal(weight_mat_tuned, ref_tuned)
})
