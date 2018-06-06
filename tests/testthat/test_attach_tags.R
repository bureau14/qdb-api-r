context("attach_tags")

test_that("stops when handle is null", {
  expect_error(
    results <-
      qdb_attach_tags(NULL, entry = generate_alias(), tags = generate_alias("tag"))
    ,
    regexp = 'type=NULL'
  )
})

test_that("successfully tags timeseries with a single tag", {
  alias <- generate_alias()

  handle <- qdb_connect(qdbd$uri)
  qdb_ts_create(handle,
                name = alias,
                columns = c("column1" = ColumnType$Double))

  tag <- generate_alias("tag")
  qdb_attach_tags(handle, entry = alias, tags = tag)

  expect_error(results <-
                 qdb_attach_tags(handle, entry = alias, tag)
               ,
               regexp = 'qdb_attach_tag:.*already.*tag')
})

test_that("successfully tags timeseries with many tags", {
  alias <- generate_alias()

  handle <- qdb_connect(qdbd$uri)
  qdb_ts_create(handle,
                name = alias,
                columns = c("column1" = ColumnType$Double))

  tags <- c(generate_alias("tag"), generate_alias("tag"))
  qdb_attach_tags(handle, entry = alias, tags = tags)

  sapply(tags, function(tag) {
    expect_error(results <-
                   qdb_attach_tags(handle, entry = alias, tags = tag)
                 ,
                 regexp = 'qdb_attach_tag:.*already.*tag')
  })
})
