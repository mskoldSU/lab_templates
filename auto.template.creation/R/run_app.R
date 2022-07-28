#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(
  onStart = NULL,
  options = list(),
  enableBookmarking = NULL,
  uiPattern = "/",
  ...
) {
  credentials <<- data.frame(
    username_id =        c("user-admin", "project-manager", "lab-user"),
    passod      = sapply(c("user-admin", "project-manager", "lab-user"), sodium::password_store),
    permission  =        c("user-admin", "project-manager", "lab-user"),
    stringsAsFactors = FALSE
  )
  credentials <<- credentials[order(credentials$username_id),]

  with_golem_options(
    app = shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}

