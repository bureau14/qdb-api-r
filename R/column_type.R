#' @title Type of a timeseries column.
#'
#' Possible types of a timeseries column.
#'
#' @description Currently, a timeseries can have columns of the following types:
#'   - double    - column of floating point values.
#'   - blob      - column of binary data.
#'   - integer   - column of signed 64-bit integer values.
#'   - string    - column of utf8 strings.
#'   - timestamp - column of nanosecond-precision timestamps.
#'
#' @export
column_type <- list(
  double = 0L,
  blob = 1L,
  integer = 2L,
  string = 3L,
  timestamp = 4L
)
