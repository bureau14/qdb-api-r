#include "handle.h"
#include <qdb/ts.h>
#include <Rcpp.h>

//' @backref src/ts_insert.cpp
//'
//' @title Insert floating-point data.
//'
//' @description
//' Insert floating-point data into double column of an existing timeseries.
//'
//' @seealso \code{\link{connect}}
//'
//' @param handle A valid cluster opened using `connect`.
//' @param name Timeseries name.
//' @param column Column name.
//'
//' @export
//'
//' @examples
//' handle <- connect("qdb://127.0.0.1:2836")
//' ts_insert.double(handle, "timeseries", "column", points)
// [[Rcpp::export(name = "ts_insert.double")]]
void _qdb_ts_double_insert(
    qdb_handle_t handle, const std::string & name, const std::string & column)
{
    if (!handle)
    {
        Rcpp::stop("invalid handle");
    }
    const std::vector<qdb_ts_double_point> values{
        qdb_ts_double_point{
            qdb_timespec_t{1483228800, 0}, 1.1}, // 2017-01-01T00:00:01
        qdb_ts_double_point{
            qdb_timespec_t{1483228801, 0}, 2.2}, // 2017-01-01T00:00:02
        qdb_ts_double_point{
            qdb_timespec_t{1483228802, 0}, 3.3} // 2017-01-01T00:00:03
    };

    qdb_error_t err = ::qdb_ts_double_insert(
        handle, name.c_str(), column.c_str(), values.data(), values.size());
    if (err)
    {
        Rcpp::stop("qdb_ts_double_insert: %s (code: %x)", qdb_error(err), err);
    }
}
