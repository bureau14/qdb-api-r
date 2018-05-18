#include <Rcpp.h>
#include <qdb/client.h>
using namespace Rcpp;

// [[Rcpp::export(name = "qdb_version")]]
std::string _qdb_version() {
  return "quasardb 2.5.0";
}

/*** R
qdb_version()
*/
