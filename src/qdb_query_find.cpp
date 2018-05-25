#include "handle.hpp"
#include <qdb/query.h>
#include <Rcpp.h>

//' @backref src/qdb_query_find.cpp
//' @title Execute a query to find matching entries.
//'
//' @param handle A valid cluster opened using qdb_connect.
//' @param query A query to execute.
//'
//' @return List of matching entry aliases/keys.
//' @export
//'
//' @examples
//' handle <- qdb_connect("qdb://127.0.0.1:2836")
//' qdb_query_find(handle, "query")
// [[Rcpp::export(name = "qdb_query_find")]]
Rcpp::StringVector _qdb_query_find(
    qdb_handle_t handle,
    const std::string & query)
{
  if (!handle)
  {
    Rcpp::stop("invalid handle");
  }

  const char ** aliases = NULL;
  size_t alias_count;
  qdb_error_t err = ::qdb_query_find(handle, query.c_str(), &aliases, &alias_count);
  if (err)
  {
    Rcpp::stop("qdb_query_find: %s (code: %x)", qdb_error(err), err);
  }

  Rcpp::StringVector r_aliases(alias_count);

  for (size_t i = 0; i < alias_count; ++i)
  {
    r_aliases[i] = aliases[i];
  }

  ::qdb_release(handle, aliases);

  return r_aliases;
}

/*** R
# TODO
*/
