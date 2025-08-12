test_that("plot of weights coincides with snapshot", {
  design_x <- setup_fujikawa_x(k = 4, p0 = 0.2, backend = "sim")
  eps_vec <- c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 2.5, 3, 4, 5, 7, 10)
  p <- plot_weights(design = design_x, n = 24, r1 = 10,
                    weight_params = list(tau = 0,
                                         epsilon = eps_vec,
                                         logbase = 2))

  fig_path <- test_path(path_refdata_rel, "ref_weights_plot.png")
  expect_false(file.exists(fig_path))
  ggplot2::ggsave(fig_path, p)
  # expect_snapshot_file(path = fig_path,
  #                      name = "snap_weights_plot.png",
  #                      variant = gsub(" ", "",
  #                                     paste0(Sys.info()["sysname"], "_",
  #                                            Sys.info()["release"],
  #                                            Sys.info()["version"])))
  expect_true(file.exists(fig_path))
  file.remove(fig_path)
})
