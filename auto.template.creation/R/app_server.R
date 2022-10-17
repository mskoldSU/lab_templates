#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic
  r <- reactiveValues()

  # r$user -- A list containing 'username' (a string of the currently logged in user, or NULL) and 'login' (TRUE if user is logged in, otherwise FALSE)
  # r$selected_project_id -- The id of the currently selected project, otherwise NULL
  # r$selected_project_dfs -- A list containing four dataframes: 'analyzes', 'samples', 'matrices', and 'parameters'
  # r$projects -- A table of all projects containing 'project_id', 'project_name', 'database', 'project_manager', 'created_by', and 'created_date'
  # r$order_spec_selected -- A matrix of selected colmns and rows of the merged samples table
  # r$wide_merged -- An automatically calculated wide format of the selected sample
  # r$wide_merged_used -- Wether wide_merged is currently in use

  r$user <- list(login = FALSE, username = NULL)
  r$projects <- load_projects()
  r$selected_project_id <- NULL
  r$selected_project_dfs <- list(analyzes = NULL, samples = NULL, matrices = NULL, parameters = NULL)

  r$wide_merged <- NULL
  r$wide_merged_used <- FALSE

  observe({
    req(r$selected_project_dfs$samples)
    req(nrow(r$selected_project_dfs$samples) > 0)
    req(r$wide_merged_used == TRUE)

    w <- long_to_wide_prover(r$selected_project_dfs$samples)
    r$wide_merged <- merge_wide(w$wide, w$non_uniform)
  })

  mod_login_server("login_1", r = r)
}
