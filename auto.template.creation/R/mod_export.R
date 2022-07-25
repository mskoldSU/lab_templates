#' export UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_export_ui <- function(id) {
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
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    r$all_export_df <- NULL

    updateDT <- function() {
      req(r$all_export_df)

      output$exported_table <- DT::renderDT(options = list(scrollX = TRUE), {
        r$all_export_df
      })
    }

    observe({
      req(r$cols_df)
      req(r$order_df)
      req(r$order_df_col_nor) # Maybe remove if not used
      req(r$order_start_accnr_df)

      req(input$sheet_selector_select)

      ## Write all export
      all_export_df <- data.frame()
      col_names <- c("NRM's sample code", "Sample code of analytical lab", "*species", "*samplingsite")

      for (col in input$sheet_selector_select) {
        for (row in seq_len(nrow(r$order_df))) {
          if (r$order_start_accnr_df[row, col] == "") {
            next
          }

          hom_size <- r$order_df[row, paste0(col, "_hom")]
          for (i in seq_len(r$order_df[row, col])) {
            all_export_df <- rbind(all_export_df,
                                   c(accnr_hom(accnr_add(r$order_start_accnr_df[row, col], (i - 1) * hom_size), hom_size),
                                     "testid",
                                     r$order_df[row, "Art"],
                                     r$order_df[row, "Lokal"]
                                     )
                                   )
          }
        }
      }

      if (nrow(all_export_df) == 0) {
        return()
      }

      colnames(all_export_df) <- col_names

      cols_to_add <- r$cols_df[r$cols_df$sheet %in% input$sheet_selector_select, "nrm_code"]

      all_export_df <- cbind(all_export_df, matrix(ncol = length(cols_to_add), nrow = nrow(all_export_df)))
      colnames(all_export_df) <- c(col_names, cols_to_add)

      r$all_export_df <<- all_export_df

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
