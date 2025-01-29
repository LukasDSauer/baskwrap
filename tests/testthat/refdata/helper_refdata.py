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

# Objects of Fujikawa's design
weights_fujikawa_raw = np.zeros(shape = (k, k))
weights_fujikawa = np.zeros(shape = (k, k))

# Home-made calculation of posteriors (no borrowing)
# # We use the theta_grid for approximating integrals on the interval [0, 1].
# theta_grid = np.arange(0, 1, 0.00001)
# theta_step_width = 1/len(theta_grid)
# posteriors_noborrow  = np.zeros(shape = (k, len(theta_grid)))
# for i in range(0, k):
#   posteriors_noborrow[i,] = beta.pdf(theta_grid, a = shape1 + r[i], b = shape2 + n - r[i])


# Calculate weights
for i in range(0, k):
  weights_fujikawa[i, i] = 1
  for j in range(i + 1, k):
    # Home-made integration - Part 1
    # m = (posteriors_noborrow[i,] + posteriors_noborrow[j,])/2
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
    # Home-made integration - Part 2
    # kl_div_pm = np.sum(rel_entr(posteriors_noborrow[i,], m))*theta_step_width
    # kl_div_qm = np.sum(rel_entr(posteriors_noborrow[j,], m))*theta_step_width
    weights_fujikawa_raw[i, j] = 1 - (kl_div_pm + kl_div_qm)/2
    weights_fujikawa_raw[j, i] = weights_fujikawa_raw[i, j]
    expo = exp(epsilon * log(weights_fujikawa_raw[i, j], logbase))
    if expo > tau:
      weights_fujikawa[i, j] = expo
      weights_fujikawa[j, i] = weights_fujikawa[i, j]
    else:
        weights_fujikawa[i, j] = 0
        weights_fujikawa[j, i] = 0
        
# Posterior probabilities
def posterior_prob(r):
  pp = np.zeros(shape = k)
  for i in range(0, k):
    a_borrow = sum(weights_fujikawa[i,]*(shape1 + r))
    b_borrow = sum(weights_fujikawa[i,]*(shape2 + n - r))
    print("a_borrow")
    print(a_borrow)
    print("b_borrow")
    print(b_borrow)
    pp[i] = integrate.quad(lambda x: beta.pdf(x, a = a_borrow, b = b_borrow),
                               p0, 1)[0]
  return pp
# Rejection probabilities
def rejection_prob(lambda_par):
  rp = np.zeros(shape = k)
  outcomes = np.zeros(shape = (n**k, k))
  for i in range(0, n**k):
    for j in range(0, k):
      vec_add = np.zeros(shape = (1,k))
      vec_add[0, j] = 1
      print(vec_add)
      # Outcomes is a home-made cartesian product
      outcomes[i,] = outcomes[i-1,] + vec_add
  # Calculate posterior_prob() and np.binom.pmf()

# Return - I want to return this to R using reticulate
print("weights_fujikawa")
print(weights_fujikawa)
print("posterior_prob")
print(posterior_prob(r))
print("cartesian_prod")
print(outcomes)
