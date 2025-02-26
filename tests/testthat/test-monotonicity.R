test_that("within-trial monotonicity conditions coincide with published results
           (see Tab. 2, Baumann et al. 2022)",
          {
  # Baumann, L., Krisam, J., & Kieser, M. (2022). Monotonicity conditions for
  # avoiding counterintuitive decisions in basket trials. Biometrical Journal,
  # 64(5), 934-947.
  design3 <- setup_fujikawa_x(k = 3,
                              shape1 = 1,
                              shape2 = 1,
                              p0 = 0.2)
  design4 <- setup_fujikawa_x(k = 4,
                             shape1 = 1,
                             shape2 = 1,
                             p0 = 0.2)
  expect_equal(check_mon_within(design = design3, n = 24,
                                 lambda = 0.99,
                                 weight_fun = baskexact::weights_fujikawa,
                                 weight_params = list(epsilon = 5,
                                                      tau = 0.4),
                                details = FALSE),
               TRUE)
  expect_equal(check_mon_within(design = design4, n = 24,
                                lambda = 0.99,
                                weight_fun = baskexact::weights_fujikawa,
                                weight_params = list(epsilon = 7,
                                                     tau = 0.3),
                                details = FALSE),
               FALSE)
})

test_that("between-trial monotonicity conditions coincide with published results
           (see Tab. 2, Baumann et al. 2022)",
          {
    # Baumann, L., Krisam, J., & Kieser, M. (2022). Monotonicity conditions for
    # avoiding counterintuitive decisions in basket trials. Biometrical Journal,
    # 64(5), 934-947.
    design3 <- setup_fujikawa_x(k = 3,
                                shape1 = 1,
                                shape2 = 1,
                                p0 = 0.2)
    design4 <- setup_fujikawa_x(k = 4,
                                shape1 = 1,
                                shape2 = 1,
                                p0 = 0.2)
    expect_equal(check_mon_between(design = design3, n = 24,
                                  lambda = 0.99,
                                  weight_fun = baskexact::weights_fujikawa,
                                  weight_params = list(epsilon = 3,
                                                       tau = 0.1),
                                  details = FALSE),
                 FALSE)
    expect_equal(check_mon_between(design = design4, n = 24,
                                  lambda = 0.99,
                                  weight_fun = baskexact::weights_fujikawa,
                                  weight_params = list(epsilon = 7,
                                                       tau = 0.4),
                                  details = FALSE),
                 TRUE)
          })
