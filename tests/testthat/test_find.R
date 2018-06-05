context("find")

test_that("stops when handle is null", {
  expect_error(results <-
                 qdb_find(NULL, "find(tag='stocks' and type=ts)")
               ,
               regexp = 'type=NULL')
})

test_that("returns successfully with some results", {
  handle <- qdb_connect(qdbd$uri)
  results <- qdb_find(handle, "find(tag='stocks' and type=ts)")
  expect_equal(length(results), 0)
})
