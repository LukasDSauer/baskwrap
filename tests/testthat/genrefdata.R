# This is code to generate reference data sets

# SETUP
library(here)
library(reticulate)
library(baskexact)
use_virtualenv()
source(here(testthat::test_path(), "helper-refdata.R"))
# PARAMETERS
design_be <- baskexact::setupOneStageBasket(k = 3, p0 = 0.2)

# GENERATE REFERENCE DATA FOR WEIGHTS
# - Weights generated with R
weights <- baskexact::weights_fujikawa(design = design_be,
                                   n = 20,
                                   lambda = NULL,
                                   epsilon = 1,
                                   tau = 0)
saveRDS(weights, here(path_refdata, "ref_weights_fujikawa_vanilla.RDS"))
weights_tuned <- baskexact::weights_fujikawa(design = design_be,
                                         n = 20,
                                         lambda = NULL,
                                         epsilon = 2.5,
                                         tau = 0.2)
saveRDS(weights_tuned, here(path_refdata, "ref_weights_fujikawa_tuned.RDS"))
# - Weights generated with Python
source_python(here(path_refdata, "genrefdata.py"))
weights_py <- get_weights_fujikawa_py(n = n_py,
                                      shape1 = shape1_py,
                                      shape2 = shape2_py,
                                      epsilon = epsilon_py,
                                      tau = tau_py,
                                      logbase = logbase_py)
saveRDS(weights_py, here(path_refdata, "ref_weights_py.RDS"))
# - Posterior probabilities generated with Python
pp_py <- get_posterior_prob_py(r = np_array(r_py, dtype = "int64"),
                               weight_mat = weights_py)
saveRDS(pp_py, here(path_refdata, "ref_pp_py.RDS"))
# - Rejection probabilities generated with Python
rp_py <- get_rejection_prob_py(lambda_par = lambda_py,
                               p0 = p0_py,
                               p1 = p1_py,
                               weight_mat = weights_py)
saveRDS(rp_py, here(path_refdata, "ref_rp_py.RDS"))
# Comparing test results with Python
# basket_test <-
# get_details(design = design_x, n = n, p1 = p1, lambda = lambda_par,
#             epsilon = epsilon, tau = tau, weight_fun = baskexact::weights_fujikawa,
#             logbase = logbase)
#saveRDS()
