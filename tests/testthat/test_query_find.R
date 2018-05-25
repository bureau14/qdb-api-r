context("qdb_query_find")

test_that("returns successfully with some results", {
  qdbd_params <- c('--transient', '--security=false')
  qdbd_path <- file.path(getwd(), '..', '..', 'bin', 'qdbd')
  if (!file.exists(qdbd_path)) {
    qdbd_path <- file.path(getwd(), '..', '..', 'inst', 'bin', 'qdbd')
  }

  expect(file.exists(qdbd_path), failure_message = sprintf('qdbd executable should reside in inst/bin directory, current path = %s', qdbd_path))
  print(qdbd_path)
  p <- processx::process$new(command = qdbd_path, args = qdbd_params, stdout = "|", stderr = "|")
  print(p)

  p$poll_io(5000) # in milliseconds

  #print(p$read_output())
  print(p$read_error())

  expect(p$is_alive(), failure_message = 'qdbd process should still be alive')

  #Sys.sleep(5)
  #print('Set up done.')

  handle <- qdb_connect("qdb://127.0.0.1:2836")
  results <- qdb_query_find(handle, "find(tag='stocks' and type=ts)")
  expect_equal(length(results), 0)

  expect(p$is_alive(), failure_message = 'qdbd process should still be alive')
  p$kill()
  p$wait()
  #expect_equal(p$get_exit_status(), 0)
})
