#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  r <- reactiveValues()

  mod_cols_conf_server("cols_conf_1", r = r)
  mod_order_spec_conf_server("order_spec_conf_1", r = r)
}
