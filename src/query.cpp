#include "handle.hpp"
#include <qdb/query.h>
#include <Rcpp.h>

static inline std::string transform_qdb_string(const qdb_string_t s)
{
    return {s.data, s.length};
}

template <typename T>
static inline std::string transform_blob(const T & blob)
{
    return {static_cast<const char *>(blob.content), blob.content_length};
}

Rcpp::StringVector transform_columns(
    const qdb_string_t * columns_names, qdb_size_t columns_count)
{
    assert(columns_names);

    Rcpp::StringVector r_columns{columns_count};

    qdb_size_t i = 0u;
    for (auto & column : r_columns)
    {
        column = transform_qdb_string(columns_names[i++]);
    }

    return r_columns;
}

Rcpp::StringVector transform_blob_points(
    qdb_point_result_t ** rows, qdb_size_t rows_count, qdb_size_t column_index)
{
    assert(rows);

    Rcpp::StringVector column(rows_count);
    for (qdb_size_t row_index = 0u; row_index < rows_count; ++row_index)
    {
        const auto & point = rows[row_index][column_index];
        assert(point.type == qdb_query_result_blob);
        column[row_index] = transform_blob(point.payload.blob);
    }

    return column;
}

Rcpp::DoubleVector transform_double_points(
    qdb_point_result_t ** rows, qdb_size_t rows_count, qdb_size_t column_index)
{
    assert(rows);

    Rcpp::DoubleVector column(rows_count);
    for (qdb_size_t row_index = 0u; row_index < rows_count; ++row_index)
    {
        const auto & point = rows[row_index][column_index];
        assert(point.type == qdb_query_result_double);
        column[row_index] = point.payload.double_.value;
    }

    return column;
}

Rcpp::IntegerVector transform_int64_points(
    qdb_point_result_t ** rows, qdb_size_t rows_count, qdb_size_t column_index)
{
    assert(rows);

    Rcpp::IntegerVector column(rows_count);
    for (qdb_size_t row_index = 0u; row_index < rows_count; ++row_index)
    {
        const auto & point = rows[row_index][column_index];
        assert(point.type == qdb_query_result_int64);
        column[row_index] = point.payload.int64_.value;
    }

    return column;
}

// See:
// http://gallery.rcpp.org/articles/creating-integer64-and-nanotime-vectors/
Rcpp::NumericVector transform_timestamp_points(
    qdb_point_result_t ** rows, qdb_size_t rows_count, qdb_size_t column_index)
{
    assert(rows);

    Rcpp::NumericVector column(rows_count);
    for (qdb_size_t row_index = 0u; row_index < rows_count; ++row_index)
    {
        const auto & point = rows[row_index][column_index];
        assert(point.type == qdb_query_result_timestamp);
        // The type underlying nanotime type is integer64 in nanoseconds.
        const auto & timestamp = point.payload.timestamp.value;
        const std::int64_t total_nsec =
            timestamp.tv_sec * 1'000'000'000LL + timestamp.tv_nsec;
        // We use this trick to avoid reinterpret_cast<double>(int64_t) and UB.
        // Generated assembly code should be the same.
#if 1
        std::memcpy(&column[row_index], &total_nsec, sizeof(double));
#else
        // Equivalent code would be:
        column[row_index] = *reinterpret_cast<const double *>(&total_nsec);
#endif
    }

    Rcpp::CharacterVector cl = Rcpp::CharacterVector::create("nanotime");
    cl.attr("package")       = "nanotime";
    column.attr(".S3Class")  = "integer64";
    column.attr("class")     = cl;
    SET_S4_OBJECT(column);

    // quasardb returns timestamps in UTC time zone.
    // column.attr("tzone") = "UTC";

    return column;
}

Rcpp::DataFrame transform_rows(qdb_point_result_t ** rows,
    qdb_size_t rows_count,
    qdb_size_t columns_count,
    const Rcpp::StringVector & columns)
{
    assert(rows);
    assert(rows_count > 0);
    assert(columns_count > 0);

    Rcpp::List df; // {rows_count * columns_count};

    for (qdb_size_t column_index = 0u; column_index < columns_count;
         ++column_index)
    {
        switch (rows[0][column_index].type)
        {
        case qdb_query_result_blob:
            df.push_back(transform_blob_points(rows, rows_count, column_index));
            break;

        case qdb_query_result_double:
            df.push_back(
                transform_double_points(rows, rows_count, column_index));
            break;

        case qdb_query_result_int64:
            df.push_back(
                transform_int64_points(rows, rows_count, column_index));
            break;

        case qdb_query_result_timestamp:
            df.push_back(
                transform_timestamp_points(rows, rows_count, column_index));
            break;

        default:
            assert(!"unknown data type");
            df.push_back(Rcpp::GenericVector(rows_count));
            break;
        }
    }

    // Set row.names (FIXME: optional?)
    Rcpp::StringVector row_names(rows_count);
    for (qdb_size_t i = 0u; i < rows_count; ++i)
    {
        row_names[i] = std::to_string(i + 1);
    }
    df.attr("row.names") = row_names;

    df.names() = columns;
    df.attr("class") = "data.frame";

    return df;
}

Rcpp::List transform_table(const qdb_table_result_t & table)
{
    auto r_columns =
        transform_columns(table.columns_names, table.columns_count);

    auto rows = transform_rows(
        table.rows, table.rows_count, table.columns_count, r_columns);

    return Rcpp::List::create( //
        Rcpp::Named("columns_count", table.columns_count),
        Rcpp::Named("rows_count", table.rows_count),
        Rcpp::Named("columns", r_columns), Rcpp::Named("data", rows));
}

Rcpp::List transform_tables(
    const qdb_table_result_t * tables, qdb_size_t tables_count)
{
    assert(tables);

    Rcpp::List r_tables; // {Rcpp::no_init(tables_count)};

    for (qdb_size_t i = 0u; i < tables_count; ++i)
    {
        const qdb_table_result_t & table = tables[i];

        r_tables.push_back(
            /*object=*/transform_table(table),
            /*name=*/transform_qdb_string(table.table_name));
    }

    return r_tables;
}

Rcpp::List transform_result(const qdb_query_result_t & result)
{
    if (result.tables_count > 0)
    {
        Rcpp::List r_tables =
            transform_tables(result.tables, result.tables_count);

        return Rcpp::List::create( //
            Rcpp::Named("scanned_rows_count", result.scanned_rows_count),
            Rcpp::Named("tables_count", result.tables_count),
            Rcpp::Named("tables", r_tables));
    }

    return Rcpp::List::create( //
        Rcpp::Named("scanned_rows_count", result.scanned_rows_count),
        Rcpp::Named("tables_count", result.tables_count));
}

//' @backref src/query.cpp
//' @title Execute a query.
//'
//' @param handle A valid cluster opened using qdb_connect.
//' @param query A query to execute.
//'
//' @return A data frame with results of the query.
//' @export
//'
//' @examples
//' handle <- qdb_connect("qdb://127.0.0.1:2836")
//' qdb_query(handle, "SELECT * FROM timeseries IN RANGE(2017, +1y)")
// [[Rcpp::export(name = "qdb_query")]]
Rcpp::List _qdb_query(qdb_handle_t handle, const std::string & query)
{
    if (!handle)
    {
        Rcpp::stop("invalid handle");
    }

    qdb_query_result_t * result = nullptr;
    qdb_error_t err = ::qdb_exp_query(handle, query.c_str(), &result);
    if (err)
    {
        Rcpp::stop("qdb_exp_query: %s (code: %x)", qdb_error(err), err);
    }
    if (!result)
    {
        Rcpp::stop("qdb_exp_query: returned null result");
    }

    auto r_result = transform_result(*result);

    ::qdb_release(handle, result);

    return r_result;
}

/*** R
# TODO
*/
