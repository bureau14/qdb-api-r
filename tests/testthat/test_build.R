context("build")

test_that("return non-empty string", {
  expect(nchar(build()) > 0)
})

test_that("return string in correct format", {
  # 3234e65 2018-05-20 20:13:03 \+0200
  expect_match(build(), "[0-9a-f]+ [-0-9]+ [:0-9]+ .*")
})
