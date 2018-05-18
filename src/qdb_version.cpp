#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
std::string qdb_version() {
  return "quasardb 2.5.0";
}

/*** R
qdb_version()
*/
