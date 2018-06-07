# https://cran.r-project.org/doc/manuals/r-release/R-exts.html#FOOT61
#' @useDynLib quasardb
#' @exportPattern "^[[:alpha:]]+"
#' @importFrom Rcpp sourceCpp
NULL

#' @title Type of a timeseries column.
#'
#' Possible types of a timeseries column.
#'
#' @description Currently, a timeseries can have columns of the following types:
#'   - double    - column of floating point values.
#'   - blob      - column of binary data.
#'   - integer   - column of signed 64-bit integer values.
#'   - timestamp - column of nanosecond-precision timestamps.
#'
#' @export
column_type <- list(
    double = 0L,
    blob = 1L,
    integer = 2L,
    timestamp = 3L
)
