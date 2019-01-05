#' @title Helper to run quasardb database server (node).
#'
#' @description
#' Run quasardb executable (qdbd) searched for in the given root directory.
#' Used for testing purposes.
#'
#' @param root Root directory in which the executable should be found.
#' @param address Daemon listening endpoint.
run_database <- function(root, address = "127.0.0.1:2836") {
  qdbd_filename <- "qdbd"
  if (.Platform[["OS.type"]] == "windows") {
    qdbd_filename <- paste(qdbd_filename, ".exe", sep = "")
  }

  qdbd_path <- file.path(root, "bin", qdbd_filename)
  if (!file.exists(qdbd_path)) {
    qdbd_path <- file.path(root, "inst", "bin", qdbd_filename)
  }
  qdbd_path <- normalizePath(qdbd_path)

  args <- c("--storage-engine=transient", "--security=false", "--address", address)

  proc <-
    processx::process$new(
      command = qdbd_path,
      args = args,
      stdout = "|",
      stderr = "|"
    )

  proc$poll_io(5000) # in milliseconds

  stderr <- proc$read_error()
  if (length(stderr) > 1) {
    print(length(stderr))
    print(proc)
    print(sprintf("STDERR: %s", stderr))
  }

  return(list(
    "process" = proc,
    "address" = address,
    "uri" = sprintf("qdb://%s", address)
  ))
}
