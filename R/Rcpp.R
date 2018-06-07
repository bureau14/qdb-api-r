# https://cran.r-project.org/doc/manuals/r-release/R-exts.html#FOOT61
#' @useDynLib quasardb
#' @exportPattern "^[[:alpha:]]+"
#' @importFrom Rcpp sourceCpp
NULL

#' @title Type of a timeseries column.
#'
#' Possible types of a timeseries column.
#'
#' @export
column_type <- list(
    double = 0L,   # Column of floating point values.
    blob = 1L,     # Column of binary data.
    integer = 2L,  # Column of signed 64-bit integer values.
    timestamp = 3L # Column of nanosecond-precision timestamps.
)
