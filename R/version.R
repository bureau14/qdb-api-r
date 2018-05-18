#' @useDynLib quasardb
#' @exportPattern "^[[:alpha:]]+"
#' @importFrom Rcpp evalCpp

qdb_version <- function() {
  return('quasardb 2.5')
}
