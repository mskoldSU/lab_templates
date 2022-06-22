#' order_spec_conf UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_order_spec_conf_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fileInput(inputId = ns("order_spec_file"), label = "Choose Order Specification", multiple = FALSE,
              accept = c("text/csv", "text/comma-separated-values", ".csv")),
    textOutput(outputId = ns("cols_check_text")),
    actionButton(inputId = ns("temp"), label = "GOGOG"),
    wellPanel(
      h4("Select [...] to Set AccNR for"),
      DT::dataTableOutput(ns("order_spec_table")),
    )
  )
}
    
#' order_spec_conf Server Functions
#'
#' @noRd 
mod_order_spec_conf_server <- function(id, r) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe({
      req(r$order_df)
      output$order_spec_table <- DT::renderDT(rownames = FALSE, escape = FALSE, server = FALSE, selection = "none", class = "nowrap",
                                                     options = list(scrollX = TRUE, select = list(style = "multi", items = "cell", selector = "td div")),
                                                     extension = "Select", {
                                                       modified_order_df <- r$order_df
                                                       sheet_cols <- seq(3, ncol(modified_order_df))
                                                       modified_order_df[,sheet_cols] <- lapply(sheet_cols, {
                                                         function(i, a, b) {
                                                           modified_order_df[modified_order_df[, i] != "", i] <- paste0(a, modified_order_df[modified_order_df[, i] != "", i], b)
                                                           modified_order_df[,i]
                                                         }
                                                       }, "<div style='user-select: none;'>", "</div>")
                                                       modified_order_df
                                                     })
    })

    observeEvent(input$temp, {
      print(input$order_spec_table_cells_selected)
    })

    observeEvent(input$order_spec_file, {
      order_df <- read.csv(file = input$order_spec_file$datapath, header = TRUE, na.strings = c("NA"), stringsAsFactors = FALSE)
      if (!is.null(r$cols_df)) {
        if (!setequal(colnames(order_df)[3:length(colnames(order_df))], unique(r$cols_df$sheet))) {
          output$cols_check_text <- renderText(
            paste0("Categories do not match with columns. Columns contains: '",
                   paste(unique(r$cols_df$sheet), collapse = "', '"),
                   "' and order spec attempted to load contains: '",
                   paste(colnames(order_df)[3:length(colnames(order_df))], collapse = "', '"),
                   "'."))
          showNotification("Category Mismatch - Categories do not match with columns.", type = "error")
          return()
        }
      } else {
        output$cols_check_text <- renderText("No Columns Loaded - Cannot Check Categories")
        showNotification("Cannot Check [...] Categories - No Columns Data Loaded", type = "warning")
      }

      r$order_df <<- order_df
    })
  })
}
    
## To be copied in the UI
# mod_order_spec_conf_ui("order_spec_conf_1")
    
## To be copied in the server
# mod_order_spec_conf_server("order_spec_conf_1")
