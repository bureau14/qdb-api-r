context("detach_tags")

test_that("stops when handle is null", {
  expect_error(
    results <-
      detach_tags(NULL, entry = generate_alias(),
                      tags = generate_alias("tag"))
    ,
    regexp = "type=NULL"
  )
})

test_that("successfully untags entry with a single tag", {
  handle <- connect(qdbd$uri)
  alias <- create_entry(handle)

  tag <- generate_alias("tag")
  attach_tags(handle, entry = alias, tags = tag)
  detach_tags(handle, entry = alias, tags = tag)
  attach_tags(handle, entry = alias, tags = tag)
  succeed("detached single tag")
})

test_that("successfully untags entry with many tags", {
  handle <- connect(qdbd$uri)
  alias <- create_entry(handle)

  tags <- c(generate_alias("tag"), generate_alias("tag"))
  attach_tags(handle, entry = alias, tags = tags)
  detach_tags(handle, entry = alias, tags = tags)
  attach_tags(handle, entry = alias, tags = tags)
  succeed("detached many tags")
})
