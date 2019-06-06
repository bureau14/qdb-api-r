context("query")

expect_member <- function(object, member_name) {
  act <- quasi_label(rlang::enquo(object))

  expect(
    member_name %in% names(object),
    failure_message =
      sprintf(
        "object %s should contain `%s`, but contains: [%s]",
        act$lab,
        member_name,
        paste(names(act$val), collapse = ", ")
      )
  )

  invisible(act$val)
}

expect_na <- function(object) {
  act <- quasi_label(rlang::enquo(object))

  expect(is.na(act$val),
         sprintf(
           "got %s of type %s instead of NA.",
           format(act$val),
           typeof(act$val)
         ))

  invisible(act$val)
}

test_that("stops when handle is null", {
  expect_error(results <-
                 query(NULL, "SELECT * FROM timeseries IN RANGE(2017, +1y)")
               ,
               regexp = "type=NULL")
})

test_that("returns alias not found when timeseries does not exist", {
  handle <- connect(qdbd$uri)
  expect_error(
    results <-
      query(handle, query = "SELECT * FROM timeseries IN RANGE(2017, +1y)")
    ,
    regexp = "An entry matching the provided alias cannot be found"
  )
})

test_that("returns empty result on existing but empty timeseries", {
  alias <- generate_alias("timeseries")
  column_name <- generate_alias("column")
  columns <- c(column_type$double)
  names(columns) <- c(column_name)

  handle <- connect(qdbd$uri)
  ts_create(handle,
                name = alias,
                columns = columns)
  results <-
    query(handle, sprintf("SELECT * FROM %s IN RANGE(2017, +1y)", alias))

  expect(is.list(results), failure_message = "query result should be a list")
  expect_named(results, c("scanned_point_count", "tables_count"))

  expect_equal(results$scanned_point_count, 0)
  expect_equal(results$tables_count, 0)
})

test_that("returns count result on empty 1-column timeseries", {
  alias <- generate_alias("timeseries")
  column_name <- generate_alias("column")
  columns <- c(column_type$double)
  names(columns) <- c(column_name)

  handle <- connect(qdbd$uri)
  ts_create(handle,
                name = alias,
                columns = columns)
  results <-
    query(handle,
              sprintf("SELECT COUNT(*) FROM %s IN RANGE(2017, +1y)", alias))

  expect(is.list(results), failure_message = "query result should be a list")

  expect_member(results, "scanned_point_count")
  expect_equal(results$scanned_point_count, 0)

  expect_member(results, "tables_count")
  expect_equal(results$tables_count, 1)

  # Check tables
  expect_member(results, "tables")

  tables <- results$tables
  expect_equal(length(tables), 1)

  expect_member(tables, alias)
  expect(
    alias %in% names(tables),
    failure_message = sprintf(
      "tables should contain <timeseries name>: [%s]",
      paste(names(tables), collapse = ", ")
    )
  )

  # Check table
  table <- tables[[alias]]

  expect_member(table, "columns_count")
  expect_equal(table$columns_count, 2)

  expect_member(table, "rows_count")
  expect_equal(table$rows_count, 1)

  # Check columns
  expect_member(table, "columns")

  actual_columns <- table$columns
  expect_equal(actual_columns,
               c("$timestamp", sprintf("count(%s)", column_name)))

  # Check data
  expect_member(table, "data")

  data <- table$data
  expect(is.data.frame(data), failure_message = "data should be a data.frame")
  expect_equal(colnames(data),
               c("$timestamp", sprintf("count(%s)", column_name)))
  expect_equal(rownames(data), c("1"))
  expect_equal(dim(data), c(1, 2))

  expect_na(data[["$timestamp"]])
  expect_equal(data[[sprintf("count(%s)", column_name)]], 0)
})

test_that("returns count result on empty multi-column timeseries", {
  alias <- generate_alias("timeseries")
  columns <-
    c(column_type$blob,
      column_type$double,
      column_type$integer,
      column_type$timestamp)
  names(columns) <-
    c(
      generate_alias("col"),
      generate_alias("col"),
      generate_alias("col"),
      generate_alias("col")
    )
  expected_column_names <-
    c("$timestamp", sprintf("count(%s)", names(columns)))

  handle <- connect(qdbd$uri)
  ts_create(handle,
                name = alias,
                columns = columns)

  query <- sprintf("SELECT COUNT(*) FROM %s IN RANGE(2018-02-03, +1y)", alias)
  results <- query(handle, query)

  expect_equal(results$scanned_point_count, 0)
  expect_equal(results$tables_count, 1)

  tables <- results$tables
  table <- tables[[alias]]

  expect_equal(table$columns_count, 1 + length(columns))
  expect_equal(table$rows_count, 1)

  actual_columns <- table$columns

  expect_equal(actual_columns, expected_column_names)

  data <- table$data
  expect(is.data.frame(data), failure_message = "data should be a data.frame")
  expect_equal(colnames(data), expected_column_names)
  expect_equal(rownames(data), c("1"))
  expect_equal(dim(data), c(1, 5))

  expect_na(data[["$timestamp"]])
  expect_equal(unlist(data[, 2:length(data)]),
               rep(0L, length(columns)),
               check.names = FALSE)
})

test_that("returns count result on multiple timeseries", {
  alias1 <- generate_alias("timeseries")
  alias2 <- generate_alias("timeseries")
  column_name <- generate_alias("column")
  columns <- c(column_type$double)
  names(columns) <- c(column_name)

  handle <- connect(qdbd$uri)
  ts_create(handle, name = alias1, columns = columns)
  ts_create(handle, name = alias2, columns = columns)

  query <-
    sprintf("SELECT COUNT(*) FROM %s, %s IN RANGE(2017, +1y)", alias1, alias2)
  results <- query(handle, query)

  expect_equal(results$scanned_point_count, 0)
  expect_equal(results$tables_count, 2)

  sapply(results$tables, function(table) {
    data <- table$data
    expect_na(data[["$timestamp"]])
    expect_equal(unlist(data[, 2:length(data)]),
                 rep(0L, length(columns)),
                 check.names = FALSE)
  })
})
