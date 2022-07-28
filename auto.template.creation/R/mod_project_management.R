#' project_management UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_project_management_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' project_management Server Functions
#'
#' @noRd 
mod_project_management_server <- function(id, r) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_project_management_ui("project_management_1")
    
## To be copied in the server
# mod_project_management_server("project_management_1")
