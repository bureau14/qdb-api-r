
<!-- README.md is generated from README.Rmd. Please edit that file -->
quasardb
========

:warning:**WARNING**: Early stage development version. Use at your own risk.

:information\_source:**NOTE**: Only :apple:macOS and Windows are currently supported.

The quasardb package is the official R API for [quasardb](https://www.quasardb.net) timeseries database.

Installation
------------

<!-- TODO:
You can install the released version from CRAN with:

```r
install.packages("quasardb")
```
-->
You can install quasardb from [GitHub](https://github.com/bureau14/qdb-api-r) with:

``` r
# install.packages("devtools")
devtools::install_github("bureau14/qdb-api-r")
```

### quasardb C API

To build the R API, you will need the C API. It can either be installed on the machine system-wide (e.g. on UNIX in `/usr/lib` or `/usr/local/lib`) or you can unpack the C API archive in `inst` directory. On Windows, you need to verify additionally that the `qdb_api.dll` is in the `PATH` environment variable.

You can get the C API as well as other tools from [our download page](https://www.quasardb.net/-Get-).

### Building the extension from source

To perform a clean build:

``` r
devtools::build(binary = TRUE)
```

To update documentation and auto-generated files:

``` r
devtools::document()
```

Only update the documentation in man, but don't regenerate R files:

``` r
roxygen2::roxygenize()
```

To check the extension:

``` r
devtools::check(check_version = TRUE)
```

You may wish to skip tests using:

``` r
devtools::check(check_version = TRUE, args = "--no-tests")
```

To test the extension:

``` r
devtools::test()
```

Usage
-----

<!-- TODO:
To regenerate the readme with knitr, run `qdbd --transient --security=false`.
Let automatise this!
-->
Load library:

``` r
library(quasardb)
```

Get underlying C API version:

``` r
qdb_version()
#> [1] "2.6.0"
```

Get underlying C API build id and date:

``` r
qdb_build()
#> [1] "1b437b2 2018-06-01 07:14:42 +0000"
```

Connect to a quasardb cluster at a default URI `qdb://127.0.0.1:2836`:

``` r
handle <- qdb_connect()
```

Connect to a quasardb cluster at a user-provided URI:

``` r
handle <- qdb_connect("qdb://127.0.0.1:2836")
```

Create a timeseries:

``` r
handle <- qdb_connect("qdb://127.0.0.1:2836")
qdb_ts_create(handle, name = "timeseries1",
     columns = c("column1" = column_type$blob, "column2" = column_type$double))
```

Show information about the columns of a timeseries:

``` r
handle <- qdb_connect("qdb://127.0.0.1:2836")
columns <- qdb_show(handle, name = "timeseries1")
columns
#> column1 column2 
#>       1       0
sapply(columns, function(ct) {
  names(which(ct == column_type))
})
#>  column1  column2 
#>   "blob" "double"
```

Add a tag to an entry:

``` r
handle <- qdb_connect("qdb://127.0.0.1:2836")
qdb_attach_tags(handle, entry = "timeseries1", tags = "my_tag")
```

Add many tags at once:

``` r
handle <- qdb_connect("qdb://127.0.0.1:2836")
qdb_attach_tags(handle,
                entry = "timeseries1",
                tags = c("my_tag1", "my_tag2", "my_tag3"))
```

Get tags of an entry:

``` r
handle <- qdb_connect("qdb://127.0.0.1:2836")
tags <- qdb_get_tags(handle, name = "timeseries1")
tags
#> [1] "my_tag3" "my_tag1" "my_tag"  "my_tag2"
```

Get all entries marked with a tag:

``` r
handle <- qdb_connect("qdb://127.0.0.1:2836")
entries <- qdb_get_tagged(handle, tag = "my_tag")
entries
#> [1] "timeseries2" "timeseries1"
```

Get all entry keys matching given find query:

``` r
handle <- qdb_connect("qdb://127.0.0.1:2836")
# Get all entries (precisely: their keys) tagged with 'my-tag' being timeseries.
keys <- qdb_find(handle, "find(tag='my_tag' and type=ts)")
keys
#> [1] "timeseries2" "timeseries1"
```

Untag an entry:

``` r
handle <- qdb_connect("qdb://127.0.0.1:2836")
qdb_detach_tags(handle, entry = "timeseries2", tag = "my_tag")
# Now, timeseries2 is no more on the list.
keys <- qdb_find(handle, "find(tag='my_tag' and type=ts)")
keys
#> [1] "timeseries1"
```

Execute a select query:

``` r
handle <- qdb_connect("qdb://127.0.0.1:2836")
# Get number of elements in each column of the timeseries in year 2017.
result <-
  qdb_query(handle, "select count(*) from timeseries1 in range(2017, +1y)")
result$scanned_rows_count
#> [1] 0
result$tables[["timeseries1"]]$data
#>                             timestamp count(column1) count(column2)
#> 1 2017-01-01T00:00:00.000000000+00:00              0              0
```

Remove an entry:

``` r
handle <- qdb_connect("qdb://127.0.0.1:2836")
qdb_remove(handle, name = "timeseries1")
```

TODO
----

-   Add `qdb_ts_insert` (only stub is currently implemented), `qdb_has_tag`.
-   Make compliant with other OSes: Linux, FreeBSD.
-   Make a quasardb driver compliant with [DBI package](https://www.rdocumentation.org/packages/DBI/).
