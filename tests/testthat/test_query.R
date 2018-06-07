context("query")

test_that("stops when handle is null", {
  expect_error(results <-
                 qdb_query(NULL, "SELECT * FROM timeseries IN RANGE(2017, +1y)")
               ,
               regexp = 'type=NULL')
})

test_that("returns alias not found when timeseries doesn't exist", {
  handle <- qdb_connect(qdbd$uri)
  expect_error(results <-
                 qdb_query(handle, "SELECT * FROM timeseries IN RANGE(2017, +1y)")
               ,
               regexp = 'An entry matching the provided alias cannot be found')
})

test_that("returns empty result on existing but empty timeseries", {
  alias <- generate_alias("timeseries")
  column_name <- generate_alias("column")
  columns <- c(column_type$double)
  names(columns) <- c(column_name)

  handle <- qdb_connect(qdbd$uri)
  qdb_ts_create(handle,
                name = alias,
                columns = columns)
  results <-
    qdb_query(handle, sprintf("SELECT * FROM %s IN RANGE(2017, +1y)", alias))

  expect(is.list(results), failure_message = "query result should be a list")
  expect_named(results, c("scanned_rows_count", "tables_count"))

  expect_equal(results$scanned_rows_count, 0)
  expect_equal(results$tables_count, 0)
})

test_that("returns count result on empty 1-column timeseries", {
  alias <- generate_alias("timeseries")
  column_name <- generate_alias("column")
  columns <- c(column_type$double)
  names(columns) <- c(column_name)

  handle <- qdb_connect(qdbd$uri)
  qdb_ts_create(handle,
                name = alias,
                columns = columns)
  results <-
    qdb_query(handle,
              sprintf("SELECT COUNT(*) FROM %s IN RANGE(2017, +1y)", alias))

  expect(is.list(results), failure_message = "query result should be a list")

  expect("scanned_rows_count" %in% names(results), failure_message = "query result should contain scanned_rows_count")
  expect_equal(results$scanned_rows_count, 0)

  expect("tables_count" %in% names(results), failure_message = "query result should contain tables_count")
  expect_equal(results$tables_count, 1)

  # Check tables
  expect("tables" %in% names(results), failure_message = "query result should contain tables")

  tables <- results$tables
  expect_equal(length(tables), 1)

  expect(
    alias %in% names(tables),
    failure_message = sprintf(
      "tables should contain <timeseries name>: [%s]",
      paste(names(tables), collapse = ", ")
    )
  )

  # Check table
  table <- tables[[alias]]

  expect(
    "columns_count" %in% names(table),
    failure_message = sprintf(
      "table should contain columns_count: [%s]",
      paste(names(table), collapse = ", ")
    )
  )
  expect_equal(table$columns_count, 2)

  expect(
    "rows_count" %in% names(table),
    failure_message = sprintf(
      "table should contain rows_count: [%s]",
      paste(names(table), collapse = ", ")
    )
  )
  expect_equal(table$rows_count, 1)

  # Check columns
  expect(
    "columns" %in% names(table),
    failure_message = sprintf(
      "table should contain columns: [%s]",
      paste(names(table), collapse = ", ")
    )
  )

  expect(
    "columns" %in% names(table),
    failure_message = sprintf(
      "table should contain columns:\nActual fields: [%s]",
      paste(names(table), collapse = ", ")
    )
  )
  actual_columns <- table$columns
  expect_equal(actual_columns, c("timestamp", sprintf("count(%s)", column_name)))

  # Check data
  expect(
    "data" %in% names(table),
    failure_message = sprintf(
      "table should contain data:\nActual fields: [%s]",
      paste(names(table), collapse = ", ")
    )
  )

  data <- table$data
  expect(is.data.frame(data), failure_message = "data should be a data.frame")
  expect_equal(colnames(data), c("timestamp", sprintf("count(%s)", column_name)))
  expect_equal(rownames(data), c("1"))
  expect_equal(dim(data), c(1, 2))

  #expect_equal(attr(data$timestamp, "tzone"), "UTC")
  expect_equal(format(data$timestamp, "%Y-%m-%dT%H:%M:%E9S"),
               "2017-01-01T00:00:00.000000000")
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
      generate_alias('col'),
      generate_alias('col'),
      generate_alias('col'),
      generate_alias('col')
    )
  expected_column_names <-
    c("timestamp", sprintf("count(%s)", names(columns)))

  handle <- qdb_connect(qdbd$uri)
  qdb_ts_create(handle,
                name = alias,
                columns = columns)
  results <-
    qdb_query(handle,
              sprintf("SELECT COUNT(*) FROM %s IN RANGE(2018-02-03, +1y)", alias))

  expect_equal(results$scanned_rows_count, 0)
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

  expect_equal(format(data$timestamp, "%Y-%m-%dT%H:%M:%E9S"),
               "2018-02-03T00:00:00.000000000")
  expect_equal(unlist(data[, 2:length(data)]), rep(0L, length(columns)), check.names = FALSE)
})
