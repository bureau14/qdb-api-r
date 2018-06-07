#include "handle.h"
#include <qdb/ts.h>
#include <Rcpp.h>

//' @backref src/ts_create.cpp
//' @title Create a timeseries.
//'
//' @param handle A valid cluster opened using qdb_connect.
//' @param name A name of the to-be-created timeseries.
//'
//' @export
//'
//' @examples
//' handle <- qdb_connect("qdb://127.0.0.1:2836")
//' qdb_ts_create(handle, name = "ts",
//'     columns = c("col1" = column_type$blob, "col2" = column_type$double))
// [[Rcpp::export(name = "qdb_ts_create")]]
void _qdb_ts_create(qdb_handle_t handle,
    const std::string & name,
    const Rcpp::IntegerVector & columns)
{
    if (!handle)
    {
        Rcpp::stop("invalid handle");
    }

    if (columns.size() == 0)
    {
        Rcpp::stop("columns should have at least one element");
    }

    SEXP names_attr = columns.names();
    if (Rf_isNull(names_attr))
    {
        Rcpp::stop("columns should have all elements named");
    }

    const Rcpp::StringVector & column_names = names_attr;
    if (column_names.size() == 0)
    {
        Rcpp::stop("columns should have all elements named");
    }

    std::vector<qdb_ts_column_info_t> column_infos(columns.size());
    for (size_t i = 0; i < column_infos.size(); ++i)
    {
        const char * column_name = column_names[i];
        if (!column_name || *column_name == '\0')
        {
            Rcpp::stop("columns should have all elements named");
        }
        column_infos[i].name = column_name;
        column_infos[i].type = static_cast<qdb_ts_column_type_t>(columns[i]);
    }

    qdb_error_t err = ::qdb_ts_create(handle, name.c_str(),
        qdb_d_default_shard_size, column_infos.data(), column_infos.size());
    if (err)
    {
        Rcpp::stop("qdb_ts_create: %s (code: %x)", qdb_error(err), err);
    }
}

/*** R
# TODO
*/
