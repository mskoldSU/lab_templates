#' samples_preparation UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_samples_preparation_ui <- function(id){
  ns <- NS(id)
  tagList(
    conditionalPanel(condition = "show_order_spec == false",
                       h4("Select which to specify AccNR for, then: ",
                          actionButton(inputId = ns("set_accnr_button"), label = "Set AccNR")),
                       textOutput(outputId = ns("selected_count_text")),
                       br(),
                       div(style="overflow-x: auto",
                           DT::DTOutput(ns("order_spec_table")),
                           )
                     ),
    conditionalPanel(condition = "show_order_spec == true",
                     actionButton(inputId = ns("back_to_order_spec"), label = "Back to Full Order"),
                     mod_set_accnr_and_provid_ui("set_accnr_and_provid_1")
                     )
  )
}
    
#' samples_preparation Server Functions
#'
#' @noRd 
mod_samples_preparation_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

  })

  mod_set_accnr_and_provid_server("set_accnr_and_provid_1", r = r)
}
    
## To be copied in the UI
# mod_samples_preparation_ui("samples_preparation_1")
    
## To be copied in the server
# mod_samples_preparation_server("samples_preparation_1")
