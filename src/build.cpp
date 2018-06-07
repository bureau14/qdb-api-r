#include <qdb/client.h>
#include <Rcpp.h>

//' @backref src/build.cpp
//' @title Return quasardb API build information.
//'
//' @description
//' Return build information of the underlying quasardb C API.
//'
//' Build information may be useful when a problem or a bug has
//' been encountered to precisely describe the version of the API used.
//'
//' @return API build information
//' @export
//'
//' @examples
//' build()
// [[Rcpp::export(name = "build")]]
std::string _qdb_build()
{
    return ::qdb_build();
}
