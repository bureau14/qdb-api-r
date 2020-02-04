context("get_last_error")

test_that("returns last error", {
  expect_error(query(NULL, "SELECT"), class = "Rcpp::not_compatible")
  message <- get_last_error()
  expect(nchar(message) > 0, failure_message = "Got empty error message")
  expect_match(message, "at qdb_.*: .*")
})
