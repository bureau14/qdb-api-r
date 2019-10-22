#include "handle.h"
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
    const qdb_string_t * column_names, qdb_size_t column_count)
{
    assert(column_names);

    Rcpp::StringVector r_columns{column_count};

    qdb_size_t i = 0u;
    for (auto & column : r_columns)
    {
        column = transform_qdb_string(column_names[i++]);
    }

    return r_columns;
}

Rcpp::StringVector transform_blob_points(
    qdb_point_result_t ** rows, qdb_size_t row_count, qdb_size_t column_index)
{
    assert(rows);

    Rcpp::StringVector column(row_count);
    for (qdb_size_t row_index = 0u; row_index < row_count; ++row_index)
    {
        const auto & point = rows[row_index][column_index];
        assert(point.type == qdb_query_result_blob);
        column[row_index] = transform_blob(point.payload.blob);
    }

    return column;
}

Rcpp::IntegerVector transform_count_points(
    qdb_point_result_t ** rows, qdb_size_t row_count, qdb_size_t column_index)
{
    assert(rows);

    Rcpp::IntegerVector column(row_count);
    for (qdb_size_t row_index = 0u; row_index < row_count; ++row_index)
    {
        const auto & point = rows[row_index][column_index];
        assert(point.type == qdb_query_result_count);
        column[row_index] = point.payload.count.value;
    }

    return column;
}

Rcpp::DoubleVector transform_double_points(
    qdb_point_result_t ** rows, qdb_size_t row_count, qdb_size_t column_index)
{
    assert(rows);

    Rcpp::DoubleVector column(row_count);
    for (qdb_size_t row_index = 0u; row_index < row_count; ++row_index)
    {
        const auto & point = rows[row_index][column_index];
        assert(point.type == qdb_query_result_double);
        column[row_index] = point.payload.double_.value;
    }

    return column;
}

Rcpp::IntegerVector transform_int64_points(
    qdb_point_result_t ** rows, qdb_size_t row_count, qdb_size_t column_index)
{
    assert(rows);

    Rcpp::IntegerVector column(row_count);
    for (qdb_size_t row_index = 0u; row_index < row_count; ++row_index)
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
    qdb_point_result_t ** rows, qdb_size_t row_count, qdb_size_t column_index)
{
    assert(rows);

    Rcpp::NumericVector column(row_count);
    for (qdb_size_t row_index = 0u; row_index < row_count; ++row_index)
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
    qdb_size_t row_count,
    qdb_size_t column_count,
    const Rcpp::StringVector & columns)
{
    assert(rows);
    assert(column_count > 0);

    Rcpp::DataFrame df; // {row_count * column_count};

    if (!row_count)
    {
        // For some reason I need to redo these steps in the other case
        df.attr("row.names") = Rcpp::IntegerVector{};
        df.attr("class")     = "data.frame";
        return df;
    }

    for (qdb_size_t column_index = 0u; column_index < column_count;
         ++column_index)
    {
        std::string column_name = Rcpp::as<std::string>(columns[column_index]);
        switch (rows[0][column_index].type)
        {
        case qdb_query_result_blob:
            df.push_back(transform_blob_points(rows, row_count, column_index),
                std::move(column_name));
            break;

        case qdb_query_result_count:
            df.push_back(transform_count_points(rows, row_count, column_index),
                std::move(column_name));
            break;

        case qdb_query_result_double:
            df.push_back(transform_double_points(rows, row_count, column_index),
                std::move(column_name));
            break;

        case qdb_query_result_int64:
            df.push_back(transform_int64_points(rows, row_count, column_index),
                std::move(column_name));
            break;

        case qdb_query_result_timestamp:
            df.push_back(
                transform_timestamp_points(rows, row_count, column_index),
                std::move(column_name));
            break;

        default:
            assert(!"unknown data type");
            df.push_back(
                Rcpp::GenericVector(row_count), std::move(column_name));
            break;
        }
    }

    // dataframe rows start count at 1
    Rcpp::IntegerVector row_names(row_count);
    for (qdb_size_t i = 0u; i < row_count; ++i)
    {
        row_names[i] = i + 1;
    }
    // if not set dim(rows) for one row will be (0, x) instead of (1, x)
    df.attr("row.names") = row_names;

    df.attr("class") = "data.frame";

    return df;
}

Rcpp::List transform_result(const qdb_query_result_t & result)
{
    auto r_columns =
        transform_columns(result.column_names, result.column_count);

    auto rows = transform_rows(
        result.rows, result.row_count, result.column_count, r_columns);

    return Rcpp::List::create(
        Rcpp::Named("scanned_point_count", result.scanned_point_count), //
        Rcpp::Named("column_count", result.column_count),               //
        Rcpp::Named("columns", r_columns),                              //
        Rcpp::Named("row_count", result.row_count),                     //
        Rcpp::Named("rows", rows)                                       //
    );
}

//' @backref src/query.cpp
//' @title Execute a query.
//'
//' @description
//' Execute a select query using SQL-like syntax.
//'
//' @seealso \url{https://doc.quasardb.net/master/api/queries.html.}
//' @seealso \code{\link{connect}}
//'
//' @param handle A valid cluster opened using `connect`.
//' @param query A query to execute.
//'
//' @return A data frame with results of the query.
//' @export
//'
//' @examples
//' handle <- connect("qdb://127.0.0.1:2836")
//' query(handle, "SELECT * FROM timeseries IN RANGE(2017, +1y)")
// [[Rcpp::export(name = "query")]]
Rcpp::List _qdb_query(qdb_handle_t handle, const std::string & query)
{
    if (!handle)
    {
        Rcpp::stop("invalid handle");
    }

    qdb_query_result_t * result = nullptr;
    qdb_error_t err             = ::qdb_query(handle, query.c_str(), &result);
    if (err)
    {
        Rcpp::stop("qdb_query: %s (code: %x)", qdb_error(err), err);
    }
    if (!result)
    {
        Rcpp::stop("qdb_query: returned null result");
    }

    auto r_result = transform_result(*result);

    ::qdb_release(handle, result);

    return r_result;
}
