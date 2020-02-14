context("get_last_error")

test_that("returns last error", {
  handle <- connect("qdb://127.0.0.1:2836")
  expect_error(query(handle, "SELECT"))
  message <- get_last_error(handle)
  expect(nchar(message) > 0, failure_message = "Got empty error message")
  expect_match(message, "at qdb_.*: .*")
})
