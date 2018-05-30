#include "handle.hpp"
#include <qdb/ts.h>
#include <Rcpp.h>

//' @backref src/ts_create.cpp
//' @title Create a timeseries.
//'
//' @param handle A valid cluster opened using qdb_connect.
//' @param name A name of the to-be-created timeseries.
//'
//' @export
//'
//' @examples
//' handle <- qdb_connect("qdb://127.0.0.1:2836")
//' qdb_ts_create(handle, name = "ts")
// [[Rcpp::export(name = "qdb_ts_create")]]
void _qdb_ts_create(qdb_handle_t handle, const std::string & name)
{
    if (!handle)
    {
        Rcpp::stop("invalid handle");
    }

    // TODO(marek): Create columns as given by the user.
    qdb_ts_column_info_t column{"column", qdb_ts_column_double};
    qdb_error_t err = ::qdb_ts_create(
        handle, name.c_str(), qdb_d_default_shard_size, &column, 1u);
    if (err)
    {
        Rcpp::stop("qdb_ts_create: %s (code: %x)", qdb_error(err), err);
    }
}

/*** R
# TODO
*/
