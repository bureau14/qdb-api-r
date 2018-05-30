context("error")

# TODO(marek): Expose qdb_e_* enum values.
test_that("qdb_error", {
  unknown_error <- 1
  qdb_e_ok <- 0
  qdb_e_alias_not_found <- -1325400056 # 0xB1000008

  expect(nchar(qdb_error(unknown_error)) > 0)
  expect_match(qdb_error(unknown_error), ".*unknown error.*")

  expect(nchar(qdb_error(qdb_e_ok)) > 0)
  expect_match(qdb_error(qdb_e_ok), ".*success.*")

  expect(nchar(qdb_error(qdb_e_alias_not_found)) > 0)
  expect_match(qdb_error(qdb_e_alias_not_found), ".*entry.*cannot be found*")
})
