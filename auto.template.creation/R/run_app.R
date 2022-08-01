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
  credentials <<- load_credentials()
  if (is.null(credentials)) {
    print("Could not find a credentials database, created a new user 'user-admin'")
    credentials <<- data.frame(
      username   =        c("user-admin"),
      password   = sapply(c("user-admin"), sodium::password_store),
      permission =        c("user-admin"),
      stringsAsFactors = FALSE
    )
  }

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

