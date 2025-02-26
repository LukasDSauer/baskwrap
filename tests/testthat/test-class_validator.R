test_that("error messages for erroneous classes work", {
  # k integer
  expect_error(setup_fujikawa_x(k = 0.5, p0 = 0.2))
  # k less than 2
  expect_error(setup_fujikawa_x(k = 1, p0 = 0.2))
  # shape1 less than or equal to 0
  expect_error(setup_fujikawa_x(k = 3, p0 = 0.2, shape1 = 0, shape2 = 1))
  # shape2 less than or equal to 0
  expect_error(setup_fujikawa_x(k = 3, p0 = 0.2, shape1 = 1, shape2 = -1))
  # unknown backend
  expect_error(setup_fujikawa_x(k = 4, p0 = 0.2, shape1 = 1, shape2 = 1,
                                backend = "simtypo"))
})
