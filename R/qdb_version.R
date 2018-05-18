#' @useDynLib quasardb
#' @exportPattern "^[[:alpha:]]+"
#' @importFrom Rcpp sourceCpp

qdb_version <- function() {
  return('quasardb 2.5')
}
