#' lab_management UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_lab_management_ui <- function(id){
  ns <- NS(id)
  tagList(
    tabsetPanel(id = "tabs", type = "tabs",
                tabPanel("Kolumner", id = "cols-tab",
                         br(),
                         mod_cols_conf_ui("cols_conf_1"),
                         ),
                tabPanel("Provberedning", id = "provprep-tab",
                         br(),
                         mod_order_spec_conf_ui("order_spec_conf_1"),
                         ),
                tabPanel("Export", id = "export-tab",
                         br(),
                         mod_export_ui("export_1")
                         )
                )
  )
}
    
#' lab_management Server Functions
#'
#' @noRd 
mod_lab_management_server <- function(id, r) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })

  mod_cols_conf_server("cols_conf_1", r = r)
  mod_order_spec_conf_server("order_spec_conf_1", r = r)
  mod_export_server("export_1", r = r)
}
    
## To be copied in the UI
# mod_lab_management_ui("lab_management_1")
    
## To be copied in the server
# mod_lab_management_server("lab_management_1")
