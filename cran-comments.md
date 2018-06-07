## Test environments
* local Windows 10 install, R 3.3.3
* continuous integration on macOS Sierra 10.12.6, R 3.4.3

## R CMD check results
### Windows
> devtools::check(args = "--no-multiarch --no-examples --no-tests")
Updating quasardb documentation
Loading quasardb
Setting env vars -----------------------------------------------------------------------------------------------------------------
CFLAGS  : -Wall -pedantic
CXXFLAGS: -Wall -pedantic
Building quasardb ----------------------------------------------------------------------------------------------------------------
"C:/PROGRA~1/R/R-33~1.3/bin/x64/R" --no-site-file --no-environ --no-save --no-restore --quiet CMD build "D:\workspace\qdb-api-r"  \
  --no-resave-data --no-manual

* checking for file 'D:\workspace\qdb-api-r/DESCRIPTION' ... OK
* preparing 'quasardb':
* checking DESCRIPTION meta-information ... OK
* cleaning src
* checking for LF line-endings in source and make files
* checking for empty or unneeded directories
* building 'quasardb_0.0.0.9000.tar.gz'

Setting env vars -----------------------------------------------------------------------------------------------------------------
_R_CHECK_CRAN_INCOMING_ : FALSE
_R_CHECK_FORCE_SUGGESTS_: FALSE
Checking quasardb ----------------------------------------------------------------------------------------------------------------
"C:/PROGRA~1/R/R-33~1.3/bin/x64/R" --no-site-file --no-environ --no-save --no-restore --quiet CMD check  \
  "C:\Users\Marek\AppData\Local\Temp\RtmpsTXfyn/quasardb_0.0.0.9000.tar.gz" --as-cran --timings --no-multiarch --no-examples  \
  --no-tests --no-manual

* using log directory 'C:/Users/Marek/AppData/Local/Temp/RtmpsTXfyn/quasardb.Rcheck'
* using R version 3.3.3 (2017-03-06)
* using platform: x86_64-w64-mingw32 (64-bit)
* using session charset: ISO8859-1
* using options '--no-examples --no-tests --no-manual --as-cran'
* checking for file 'quasardb/DESCRIPTION' ... OK
* checking extension type ... Package
* this is package 'quasardb' version '0.0.0.9000'
* checking package namespace information ... OK
* checking package dependencies ... OK
* checking if this is a source package ... NOTE
Found the following apparent object files/libraries:
  inst/bin/qdb_api.dll
Object files/libraries should not be included in a source package.
* checking if there is a namespace ... OK
* checking for executable files ... WARNING
Found the following executable files:
  inst/bin/qdb_api.dll
  inst/bin/qdbd.exe
Source packages should not contain undeclared executable files.
See section 'Package structure' in the 'Writing R Extensions' manual.
* checking for hidden files and directories ... OK
* checking for portable file names ... OK
* checking whether package 'quasardb' can be installed ... OK
* checking installed package size ... NOTE
  installed size is 23.2Mb
  sub-directories of 1Mb or more:
    bin  21.9Mb
* checking package directory ... OK
* checking DESCRIPTION meta-information ... OK
* checking top-level files ... OK
* checking for left-over files ... OK
* checking index information ... OK
* checking package subdirectories ... OK
* checking R files for non-ASCII characters ... OK
* checking R files for syntax errors ... OK
* checking whether the package can be loaded ... OK
* checking whether the package can be loaded with stated dependencies ... OK
* checking whether the package can be unloaded cleanly ... OK
* checking whether the namespace can be loaded with stated dependencies ... OK
* checking whether the namespace can be unloaded cleanly ... OK
* checking loading without being on the library search path ... OK
* checking dependencies in R code ... OK
* checking S3 generic/method consistency ... OK
* checking replacement functions ... OK
* checking foreign function calls ... OK
* checking R code for possible problems ... OK
* checking Rd files ... OK
* checking Rd metadata ... OK
* checking Rd line widths ... OK
* checking Rd cross-references ... OK
* checking for missing documentation entries ... OK
* checking for code/documentation mismatches ... OK
* checking Rd \usage sections ... OK
* checking Rd contents ... OK
* checking for unstated dependencies in examples ... OK
* checking line endings in C/C++/Fortran sources/headers ... OK
* checking line endings in Makefiles ... OK
* checking compilation flags in Makevars ... OK
* checking for GNU extensions in Makefiles ... OK
* checking for portable use of $(BLAS_LIBS) and $(LAPACK_LIBS) ... OK
* checking compiled code ... OK
* checking examples ... SKIPPED
* checking for unstated dependencies in 'tests' ... OK
* checking tests ... SKIPPED
* DONE

Status: 1 WARNING, 2 NOTEs
See
  'C:/Users/Marek/AppData/Local/Temp/RtmpsTXfyn/quasardb.Rcheck/00check.log'
for details.


R CMD check results
0 errors | 1 warning  | 2 notes
checking for executable files ... WARNING
Found the following executable files:
  inst/bin/qdb_api.dll
  inst/bin/qdbd.exe
Source packages should not contain undeclared executable files.
See section 'Package structure' in the 'Writing R Extensions' manual.

checking if this is a source package ... NOTE
Found the following apparent object files/libraries:
  inst/bin/qdb_api.dll
Object files/libraries should not be included in a source package.

checking installed package size ... NOTE
  installed size is 23.2Mb
  sub-directories of 1Mb or more:
    bin  21.9Mb