context("qdb_query")

test_that("returns alias not found when timeseries doesn't exist", {
  handle <- qdb_connect(qdbd$uri)
  expect_error(results <-
                 qdb_query(handle, "SELECT * FROM timeseries IN RANGE(2017, +1y)")
               ,
               regexp = 'An entry matching the provided alias cannot be found')
})

test_that("returns empty result on existing but empty timeseries", {
  alias <- "timeseriesL13"
  column_name <- "my_column"
  columns <- c(ColumnType$Double)
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

test_that("returns count result on existing but empty timeseries", {
  alias <- "timeseriesL25"
  column_name <- "my_column"
  columns <- c(ColumnType$Double)
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
  columns <- table$columns

  expect(
    "columns" %in% names(table),
    failure_message = sprintf(
      "table should contain columns:\nActual fields: [%s]",
      paste(names(table), collapse = ", ")
    )
  )
  expect_equal(columns, c("timestamp", sprintf("count(%s)", column_name)))

  # Check data
  expect(
    "data" %in% names(table),
    failure_message = sprintf(
      "table should contain data:\nActual fields: [%s]",
      paste(names(table), collapse = ", ")
    )
  )

  data <- table$data
  print(data)
  expect(is.data.frame(data), failure_message = "data should be a data.frame")
  expect_equal(colnames(data), c("timestamp", sprintf("count(%s)", column_name)))
  expect_equal(rownames(data), c("1"))
  expect_equal(dim(data), c(1, 2))

  expect_equal(attr(data$timestamp, "tzone"), "UTC")
  expect_equal(data$timestamp,
               ISOdatetime(
                 2017,
                 1,
                 1,
                 hour = 0,
                 min = 0,
                 sec = 0,
                 tz = "UTC"
               ))
  expect_equal(data[[sprintf("count(%s)", column_name)]], 0)
})
