#' cols_conf UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_cols_conf_ui <- function(id){
  ns <- NS(id)
  tagList(
    h3("Here is the cols conf"),
    h4(ns("test"))
  )
}
    
#' cols_conf Server Functions
#'
#' @noRd 
mod_cols_conf_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_cols_conf_ui("cols_conf_1")
    
## To be copied in the server
# mod_cols_conf_server("cols_conf_1")
