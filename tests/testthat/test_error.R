context("error")

# TODO(marek): Expose qdb_e_* enum values.
test_that("qdb_error", {
  qdb_e_ok <- 0
  expect(nchar(qdb_error(qdb_e_ok)) > 0)
  expect_match(qdb_error(qdb_e_ok), ".* success.*")
})
