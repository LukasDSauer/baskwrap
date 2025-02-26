test_that("plot of weights coincides with snapshot", {
  design_x <- setup_fujikawa_x(k = 4, p0 = 0.2, backend = "exact")
  eps_vec <- c(0.25, 0.5, 0.75, 1, 1.25, 1.5, 2, 2.5, 3, 4, 5, 7, 10)
  p <- plot_weights(design = design_x, n = 24, r1 = 10,
                    weight_params = list(tau = 0,
                                         epsilon = eps_vec))
  fig_path <- here::here(path_refdata,
                         "ref_weights_plot.RDS")
  ref_path <- saveRDS(p, fig_path)
  expect_snapshot_file(here::here(path_refdata,
                                  "ref_weights_plot.RDS"),
                       "snap_weights_plot.RDS")
})
