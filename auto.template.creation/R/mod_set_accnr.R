#' set_accnr UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_set_accnr_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$div(class="set_accnr_categories")
  )
}

#' set_accnr Server Functions
#'
#' @noRd 
mod_set_accnr_server <- function(id, r) {
  moduleServer(id, function(input, output, session){
    ns <- session$ns

    observeEvent(input$accnr_start_change, {
      req(r$order_start_accnr_df)
      if (input$accnr_start_change$value == "") {
        r$order_start_accnr_df[input$accnr_start_change$row, input$accnr_start_change$col] <- ""
        updateDTs()
      }

      if (valid_accnr(input$accnr_start_change$value)) {
        r$order_start_accnr_df[input$accnr_start_change$row, input$accnr_start_change$col] <- input$accnr_start_change$value
        updateDTs()
      } else {
        showNotification("Invalid AccNR. Please enter on the form: A2022/00001", type = "warning")
      }
    })

    updateDTs <- function() {
      rows <- unique(r$order_spec_selected[, 1])

      lapply(rows, {
        function(row) {
          cols <- r$order_spec_selected[r$order_spec_selected[, 1] == row, 2]

          id <- paste0(row, "accnr_table")
          output[[id]] <- DT::renderDT(
                                escape = FALSE, selection = "none", server = FALSE,
                                rownames = colnames(r$order_df_merged[cols]),
                                colnames = c("Count", "AccNR", "", "", "ProvID", "ProvID-grupp"),
                                options = list(dom = "t", paging = FALSE, ordering = FALSE), {
                                  data.frame(
                                    COUNT = unlist(lapply(cols, {
                                      function (col) {
                                        r$order_df_merged[row, col]
                                      }
                                    })),
                                    ACCNR = unlist(lapply(cols, {
                                      function (col) {
                                        paste0("<input onchange='Shiny.setInputValue(\"", ns("accnr_start_change"), "\", { row: ", row, ", col: ", col, ", value: this.value}, { priority: \"event\"});' value='", r$order_start_accnr_df[row, col], "'/>")
                                      }
                                    })),
                                    ARROW = rep("->", length(cols)),
                                    UPPER_ACCNR = unlist(lapply(cols, {
                                      function (col) {
                                        col_name <- colnames(r$order_df_merged)[col]
                                        if (r$order_start_accnr_df[row, col] == "") {
                                          return("-")
                                        } else {
                                          return(accnr_add(r$order_start_accnr_df[row, col], r$order_df[row, col_name] * r$order_df[row, paste0(col_name, "_hom")] - 1))
                                        }
                                      }
                                    })),
                                    TESTID = rep("testid", length(cols)),
                                    TESTIDGROUP = unlist(lapply(seq_len(length(cols)), {
                                      function (col) {
                                        paste0("<select>",
                                               paste(lapply(seq_len(length(cols)), { function(i) {
                                                 paste0("<option", " selected"[i == col], ">", i, "</option>")
                                               } }), collapse = ""),
                                               "</select>")
                                      }
                                    }))
                                  )
                                })
        }
      })
    }

    updateList <- function() {
      removeUI("div.accnr_setter", multiple = TRUE)

      rows <- unique(r$order_spec_selected[, 1])

      lapply(rows, {
        function(row) {
        cols <- r$order_spec_selected[r$order_spec_selected[, 1] == row, 2]

        insertUI("div.set_accnr_categories", where = "afterEnd",
                 tags$div(class = "accnr_setter",
                          hr(),
                          fluidRow(
                            column(width = 2,
                              h4(r$order_df_merged[row, 1]),
                              h4(r$order_df_merged[row, 2]),
                            ),
                            column(width = 10,
                                   HTML("<button onclick='let v = this.parentElement.querySelector(\"input\").value; this.parentElement.querySelectorAll(\"input\").forEach((i) => {i.value = v; i.onchange(); });'>Copy AccNR from first to rest</button>"),
                                   DT::dataTableOutput(outputId = ns(paste0(row, "accnr_table")))
                            )
                          ),
                          hr()
                          ))
        }
      })

      updateDTs()
    }

    observe({
      r$order_spec_selected
      r$order_df_modified
      ## Maybe make sure this only runs if the tables are visible
      updateList()
    })
  })
}
    
## To be copied in the UI
# mod_set_accnr_ui("set_accnr_1")
    
## To be copied in the server
# mod_set_accnr_server("set_accnr_1")
