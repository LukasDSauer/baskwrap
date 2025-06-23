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
#' Convert to a fujikawa_x object
#'
#' This function can currently convert objects for class `"OneStageBasket"` from
#' the `baskexact` package to objects of class `fujikawa_x`.
#'
#' @param design An R object.
#'
#' @returns An object of class `fujikawa_x`.
#' @export
#'
#' @examples
#' design <- baskexact::setupOneStageBasket(k = 3, p0 = 0.2)
#' design <- convert_to_fujikawa_x(design)
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
