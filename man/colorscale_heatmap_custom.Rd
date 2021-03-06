% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/matrixMain.R
\name{colorscale_heatmap_custom}
\alias{colorscale_heatmap_custom}
\title{Create custom colorscale for `plotly` heatmap}
\usage{
colorscale_heatmap_custom(palette)
}
\arguments{
\item{palette}{A custom palette.}
}
\description{
Pass in a custom palette to generate custom colorscale data required by `plotly`
}
\details{
This simply calls an internal function which relies on `scales::rescale`.
}
