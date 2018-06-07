\name{quasardb-package}
\alias{quasardb-package}
\alias{quasardb}
\alias{qdb-api-r}
\docType{package}
\title{
  R API for quasardb database
}
\description{
  The 'quasardb' package provides R API for quasardb timeseries database
  (\url{https://www.quasardb.net}).
  See \url{https://doc.quasardb.net} for documentation.
}
\details{
  TODO: This section should provide a more detailed overview of how to use the
  package, including the most important functions.
}
\author{
Marek Kurdej.

Maintainer: Marek Kurdej <marek@quasardb.net>
}
\references{
  This optional section can contain literature or other references for
  background information.
}
\keyword{timeseries,nosql,database}
\seealso{
}
\examples{
\dontrun{
handle <- connect("qdb://127.0.0.1:2836")
query(handle, "select count(*) from timeseries1 in range(2017, +1y)")
}
}
