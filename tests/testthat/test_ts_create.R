context("ts_create")

test_that("stops when handle is null", {
  expect_error(ts_create(
    NULL,
    generate_alias("timeseries"),
    columns = c("my_column" = column_type$double)
  ),
  regexp = "type=NULL")
})

test_that("successfully creates a timeseries with one column", {
  handle <- connect("qdb://127.0.0.1:2836")
  ts_create(handle,
            generate_alias("timeseries"),
            columns = c("my_column" = column_type$double))
  succeed("timeseries created")
})

test_that("successfully creates a timeseries with many columns", {
  handle <- connect("qdb://127.0.0.1:2836")
  ts_create(
    handle,
    generate_alias("timeseries"),
    columns = c(
      "my_column1" = column_type$blob,
      "my_column2" = column_type$double,
      "my_column3" = column_type$integer,
      "my_column4" = column_type$timestamp
    )
  )
  succeed("timeseries created")
})

test_that("stops when column is not named", {
  handle <- connect("qdb://127.0.0.1:2836")
  expect_error(ts_create(
    handle,
    generate_alias("timeseries"),
    columns = c(column_type$double)
  ),
  regexp = "columns should have all elements named")
  succeed("timeseries created")
})

test_that("stops when not all columns are named", {
  handle <- connect("qdb://127.0.0.1:2836")
  expect_error(ts_create(
    handle,
    generate_alias("timeseries"),
    columns = c("my_column" = column_type$double, column_type$blob)
  ),
  regexp = "columns should have all elements named")
  succeed("timeseries created")
})

test_that("returns error when entry already exists", {
  handle <- connect("qdb://127.0.0.1:2836")
  name <- generate_alias("timeseries")
  ts_create(handle,
            name = name,
            columns = c("my_column" = column_type$double))
  expect_error(ts_create(
    handle,
    name = name,
    columns = c("my_column" = column_type$double)
  ),
  regexp = ".*entry.*already exists.*")
})
