#' rows_conf UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_rows_conf_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
    column(width = 6,
           ),
    column(width = 6,
           )),
    h4("This is a module"),
    h5(id)
  )
}
    
#' rows_conf Server Functions
#'
#' @noRd 
mod_rows_conf_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_rows_conf_ui("rows_conf_1")
    
## To be copied in the server
# mod_rows_conf_server("rows_conf_1")
