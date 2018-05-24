#include <Rcpp.h>
#include <qdb/client.h>
using namespace Rcpp;

//' Return quasardb API build information.
//' 
//' Return build information of the underlying quasardb C API.
//' 
//' @return API build information
//' @export
//' @examples
//' qdb_build()
// [[Rcpp::export(name = "qdb_build")]]
std::string _qdb_build() {
  return ::qdb_build();
}

/*** R
qdb_build()
*/
