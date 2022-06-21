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
    tabsetPanel(id = ns("row_col_tabs"), type = "pills",
      tabPanel("Rows", id = ns("rows"),
               mod_rows_conf_ui(ns("rows_conf_1"))
               ),
      tabPanel("Cols", id = ns("cols"),
               mod_cols_conf_ui(ns("cols_conf_1")),
               )
    )
  )
}
    
#' template_category_conf Server Functions
#'
#' @noRd 
mod_template_category_conf_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    mod_rows_conf_server(ns("rows_conf_1"))
    mod_cols_conf_server(ns("cols_conf_1"))
 
  })
}
    
## To be copied in the UI
# mod_template_category_conf_ui("template_category_conf_1")
    
## To be copied in the server
# mod_template_category_conf_server("template_category_conf_1")
