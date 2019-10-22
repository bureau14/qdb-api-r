context("query")

expect_member <- function(object, member_name) {
  act <- quasi_label(rlang::enquo(object))

  expect(
    member_name %in% names(object),
    failure_message =
      sprintf(
        "object %s should contain `%s`, but contains: [%s]",
        act$lab,
        member_name,
        paste(names(act$val), collapse = ", ")
      )
  )

  invisible(act$val)
}

expect_na <- function(object) {
  act <- quasi_label(rlang::enquo(object))

  expect(is.na(act$val),
         sprintf(
           "got %s of type %s instead of NA.",
           format(act$val),
           typeof(act$val)
         ))

  invisible(act$val)
}

test_that("stops when handle is null", {
  expect_error(results <-
                 query(NULL, "SELECT * FROM timeseries IN RANGE(2017, +1y)")
               , regexp = "type=NULL")
})

test_that("returns alias not found when timeseries does not exist", {
  handle <- connect(qdbd$uri)
  expect_error(
    results <-
      query(handle, query = "SELECT * FROM timeseries IN RANGE(2017, +1y)")
    , regexp = "An entry matching the provided alias cannot be found"
  )
})

test_that("returns empty result on existing but empty timeseries", {
  alias <- generate_alias("timeseries")
  column_name <- generate_alias("column")
  columns <- c(column_type$double)
  names(columns) <- c(column_name)

  handle <- connect(qdbd$uri)

  ts_create(handle, name = alias, columns = columns)

  results <- query(handle, sprintf("SELECT * FROM %s IN RANGE(2017, +1y)", alias))

  expect(is.list(results), failure_message = "query result should be a list")
  expect_named(results, c("scanned_point_count", "column_count", "columns", "row_count", "rows"))

  expect_equal(results$scanned_point_count, 0)
  expect_equal(results$column_count, 3)
  expect_equal(results$row_count, 0)
})

test_that("returns count result on empty 1-column timeseries", {
  alias <- generate_alias("timeseries")
  column_name <- generate_alias("column")
  columns <- c(column_type$double)
  names(columns) <- c(column_name)

  handle <- connect(qdbd$uri)
  ts_create(handle, name = alias, columns = columns)
  ts_insert.double(handle, name = alias, column = column_name)
  results <-
    query(handle, sprintf("SELECT COUNT(*) FROM %s IN RANGE(2017, +1y)", alias))

  expect(is.list(results), failure_message = "query result should be a list")
  expect_named(results, c("scanned_point_count", "column_count", "columns", "row_count", "rows"))

  expect_equal(results$scanned_point_count, 3)
  expect_equal(results$column_count, 1)

  # Check columns
  count_result_column <- sprintf("count(%s)", column_name)

  actual_columns <- results$columns
  expect_equal(actual_columns, c(count_result_column))
  
  expect_equal(results$row_count, 1)
  
  rows <- results$rows
  expect(is.data.frame(rows), failure_message = "rows should be a data.frame")
  expect_equal(colnames(rows), c(count_result_column))
  expect_equal(dim(rows), c(1, 1))
  expect_equal(rows[[count_result_column]], 3)
})

test_that("returns count result on empty multi-column timeseries", {
  alias <- generate_alias("timeseries")
  columns <-
    c(column_type$double,
      column_type$double,
      column_type$double,
      column_type$double)
  names(columns) <-
    c(
      generate_alias("col"),
      generate_alias("col"),
      generate_alias("col"),
      generate_alias("col")
    )
  expected_column_names <-
    c(sprintf("count(%s)", names(columns)))

  handle <- connect(qdbd$uri)
  ts_create(handle, name = alias, columns = columns)
  sapply(names(columns), function(column_name) {
    ts_insert.double(handle, name = alias, column = column_name)
  })

  query <- sprintf("SELECT COUNT(*) FROM %s IN RANGE(2017-01-01, +1y)", alias)
  results <- query(handle, query)

  expect_equal(results$scanned_point_count, 12)
  expect_equal(results$column_count, 4)

  expect_equal(results$column_count, length(columns))
  expect_equal(results$row_count, 1)

  actual_columns <- results$columns

  expect_equal(actual_columns, expected_column_names)

  rows <- results$rows
  expect(is.data.frame(rows), failure_message = "rows should be a data.frame")
  expect_equal(colnames(rows), expected_column_names)
  expect_equal(dim(rows), c(1, 4))

  expected_result = data.frame(
    c(3),
    c(3),
    c(3),
    c(3)
  )
  names(expected_result) = expected_column_names
  expect_equal(dim(rows), dim(expected_result))
  expect_equal(rows, expected_result)
})

test_that("returns count result on multiple timeseries", {
  alias1 <- generate_alias("timeseries")
  alias2 <- generate_alias("timeseries")
  column_name <- generate_alias("column")
  columns <- c(column_type$double)
  names(columns) <- c(column_name)

  handle <- connect(qdbd$uri)
  ts_create(handle, name = alias1, columns = columns)
  ts_create(handle, name = alias2, columns = columns)
  
  ts_insert.double(handle, name = alias1, column = column_name)
  ts_insert.double(handle, name = alias2, column = column_name)

  query <-
    sprintf("SELECT COUNT(*) FROM %s, %s IN RANGE(2017, +1y)", alias1, alias2)
  results <- query(handle, query)

  expect_equal(results$scanned_point_count, 6)
  expect_equal(results$column_count, 1)

  # Check columns
  count_result_column <- sprintf("count(%s)", column_name)

  actual_columns <- results$columns
  expect_equal(actual_columns, c(count_result_column))
  
  expect_equal(results$row_count, 2)
  
  rows <- results$rows

  expect(is.data.frame(rows), failure_message = "rows should be a data.frame")
  expect_equal(colnames(rows), c(count_result_column))
  expect_equal(dim(rows), c(2, 1))
  expect_equal(rows[[count_result_column]], c(3,3))
})
