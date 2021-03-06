% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/matrixCtrl2.R
\name{matrixCtrl2UI}
\alias{matrixCtrl2UI}
\title{Shiny module UI for matrix view}
\usage{
matrixCtrl2UI(
  id,
  minN = 4,
  selection = FALSE,
  nfilter = FALSE,
  pfilter = FALSE
)
}
\arguments{
\item{id}{Character ID for specifying namespace, see \code{shiny::\link[shiny]{NS}}.}

\item{minN}{Minimum number for numeric input filter.}

\item{selection}{Whether to show selection input.}

\item{nfilter}{Whether to show the N filter input.}

\item{pfilter}{Whether to show the P filter input.}
}
\description{
Interactive controls of matrix view
}
\details{
This includes UI elements for selection and filtering
of the matrix; these can be conditionally rendered.
}
