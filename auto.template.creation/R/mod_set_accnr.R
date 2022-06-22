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
  moduleServer( id, function(input, output, session){
    ns <- session$ns

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
                              h4(r$order_df[row, 1]),
                              h4(r$order_df[row, 2]),
                            ),
                            column(width = 10,
                              DT::dataTableOutput(outputId = ns(paste0(row, "accnr_table")))
                            )
                          ),
                          hr()
                          ))

        id <- paste0(row, "accnr_table")

        output[[id]] <- DT::renderDT(
                              escape = FALSE, selection = "none",
                              rownames = colnames(r$order_df[cols]),
                              colnames = c("AccNR", "", "", "ProvID", "ProvID-grupp"),
                              options = list(dom = "t", paging = FALSE, ordering = FALSE), {
                                data.frame(
                                  ACCNR = rep("<input></input>", length(cols)),
                                  ARROW = rep("->", length(cols)),
                                  UPPER_ACCNR = rep("large value", length(cols)),
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

    observe({
      r$order_spec_selected
      ## Maybe make sure this only runs if the tables are visible
      updateList()
    })
  })
}
    
## To be copied in the UI
# mod_set_accnr_ui("set_accnr_1")
    
## To be copied in the server
# mod_set_accnr_server("set_accnr_1")
