context("version")

test_that("qdb_version", {
  expect(nchar(qdb_version()) > 0)
  expect_match(qdb_version(), "quasardb")
})
