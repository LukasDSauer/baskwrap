# GENERAL PARAMETERS
path_refdata <- list("tests", "testthat", "refdata")
path_refdata_rel <- "refdata"
# PARAMETERS USED IN ALL PYTHON-GENERATED EXAMPLES
k_py <- 4
shape1_py <- 1
shape2_py <- 1
p0_py <- 0.2
p1_py <- c(0.2, 0.2, 0.5, 0.5)
p1_py_toer_eq0 <- c(0.5, 0.5, 0.5, 0.5)
p1_py_pow_eq0 <- c(0.2, 0.2, 0.2, 0.2)
n_py <- 15
r_py <- c(2, 9, 9, 10)
epsilon_py <- 1.5
tau_py <- 0.25
lambda_py <-  0.99
logbase_py <- exp(1)
design_py <- setup_fujikawa_x(k = k_py,
                              p0 = p0_py,
                              backend = "exact")
design_py_sim <- setup_fujikawa_x(k = k_py,
                              p0 = p0_py,
                              backend = "sim")
# PARAMETERS USED IN MC-SIMULATED EXAMPLES
k_sim <- 4
shape1_sim <- 1
shape2_sim <- 1
p0_sim <- 0.02
p1_sim <- c(0.02, 0.05, 0.05, 0.1)
n_sim <- 16
r_sim <- c(0, 0, 0, 0)
epsilon_sim <- 2
tau_sim <- 0.5
lambda_sim <-  0.999
logbase_sim <- 2
iter_sim <- 1000
design_sim <- setup_fujikawa_x(k = k_sim,
                              p0 = p0_sim,
                              backend = "sim")
# ERRONEOUS DESIGN
design_typo <- design_sim
design_typo$backend <- "backend-typo"
