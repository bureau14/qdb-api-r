context("qdb_ts_create")

test_that("successfully creates a timeseries with one column", {
  handle <- qdb_connect(qdbd$uri)
  qdb_ts_create(handle,
                "ts_create_L5",
                columns = c("my_column" = ColumnType$Double))
  succeed("timeseries created")
})

test_that("successfully creates a timeseries with many columns", {
  handle <- qdb_connect(qdbd$uri)
  qdb_ts_create(
    handle,
    "ts_create_L14",
    columns = c(
      "my_column1" = ColumnType$Blob,
      "my_column2" = ColumnType$Double,
      "my_column3" = ColumnType$Integer,
      "my_column4" = ColumnType$Timestamp
    )
  )
  succeed("timeseries created")
})

test_that("stops when column is not named", {
  handle <- qdb_connect(qdbd$uri)
  expect_error(qdb_ts_create(handle,
                             "ts_create_L23",
                             columns = c(ColumnType$Double))
               , regexp = 'columns should have all elements named')
  succeed("timeseries created")
})

test_that("stops when not all columns are named", {
  handle <- qdb_connect(qdbd$uri)
  expect_error(qdb_ts_create(
    handle,
    "ts_create_L34",
    columns = c("my_column" = ColumnType$Double, ColumnType$Blob)
  )
  , regexp = 'columns should have all elements named')
  succeed("timeseries created")
})

test_that("returns error when entry already exists", {
  handle <- qdb_connect(qdbd$uri)
  name <- "ts_create_L43"
  qdb_ts_create(handle,
                name = name,
                columns = c("my_column" = ColumnType$Double))
  expect_error(qdb_ts_create(
    handle,
    name = name,
    columns = c("my_column" = ColumnType$Double)
  )
  ,
  regexp = '.*entry.*already exists.*')
})
