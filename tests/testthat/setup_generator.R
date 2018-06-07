g_counter <- 0

generate_alias <- function(prefix = "alias") {
  alias <- paste(prefix, g_counter, sep = "") # nolint
  g_counter <<- g_counter + 1 # nolint
  return(alias)
}

create_timeseries <- function(handle, prefix = "timeseries") {
  alias <- generate_alias(prefix) # nolint

  qdb_ts_create(handle,
                name = alias,
                columns = c("column1" = column_type$double))

  return(alias)
}

create_entry <- function(handle, prefix = "entry") {
  return(create_timeseries(handle, prefix)) # nolint
}
