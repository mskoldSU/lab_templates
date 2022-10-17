#' export UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList textOutput uiOutput
mod_export_ui <- function(id) {
  ns <- NS(id)
  tagList(
    # textOutput(outputId = ns("info_text")),
    # uiOutput(outputId = ns("sheet_selector_ui")),
    # DT::DTOutput(ns("exported_table")),
    h2("This view currently used for debugging"),
    h3("Current value of r$selected_project_dfs"),
    uiOutput(ns("selected_project_dfs")),
    h3("Current value of r$order_spec_selected"),
    uiOutput(ns("order_spec_selected")),
    h3("Download current copy of SQLite database"),
    downloadButton(ns("downloadData"), "Download")
  )
}

#' export Server Functions
#'
#' @noRd
mod_export_server <- function(id, r) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns
    output$selected_project_dfs <- renderUI(listviewer::jsonedit(r$selected_project_dfs))
    output$order_spec_selected <- renderUI(listviewer::jsonedit(r$order_spec_selected))
    output$downloadData <- downloadHandler(filename  = r$projects$database[r$projects$project_id == r$selected_project_id],
                                           content = function(file){
                                             con <-  dbConnect(SQLite(), 
                                                               paste0(projects_folder_sqlite_path, r$projects$database[r$projects$project_id == r$selected_project_id]))
                                             sqliteCopyDatabase(con, file)
                                           }
    )
  })
}

## To be copied in the UI
# mod_export_ui("export_1")

## To be copied in the server
# mod_export_server("export_1")
