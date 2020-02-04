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

//' @backref src/error.cpp
//' @title Return last error.
//'
//' @description
//' Return error description of the last error occurred when calling the API.
//'
//' @return Last error description.
//' @export
//'
//' @examples
//' get_last_error()
// [[Rcpp::export(name = "get_last_error")]]
std::string _qdb_get_last_error() {
  qdb_error_t err;
  qdb_string_t message;
  ::qdb_get_last_error(&err, &message);
  if (!message.data || !message.length) {
    return {};
  }
  return std::string(message.data, message.length);
}
