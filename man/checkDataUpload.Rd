% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/checks.R
\name{checkDataUpload}
\alias{checkDataUpload}
\title{General check function for user-uploaded data}
\usage{
checkDataUpload(data, result = NULL, idcol = "ID", idchar = TRUE, html = TRUE)
}
\arguments{
\item{data}{A \code{data.table}.}

\item{result}{What to return in place of data if issues are found with the data. Defaults to \code{NULL}.}

\item{idcol}{Name of expected ID column, defaulting to "ID".}

\item{idchar}{Logical with default \code{TRUE}, for whether to convert \code{idcol} to character.}

\item{html}{(Not used) Logical with default TRUE, for whether to format message with HTML for display.}
}
\value{
A list with \code{result} and \code{message}. See details.
}
\description{
This is used in \code{\link{dataUploadServer}}. Checks for (in this order):
\enumerate{
  \item exactly one ID column, which is by default converted to character
  \item actual data columns besides ID
  \item all data columns are numeric
}
When all of the above pass without issues, the function returns a named list
with data contained in \code{result} and \code{NULL} contained in \code{message},
otherwise it witholds the data by returning \code{NULL} for \code{result} and
\code{message} will contain a character vector of the issue(s) noted.
If the downstream use for data requires different check steps and transformations,
this function can be replaced as long as the new one uses the same return structure.
For some cases, if it is desired that we return data even if there are issues,
use \code{result = data} and rely on the \code{message} output.
}
\keyword{internal}
