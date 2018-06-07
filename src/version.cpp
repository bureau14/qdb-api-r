#include <qdb/client.h>
#include <Rcpp.h>

//' @backref src/version.cpp
//' @title Return quasardb API version
//'
//' Return version of the underlying quasardb C API.
//'
//' @description Version information may be useful when a problem or a bug has
//' been encountered to precisely describe the version of the API used.
//'
//' @return API version
//' @export
//'
//' @examples
//' qdb_version()
// [[Rcpp::export(name = "qdb_version")]]
std::string _qdb_version()
{
    return ::qdb_version();
}

/*** R
qdb_version()
*/
