g_counter <- 0

generate_alias <- function(prefix = "alias") {
  alias <- paste(prefix, g_counter, sep = "")
  g_counter <<- g_counter + 1
  return(alias)
}

create_timeseries <- function(handle, prefix = "timeseries") {
  alias <- generate_alias(prefix)

  qdb_ts_create(handle,
                name = alias,
                columns = c("column1" = column_type$double))

  return(alias)
}

create_entry <- function(handle, prefix = "entry") {
  create_timeseries(handle, prefix)
}