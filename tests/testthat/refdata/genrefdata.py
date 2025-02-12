from math import exp, log
import numpy as np
from scipy.stats import beta, binom
from itertools import product
import scipy.integrate as integrate

# Weights
def get_weights_fujikawa_py(n, shape1, shape2, epsilon, tau, logbase):
  n = int(n)
  # Objects of Fujikawa's design
  weights_fujikawa_raw = np.zeros(shape = (n + 1, n + 1))
  weights_fujikawa = np.zeros(shape = (n + 1, n + 1))
  # Calculate weights
  for i in range(0, n + 1):
    weights_fujikawa[i, i] = 1
    for j in range(i + 1,  n + 1):
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
def get_posterior_prob_py(n, k, shape1, shape2, p0,
                          r, weight_mat):
  n = int(n)
  k = int(k)
  pp = np.zeros(shape = k)
  for i in range(0, k):
    a_borrow = sum(weight_mat[r[i],r]*(shape1 + r))
    b_borrow = sum(weight_mat[r[i],r]*(shape2 + n - r))
    pp[i] = integrate.quad(lambda x: beta.pdf(x, a = a_borrow, b = b_borrow),
                               p0, 1)[0]
  return pp

# Posterior mean
def get_posterior_mean_py(n, k, shape1, shape2, r, weight_mat):
  n = int(n)
  k = int(k)
  mean = np.zeros(shape = k)
  for i in range(0, k):
    a_borrow = sum(weight_mat[r[i],r]*(shape1 + r))
    b_borrow = sum(weight_mat[r[i],r]*(shape2 + n - r))
    mean[i] = integrate.quad(lambda x: x*beta.pdf(x, a = a_borrow, b = b_borrow),
                             0, 1)[0]
  return mean

# Rejection probabilities
def get_details_py(n, k, shape1, shape2, lambda_par, p0, p1, weight_mat):
  n = int(n)
  k = int(k)
  fwer = float('nan')
  ewp = float('nan')
  h0_true = (p0 == p1)
  get_fwer = not all(np.logical_not(h0_true))
  get_ewp = not all(h0_true)
  if get_fwer:
    fwer = 0
  if get_ewp:
    ewp = 0
  responses = np.array(list(product(np.arange(start = 0, stop = n + 1),
                            repeat = k)))
  prod_sampling_prob = list(map(np.prod,
                           list(map(lambda r: binom.pmf(np.array(r), n = n, p = p1),
                               responses))))
  pps = list(map(lambda r: get_posterior_prob_py(n, k, shape1, shape2, p0,
                                                 np.array(r), weight_mat), 
                 responses))
  pmean_list = list(map(lambda r: get_posterior_mean_py(n, k, shape1, shape2, 
                                                        np.array(r),
                                                        weight_mat), responses))
  mean = sum(map(lambda pmean, psp: pmean*psp, 
                 pmean_list, prod_sampling_prob))
  mse = sum(map(lambda pmean, psp: (pmean - np.array(p1))**2*psp, 
                 pmean_list, prod_sampling_prob))
  reject = list(map(lambda pp: pp > lambda_par, pps))
  rp = sum(map(lambda rej, psp: rej*psp,
                reject, prod_sampling_prob))
  ecd = sum(map(lambda rej, psp: (sum(rej & np.logical_not(h0_true)) + 
                                    sum(np.logical_not(rej) & h0_true))*psp,
                   reject, prod_sampling_prob))
  if get_fwer:
    fwer = sum(map(lambda rej, psp: any(rej & h0_true)*psp,
                       reject, prod_sampling_prob))
  if get_ewp:
    ewp = sum(map(lambda rej, psp: any(rej & np.logical_not(h0_true))*psp,
                       reject, prod_sampling_prob))
  return {'rejection_probabilities': rp,
          'ewp': ewp,
          'fwer': fwer,
          'ecd': ecd,
          'mean': mean,
          'mse': mse}

# - Example calls. For testhat, parameters will be set automatically 
#   in genrefdata.R and helper-refdata_pyparams.R
# k = 3
# shape1 = 1
# shape2 = 1
# p0 = 0.2
# p1 = np.array([0.2, 0.5, 0.5])
# n = 15
# r = np.array([2, 9, 10])
# epsilon = 2
# tau = 0.5
# lambda_par = 0.95
# logbase = 2
# wm = get_weights_fujikawa_py(n, shape1, shape2, epsilon, tau, logbase)
# rp = get_details_py(lambda_par = lambda_par, p0 = p0, p1 = p1, 
#                            weight_mat = wm)

