context("get_tags")

test_that("stops when handle is null", {
  expect_error(get_tags(NULL, generate_alias("timeseries")),
               regexp = "type=NULL")
})

test_that("returns alias not found when the entry does not exist", {
  handle <- connect("qdb://127.0.0.1:2836")
  expect_error(get_tags(handle, generate_alias("timeseries")),
               regexp = "An entry matching the provided alias cannot be found")
})

test_that("returns empty character(0) vector when the entry has no tags", {
  handle <- connect("qdb://127.0.0.1:2836")
  alias <- create_entry(handle)

  results <- get_tags(handle, alias)

  expect_equal(class(results), "character")
  expect_equal(length(results), 0)
})

test_that("returns all tags of the entry", {
  handle <- connect("qdb://127.0.0.1:2836")
  alias <- create_entry(handle)

  tags <-
    c(generate_alias("tag"),
      generate_alias("tag"),
      generate_alias("tag"))
  attach_tags(handle, entry = alias, tags = tags)

  results <- get_tags(handle, alias)

  expect_equal(class(results), "character")
  expect_equal(length(results), 3)
  expect_equal(sort(results), sort(tags))
})
