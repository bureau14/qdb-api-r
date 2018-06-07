#include "handle.h"
#include <Rcpp.h>

//' @backref src/remove.cpp
//' @title Remove an entry.
//'
//' @description
//' Remove an existing entry from the database.
//'
//' @seealso \code{\link{connect}}
//'
//' @param handle A valid cluster opened using `connect`.
//' @param name Timeseries name.
//'
//' @export
//'
//' @examples
//' handle <- connect("qdb://127.0.0.1:2836")
//' remove(handle, "timeseries")
// [[Rcpp::export(name = "remove")]]
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
