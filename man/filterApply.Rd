% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filterPanel.R
\name{filterApply}
\alias{filterApply}
\title{Apply filter expressions to data}
\usage{
filterApply(dt, fs, j = NULL, res = 0)
}
\arguments{
\item{dt}{The data table.}

\item{fs}{Filter expression(s) as quosure or list of quosures.}

\item{j}{Optional, character name of column of data to return for matches of `values` in `col`.}

\item{res}{Result/resolution type.
If \code{NULL}, returns all columns for subsetted rows.}
}
\description{
Apply filter expressions to data
}
\keyword{internal}
