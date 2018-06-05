context("remove")

test_that("stops when handle is null", {
  expect_error(results <-
                 qdb_remove(NULL,
                            generate_alias("timeseries"))
               ,
               regexp = 'type=NULL')
})

test_that("correctly removes a timeseries", {
  handle <- qdb_connect(qdbd$uri)
  name <- generate_alias("timeseries")
  qdb_ts_create(handle,
                name = name,
                columns = c("my_column" = ColumnType$Double))
  qdb_remove(handle, name = name)
  qdb_ts_create(handle,
                name = name,
                columns = c("my_column" = ColumnType$Double))
  succeed("timeseries removed")
})
