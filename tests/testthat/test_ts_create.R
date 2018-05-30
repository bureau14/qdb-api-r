context("qdb_ts_create")

test_that("successfully creates a timeseries", {
  handle <- qdb_connect(qdbd$uri)
  qdb_ts_create(handle, "ts_create_L5")
  succeed("timeseries created")
})

test_that("returns error when entry already exists", {
  handle <- qdb_connect(qdbd$uri)
  name <- "ts_create_L11"
  qdb_ts_create(handle, name = name)
  expect_error(qdb_ts_create(handle, name = name)
               ,
               regexp = '.*entry.*already exists.*')
})
