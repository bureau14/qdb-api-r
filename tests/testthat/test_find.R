context("qdb_find")

test_that("returns successfully with some results", {
  handle <- qdb_connect(qdbd$uri)
  results <- qdb_find(handle, "find(tag='stocks' and type=ts)")
  expect_equal(length(results), 0)
})
