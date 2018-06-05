message("**** Running qdbd daemon... *****")

run_qdbd <- function(root) {
  qdbd_path <- file.path(root, "bin", "qdbd")
  if (!file.exists(qdbd_path)) {
    qdbd_path <- file.path(root, "inst", "bin", "qdbd")
    if (.Platform[["OS.type"]] == "windows") {
      qdbd_path <- paste(qdbd_path, ".exe", sep = "")
    }
  }
  print(qdbd_path)
  qdbd_path <- normalizePath(qdbd_path)
  print(qdbd_path)
  address <- "127.0.0.1:2836"
  
  args <- c("--transient", "--security=false", "--address", address)
  
  expect(
    file.exists(qdbd_path),
    failure_message = sprintf(
      "qdbd executable should reside in inst/bin directory, current path = %s",
      qdbd_path
    )
  )
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

qdbd <- run_qdbd(root = file.path(getwd(), "..", ".."))

expect(qdbd$process$is_alive(), failure_message = "qdbd process should still be alive")

message("***** Setup done. *****")
