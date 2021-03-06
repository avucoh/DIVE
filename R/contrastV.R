#' Shiny module contrast UI
#'
#' UI for user to define contrast groups for comparison plots
#'
#' @family contrastV module functions
#'
#' @param id Character ID for specifying namespace, see \code{shiny::\link[shiny]{NS}}.
#' @param choices A vector corresponding to choices of grouping variables for contrast.
#' @param xbtn Whether to include a close-modal button that also clears the plot. For use when UI is within a modal dialog (the default).
#' @import shiny
#' @export
contrastVUI <- function(id, choices, xbtn = T) {

  ns <- NS(id)
  tags$div(id = ns("contrastVUI"), class = "contrastVUI-panel",
           if(xbtn) HTML(sprintf('<button id = "%s" type="button" class="close action-button" data-dismiss="modal">x</button>', ns("close"))),
           selectInput(ns("groupby"), "Group by", choices = choices),
           div(class = "ui-inline", uiOutput(ns("by1"))),
           span("vs"),
           div(class = "ui-inline", uiOutput(ns("by2"))),
           div(style = "padding-bottom: 10px;", actionButton(ns("run"), "Run")),
           plotly::plotlyOutput(ns("plot"))
  )
}

#' Shiny module server for creating comparison plots between subgrouped data
#'
#' Create comparison plots based on user-defined contrast groups
#'
#' The implementation primarily relies on \code{limma}.
#'
#' @family contrastV module functions
#'
#' @param id Character ID for specifying namespace, see \code{shiny::\link[shiny]{NS}}.
#' @param cdata A \code{data.table} of clinical, phenotype, or other experimental data used to define groups.
#' @param selected_dataset An expression dataset.
#' @import shiny
#' @import magrittr
#' @export
contrastVServer <- function(id,
                            cdata,
                            selected_dataset) {

  moduleServer(id, function(input, output, session) {

    plotOut <- reactiveVal(plotly::plotly_empty())

    observeEvent(input$close, {
      plotOut(plotly::plotly_empty())
    }, ignoreInit = TRUE)

    # https://github.com/rstudio/shiny/issues/2744
    # observeEvent(cdata(), {
    #    updateSelectInput(session, "groupby", choices = names(cdata()))
    # })

    # When feature variable is selected, render appropriate UI used to define groups
    # and constrain choices to levels available in selected dataset
    output$by1 <- renderUI({
      if(input$groupby == "") return(NULL)
      customGroupSelect(cdata()[[input$groupby]], session$ns("s1"))
    })

    output$by2 <- renderUI({
      if(input$groupby == "") return(NULL)
      customGroupSelect(cdata()[[input$groupby]], session$ns("s2"))
    })

    # Get the IDs for each group defined
    group1 <- reactive({
      req(input$s1)
      req(selected_dataset())
      getFilterGroup(input$s1, refids = rownames(selected_dataset()), filtercol = input$groupby, parentdata = cdata())
    })

    group2 <- reactive({
      req(input$s2)
      req(selected_dataset())
      getFilterGroup(input$s2, refids = rownames(selected_dataset()), filtercol = input$groupby, parentdata = cdata())
    })

    observeEvent(input$run, {
      tryCatch(expr = {
        # check for group size and whether groups overlap
        okgroupsize <- length(group1()) > 1 && length(group2()) > 1
        disjoint <- !length(intersect(group1(), group2()))
        if(!okgroupsize || !disjoint) {
          message <- if(!okgroupsize) "One or both groups do not have the minimum number of samples (2)." else "Defined groups must be disjoint!"
          p <- plotly::plotly_empty() %>%
            plotly::layout(title = message, font = list(color = "gray"))
        } else {
          # do fit, return (A) fold difference, (B) p-values, (C) color based on adj.P
          limfit <- limmaWrapper(selected_dataset(), group1(), group2())
          xfc <- xFoldChange(selected_dataset(), group1(), group2()) # A
          yp <- asNegLogAdjP(limfit$p.value) # B
          labels <- colnames(selected_dataset())
          sigcolor <- ifelse(yp > 3, "significant", "not significant")
          p <- plotly::plot_ly(x = xfc, y = yp, type = "scatter", mode = "markers",
                  hoverinfo = "text", text = paste(labels, "<br>-log(adjusted p): ", yp, "<br>Difference: ", xfc),
                  color = sigcolor, colors = c(significant = "deeppink", `not significant` = "gray"),
                  showlegend = T) %>%
            plotly::layout(xaxis = list(title = "Fold Change Difference [Group 1 - Group 2]"), yaxis = list(title = "-log(adjusted p-value)"),
                   legend = list(orientation = "h", y = 1.02, yanchor = "bottom"))
        }
        plotOut(p)
      }, error = function(e) meh(error = e))
    })

    output$plot <- plotly::renderPlotly({
      plotOut() %>%
        plotly::config(displayModeBar = F)
    })

  })

}

# Helpers --------------------------------------------------------------------------------------#

#' Return a select input or slider range depending on group selection
#' @keywords internal
customGroupSelect <- function(x, inputId) {
  if(class(x) == "character" || class(x) == "factor") {
    selectizeInput(inputId, "discrete group(s)", choices = unique(x), multiple = T, width = 200)
  } else {
    x <- stats::na.omit(x)
    if(length(x)) {
      sliderInput(inputId, label = "range bin",
                  min = min(x), max = max(x), value = c(min(x), max(x)),
                  width = 200, ticks = F)
    }
  }
}

#' Apply filter values \code{x} and return a defined group
#'
#' Convenience method that can handle whether filter values are numeric of character/factor
#' @keywords internal
getFilterGroup <- function(x, refids, filtercol, parentdata) {
  if(is.numeric(x)) {
    ids <- parentdata[which(findInterval(parentdata[[filtercol]], x, rightmost.closed = T) == 1), ID]
    intersect(ids, refids)
  } else {
    ID <- NULL # avoid NSE NOTE for R CMD check
    ids <- parentdata[get(filtercol) %in% x, ID]
    intersect(ids, refids)
  }
}

#' Format data for limma
#'
#' @keywords internal
asLimmaInput <- function(xdata, group1, group2) {
  xm <- t(xdata)
  sampIDs <- colnames(xm)
  group <- factor(sampIDs)
  levels(group) <- list(g1 = group1, g2 = group2)
  group <- addNA(group)
  levels(group)[3] <- "ignore"
  return(list(xm = xm, group = group))
}


#' Wrapper for creating design matrix and lmFit
#'
#' @keywords internal
fitDesign <- function(matrix, group) {
  design <- stats::model.matrix(~0 + group)
  colnames(design) <- gsub("group", "", colnames(design))
  fit <- limma::lmFit(matrix, design)
  return(fit)
}

#' @import magrittr
#' @keywords internal
fitContrast <- function(fit, contrast) {
  cont.matrix <- limma::makeContrasts(contrasts = contrast, levels = fit$design)
  fit2 <- limma::contrasts.fit(fit, cont.matrix) %>% limma::eBayes()
  return(fit2)
}

#' Wrapper all limma steps
#'
#' @keywords internal
limmaWrapper <- function(xdata, group1, group2) {
  input <- asLimmaInput(xdata, group1, group2)
  fit <- fitDesign(input$xm, group = input$group)
  fit2 <- fitContrast(fit, contrast = "g1-g2")
  return(fit2)
}

#' Compute fold change for x-axis
#'
#' @keywords internal
xFoldChange <- function(xdata, group1, group2) {
  sampIDs <- rownames(xdata)
  means1 <- colMeans(xdata[sampIDs %in% group1, ])
  means2 <- colMeans(xdata[sampIDs %in% group2, ])
  return(means1-means2)
}

#' Convert p-values to negative log values
#'
#' @keywords internal
asNegLogAdjP <- function(p) {
  adjP <- stats::p.adjust(p, method = "fdr")
  nlaP <- -log(adjP)
  return(nlaP)
}
