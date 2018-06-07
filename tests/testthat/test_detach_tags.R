context("detach_tags")

test_that("stops when handle is null", {
  expect_error(
    results <-
      qdb_detach_tags(NULL, entry = generate_alias(), tags = generate_alias("tag"))
    ,
    regexp = 'type=NULL'
  )
})

test_that("successfully untags entry with a single tag", {
  handle <- qdb_connect(qdbd$uri)
  alias <- create_entry(handle)

  tag <- generate_alias("tag")
  qdb_attach_tags(handle, entry = alias, tags = tag)
  qdb_detach_tags(handle, entry = alias, tags = tag)
  qdb_attach_tags(handle, entry = alias, tags = tag)
  succeed("detached single tag")
})

test_that("successfully untags entry with many tags", {
  handle <- qdb_connect(qdbd$uri)
  alias <- create_entry(handle)

  tags <- c(generate_alias("tag"), generate_alias("tag"))
  qdb_attach_tags(handle, entry = alias, tags = tags)
  qdb_detach_tags(handle, entry = alias, tags = tags)
  qdb_attach_tags(handle, entry = alias, tags = tags)
  succeed("detached many tags")
})
