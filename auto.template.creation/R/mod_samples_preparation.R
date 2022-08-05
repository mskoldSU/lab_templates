#' samples_preparation UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList  conditionalPanel h4 actionButton textOutput br div
mod_samples_preparation_ui <- function(id){
  ns <- NS(id)
  tagList(
    conditionalPanel(condition = "show_order_spec == false",
                       h4("Select which to specify AccNR for, then: ",
                          actionButton(inputId = ns("set_accnr_button"), label = "Set AccNR")),
                       textOutput(outputId = ns("selected_count_text")),
                       br(),
                       div(style="overflow-x: auto",
                           DT::DTOutput(ns("order_spec_table")),
                           )
                     ),
    conditionalPanel(condition = "show_order_spec == true",
                     actionButton(inputId = ns("back_to_order_spec"), label = "Back to Full Order"),
                     mod_set_accnr_and_provid_ui("set_accnr_and_provid_1")
                     )
  )
}
    
#' samples_preparation Server Functions
#'
#' @noRd 
mod_samples_preparation_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    save_selected <- reactiveVal()

    get_selectable_cells <- function() {
      sel <- matrix(nrow = 0, ncol = 2)
      for (col in seq(3, ncol(r$wide_merged))) {
        for (row in seq(1,nrow(r$wide_merged))) {
          if (r$wide_merged[row, col] != "") {
            sel <- rbind(sel, matrix(c(row, col - 1), nrow = 1, ncol = 2))
          }
        }
      }
      sel
    }

    generate_order_spec_table <- function() {
      modified_order_df <- data.frame(r$wide_merged)

      sheet_cols <- seq(3, ncol(modified_order_df))
      modified_order_df[,sheet_cols] <- lapply(sheet_cols, {
        function(col) {
          modified_order_df[modified_order_df[, col] != "", col] <- vapply(which(modified_order_df[, col] != ""), {
            function(row) {
              fully_entered <- FALSE ##r$order_start_accnr_df[row, col] != "" && r$order_start_provid_df[row, col] != ""
              as.character(div(modified_order_df[row, col], class= (if (fully_entered) "highlight" else "")))
            }
          }, FUN.VALUE = "")
          modified_order_df[, col]
        }
      })
      modified_order_df
    }

    observe({
      req(r$wide_merged)

      df <- generate_order_spec_table()
      output$order_spec_table <- DT::renderDT(
                                       rownames = FALSE,
                                       escape = FALSE,
                                       server = FALSE,
                                       selection =
                                         list(target = "cell", selected = isolate(save_selected()), selectable = get_selectable_cells()),
                                       class = "nowrap",
                                       df
                                     )
    })

    observe({
      req(!is.null(input$order_spec_table_cells_selected))
      output$selected_count_text <- renderText(paste0("Selected: ", nrow(input$order_spec_table_cells_selected)))
    })

    observeEvent(input$set_accnr_button, {
      if (is.null(r$wide_merged)) {
        showNotification("The project manager has not uploaded the order specification yet.", type = "error")
        return()
      }

      sel <- input$order_spec_table_cells_selected
      if (ncol(sel) == 0) {
        showNotification("Nothing selected.", type = "message")
        return()
      }

      save_selected(input$order_spec_table_cells_selected)
      selected_filtered <- input$order_spec_table_cells_selected
      selected_filtered[,2] <- selected_filtered[,2] + 1
      r$order_spec_selected <- selected_filtered

      ## This is read by JS in custom_js.js and updates the variable show_order_spec in the client
      session$sendCustomMessage("show_hide_order_spec", TRUE);
    })

    observeEvent(input$back_to_order_spec, {
      ## This is read by JS in custom_js.js and updates the variable show_order_spec in the client
      session$sendCustomMessage("show_hide_order_spec", FALSE);
    })

  })

  mod_set_accnr_and_provid_server("set_accnr_and_provid_1", r = r)
}

## To be copied in the UI
# mod_samples_preparation_ui("samples_preparation_1")

## To be copied in the server
# mod_samples_preparation_server("samples_preparation_1")
