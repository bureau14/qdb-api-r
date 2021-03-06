% Generated by roxygen2: do not edit by hand
% Please edit documentation in src/attach_tags.cpp
\name{attach_tags}
\alias{attach_tags}
\title{Attach tags to an entry.}
\usage{
attach_tags(handle, entry, tags)
}
\arguments{
\item{handle}{A valid cluster opened using `connect`.}

\item{entry}{An alias (key) of an entry.}

\item{tags}{A vector of tag names to attach.}
}
\description{
Attach one or many tags to an existing entry.

When attaching tags, no error will be raised if the entry has been tagged
with at least one tag (i.e. when this entry had not already been tagged
with all given tags).
}
\examples{
handle <- connect("qdb://127.0.0.1:2836")
attach_tags(handle, "key", "tag")
}
\seealso{
\url{https://doc.quasardb.net/master/concepts/tags.html}

\code{\link{connect}}
}
