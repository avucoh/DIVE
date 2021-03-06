% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getGEO.R
\name{getGEOServer}
\alias{getGEOServer}
\title{Shiny module server for importing data from GEO}
\usage{
getGEOServer(id)
}
\arguments{
\item{id}{Character ID for specifying namespace, see \code{shiny::\link[shiny]{NS}}.}
}
\value{
\code{GEOdata} reactive values list object containing
\code{$accession}, \code{$eset}, \code{$pData} and \code{$return}.
\code{$return} is an internal status flag for use by \code{\link{multiVCtrlServer}}
to know when a new GEO dataset has been processed completely through the annotation step.
}
\description{
Interactively import GEO data with step-by-step process using a series of modals
}
\details{
This server function implements interactive GEO data import with three main steps.
\enumerate{
  \item Query for accession, extract expression data and check whether of compatible type and format.
  \item Import characteristics data selectively according to user.
  \item Import the feature annotation according to user.
}
}
