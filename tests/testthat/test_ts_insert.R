context("ts_insert")

test_that("stops when handle is null", {
  expect_error(
    ts_double_insert(
      NULL,
      generate_alias("timeseries"),
      generate_alias("column")
    ),
    regexp = "type=NULL"
  )
})

test_that("returns alias not found when timeseries does not exist", {
  handle <- connect("qdb://127.0.0.1:2836")
  expect_error(ts_double_insert(
    handle,
    generate_alias("timeseries"),
    generate_alias("column")
  ),
  regexp = "An entry matching the provided alias cannot be found")
})

test_that("returns column not found when column does not exist", {
  alias <- generate_alias("timeseries")
  column_name <- generate_alias("column")
  columns <- c(column_type$double)
  names(columns) <- c(column_name)

  handle <- connect("qdb://127.0.0.1:2836")
  ts_create(handle,
            name = alias,
            columns = columns)

  expect_error(ts_double_insert(handle,
                                name = alias,
                                column = generate_alias("column")),
               regexp = "The timeseries does not contain this column")
})

test_that("returns empty result on existing but empty timeseries", {
  alias <- generate_alias("timeseries")
  column_name <- generate_alias("column")
  columns <- c(column_type$double)
  names(columns) <- c(column_name)

  handle <- connect("qdb://127.0.0.1:2836")
  ts_create(handle, name = alias, columns = columns)

  results <-
    query(handle, sprintf("SELECT * FROM %s IN RANGE(2018, +1y)", alias))

  expect_equal(results$scanned_point_count, 0)

  expect_equal(results$column_count, 3)
  expect_equal(results$row_count, 0)
})
