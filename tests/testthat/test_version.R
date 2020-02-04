context("version")

test_that("return non-empty string", {
  expect(nchar(version()) > 0, failure_message = "Got empty message")
})

test_that("return string in format major.minor.patch with optional tags", {
  expect_match(version(), "[0-9]+\\.[0-9]+\\.[0-9]+.*")
})
