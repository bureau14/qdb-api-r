#include "handle.h"
#include <qdb/query.h>
#include <Rcpp.h>

//' @backref src/find.cpp
//' @title Execute a find query.
//'
//' @description
//' Execute a query to find matching entries.
//' A find query should be composed of at least one `tag='some_tag'` part.
//' It may also limit the type of entries through the use of `type=?`.
//' The type may be one of: `blob`, `deque`, `int` (or `integer`), `stream`,
//' `tag` or `ts`.
//' Logical operations `and` and `or` as well as negation `not` may be used as
//' well.
//'
//' @param handle A valid cluster opened using qdb_connect.
//' @param query A query to execute.
//'
//' @return List of matching entry aliases/keys.
//' @export
//'
//' @examples
//' handle <- qdb_connect("qdb://127.0.0.1:2836")
//' qdb_find(handle, "find(tag='my_tag' and type=ts)")
// [[Rcpp::export(name = "qdb_find")]]
Rcpp::StringVector _qdb_query_find(
    qdb_handle_t handle, const std::string & query)
{
    if (!handle)
    {
        Rcpp::stop("invalid handle");
    }

    const char ** aliases = nullptr;
    size_t alias_count;
    qdb_error_t err =
        ::qdb_query_find(handle, query.c_str(), &aliases, &alias_count);
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
