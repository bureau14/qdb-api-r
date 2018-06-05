// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include "quasardb_types.h"
#include <Rcpp.h>

using namespace Rcpp;

// _qdb_build
std::string _qdb_build();
RcppExport SEXP _quasardb__qdb_build() {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    rcpp_result_gen = Rcpp::wrap(_qdb_build());
    return rcpp_result_gen;
END_RCPP
}
// _qdb_connect
qdb_handle_t _qdb_connect(const std::string& uri);
RcppExport SEXP _quasardb__qdb_connect(SEXP uriSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const std::string& >::type uri(uriSEXP);
    rcpp_result_gen = Rcpp::wrap(_qdb_connect(uri));
    return rcpp_result_gen;
END_RCPP
}
// _qdb_error
std::string _qdb_error(int ierr);
RcppExport SEXP _quasardb__qdb_error(SEXP ierrSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< int >::type ierr(ierrSEXP);
    rcpp_result_gen = Rcpp::wrap(_qdb_error(ierr));
    return rcpp_result_gen;
END_RCPP
}
// _qdb_query_find
Rcpp::StringVector _qdb_query_find(qdb_handle_t handle, const std::string& query);
RcppExport SEXP _quasardb__qdb_query_find(SEXP handleSEXP, SEXP querySEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< qdb_handle_t >::type handle(handleSEXP);
    Rcpp::traits::input_parameter< const std::string& >::type query(querySEXP);
    rcpp_result_gen = Rcpp::wrap(_qdb_query_find(handle, query));
    return rcpp_result_gen;
END_RCPP
}
// _qdb_query
Rcpp::List _qdb_query(qdb_handle_t handle, const std::string& query);
RcppExport SEXP _quasardb__qdb_query(SEXP handleSEXP, SEXP querySEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< qdb_handle_t >::type handle(handleSEXP);
    Rcpp::traits::input_parameter< const std::string& >::type query(querySEXP);
    rcpp_result_gen = Rcpp::wrap(_qdb_query(handle, query));
    return rcpp_result_gen;
END_RCPP
}
// _qdb_remove
void _qdb_remove(qdb_handle_t handle, const std::string& name);
RcppExport SEXP _quasardb__qdb_remove(SEXP handleSEXP, SEXP nameSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< qdb_handle_t >::type handle(handleSEXP);
    Rcpp::traits::input_parameter< const std::string& >::type name(nameSEXP);
    _qdb_remove(handle, name);
    return R_NilValue;
END_RCPP
}
// _qdb_ts_create
void _qdb_ts_create(qdb_handle_t handle, const std::string& name, const Rcpp::IntegerVector& columns);
RcppExport SEXP _quasardb__qdb_ts_create(SEXP handleSEXP, SEXP nameSEXP, SEXP columnsSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< qdb_handle_t >::type handle(handleSEXP);
    Rcpp::traits::input_parameter< const std::string& >::type name(nameSEXP);
    Rcpp::traits::input_parameter< const Rcpp::IntegerVector& >::type columns(columnsSEXP);
    _qdb_ts_create(handle, name, columns);
    return R_NilValue;
END_RCPP
}
// _qdb_ts_double_insert
void _qdb_ts_double_insert(qdb_handle_t handle, const std::string& name, const std::string& column);
RcppExport SEXP _quasardb__qdb_ts_double_insert(SEXP handleSEXP, SEXP nameSEXP, SEXP columnSEXP) {
BEGIN_RCPP
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< qdb_handle_t >::type handle(handleSEXP);
    Rcpp::traits::input_parameter< const std::string& >::type name(nameSEXP);
    Rcpp::traits::input_parameter< const std::string& >::type column(columnSEXP);
    _qdb_ts_double_insert(handle, name, column);
    return R_NilValue;
END_RCPP
}
// _qdb_version
std::string _qdb_version();
RcppExport SEXP _quasardb__qdb_version() {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    rcpp_result_gen = Rcpp::wrap(_qdb_version());
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_quasardb__qdb_build", (DL_FUNC) &_quasardb__qdb_build, 0},
    {"_quasardb__qdb_connect", (DL_FUNC) &_quasardb__qdb_connect, 1},
    {"_quasardb__qdb_error", (DL_FUNC) &_quasardb__qdb_error, 1},
    {"_quasardb__qdb_query_find", (DL_FUNC) &_quasardb__qdb_query_find, 2},
    {"_quasardb__qdb_query", (DL_FUNC) &_quasardb__qdb_query, 2},
    {"_quasardb__qdb_remove", (DL_FUNC) &_quasardb__qdb_remove, 2},
    {"_quasardb__qdb_ts_create", (DL_FUNC) &_quasardb__qdb_ts_create, 3},
    {"_quasardb__qdb_ts_double_insert", (DL_FUNC) &_quasardb__qdb_ts_double_insert, 3},
    {"_quasardb__qdb_version", (DL_FUNC) &_quasardb__qdb_version, 0},
    {NULL, NULL, 0}
};

RcppExport void R_init_quasardb(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
