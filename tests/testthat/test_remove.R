context("remove")

test_that("stops when handle is null", {
  expect_error(results <-
                 qdb_remove(NULL,
                            generate_alias("timeseries"))
               ,
               regexp = "type=NULL")
})

test_that("correctly removes a timeseries", {
  handle <- qdb_connect(qdbd$uri)
  alias <- create_timeseries(handle)

  qdb_remove(handle, name = alias)

  qdb_ts_create(handle,
                name = alias,
                columns = c("my_column" = column_type$double))
  succeed("timeseries removed")
})
