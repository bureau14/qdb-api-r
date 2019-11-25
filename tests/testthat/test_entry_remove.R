context("entry_remove")

test_that("stops when handle is null", {
  expect_error(results <-
    entry_remove(
      NULL,
      generate_alias("timeseries")
    ),
  regexp = "type=NULL"
  )
})

test_that("correctly removes a timeseries", {
  handle <- connect("qdb://127.0.0.1:2836")
  alias <- create_timeseries(handle)

  entry_remove(handle, name = alias)

  ts_create(handle,
    name = alias,
    columns = c("my_column" = column_type$double)
  )
  succeed("timeseries removed")
})
