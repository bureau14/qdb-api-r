context("find")

test_that("stops when handle is null", {
  expect_error(results <-
                 find(NULL, "find(tag='stocks' and type=ts)")
               ,
               regexp = "type=NULL")
})

test_that("returns empty results when no tagged entries", {
  handle <- connect(qdbd$uri)
  results <-
    find(handle,
             sprintf("find(tag='%s' and type=ts)", generate_alias("tag")))
  expect_equal(length(results), 0)
})

test_that("returns key of a single tagged entry", {
  handle <- connect(qdbd$uri)
  alias <- create_entry(handle)

  tag <- generate_alias("tag")
  attach_tags(handle, entry = alias, tags = tag)

  results <- find(handle, sprintf("find(tag='%s')", tag))
  expect_equal(results, alias)
})

test_that("returns key of a single tagged timeseries", {
  handle <- connect(qdbd$uri)
  alias <- create_timeseries(handle)

  tag <- generate_alias("tag")
  attach_tags(handle, entry = alias, tags = tag)

  results <- find(handle, sprintf("find(tag='%s' and type=ts)", tag))
  expect_equal(results, alias)
})
