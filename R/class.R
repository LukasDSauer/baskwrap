setup_fujikawaxt <- function(k, p0, shape1 = 1, shape2 = 1, backend = "sim") {
  validate_fujikawaxt(structure(
    list(k = k, p0 = p0, shape1 = shape1, shape2 = shape2),
    class = c("fujikawaxt", "fujikawa")
  ))
}
