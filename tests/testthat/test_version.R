context("version")

test_that("return non-empty string", {
  expect(nchar(qdb_version()) > 0)
})

test_that("return string in format major.minor.patch with optional tags", {
  expect_match(qdb_version(), "[0-9]+\\.[0-9]+\\.[0-9]+.*")
})
