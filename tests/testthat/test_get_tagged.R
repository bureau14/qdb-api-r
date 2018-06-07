context("get_tagged")

test_that("stops when handle is null", {
  expect_error(results <-
                 qdb_get_tagged(NULL, generate_alias("tag"))
               ,
               regexp = 'type=NULL')
})

test_that("returns empty character(0) vector when entry doesn't exist", {
  handle <- qdb_connect(qdbd$uri)

  results <- qdb_get_tagged(handle, generate_alias("tag"))

  expect_equal(class(results), "character")
  expect_equal(length(results), 0)
})

test_that("returns tags of a timeseries", {
  handle <- qdb_connect(qdbd$uri)
  alias <- create_entry(handle)

  tags <-
    c(generate_alias("tag"),
      generate_alias("tag"),
      generate_alias("tag"))
  qdb_attach_tags(handle, entry = alias, tags = tags)

  results <- qdb_get_tags(handle, alias)

  expect_equal(class(results), "character")
  expect_equal(length(results), 3)
  expect_equal(sort(results), sort(tags))
})
