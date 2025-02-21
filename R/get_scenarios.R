#' Generate a matrix of default outcome scenarios
#'
#' This functions generates a matrix of `k+1` default outcome scenarios,
#' ranging from no responsive strata (global null scenarios) to all responsive
#' strata (global alternative scenario). It is a wrapper of the function
#' `basksim::get_scenarios`.
#'
#' No backend switching is implemented in this function because
#' `baskexact::get_scenarios()` does precisely the same thing as
#' `basksim::get_scenarios()`.
#'
#' @inheritParams basksim::get_scenarios
#'
#' @inherit basksim::get_scenarios return
#' @export
#'
#' @examples
#' # Example for a basket trial with Fujikawa's Design
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2)
#' get_scenarios(design, p1 = 0.5)
get_scenarios <- function(design, p1) {
  return(basksim::get_scenarios(design, p1))
}
