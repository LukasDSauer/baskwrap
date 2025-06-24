#' Check whether an R object is a `baskexact` design.
#'
#' @param design An R object.
#' @param baskexact_class A character string to specify the respective `baskexact`
#' class, e.g. `"OneStageBasket"` or `"TwoStageBasket"`.
#'
#' @returns A logical.
#' @export
#'
#' @examples
#' design <- baskexact::setupOneStageBasket(k = 3, p0 = 0.2)
#' is_baskexact_design(design, "OneStageBasket")
is_baskexact_design <- function(design, baskexact_class){
  if(!is.null(attr(class(design), "package"))){
    if("baskexact" %in% attr(class(design), "package")){
      if(baskexact_class %in% class(design)){
        return(TRUE)
      }
    }
  }
  return(FALSE)
}
#' Class conversions
#'
#' These convenience functions can convert objects from the `baskexact`,
#' `basksim` and `baskwrap` into one another.
#'
#' `convert_to_fujikawa_x()` can currently convert objects of class
#' `"OneStageBasket"` from the `baskexact` package to objects of class
#' `fujikawa_x`. The functions `convert_to_baskexact()` and
#' `convert_to_basksim()` can convert `fujikawa_x` objects to `baskexact`
#' and `basksim` objects, respectively.
#'
#' @param design An R object.
#'
#' @returns An object of class `fujikawa_x`.
#' @export
#'
#' @examples
#' design <- baskexact::setupOneStageBasket(k = 3, p0 = 0.2)
#' design_fujx <- convert_to_fujikawa_x(design)
#' design_bsim <- convert_to_basksim(design_fujx)
#' # Below should be identical to initial design
#' design_bx <- convert_to_baskexact(design_fujx)
convert_to_fujikawa_x <- function(design){
  if("fujikawa_x" %in% class(design)){
    return(design)
  } else if(is_baskexact_design(design, "OneStageBasket")) {
    return(setup_fujikawa_x(k = design@k,
                     p0 = design@p0,
                     shape1 = design@shape1,
                     shape2 = design@shape2,
                     backend = "exact"))
  } else if("fujikawa" %in% class(design)){
    return(setup_fujikawa_x(k = design$k,
                            p0 = design$p0,
                            shape1 = design$shape1,
                            shape2 = design$shape2,
                            backend = "sim"))
  } else {
    stop("Cannot convert this object to object of class fujikawa_x.")
  }
}

#' @export
#' @rdname convert_to_fujikawa_x
convert_to_baskexact <- function(design){
  return(set_design_exact(design)$design_exact)
}

#' @export
#' @rdname convert_to_fujikawa_x
convert_to_basksim <- function(design){
  return(basksim::setup_fujikawa(k = design$k,
                        p0 = design$p0,
                        shape1 = design$shape1,
                        shape2 = design$shape2))
}
