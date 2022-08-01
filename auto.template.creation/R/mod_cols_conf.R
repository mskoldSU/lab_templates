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
    fileInput(inputId = ns("cols_data_file"), label = "Upload Cols Definition", multiple = FALSE,
              accept = c("text/csv", "text/comma-separated-values", ".csv")),
    wellPanel(
      h4("Preview Columns"),
      uiOutput(outputId = ns("sheet_selector_ui")),
      DT::DTOutput(ns("input_table")),
    )
  )
}

#' cols_conf Server Functions
#'
#' @noRd
mod_cols_conf_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observe({
      req(r$selected_project_id)
      r$cols_df <- NULL
    })

    update_main_df <- function() {
      output$input_table <- DT::renderDT(options = list(scrollX = TRUE, pageLength = 25), {
        r$cols_df[r$cols_df$sheet %in% input$sheet_selector_select,]
      })
    }

    observeEvent(input$cols_data_file, {
      cols_df <- read.csv(file = input$cols_data_file$datapath, header = TRUE, na.strings = c("NA"), stringsAsFactors = FALSE, fileEncoding = "utf8")

      required_headers <- c("nrm_code", "sheet")

      for (head in required_headers) {
        if (!(head %in% colnames(cols_df))) {
          showNotification(paste0("Table is missing '", head, "' header. Expecting headers: '", paste(required_headers, collapse = "', '"), "'."), type="error")
          return()
        }
      }

      r$cols_df <- cols_df

      output$sheet_selector_ui <- renderUI({
        selectInput(inputId = ns("sheet_selector_select"), label = "Select Sheets to Preview", choices = unique(r$cols_df$sheet), selected = unique(r$cols_df$sheet), multiple = TRUE)
      })
    })

    observeEvent(input$sheet_selector_select, {
      update_main_df()
    })
  })
}

## To be copied in the UI
# mod_cols_conf_ui("cols_conf_1")

## To be copied in the server
# mod_cols_conf_server("cols_conf_1")
