#' export UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_export_ui <- function(id){
  ns <- NS(id)
  tagList(
    textOutput(outputId = ns("info_text")),
    uiOutput(outputId = ns("sheet_selector_ui")),
    DT::dataTableOutput(ns("exported_table")),
  )
}
    
#' export Server Functions
#'
#' @noRd 
mod_export_server <- function(id, r) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    r$all_export_df <- NULL

    updateDT <- function() {
      req(r$all_export_df)

      exported_table <- DT::renderDT({
        ## Select only selected rows and cols
        r$all_export_df
      })
    }

    observe({
      req(r$cols_df)
      req(r$order_df)
      req(r$order_df_col_nor) # Maybe remove if not used
      req(r$order_start_accnr_df)

      input$sheet_selector_select

      ## Write all export
      all_export_df <- data.frame()

      for (col in seq(3, ncol(r$order_df))) {
        for (row in nrow(r$order_df)) {
          col_name <- colnames(r$order_df_merged)[col]
          print(r$order_start_accnr_df[row, col])
          if (is.null(r$order_start_accnr_df[row, col]) || r$order_start_accnr_df[row, col] == "") {
            next
          }

          for (i in seq_len(r$order_df[row, col_name])) {
            all_export_df <- rbind(all_export_df,
                                   c("NRM's sample code" = accnr_hom(r$order_start_accnr_df[row, col], r$order_df[row, paste0(col_name, "_hom")]),
                                     "Sample code of analytical lab" = "testid",
                                     "*species" = r$order_df[row, "Art"],
                                     "*lamlingsite" = r$order_df[row, "Lokal"]
                                     )
                                   )
          }
        }
      }

      r$all_export_df <- all_export_df

      updateDT()
    })

    observe({
      req(r$order_start_accnr_df)

      output$sheet_selector_ui <- renderUI({
        selectInput(inputId = ns("sheet_selector_select"), label = "Select Sheets to Export", choices = unique(r$cols_df$sheet), multiple = TRUE)
      })
    })


  })
}
    
## To be copied in the UI
# mod_export_ui("export_1")
    
## To be copied in the server
# mod_export_server("export_1")
