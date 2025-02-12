# GENERAL PARAMETERS
path_refdata <- paste0(testthat::test_path(), "/refdata")
# PARAMETERS USED IN ALL PYTHON-GENERATED EXAMPLES
k_py <- 4
shape1_py <- 1
shape2_py <- 1
p0_py <- 0.2
p1_py <- c(0.2, 0.2, 0.5, 0.5)
n_py <- 15
r_py <- c(2, 9, 9, 10)
epsilon_py <- 1.5
tau_py <- 0.25
lambda_py <-  0.99
logbase_py <- exp(1)
design_py <- setup_fujikawa_x(k = k_py,
                              p0 = p0_py,
                              backend = "exact")
