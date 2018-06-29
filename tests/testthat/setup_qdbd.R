message("**** Running qdbd daemon... *****")

qdbd <- run_database(root = file.path(getwd(), "..", ".."))

expect(qdbd$process$is_alive(),
       failure_message = "qdbd process should still be alive")

message("***** Setup done. *****")
