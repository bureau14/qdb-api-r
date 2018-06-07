context("ts_insert")

test_that("stops when handle is null", {
  expect_error(results <-
                 ts_insert.double(
                   NULL,
                   generate_alias("timeseries"),
                   generate_alias("column")
                 )
               ,
               regexp = "type=NULL")
})

test_that("returns alias not found when timeseries does not exist", {
  handle <- connect(qdbd$uri)
  expect_error(
    results <-
      ts_insert.double(
        handle,
        generate_alias("timeseries"),
        generate_alias("column")
      )
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

  ts_insert.double(handle,
                       name = alias,
                       column = column_name)

  results <-
    query(handle, sprintf("SELECT * FROM %s IN RANGE(2018, +1y)", alias))

  expect_equal(results$scanned_rows_count, 1)

  tables <- results$tables
  table <- tables[[alias]]
  expect_equal(table$columns_count, 2)
  expect_equal(table$rows_count, 1)
  actual_columns <- table$columns
  expect_equal(actual_columns, c("timestamp", column_name))

  data <- table$data
  expect_equal(format(data$timestamp, "%Y-%m-%dT%H:%M:%E9S"),
               "2018-04-05T06:07:08.123456789")
  expect_equal(data[[column_name]], 1.2345)
})
