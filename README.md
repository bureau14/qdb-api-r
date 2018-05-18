
<!-- README.md is generated from README.Rmd. Please edit that file -->
quasardb
========

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

To build the R API, you will need the C API. It can either be installed on the machine (e.g. on UNIX in `/usr/lib` or `/usr/local/lib`) or you can unpack the C API archive in `qdb` directory. You can get the C API as well as other tools from [our download page](https://www.quasardb.net/-Get-).

### Building the extension from source

*NOTE: Commands to be executed from when source directory is the current working directory.*

To perform a clean build:

``` bash
R INSTALL --preclean --no-multiarch --with-keep.source .
```

To check the extension:

``` r
devtools::check()
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

TODO
----

-   Make a quasardb driver compliant with [DBI package](https://www.rdocumentation.org/packages/DBI/)
