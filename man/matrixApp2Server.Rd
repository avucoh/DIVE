% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/matrixApp2.R
\name{matrixApp2Server}
\alias{matrixApp2Server}
\title{Shiny app server for interactive matrix (v2)}
\usage{
matrixApp2Server(
  id,
  M,
  N,
  P,
  cdata,
  metafilter = reactive({ }),
  factorx,
  colorby,
  colorscales = list(default = list(colorscale_named(pal = "RdBu"), zmin = -1, zmax =
    1)),
  informd = system.file("info/interactive_matrix.Rmd", package = "DIVE"),
  appdata = NULL
)
}
\arguments{
\item{id}{Character ID for specifying namespace, see \code{shiny::\link[shiny]{NS}}.}

\item{M}{A data matrix, e.g. a correlation matrix, which must have row and column names.}

\item{N}{A matrix of the same dimensions as `M` to be used as a filter layer, e.g. sample size.}

\item{P}{A matrix of the same dimensions as `M` to be used as a filter layer, e.g. p-values.}

\item{cdata}{The data used for generating the matrix,
necessary for allowing user-uploaded data for mutable `M`.}

\item{metafilter}{A reactive filter such as from \code{dataHelper}, used to filter upon the matrix.}

\item{factorx}{Optional, a function that returns a boolean for whether
a variable should be plotted as factor when given the variable name.
Useful when for some reason factor variables are numeric or character instead of already factor-encoded.
By default, variables are merely checked using \code{base::is.factor},
which works when the data is already factor-encoded.}

\item{colorby}{A named list where name matches the (factor) variable in \code{cdata} to use for color grouping.
If there is a named vector, this is passed into \code{scale_color_manual} to be used for custom color mapping, e.g.
`list(MyGroupingVar = c(A = "red", B = "blue"))` (useful for enforcing a consistent/meaningful color scheme),
or use `list(MyGroupingVar = NULL)` if custom color scaling isn't necessary. See also details.}

\item{colorscales}{Optional, a list of custom colorscale functions
that takes a numeric matrix and returns either a named colorscale
or custom colorscale used for heatmap. If not given, two default colorscale functions are used.}

\item{informd}{Relative path to the Rmarkdown file, whose contents will be displayed in the modal.}

\item{appdata}{Optional, the path of one or more files that can be mock-uploaded. See details.}
}
\description{
See matrixCtrl2UI
}
