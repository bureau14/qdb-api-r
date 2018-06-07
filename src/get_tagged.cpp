#include "handle.hpp"
#include <qdb/tag.h>
#include <Rcpp.h>

//' @backref src/get_tagged.cpp
//' @title Return all entries tagged by a tag.
//'
//' @param handle A valid cluster opened using qdb_connect.
//' @param tag An alias (key) of a tag.
//'
//' @return List of entries.
//' @export
//'
//' @examples
//' handle <- qdb_connect("qdb://127.0.0.1:2836")
//' qdb_get_tagged(handle, tag = "tag")
// [[Rcpp::export(name = "qdb_get_tagged")]]
Rcpp::StringVector _qdb_get_tagged(qdb_handle_t handle, const std::string & tag)
{
    if (!handle)
    {
        Rcpp::stop("invalid handle");
    }

    const char ** aliases = nullptr;
    size_t alias_count;
    qdb_error_t err =
        ::qdb_get_tagged(handle, tag.c_str(), &aliases, &alias_count);
    if (err)
    {
        Rcpp::stop("qdb_get_tagged: %s (code: %x)", qdb_error(err), err);
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
