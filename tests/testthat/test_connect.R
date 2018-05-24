context("qdb_connect")

test_that("returns invalid argument when URI is invalid", {
  expect_error(
    handle <- qdb_connect("invalid URI")
    , regexp = 'The argument is invalid')
})

test_that("returns invalid argument when cluster is down", {
  expect_error(
    handle <- qdb_connect("qdb://127.0.0.1:1")
    , regexp = 'Connection refused')
})

qdbd_params <- c('--transient', '--security=false')
qdbd_path <- file.path(getwd(), '..', '..', 'inst', 'bin', 'qdbd')

test_that("connects successfully to the existing cluster", {
  p <- processx::process$new(command = qdbd_path, args = qdbd_params, stdout = "|", stderr = "|")
  print('')
  print(p)
  
  p$poll_io(5000) # in milliseconds
  
  #print('STDOUT: ')
  #print(p$read_output())
  
  print('STDERR: ')
  print(p$read_error())
  
  expect(p$is_alive(), failure_message = 'qdbd process should still be alive')

  handle <- qdb_connect("qdb://127.0.0.1:2836")
  succeed(message = "successfully connected to quasardb cluster")
  
  expect(p$is_alive(), failure_message = 'qdbd process should still be alive')
  p$kill()
  p$wait()
  #expect_equal(p$get_exit_status(), 0)
})

