test_that("erroneous backend throws error message", {
  p1 <- c(0.5, 0.5, 0.5)
  design <- setup_fujikawa_x(k = 3, p0 = 0.2)
  expect_error(set_backend(design = design,
                           backend = "typo"))
})
