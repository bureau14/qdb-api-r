context("build")

test_that("qdb_build", {
  expect(nchar(qdb_build()) > 0)
  # 3234e65 2018-05-20 20:13:03 \+0200
  expect_match(qdb_build(), "[0-9a-f]+ .*")
})
