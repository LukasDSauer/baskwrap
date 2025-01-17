from math import exp, log
import numpy as np
from scipy.special import rel_entr
from scipy.stats import beta
import scipy.integrate as integrate
# Parameters
k = 3
shape1 = 1
shape2 = 1
p0 = 0.2
n = 24
r = np.array([5, 9, 10])
epsilon = 1.25
tau = 0.5
lambda_par = 0.99
logbase = 2
# We use the theta_grid for approximating integrals on the interval [0, 1].
theta_grid = np.arange(0, 1, 0.00001)
theta_step_width = 1/len(theta_grid)
# Objects of Fujikawa's design

weights_fujikawa_raw = np.zeros(shape = (k, k))
weights_fujikawa = np.zeros(shape = (k, k))
# # Calculate posteriors (no borrowing)
# posteriors_noborrow  = np.zeros(shape = (k, len(theta_grid)))
# for i in range(0, k):
#   posteriors_noborrow[i,] = beta.pdf(theta_grid, a = shape1 + r[i], b = shape2 + n - r[i])
# Calculate weights
for i in range(0, k):
  weights_fujikawa[i, i] = 1
  for j in range(i + 1, k):
    m = (posteriors_noborrow[i,] + posteriors_noborrow[j,])/2
    def kl_div_fun(x, ii, jj):
      p_x = beta.pdf(x, a = shape1 + r[ii], b = shape2 + n - r[ii])
      m_x = (beta.pdf(x, a = shape1 + r[ii], b = shape2 + n - r[ii]) +
              beta.pdf(x, a = shape1 + r[jj], 
                       b = shape2 + n - r[jj]))/2
      return rel_entr(p_x, m_x)
    # Relative entropy is the usual Kullback-Leibler divergence
    kl_div_pm = integrate.quad(lambda x: kl_div_fun(x, ii = i, jj = j),
                               0, 1)[0]
    kl_div_qm = integrate.quad(lambda x: kl_div_fun(x, ii = j, jj = i),
                               0, 1)[0]
    # Home-made integration
    # kl_div_pm = np.sum(rel_entr(posteriors_noborrow[i,], m))*theta_step_width
    # kl_div_qm = np.sum(rel_entr(posteriors_noborrow[j,], m))*theta_step_width
    weights_fujikawa_raw[i, j] = 1 - (kl_div_pm + kl_div_qm)/2
    weights_fujikawa_raw[j, i] = weights_fujikawa_raw[i, j]
    print(weights_fujikawa_raw[i, j])
    expo = exp(epsilon * log(weights_fujikawa_raw[i, j], logbase))
    if expo > tau:
      weights_fujikawa[i, j] = expo
      weights_fujikawa[j, i] = weights_fujikawa[i, j]
    else:
        weights_fujikawa[i, j] = 0
        weights_fujikawa[j, i] = 0
      
print(weights_fujikawa)
