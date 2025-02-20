# This is code to generate reference data sets

# SETUP
library(here)
library(reticulate)
library(baskexact)
use_virtualenv()
devtools::load_all()
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
# # - Weights generated with Python
source_python(here(path_refdata, "genrefdata.py"))
weights_py <- get_weights_fujikawa_py(n = n_py,
                                      shape1 = shape1_py,
                                      shape2 = shape2_py,
                                      epsilon = epsilon_py,
                                      tau = tau_py,
                                      logbase = logbase_py)
saveRDS(weights_py, here(path_refdata, "ref_weights_py.RDS"))
# - Posterior probabilities generated with Python
pp_py <- get_posterior_prob_py(n = n_py,
                               k = k_py,
                               shape1 = shape1_py,
                               shape2 = shape2_py,
                               p0 = np_array(p0_py, dtype = "float32"),
                               r = np_array(r_py, dtype = "int64"),
                               weight_mat = weights_py)
saveRDS(pp_py, here(path_refdata, "ref_pp_py.RDS"))
# - Rejection probabilities generated with Python
details_py <- get_details_py(n = n_py,
                             k = k_py,
                             shape1 = shape1_py,
                             shape2 = shape2_py,
                             lambda_par = lambda_py,
                             p0 = np_array(p0_py, dtype = "float32"),
                             p1 = np_array(p1_py, dtype = "float32"),
                             weight_mat = weights_py)
saveRDS(details_py, here(path_refdata, "ref_details_py.RDS"))
# - Save session info
saveRDS(sessionInfo(), here(path_refdata, "genrefdata_session_info.RDS"))
