#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  r <- reactiveValues()

  # r$cols_df
  # r$order_spec_selected
  # r$order_df
  # r$order_df_merged
  # r$order_df_col_nor
  # r$order_df_col_hom
  # r$order_start_accnr_df
  # r$order_start_provid_df
  # r$all_export_df

  mod_login_server("login_1", r = r)
}
