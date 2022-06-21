#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  mod_template_category_conf_server("template_category_conf_diox")
  mod_template_category_conf_server("template_category_conf_meta")
  mod_template_category_conf_server("template_category_conf_hgsi")
  mod_template_category_conf_server("template_category_conf_pfas")
}
