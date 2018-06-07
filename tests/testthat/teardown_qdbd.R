message("***** Stopping qdbd daemon... *****")

expect(qdbd$process$is_alive(),
       failure_message = "qdbd process should still be alive")

qdbd$process$kill()
qdbd$process$wait()

message("***** Teardown done. *****")
