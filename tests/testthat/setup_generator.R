g_counter <- 0

generate_alias <- function(prefix = "alias") {
  alias <- paste(prefix, g_counter, sep = "")
  g_counter <<- g_counter + 1
  return(alias)
}
