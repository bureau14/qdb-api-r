#include <Rcpp.h>
#include <qdb/client.h>

//' @backref src/error.cpp
//' @title Return error description.
//'
//' @description
//' Return error description string for a given error code.
//'
//' @param code Error code.
//'
//' @return Error description string.
//' @export
//'
//' @examples
//' error(code = 0)
// [[Rcpp::export(name = "error")]]
std::string _qdb_error(int code) {
  const qdb_error_t err = static_cast<qdb_error_t>(code);
  return ::qdb_error(err);
}
