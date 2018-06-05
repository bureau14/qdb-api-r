#include "handle.hpp"
#include <Rcpp.h>

//' @backref src/remove.cpp
//' @title Remove an entry.
//'
//' @param handle A valid cluster opened using qdb_connect.
//' @param name Timeseries name.
//'
//' @export
//'
//' @examples
//' handle <- qdb_connect("qdb://127.0.0.1:2836")
//' qdb_remove(handle, "timeseries")
// [[Rcpp::export(name = "qdb_remove")]]
void _qdb_remove(qdb_handle_t handle, const std::string & name)
{
    if (!handle)
    {
        Rcpp::stop("invalid handle");
    }

    qdb_error_t err = ::qdb_remove(handle, name.c_str());
    if (err)
    {
        Rcpp::stop("qdb_remove: %s (code: %x)", qdb_error(err), err);
    }
}

/*** R
# TODO
*/
