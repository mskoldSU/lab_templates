#' login UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_login_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(outputId = ns("body"))
  )
}
    
#' login Server Functions
#'
#' @noRd 
mod_login_server <- function(id, r) {
  moduleServer( id, function(input, output, session) {
    ns <- session$ns

    USER <- reactiveValues(login = FALSE)

    observe({
      if (USER$login) {
        output$body <- renderUI(isolate({
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
        }))
      } else {
        output$body <- renderUI({
          actionButton(inputId = ns("login"), label="LOGIN")
        })
      }
    })

    observeEvent(input$login, {
      USER$login <- !USER$login
    })

    mod_cols_conf_server("cols_conf_1", r = r)
    mod_order_spec_conf_server("order_spec_conf_1", r = r)
    mod_export_server("export_1", r = r)
  })
}
    
## To be copied in the UI
# mod_login_ui("login_1")
    
## To be copied in the server
# mod_login_server("login_1")
