context("attach_tags")

test_that("stops when handle is null", {
  expect_error(
    results <-
      attach_tags(NULL, entry = generate_alias(),
                      tags = generate_alias("tag"))
    ,
    regexp = "type=NULL"
  )
})

test_that("successfully tags timeseries with a single tag", {
  handle <- connect(qdbd$uri)
  alias <- create_entry(handle)

  tag <- generate_alias("tag")
  attach_tags(handle, entry = alias, tags = tag)

  expect_error(results <-
                 attach_tags(handle, entry = alias, tag)
               ,
               regexp = "attach_tag:.*already.*tag")
})

test_that("successfully tags timeseries with many tags", {
  handle <- connect(qdbd$uri)
  alias <- create_entry(handle)

  tags <- c(generate_alias("tag"), generate_alias("tag"))
  attach_tags(handle, entry = alias, tags = tags)

  sapply(tags, function(tag) {
    expect_error(results <-
                   attach_tags(handle, entry = alias, tags = tag)
                 ,
                 regexp = "attach_tag:.*already.*tag")
  })
})
