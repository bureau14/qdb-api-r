# quasardb R API

## Installation

To install quasardb R API:

 - **TODO**: Get the released version from CRAN: `install.packages("quasardb")`
 - Get the development version from GitHub: `devtools::install_github("bureau14/qdb-api-r")`

### quasardb C API

To build the R API, you will need the C API. It can either be installed on the machine (e.g. on UNIX in `/usr/lib` or `/usr/local/lib`) or you can unpack the C API archive in `qdb` directory. You can get the C API as well as other tools from https://www.quasardb.net/-Get-.

### Building the extension

To perform a clean build:
```shell
R INSTALL --preclean --no-multiarch --with-keep.source quasardb
```

## Usage

Load the library:

```r
library(quasardb)
```
