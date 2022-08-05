#' lab_management UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList uiOutput
mod_lab_management_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(outputId = ns("body"))
  )
}

#' lab_management Server Functions
#'
#' @noRd 
mod_lab_management_server <- function(id, r) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    observe({
      if (is.null(r$selected_project_id)) {
        output$body <- renderUI(isolate({
          mod_project_selector_ui("project_selector_1")
        }))
      } else {
        output$body <- renderUI(isolate({
          tagList(
            div(
              actionButton(inputId = ns("select_another_project"), label = "Select Another Project"),
              style = "margin: 10px 0px 10px 0px"
            ),
            br(),
            tabsetPanel(id = "tabs", type = "tabs",
                        tabPanel("Provberedning", id = "provprep-tab",
                                 wellPanel(
                                   mod_samples_preparation_ui("samples_preparation_1")
                                 )),
                        tabPanel("Export", id = "export-tab",
                                 wellPanel(
                                   mod_export_ui("export_1")
                                 ))
                        )
          )
        }))
      }
    })

    observeEvent(input$select_another_project, {
      r$selected_project_id <- NULL
      r$selected_project_dfs <- list(analyzes = NULL, samples = NULL, matrices = NULL, parameters = NULL)

      ## This is read by JS in custom_js.js and updates the variable show_order_spec in the client
      session$sendCustomMessage("show_hide_order_spec", FALSE);
    })

  })

  mod_project_selector_server("project_selector_1", r = r)
  mod_samples_preparation_server("samples_preparation_1", r = r)
  mod_export_server("export_1", r = r)
}
    
## To be copied in the UI
# mod_lab_management_ui("lab_management_1")
    
## To be copied in the server
# mod_lab_management_server("lab_management_1")
