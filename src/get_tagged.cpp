#include "handle.h"
#include <qdb/tag.h>
#include <Rcpp.h>

//' @backref src/get_tagged.cpp
//' @title Get tagged entries.
//'
//' @description
//' Return keys of all the entries tagged by the given tag.
//'
//' @seealso \code{\link{connect}}
//'
//' @param handle A valid cluster opened using `connect`.
//' @param tag An alias (key) of a tag.
//'
//' @return List of entries.
//' @export
//'
//' @examples
//' handle <- connect("qdb://127.0.0.1:2836")
//' get_tagged(handle, tag = "tag")
// [[Rcpp::export(name = "get_tagged")]]
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
