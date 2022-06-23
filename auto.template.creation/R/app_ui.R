#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      title = "Automatic Template Creation",
      HTML("<h1>aut<span style='color: #A52A2A;'>O</span>matic templa<span style='color: #A52A2A;'>T</span>e <span style='color: #A52A2A;'>C</span>reation</h1>"),
      tabsetPanel(id = "tabs", type = "tabs",
                  tabPanel("Kolumner", id = "cols-tab",
                           br(),
                           mod_cols_conf_ui("cols_conf_1"),
                           ),
                  tabPanel("Provberedning", id = "provprep-tab",
                           br(),
                           mod_order_spec_conf_ui("order_spec_conf_1"),
                           ),
                  tabPanel("Export", id = "export-tab",
                           br(),
                           mod_export_ui("export_1")
                           )
                  )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
         favicon(),
         bundle_resources(
           path = app_sys("app/www"),
           app_title = "auto.template.creation"
         )
                                        # Add here other external resources
                                        # for example, you can add shinyalert::useShinyalert()
       )
}
