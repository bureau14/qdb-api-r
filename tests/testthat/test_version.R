context("version")
library(stringr)

test_that("qdb_version", {
  expect(str_length(qdb_version()) > 0)
  expect_match(qdb_version(), "quasardb")
})
