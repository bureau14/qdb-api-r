context("connect")

test_that("returns invalid argument when URI is invalid", {
  expect_error(handle <- qdb_connect("invalid URI")
               , regexp = "The argument is invalid")
})

test_that("returns invalid argument when cluster is down", {
  expect_error(handle <- qdb_connect("qdb://127.0.0.1:1")
               , regexp = "Connection refused")
})

test_that("connects successfully to the existing cluster using default URI", {
  expect_equal(qdbd$uri, "qdb://127.0.0.1:2836")
  handle <- qdb_connect()
  succeed(message = "successfully connected to quasardb cluster")
})

test_that("connects successfully to the existing cluster", {
  handle <- qdb_connect(qdbd$uri)
  succeed(message = "successfully connected to quasardb cluster")
})
