if (requireNamespace("lintr", quietly = TRUE)) {
  context("lints")
  test_that("no lintr warnings", {
    lintr::expect_lint_free()
  })
}
