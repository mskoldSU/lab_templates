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
    DT::DTOutput(ns("exported_table")),
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

      output$exported_table <- DT::renderDT(options = list(scrollX = TRUE, pageLength = 25), {
        r$all_export_df
      })
    }

    observe({
      req(r$cols_df)
      req(r$order_df)
      req(r$order_df_col_nor) # Maybe remove if not used
      req(r$order_start_accnr_df)
      req(r$order_start_provid_df)

      req(input$sheet_selector_select)

      message(paste0(session$token, ": Updating export table"))

      ## Write all export
      all_export_df <- data.frame()
      col_names <- c("Accession Number", "NRM's sample code", "Sample code of analytical lab", "*species", "*samplingsite")

      for (col in input$sheet_selector_select) {
        for (row in seq_len(nrow(r$order_df))) {
          if (r$order_start_accnr_df[row, col] == "" || r$order_start_provid_df[row, col] == "") {
            ## TODO: Maybe option in export to include those without provid
            next
          }

          hom_size <- r$order_df[row, paste0(col, "_hom")]
          for (i in seq_len(r$order_df[row, col])) {
            added_accnr <- accnr_add(r$order_start_accnr_df[row, col], (i - 1) * hom_size)
            if ("warning" %in% names(added_accnr)) {
              showNotification(paste0(added_accnr$warning), type = "error")
            }

            added_provid <- provid_add(r$order_start_provid_df[row, col], i - 1)
            if ("warning" %in% names(added_provid)) {
              showNotification(paste0(added_provid$warning), type = "error")
            }

            all_export_df <- rbind(all_export_df,
                                   c(accnr_hom(added_accnr$accnr, hom_size),    # AccNR
                                     added_provid$provid,                       # ProvID
                                     "",                                        # Sample code of analytical lab
                                     r$order_df[row, "Art"],                    # *species
                                     r$order_df[row, "Lokal"]                   # *samplingsite
                                     )
                                   )
          }
        }
      }

      if (nrow(all_export_df) > 0) {
        cols_to_add <- r$cols_df[r$cols_df$sheet %in% input$sheet_selector_select, "nrm_code"]

        all_export_df <- cbind(all_export_df, matrix(ncol = length(cols_to_add), nrow = nrow(all_export_df)))
        colnames(all_export_df) <- c(col_names, cols_to_add)
      }

      r$all_export_df <- all_export_df

      updateDT()

      message(paste0(session$token, ": Done updating export table"))
    })

    observe({
      req(r$cols_df)

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
