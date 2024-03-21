validate_fujikawa_x <- function(x) {
  validate_betabin(x)
  if(!(x$backend %in% c("sim", "exact"))){
    stop("backend must be either 'sim' or 'exact'.")
  }
  return(x)
}
# The following function was copied from lbau7/basksim, 2024/03/21
validate_betabin <- function(x) {
  if ((x$k %% 1) != 0) {
    stop("k must be an integer")
  }
  if (x$k <= 1) {
    stop("k must be greater than or equal to 2")
  }
  if (x$p0 <= 0 | x$p0 >= 1) {
    stop("p0 must be between 0 and 1")
  }
  if (x$shape1 <= 0 | x$shape2 <= 0) {
    stop("shape1 and shape2 must be greater than 0")
  }
  x
}
