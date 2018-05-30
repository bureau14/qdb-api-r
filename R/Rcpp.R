# https://cran.r-project.org/doc/manuals/r-release/R-exts.html#FOOT61
#' @useDynLib quasardb
#' @exportPattern "^[[:alpha:]]+"
#' @importFrom Rcpp sourceCpp
NULL

#' @export
ColumnType <- list(
    Double = 0L,   # Column of floating point values.
    Blob = 1L,     # Column of binary data.
    Integer = 2L,  # Column of signed 64-bit integer values.
    Timestamp = 3L # Column of nanosecond-precision timestamps.
)
