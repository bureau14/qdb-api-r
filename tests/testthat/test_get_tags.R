context("get_tags")

test_that("stops when handle is null", {
  expect_error(results <-
                 qdb_get_tags(NULL, generate_alias("timeseries"))
               ,
               regexp = "type=NULL")
})

test_that("returns alias not found when the entry does not exist", {
  handle <- qdb_connect(qdbd$uri)
  expect_error(results <-
                 qdb_get_tags(handle, generate_alias("timeseries"))
               ,
               regexp = "An entry matching the provided alias cannot be found")
})

test_that("returns empty character(0) vector when the entry has no tags", {
  handle <- qdb_connect(qdbd$uri)
  alias <- create_entry(handle)

  results <- qdb_get_tags(handle, alias)

  expect_equal(class(results), "character")
  expect_equal(length(results), 0)
})

test_that("returns all tags of the entry", {
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
