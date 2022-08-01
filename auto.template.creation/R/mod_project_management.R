#' project_management UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList
mod_project_management_ui <- function(id) {
  ns <- NS(id)
  tagList(
    tabsetPanel(id = "tabs", type = "tabs",
                tabPanel("Projects", id = "projects-tab",
                         br(),
                         actionButton(inputId = ns("create_new_project"), label = "Create New Project"),
                         div(
                           DT::DTOutput(outputId = ns("projects_table")),
                           style = "font-family: monospace;"
                         )),
                tabPanel("Project Information", id = "project-information-tab",
                         uiOutput(outputId = ns("project_body"))
                         )
                )
  )
}

#' project_management Server Functions
#'
#' @noRd 
mod_project_management_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    renderProjectsDT <- function() {
      r$projects <- load_projects()
      output$projects_table <- DT::renderDT(
                                     editable = list(target = "cell"),
                                     selection = "none",
                                     rownames = FALSE,
                                     options = list(paging = FALSE),
                                     {
                                       r$projects
                                     }
                                   )
    }

    observe({
      req(r$projects)
      isolate({
        renderProjectsDT()
      })
    })

    observe({
      if (is.null(r$selected_project_id)) {
        output$project_body <- renderUI(isolate({
          mod_project_selector_ui("project_selector_management_1")
        }))
      } else {
        output$project_body <- renderUI(isolate({
          tagList(
            actionButton(inputId = ns("select_another_project"), label = "Select Another Project"),
            br(),
            br(),
            tabsetPanel(id = "tabs2", type = "tabs",
                tabPanel("Analyser", id = "analyzes-tab",
                         p("En rad för varje analyspaket/rapportmall, innehåller diverse meta-data som återfinns i rapportmallens flik \"general info\""),
                         ),
                tabPanel("Prover", id = "samples-tab",
                         p("En rad för varje kombination av art, lokal och varje analystyp som förekommer i tabellen Analyser."),
                         ),
                tabPanel("Matriser", id = "matrices-tab",
                         p("En tabell över matriser (kombinationer av Art och Organ)"),
                         ),
                tabPanel("Parametrar", id = "parameters-tab",
                         p("Alla parametrar som skall rapporteras för respektive Analystyp och deras mätenhet."),
                         )
                )
          )
        }))
      }
    })

    observeEvent(input$select_another_project, {
      r$selected_project_id <- NULL
    })

    observeEvent(input$create_new_project, {
      project_id <- uuid::UUIDgenerate()
      project_database <- paste0(project_id, ".db")
      insert_project(project_id, project_database, r$user$username, format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z"))
      renderProjectsDT()
    })

    observeEvent(input$projects_table_cell_edit, {
      col <- input$projects_table_cell_edit$col + 1
      if (colnames(r$projects)[col] %in% c("project_name", "project_manager")) {
        project_id <- r$projects$project_id[input$projects_table_cell_edit$row]
        update_project(project_id, colnames(r$projects)[col], input$projects_table_cell_edit$value)
      } else {
        showNotification("Only project_names and project_manager are editable.", type = "message")
      }
      renderProjectsDT()
    })
  })

  mod_project_selector_server("project_selector_management_1", r)
}

## To be copied in the UI
# mod_project_management_ui("project_management_1")

## To be copied in the server
# mod_project_management_server("project_management_1")
