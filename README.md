
<!-- README.md is generated from README.Rmd. Please edit that file -->
quasardb
========

:warning:**WARNING**: Early stage development version. Use at your own risk.

:information\_source:**NOTE**: Only :apple:macOS is currently supported.

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

To build the R API, you will need the C API. It can either be installed on the machine (e.g. on UNIX in `/usr/lib` or `/usr/local/lib`) or you can unpack the C API archive in `inst` directory. You can get the C API as well as other tools from [our download page](https://www.quasardb.net/-Get-).

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

``` r
library(quasardb)
```

Get underlying C API version:

``` r
qdb_version()
#> [1] "quasardb 2.5.0"
```

Get underlying C API build id:

``` r
qdb_build()
```

Connect to a quasardb cluster at default URI:

``` r
handle <- qdb_connect("qdb://127.0.0.1:2836")
```

TODO
----

-   Add a default parameter to `qdb_connect`.
-   Make a quasardb driver compliant with [DBI package](https://www.rdocumentation.org/packages/DBI/)
