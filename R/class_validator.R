validate_fujikawaxt <- function(x) {
  basksim::validate_betabin(x)
  if(!(x$backend = c("sim", "exact"))){
    stop("backend must be either 'sim' or 'exact'.")
  }
}
