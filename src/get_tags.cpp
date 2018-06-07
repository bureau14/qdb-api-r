#include "handle.hpp"
#include <qdb/tag.h>
#include <Rcpp.h>

//' @backref src/get_tags.cpp
//' @title Return all tags of an entry.
//'
//' @param handle A valid cluster opened using qdb_connect.
//' @param name An alias (key) of an entry.
//'
//' @return List of tags.
//' @export
//'
//' @examples
//' handle <- qdb_connect("qdb://127.0.0.1:2836")
//' qdb_get_tags(handle, name = "key")
// [[Rcpp::export(name = "qdb_get_tags")]]
Rcpp::StringVector _qdb_get_tags(qdb_handle_t handle, const std::string & name)
{
    if (!handle)
    {
        Rcpp::stop("invalid handle");
    }

    const char ** aliases = nullptr;
    size_t alias_count;
    qdb_error_t err =
        ::qdb_get_tags(handle, name.c_str(), &aliases, &alias_count);
    if (err)
    {
        Rcpp::stop("qdb_get_tags: %s (code: %x)", qdb_error(err), err);
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
