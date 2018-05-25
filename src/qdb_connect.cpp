#include "handle.hpp"
#include <Rcpp.h>

//' @backref src/qdb_connect.cpp
//' @title Connect to a quasardb cluster.
//'
//' Connect to a quasardb cluster described with the given URI and returns a handle to it.
//' The URI must be in a form \code{"qdb://<ip or hostname>:<port>[, ...]"}.
//'
//' @param uri Cluster URI, e.g.: \code{"qdb://127.0.0.1:2836"}, \code{"qdb://10.0.1.1:2836,10.0.1.2:2837,my.database.com:2838"}.
//' @return Handle to the cluster
//'
//' @export
//'
//' @examples
//' handle <- qdb_connect("qdb://127.0.0.1:2836")
// [[Rcpp::export(name = "qdb_connect")]]
qdb_handle_t _qdb_connect(const std::string & uri) {
  qdb_handle_t handle = ::qdb_open_tcp();
  if (!handle)
  {
    Rcpp::stop("cannot open TCP handle");
  }

  qdb_error_t err = ::qdb_connect(handle, uri.c_str());
  if (err)
  {
    Rcpp::stop("cannot connect to cluster: %s (code: %x)", qdb_error(err), err);
  }

  return handle;
}

/*** R
# TODO
*/
