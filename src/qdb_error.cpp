#include <Rcpp.h>
#include <qdb/client.h>

//' @backref src/qdb_error.cpp
//' @title Return error description.
//' 
//' Return error description string for a given error code.
//' 
//' @param code Error code.
//' 
//' @return Error description string.
//' @export
//' 
//' @examples
//' handle <- qdb_error(0)
// [[Rcpp::export(name = "qdb_error")]]
std::string _qdb_error(int ierr) {
  const qdb_error_t err = static_cast<qdb_error_t>(ierr);
  return ::qdb_error(err);
}

/*** R
# TODO
*/
