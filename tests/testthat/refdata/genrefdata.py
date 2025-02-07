from math import exp, log
import numpy as np
from scipy.stats import beta, binom
from itertools import product
# from tqdm.contrib.itertools import product
# from tqdm import tqdm
import scipy.integrate as integrate
# Parameters
# TODO: Remove these parameters when done with validating. Parameters
# will be set automatically in genrefdata.R and helper-refdata_pyparams.R
# k = 3
# shape1 = 1
# shape2 = 1
# p0 = 0.2
# p1 = np.array([0.2, 0.5, 0.5])
# n = 20
# r = np.array([5, 9, 10])
# epsilon = 2
# tau = 0.5
# lambda_par = 0.95
# logbase = 2

def get_weights_fujikawa_py(n, shape1, shape2, epsilon, tau, logbase):
  n = int(n)
  # Objects of Fujikawa's design
  weights_fujikawa_raw = np.zeros(shape = (n + 1, n + 1))
  weights_fujikawa = np.zeros(shape = (n + 1, n + 1))
  # Home-made calculation of posteriors (no borrowing)
  # # We use the theta_grid for approximating integrals on the interval [0, 1].
  # theta_grid = np.arange(0, 1, 0.00001)
  # theta_step_width = 1/len(theta_grid)
  # posteriors_noborrow  = np.zeros(shape = (k, len(theta_grid)))
  # for i in range(0, k):
  #   posteriors_noborrow[i,] = beta.pdf(theta_grid, a = shape1 + r[i], b = shape2 + n - r[i])
  # Calculate weights
  for i in range(0, n + 1):
    weights_fujikawa[i, i] = 1
    for j in range(i + 1,  n + 1):
      # Home-made integration - Part 1
      # m = (posteriors_noborrow[i,] + posteriors_noborrow[j,])/2
      def kl_div_fun(x, i, j):
        p_x = beta.pdf(x, a = shape1 + i, b = shape2 + n - i)
        m_x = (p_x +
                beta.pdf(x, a = shape1 + j, 
                         b = shape2 + n - j))/2
        if p_x > 0 and m_x > 0:
          return p_x*log(p_x/m_x, logbase)
        elif p_x == 0 and y >= 0:
          return 0
        else:
          return Inf
      # Relative entropy is the usual Kullback-Leibler divergence
      kl_div_pm = integrate.quad(lambda x: kl_div_fun(x, i = i, j = j),
                                 0, 1)[0]
      kl_div_qm = integrate.quad(lambda x: kl_div_fun(x, i = j, j = i),
                                 0, 1)[0]
      # Home-made integration - Part 2
      # kl_div_pm = np.sum(rel_entr(posteriors_noborrow[i,], m))*theta_step_width
      # kl_div_qm = np.sum(rel_entr(posteriors_noborrow[j,], m))*theta_step_width
      weights_fujikawa_raw[i, j] = 1 - (kl_div_pm + kl_div_qm)/2
      weights_fujikawa_raw[j, i] = weights_fujikawa_raw[i, j]
      expo = weights_fujikawa_raw[i, j]**epsilon
      if expo > tau:
        weights_fujikawa[i, j] = expo
        weights_fujikawa[j, i] = weights_fujikawa[i, j]
      else:
          weights_fujikawa[i, j] = 0
          weights_fujikawa[j, i] = 0
  return weights_fujikawa
        
# Posterior probabilities
def posterior_prob(r, weight_mat):
  pp = np.zeros(shape = k)
  for i in range(0, k):
    a_borrow = sum(weight_mat[r[i],r]*(shape1 + r))
    b_borrow = sum(weight_mat[r[i],r]*(shape2 + n - r))
    pp[i] = integrate.quad(lambda x: beta.pdf(x, a = a_borrow, b = b_borrow),
                               p0, 1)[0]
  return pp

# Rejection probabilities
# def rejection_prob(lambda_par, p0, p1):
  # rp = np.zeros(shape = k)
# fwer = float('nan')
# ewp = float('nan')
# h0_true = (p0 == p1)
# get_fwer = not all(np.logical_not(h0_true))
# get_ewp = not all(h0_true)
# if get_fwer:
#   fwer = 0
# if get_ewp:
#   ewp = 0
# responses = np.array(list(product(np.arange(start = 0, stop = n + 1),
#                           repeat = k)))
# prod_sampling_prob = list(map(np.prod,
#                          list(map(lambda r: binom.pmf(np.array(r), n = n, p = p1),
#                              responses))))

# pps = list(map(posterior_prob, responses))
# reject = list(map(lambda pp: pp > lambda_par, pps))
# rp = sum(map(lambda rej, psp: rej*psp,
#              reject, prod_sampling_prob))
  # for r in tqdm(product(np.arange(start = 0, stop = n + 1), repeat = k),
  #               total = (n+1)**k):
  #   sampling_prob = binom.pmf(np.array(r), n = n, p = p1)
  #   prod_sampling_prob = np.prod(sampling_prob)
  #   reject = (posterior_prob(np.array(r)) > lambda_par)
  #   rp = rp + reject*prod_sampling_prob
  #   if get_fwer:
  #     fwer = fwer + sum(h0_true*reject*prod_sampling_prob)
  #   if get_ewp:
  #     ewp = ewp + sum(np.logical_not(h0_true)*reject*prod_sampling_prob)
  # return {'rejection_probabilities': rp,
  #         'ewp': ewp,
  #         'fwer': fwer
  #         }

# # Return - I want to return this to R using reticulate
# print("weights_fujikawa")
# print(weights_fujikawa)
# print("posterior_prob")
# print(posterior_prob(r))
# # rp = rejection_prob(lambda_par = lambda_par, p0 = p0, p1 = p1)
# print(rp)
