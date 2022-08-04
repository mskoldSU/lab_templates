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
                         wellPanel(
                         br(),
                         actionButton(inputId = ns("create_new_project"), label = "Create New Project"),
                         div(
                           DT::DTOutput(outputId = ns("projects_table")),
                           style = "font-family: monospace;"
                         ))),
                tabPanel("Project Information", id = "project-information-tab",
                         wellPanel(
                           uiOutput(outputId = ns("project_body"))
                         ))
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
            div(
              actionButton(inputId = ns("select_another_project"), label = "Select Another Project"),
              style = "margin: 10px 0px 10px 0px"
            ),
            tabsetPanel(id = "tabs2", type = "tabs",
                tabPanel("Analyser", id = "analyzes-tab",
                         wellPanel(
                         p("En rad för varje analyspaket/rapportmall, innehåller diverse meta-data som återfinns i rapportmallens flik \"general info\"."),
                         fileInput(inputId = ns("analyzes_file"), label = "Upload (and override) Analyzes", multiple = FALSE,
                                   accept = c("text/csv", "text/comma-separated-values", ".csv", ".xlsx", ".xls", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")),
                           h4("Analyzes"),
                           DT::DTOutput(outputId = ns("analyzes_table"))
                         )
                         ),
                tabPanel("Prover", id = "samples-tab",
                         wellPanel(
                           p("En rad för varje kombination av art, lokal och varje analystyp som förekommer i tabellen Analyser."),
                           fileInput(inputId = ns("samples_file"), label = "Upload (and override) Samples", multiple = FALSE,
                                     accept = c("text/csv", "text/comma-separated-values", ".csv", ".xlsx", ".xls", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")),
                           h4("Samples"),
                           checkboxInput(inputId = ns("long_format"), label = "View in long-format", value = FALSE),
                           DT::DTOutput(outputId = ns("samples_table"))
                         )
                         ),
                tabPanel("Matriser", id = "matrices-tab",
                         wellPanel(
                         p("En tabell över matriser (kombinationer av Art och Organ)."),
                         fileInput(inputId = ns("matrices_file"), label = "Upload (and override) Matrices", multiple = FALSE,
                                   accept = c("text/csv", "text/comma-separated-values", ".csv", ".xlsx", ".xls", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")),
                           h4("Matrices"),
                           DT::DTOutput(outputId = ns("matrices_table"))
                         )
                         ),
                tabPanel("Parametrar", id = "parameters-tab",
                         wellPanel(
                         p("Alla parametrar som skall rapporteras för respektive Analystyp och deras mätenhet."),
                         fileInput(inputId = ns("parameters_file"), label = "Upload (and override) Parameters", multiple = FALSE,
                                   accept = c("text/csv", "text/comma-separated-values", ".csv", ".xlsx", ".xls", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")),
                           h4("Parameters"),
                           DT::DTOutput(outputId = ns("parameters_table"))
                         )
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

    observe({
      req(r$selected_project_dfs)
      req(r$selected_project_dfs$analyzes)

      if (nrow(r$selected_project_dfs$analyzes) == 0) {
        return()
      }

      output$analyzes_table <- DT::renderDT(
                                     options = list(paging = FALSE, scrollX = TRUE),
                                     {
                                       r$selected_project_dfs$analyzes
                                     })
    })

    observeEvent(input$analyzes_file, {
      expected_columns <- c("analystyp", "labb", "utforarlabb", "provtillstand", "provberedning", "forvaringskarl", "analys_metod", "analys_instrument")

      if (endsWith(input$analyzes_file$datapath, ".xls") | endsWith(input$analyzes_file$datapath, ".xlsx")) {
        raw_data <- readxl::read_excel(path = input$analyzes_file$datapath, col_names = TRUE, header = TRUE)
      } else {
        raw_data <- read.csv(file = input$analyzes_file$datapath, header = TRUE, stringsAsFactors = FALSE)
      }

      missing_headers <- expected_columns[!(expected_columns %in% colnames(raw_data))]

      if (length(missing_headers) > 0) {
        showNotification(paste0("Missing headers: '", paste(missing_headers, collapse = "', '"), "' in table."), type = "warning")
        return()
      }

      upload_data_to_project_table(
        r$projects$database[r$projects$project_id == r$selected_project_id],
        projects_table_analyzes,
        expected_columns,
        raw_data)
      r$selected_project_dfs <- load_project(r$projects$database[r$projects$project_id == r$selected_project_id])
    })

    observe({
      req(r$selected_project_dfs)
      req(r$selected_project_dfs$samples)
      req(nrow(r$selected_project_dfs$samples) > 0)
      req(r$wide_merged)

      if (nrow(r$selected_project_dfs$samples) == 0) {
        return()
      }

      output$samples_table <- DT::renderDT(
                                     options = list(scrollX = TRUE),
                                     {
                                       if (input$long_format) {
                                         r$selected_project_dfs$samples
                                       } else {
                                         r$wide_merged
                                       }
                                     })
    })

    observeEvent(input$samples_file, {
      if (endsWith(input$samples_file$datapath, ".xls") | endsWith(input$samples_file$datapath, ".xlsx")) {
        raw_data <- readxl::read_excel(path = input$samples_file$datapath, col_names = TRUE, header = TRUE)
      } else {
        raw_data <- read.csv(file = input$samples_file$datapath, header = TRUE, stringsAsFactors = FALSE)
      }

      required_headers <- c("art", "lokal")

      for (rh in required_headers) {
        if (!(rh %in% colnames(raw_data))) {
          showNotification(paste("Missing required header:", rh), type = "error")
          return()
        }
      }

      colns <- colnames(raw_data)[3:ncol(raw_data)]
      col_hom <- colns[endsWith(colns, "_hom")]
      col_nor <- colns[!endsWith(colns, "_hom")]

      ## check that every column has both _hom and normal
      if (length(col_hom) != length(col_nor)) {
        showNotification("There must be an equal number of columns defining homogenate as there are defining number of tests.", type = "error")
        return()
      }

      for (i in seq_len(length(col_hom))) {
        if (!(paste0(col_nor[i], "_hom") %in% col_hom)) {
          showNotification(paste("The column:", col_nor[i], "is missing a corresponding:", paste0(col_nor[i], "_hom"), "column."), type = "error")
          return()
        }

        if (!(substr(col_hom[i], 1, nchar(col_hom[i]) - 4) %in% col_nor)) {
          showNotification(paste("The column:", col_hom[i], "is missing a corresponding:", substr(col_hom[i], 1, nchar(col_hom[i]) - 4), "column."), type = "error")
          return()
        }
      }

      for (col in col_nor) {
        raw_data[is.na(raw_data[, col]) & !is.na(raw_data[,paste0(col, "_hom")]), col] <- 1
        raw_data[is.na(raw_data[, paste0(col, "_hom")]) & !is.na(raw_data[,col]), paste0(col, "_hom")] <- 1
      }

      longf <- wide_to_long_prover(raw_data)
      print(1)
      print(longf)
      longf <- cbind(ind = seq_len(nrow(longf)), longf)
      print(2)
      print(longf)

      expected_columns <- c("ind", "analystyp", "art", "lokal", "individer_per_prov")

      upload_data_to_project_table(
        r$projects$database[r$projects$project_id == r$selected_project_id],
        projects_table_samples,
        expected_columns,
        longf)
      r$selected_project_dfs <- load_project(r$projects$database[r$projects$project_id == r$selected_project_id])
    })

    observe({
      req(r$selected_project_dfs)
      req(r$selected_project_dfs$matrices)
      req(nrow(r$selected_project_dfs$matrices) > 0)

      output$matrices_table <- DT::renderDT(
                                     options = list(paging = FALSE, scrollX = TRUE),
                                     {
                                       r$selected_project_dfs$matrices
                                     })
    })

    observeEvent(input$matrices_file, {
      expected_columns <- c("analystyp", "art", "organ")

      if (endsWith(input$matrices_file$datapath, ".xls") | endsWith(input$matrices_file$datapath, ".xlsx")) {
        raw_data <- readxl::read_excel(path = input$matrices_file$datapath, col_names = TRUE, header = TRUE)
      } else {
        raw_data <- read.csv(file = input$matrices_file$datapath, header = TRUE, stringsAsFactors = FALSE)
      }

      missing_headers <- expected_columns[!(expected_columns %in% colnames(raw_data))]

      if (length(missing_headers) > 0) {
        showNotification(paste0("Missing headers: '", paste(missing_headers, collapse = "', '"), "' in table."), type = "warning")
        return()
      }

      upload_data_to_project_table(
        r$projects$database[r$projects$project_id == r$selected_project_id],
        projects_table_matrices,
        expected_columns,
        raw_data)
      r$selected_project_dfs <- load_project(r$projects$database[r$projects$project_id == r$selected_project_id])
    })

    observe({
      req(r$selected_project_dfs)
      req(r$selected_project_dfs$parameters)

      if (nrow(r$selected_project_dfs$parameters) == 0) {
        return()
      }

      output$parameters_table <- DT::renderDT(
                                     options = list(paging = FALSE, scrollX = TRUE),
                                     {
                                       r$selected_project_dfs$parameters
                                     })
    })

    observeEvent(input$parameters_file, {
      expected_columns <- c("analystyp", "parameternamn", "matenhet")

      if (endsWith(input$parameters_file$datapath, ".xls") | endsWith(input$parameters_file$datapath, ".xlsx")) {
        raw_data <- readxl::read_excel(path = input$parameters_file$datapath, col_names = TRUE, header = TRUE)
      } else {
        raw_data <- read.csv(file = input$parameters_file$datapath, header = TRUE, stringsAsFactors = FALSE)
      }

      missing_headers <- expected_columns[!(expected_columns %in% colnames(raw_data))]

      if (length(missing_headers) > 0) {
        showNotification(paste0("Missing headers: '", paste(missing_headers, collapse = "', '"), "' in table."), type = "warning")
        return()
      }

      upload_data_to_project_table(
        r$projects$database[r$projects$project_id == r$selected_project_id],
        projects_table_parameters,
        expected_columns,
        raw_data)
      r$selected_project_dfs <- load_project(r$projects$database[r$projects$project_id == r$selected_project_id])
    })
  })

  mod_project_selector_server("project_selector_management_1", r)
}

## To be copied in the UI
# mod_project_management_ui("project_management_1")

## To be copied in the server
# mod_project_management_server("project_management_1")
