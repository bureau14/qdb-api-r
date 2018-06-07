#include <qdb/client.h>
#include <qdb/tag.h>
#include <Rcpp.h>

//' @backref src/attach_tags.cpp
//' @title Attach tags to an entry.
//'
//' Attach one or many tags to an existing entry.
//'
//' @param handle A valid cluster opened using qdb_connect.
//' @param entry An alias (key) of an entry.
//' @param tags A vector of tag names to attach.
//'
//' @export
//'
//' @examples
//' qdb_attach_tags(handle, 'key', 'tag')
// [[Rcpp::export(name = "qdb_attach_tags")]]
void _qdb_attach_tags(qdb_handle_t handle,
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
            ::qdb_attach_tag(handle, entry.c_str(), tags.front().c_str());
        if (err)
        {
            Rcpp::stop("qdb_attach_tag: %s (code: %x)", qdb_error(err), err);
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
        ::qdb_attach_tags(handle, entry.c_str(), ctags.data(), ctags.size());
    if (err)
    {
        Rcpp::stop("qdb_attach_tags: %s (code: %x)", qdb_error(err), err);
    }
}

/*** R
qdb_build()
*/
