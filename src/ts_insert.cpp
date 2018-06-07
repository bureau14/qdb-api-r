#include "handle.h"
#include <qdb/ts.h>
#include <Rcpp.h>

//' @backref src/ts_insert.cpp
//' @title Insert data into double column of an existing timeseries.
//'
//' @param handle A valid cluster opened using qdb_connect.
//' @param name Timeseries name.
//' @param column Column name.
//'
//' @export
//'
//' @examples
//' handle <- qdb_connect("qdb://127.0.0.1:2836")
//' qdb_ts_insert.double(handle, "timeseries", "column", points)
// [[Rcpp::export(name = "qdb_ts_insert.double")]]
void _qdb_ts_double_insert(qdb_handle_t handle, const std::string & name, const std::string & column)
{
    if (!handle)
    {
        Rcpp::stop("invalid handle");
    }

    std::vector<qdb_ts_double_point> values{
        {qdb_timespec_t{1'522'908'428, 123'456'789}, 1.2345} // 2018-04-05T06:07:08.123456789+00:00
    };

    qdb_error_t err = ::qdb_ts_double_insert(handle, name.c_str(), column.c_str(), values.data(), values.size());
    if (err)
    {
        Rcpp::stop("qdb_ts_double_insert: %s (code: %x)", qdb_error(err), err);
    }
}

/*** R
# TODO
*/
