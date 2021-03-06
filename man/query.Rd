% Generated by roxygen2: do not edit by hand
% Please edit documentation in src/query.cpp
\name{query}
\alias{query}
\title{Execute a query.}
\usage{
query(handle, query)
}
\arguments{
\item{handle}{A valid cluster opened using `connect`.}

\item{query}{A query to execute.}
}
\value{
A data frame with results of the query.
}
\description{
Execute a select query using SQL-like syntax.
}
\examples{
handle <- connect("qdb://127.0.0.1:2836")
query(handle, "SELECT * FROM timeseries IN RANGE(2017, +1y)")
}
\seealso{
\url{https://doc.quasardb.net/master/api/queries.html.}

\code{\link{connect}}
}
