#include <qdb/client.h>
#include <qdb/tag.h>
#include <Rcpp.h>

//' @backref src/Detach_tags.cpp
//' @title Detach tags from an entry.
//'
//' Detach one or many tags from an existing entry.
//'
//' @export
//'
//' @examples
//' qdb_detach_tags(handle, 'key', 'tag')
// [[Rcpp::export(name = "qdb_detach_tags")]]
void _qdb_detach_tags(qdb_handle_t handle,
    const std::string & entry,
    const std::vector<std::string> & tags)
{
    if (!handle)
    {
        Rcpp::stop("invalid handle");
    }

    if (tags.size() == 1)
    {
        qdb_error_t err =
            ::qdb_detach_tag(handle, entry.c_str(), tags.front().c_str());
        if (err)
        {
            Rcpp::stop("qdb_detach_tag: %s (code: %x)", qdb_error(err), err);
        }
        return;
    }

    // Make a shallow copy of tags.
    std::vector<const char *> ctags(tags.size());
    for (auto i = 0u; i < ctags.size(); ++i)
    {
        ctags[i] = tags[i].c_str();
    }

    qdb_error_t err =
        ::qdb_detach_tags(handle, entry.c_str(), ctags.data(), ctags.size());
    if (err)
    {
        Rcpp::stop("qdb_detach_tags: %s (code: %x)", qdb_error(err), err);
    }
}

/*** R
qdb_build()
*/
