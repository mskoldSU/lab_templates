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

    proxies <- reactiveValues()

    observeEvent(input$accnr_start_change, {
      req(r$order_start_accnr_df)
      if (input$accnr_start_change$value == "") {
        r$order_start_accnr_df[input$accnr_start_change$row, input$accnr_start_change$col] <- ""
        updateDTs()
      } else if (valid_accnr(input$accnr_start_change$value)) {
        r$order_start_accnr_df[input$accnr_start_change$row, input$accnr_start_change$col] <- input$accnr_start_change$value
        updateDTs()
      } else {
        showNotification("Invalid AccNR. Please enter on the form: A2022/00001", type = "warning")
      }
    })

    observeEvent(input$provid_start_change, {
      req(r$order_start_provid_df)
      if (input$provid_start_change$value == "") {
        r$order_start_provid_df[input$provid_start_change$row, input$provid_start_change$col] <- ""
        updateDTs()
      } else if (valid_provid(input$provid_start_change$value)) {
        r$order_start_provid_df[input$provid_start_change$row, input$provid_start_change$col] <- input$provid_start_change$value
        updateDTs()
      } else {
        showNotification("Invalid ProvID. Please enter on the form: Q2022/00001", type = "warning")
      }
    })

    updateDTs <- function() {
      rows <- unique(r$order_spec_selected[, 1])

      lapply(rows, {
        function(row) {
          cols <- r$order_spec_selected[r$order_spec_selected[, 1] == row, 2]

          id <- paste0(row, "accnr_table")
          df <- data.frame(
            COUNT = unlist(lapply(cols, {
              function (col) {
                r$order_df_merged[row, col]
              }
            })),
            ACCNR = unlist(lapply(cols, {
              function (col) {
                paste0("<input class='accnrinput' onchange='Shiny.setInputValue(\"", ns("accnr_start_change"), "\", { row: ", row, ", col: ", col, ", value: this.value}, { priority: \"event\"});' value='", r$order_start_accnr_df[row, col], "'/>")
              }
            })),
            ARROW1 = rep("->", length(cols)),
            UPPER_ACCNR = unlist(lapply(cols, {
              function (col) {
                col_name <- colnames(r$order_df_merged)[col]
                if (r$order_start_accnr_df[row, col] == "") {
                  return("-")
                } else {
                  added_accnr <- accnr_add(r$order_start_accnr_df[row, col], r$order_df[row, col_name] * r$order_df[row, paste0(col_name, "_hom")] - 1)
                  if ("warning" %in% names(added_accnr)) {
                    showNotification(added_accnr$warning, type = "warning")
                  }
                  return(added_accnr$accnr)
                }
              }
            })),
            PROVID = unlist(lapply(cols, {
              function (col) {
                paste0(
                  "<input class='providinput' onchange='Shiny.setInputValue(\"",
                  ns("provid_start_change"),
                  "\", { row: ",
                  row,
                  ", col: ",
                  col,
                  ", value: this.value}, { priority: \"event\"});' value='",
                  r$order_start_provid_df[row, col],
                  "'/>")
              }
            })),
            ARROW2 = rep("->", length(cols)),
            UPPER_PROVID = unlist(lapply(cols, {
              function (col) {
                col_name <- colnames(r$order_df_merged)[col]
                if (r$order_start_provid_df[row, col] == "") {
                  return("-")
                } else {
                  added_provid <- provid_add(r$order_start_provid_df[row, col], r$order_df[row, col_name] - 1)
                  if ("warning" %in% names(added_provid)) {
                    showNotification(added_provid$warning, type = "warning")
                  }
                  return(added_provid$provid)
                }
              }
            })),
            SPACER = rep(as.character(div(style="width=100%;")), length(cols))
          )

          rownames(df) <- colnames(r$order_df_merged[cols])

          if (isolate(is.null(proxies[[id]]))) {
            output[[id]] <- DT::renderDT(
                                  escape = FALSE, selection = "none", server = TRUE,
                                  colnames = c("Count", "AccNR", "", "", "ProvID", "", "", ""),
                                  options = list(dom = "t", paging = FALSE, ordering = FALSE),
                                  df
                                )
            proxies[[id]] <- DT::dataTableProxy(id)
          } else {
            DT::replaceData(isolate(proxies[[id]]), df, resetPaging = FALSE)
            DT::updateFilters(isolate(proxies[[id]]), df)
          }
        }
      })
    }

    updateList <- function() {
      removeUI("div.accnr_setter", multiple = TRUE)

      rows <- unique(r$order_spec_selected[, 1])

      lapply(rows, {
        function(row) {
          cols <- r$order_spec_selected[r$order_spec_selected[, 1] == row, 2]

          id <- paste0(row, "accnr_table")
          proxies[[id]] <- NULL

          insertUI("div.set_accnr_categories", where = "afterEnd",
                   tags$div(class = "accnr_setter",
                            hr(),
                            fluidRow(
                              column(width = 2,
                                     h4(r$order_df_merged[row, 1]),
                                     h4(r$order_df_merged[row, 2]),
                                     ),
                              column(width = 10,
                                     HTML(
                                       paste0(
                                         "<button ",
                                         "onclick='",
                                         "let v = this.parentElement.querySelector(\"input.accnrinput\").value;\n",
                                         "this.parentElement.querySelectorAll(\"input.accnrinput\").forEach((i) => {i.value = v; i.onchange(); });",
                                         "'>",
                                         "Copy AccNR from first to rest",
                                         "</button>"
                                       )
                                     ),
                                     div(class="set_accnr_div_dt_holder",
                                         DT::DTOutput(outputId = ns(id))
                                         )
                                     )
                            )
                            )
                   )
        }
      })

      updateDTs()
    }

    observe({
      r$order_spec_selected
      ## Maybe make sure this only runs if the tables are visible
      isolate(updateList())
    })
  })
}
    
## To be copied in the UI
# mod_set_accnr_ui("set_accnr_1")
    
## To be copied in the server
# mod_set_accnr_server("set_accnr_1")
