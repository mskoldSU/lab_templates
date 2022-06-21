#' template_category_conf UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_template_category_conf_ui <- function(id){
  ns <- NS(id)
  tagList(
    mod_cols_conf_ui(ns("cols_conf_1")),
    uiOutput(outputId = ns("tabs"))
    )
}
    
#' template_category_conf Server Functions
#'
#' @noRd 
mod_template_category_conf_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
      if (!is.null(r$cols_df)) {
        output$tabs <- renderUI({
          tabs <- list()
          for (sheet in unique(r$cols_df$sheet)) {
            tabs <- append(tabs, list(
                           tabPanel(sheet, id = ns(sheet),
                                    p(paste0("hello :)", sheet)))
                           ))
          }

          do.call("tabsetPanel", append(
                                   list(id = ns("row_tabs"), type = "tabs"),
                                   tabs))
        })
      }
    })

    mod_cols_conf_server("cols_conf_1", r = r)
  })
}
    
## To be copied in the UI
# mod_template_category_conf_ui("template_category_conf_1")
    
## To be copied in the server
# mod_template_category_conf_server("template_category_conf_1")
