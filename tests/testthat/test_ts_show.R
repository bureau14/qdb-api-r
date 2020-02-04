context("ts_show")

test_that("stops when handle is null", {
  expect_error(ts_show(NULL, generate_alias("timeseries")),
               regexp = "type=NULL")
})

test_that("returns alias not found when timeseries does not exist", {
  handle <- connect("qdb://127.0.0.1:2836")
  expect_error(ts_show(handle, generate_alias("timeseries")),
               regexp = "An entry matching the provided alias cannot be found")
})

test_that("returns info of multi-column timeseries", {
  alias <- generate_alias("timeseries")
  columns <-
    c(
      column_type$blob,
      column_type$double,
      column_type$integer,
      column_type$timestamp
    )
  names(columns) <-
    c(
      generate_alias("col"),
      generate_alias("col"),
      generate_alias("col"),
      generate_alias("col")
    )

  handle <- connect("qdb://127.0.0.1:2836")
  ts_create(handle,
            name = alias,
            columns = columns)

  results <- ts_show(handle, alias)

  expect_equal(class(results), "integer")
  expect_equal(length(results), 4)
  expect_equal(results, columns)
})
