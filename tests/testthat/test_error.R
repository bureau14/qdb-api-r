context("error")

# TODO(marek): Expose qdb_e_* enum values.
test_that("returns correct messages", {
  unknown_error <- 1
  qdb_e_ok <- 0
  qdb_e_alias_not_found <- -1325400056 # 0xB1000008

  expect(nchar(error(unknown_error)) > 0,
         failure_message = "Got empty error message")
  expect_match(error(unknown_error), ".*unknown error.*")

  expect(nchar(error(qdb_e_ok)) > 0,
         failure_message = "Got empty error message")
  expect_match(error(qdb_e_ok), ".*success.*")

  expect(nchar(error(qdb_e_alias_not_found)) > 0,
         failure_message = "Got empty error message")
  expect_match(error(qdb_e_alias_not_found), ".*entry.*cannot be found*")
})
