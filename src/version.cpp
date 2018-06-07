#include <qdb/client.h>
#include <Rcpp.h>

//' @backref src/version.cpp
//' @title Return quasardb API version
//'
//' @description
//' Return version of the underlying quasardb C API.
//'
//' Version information may be useful when a problem or a bug has
//' been encountered to precisely describe the version of the API used.
//'
//' @return API version
//' @export
//'
//' @examples
//' version()
// [[Rcpp::export(name = "version")]]
std::string _qdb_version()
{
    return ::qdb_version();
}
