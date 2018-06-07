#include "handle.h"
#include <qdb/ts.h>
#include <Rcpp.h>

//' @backref src/show.cpp
//' @title Describe a timeseries.
//'
//' @description
//' List columns, their names and types, of a timeseries.
//'
//' @seealso \code{\link{connect}}
//'
//' @param handle A valid cluster opened using `connect`.
//' @param name A name of the timeseries.
//'
//' @export
//'
//' @examples
//' handle <- connect("qdb://127.0.0.1:2836")
//' columns <- show(handle, name = "ts")
// [[Rcpp::export(name = "show")]]
Rcpp::IntegerVector _qdb_show(qdb_handle_t handle, const std::string & name)
{
    if (!handle)
    {
        Rcpp::stop("invalid handle");
    }

    qdb_ts_column_info_t * columns = nullptr;
    qdb_size_t column_count        = 0;
    qdb_error_t err =
        ::qdb_ts_list_columns(handle, name.c_str(), &columns, &column_count);
    if (err)
    {
        Rcpp::stop("qdb_ts_list_columns: %s (code: %x)", qdb_error(err), err);
    }

    Rcpp::StringVector names(column_count);
    Rcpp::IntegerVector types(column_count);

    assert(names.size() == column_count);
    assert(names.size() == types.size());

    for (R_xlen_t i = 0; i < names.size(); ++i)
    {
        auto && name = names[i];
        auto && type = types[i];

        name = std::string{columns[i].name};
        type = static_cast<int>(columns[i].type);
    }

    types.names() = names;

    return types;
}
