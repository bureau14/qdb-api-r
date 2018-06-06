context("detach_tags")

test_that("stops when handle is null", {
  expect_error(
    results <-
      qdb_detach_tags(NULL, entry = generate_alias(), tags = generate_alias("tag"))
    ,
    regexp = 'type=NULL'
  )
})

test_that("successfully untags timeseries with a single tag", {
  alias <- generate_alias()

  handle <- qdb_connect(qdbd$uri)
  qdb_ts_create(handle,
                name = alias,
                columns = c("column1" = ColumnType$Double))

  tag <- generate_alias("tag")
  qdb_attach_tags(handle, entry = alias, tags = tag)
  qdb_detach_tags(handle, entry = alias, tags = tag)
  qdb_attach_tags(handle, entry = alias, tags = tag)
  succeed("detached single tag")
})

test_that("successfully untags timeseries with many tags", {
  alias <- generate_alias()

  handle <- qdb_connect(qdbd$uri)
  qdb_ts_create(handle,
                name = alias,
                columns = c("column1" = ColumnType$Double))

  tags <- c(generate_alias("tag"), generate_alias("tag"))
  qdb_attach_tags(handle, entry = alias, tags = tags)
  qdb_detach_tags(handle, entry = alias, tags = tags)
  qdb_attach_tags(handle, entry = alias, tags = tags)
  succeed("detached many tag")
})
