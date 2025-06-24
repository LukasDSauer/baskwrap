#' Set up a Fujikawa design object with flexible backend
#'
#' The `fujikawa_x` S3 class is similar to the `basksim::fujikawa` class, but
#' it has an additional parameter `backend`, that allows users to decide which
#' backend should be used for calculation of details (i.e. rejection rates,
#' power, type-I error rate etc.): the `basksim` package or the
#' `baskexact` package.
#'
#' @inheritParams basksim::setup_fujikawa
#' @inheritParams set_backend
#'
#' @return An object of class `fujikawa_x`.
#' @export
#'
#' @examples
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2)
setup_fujikawa_x <- function(k, p0, shape1 = 1, shape2 = 1, backend = "sim") {
  design <- validate_fujikawa_x(structure(
    list(k = k, p0 = p0, shape1 = shape1, shape2 = shape2, backend = backend,
         design_exact = NULL),
    class = c("fujikawa_x", "fujikawa")
  ))
  design <- set_backend(design, backend)
  return(design)
}

#' Set baskexact design object
#'
#' For a given object of class `fujikawa_x`, this function sets the attribute
#' `fujikawa_x$design_exact` to `baskexact::OneStageBasket` object with the
#' same attributes as the given design. The attribute will then be used in
#' internal calls to `baskexact`.
#'
#' @param design An object of class `fujikawa_x`, i.e. a Fujikawa basket trial
#' design.
#'
#' @inherit setup_fujikawa_x return
set_design_exact <- function(design){
  if(is.null(design$design_exact)){
    design$design_exact <- baskexact::setupOneStageBasket(k = design$k,
                                                          p0 = design$p0,
                                                          shape1 = design$shape1,
                                                          shape2 = design$shape2)
  }
  return(design)
}

#' Set the backend of a Fujikawa design
#'
#' For a basket trial design of class `fujikawa_x`, set the backend.
#'
#' @inheritParams set_design_exact
#' @param backend A string, either `"sim"` or `"exact"` for specifying the
#' use of the `basksim` package or the `baskexact` package for calculation
#' of basket trial details.
#'
#' @inherit setup_fujikawa_x return
#' @export
#'
#' @examples
#' design <- setup_fujikawa_x(k = 3, p0 = 0.2)
#' design <- set_backend(design, backend = "exact")
set_backend <- function(design, backend){
  if(!(backend %in% c("exact", "sim"))){
    stop("backend must be either 'sim' or 'exact'.")
  }
  design$backend = backend
  if(design$backend == "exact"){
    design <- set_design_exact(design)
  }
  return(design)
}
