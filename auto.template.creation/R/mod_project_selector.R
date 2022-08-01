#' project_selector UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_project_selector_ui <- function(id){
  ns <- NS(id)
  tagList(
    actionButton(inputId = ns("select_project"), label = "Select Project"),
    br(),
    DT::DTOutput(outputId = ns("projects_table"))
  )
}
    
#' project_selector Server Functions
#'
#' @noRd 
mod_project_selector_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    renderProjectsDT <- function() {
      r$projects <- load_projects()
      output$projects_table <- DT::renderDT(
                                     selection = "single",
                                     rownames = FALSE,
                                     options = list(paging = FALSE),
                                     {
                                       r$projects
                                     }
                                   )
    }

    observe({
      renderProjectsDT()
    })

    observeEvent(input$select_project, {
      if (length(input$projects_table_rows_selected) == 0) {
        showNotification("Please select a project", type = "message")
        return()
      }

      r$selected_project_id <- r$projects$project_id[input$projects_table_rows_selected]
      r$selected_project_dfs <- load_project(r$projects$database[r$projects$project_id == r$selected_project_id])
      print(r$selected_project_dfs)
    })
  })
}

## To be copied in the UI
# mod_project_selector_ui("project_selector_1")

## To be copied in the server
# mod_project_selector_server("project_selector_1")
