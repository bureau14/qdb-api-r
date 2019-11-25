context("get_tagged")

test_that("stops when handle is null", {
  expect_error(results <-
    get_tagged(NULL, generate_alias("tag")),
  regexp = "type=NULL"
  )
})

test_that("returns empty character(0) vector when entry does not exist", {
  handle <- connect("qdb://127.0.0.1:2836")

  results <- get_tagged(handle, generate_alias("tag"))

  expect_equal(class(results), "character")
  expect_equal(length(results), 0)
})

test_that("returns tags of a timeseries", {
  handle <- connect("qdb://127.0.0.1:2836")
  alias <- create_entry(handle)

  tags <-
    c(
      generate_alias("tag"),
      generate_alias("tag"),
      generate_alias("tag")
    )
  attach_tags(handle, entry = alias, tags = tags)

  results <- get_tags(handle, alias)

  expect_equal(class(results), "character")
  expect_equal(length(results), 3)
  expect_equal(sort(results), sort(tags))
})
