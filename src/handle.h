#pragma once

#include <RcppCommon.h>
#include <Rcpp/XPtr.h>
#include <qdb/client.h>
#include <qdb/ts.h>

RCPP_EXPOSED_ENUM_NODECL(qdb_ts_column_type_t)

// Wrap qdb_close. We need a function returning void.
inline void handle_close(qdb_handle_t handle)
{
  // We ignore return value.
  ::qdb_close(handle);
}

typedef Rcpp::XPtr<qdb_handle_internal, Rcpp::PreserveStorage, &handle_close> r_handle_type;

//RCPP_EXPOSED_CLASS_NODECL(qdb_handle_internal);

namespace Rcpp
{

template <>
inline qdb_handle_t as(SEXP sexp) {
  r_handle_type rh(sexp);
  return rh;
}

template <>
inline SEXP wrap(const qdb_handle_t & h) {
  r_handle_type rh(h);
  return rh;
}

} // namespace Rcpp
