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
ref <- baskexact::weights_fujikawa(design = design_be,
                                   n = 20,
                                   lambda = NULL,
                                   epsilon = 1,
                                   tau = 0)
saveRDS(ref, here(path_refdata, "ref_weights_fujikawa_vanilla.RDS"))
ref_tuned <- baskexact::weights_fujikawa(design = design_be,
                                         n = 20,
                                         lambda = NULL,
                                         epsilon = 2.5,
                                         tau = 0.2)
saveRDS(ref_tuned, here(path_refdata, "ref_weights_fujikawa_tuned.RDS"))
# - Weights generated with Python
source_python(here(path_refdata, "genrefdata.py"))
ref_py <- get_weights_fujikawa_py(n = n_py,
                                  shape1 = shape1_py,
                                  shape2 = shape2_py,
                                  epsilon = epsilon_py,
                                  tau = tau_py,
                                  logbase = logbase_py)
saveRDS(ref_py, here(path_refdata, "ref_weights_py.RDS"))
# Comparing test results with Python
#basket_test <-
# get_details(design = design_x, n = n, p1 = p1, lambda = lambda_par,
#             epsilon = epsilon, tau = tau, weight_fun = baskexact::weights_fujikawa,
#             logbase = logbase)
#saveRDS()
