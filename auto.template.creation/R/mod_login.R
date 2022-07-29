#' login UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_login_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(outputId = ns("body"))
  )
}
    
#' login Server Functions
#'
#' @noRd 
mod_login_server <- function(id, r) {
  moduleServer( id, function(input, output, session) {
    ns <- session$ns

    USER <- reactiveValues(login = FALSE)

    loginpage <- div(id = "loginpage", style = "width: 500px; max-width: 100%; margin: 0 auto; padding: 20px;",
                     wellPanel(
                       tags$h2("LOG IN", class = "text-center", style = "padding-top: 0;color:#333; font-weight:600;"),
                       textInput(ns("user_name"), placeholder="Username", label = tagList(icon("user"), "Username")),
                       passwordInput(ns("passwd"), placeholder="Password", label = tagList(icon("unlock-alt"), "Password")),
                       br(),
                       div(
                         style = "text-align: center;",
                         actionButton(ns("login"), "SIGN IN", style = "color: white; background-color:#3c8dbc;
                                 padding: 10px 15px; width: 150px; cursor: pointer;
                                 font-size: 18px; font-weight: 600;"),
                         shinyjs::hidden(
                                    div(id = ns("nomatch"),
                                        tags$p("Incorrect username or password!",
                                               style = "color: red; font-weight: 600;
                                            padding-top: 5px;font-size:16px;",
                                            class = "text-center"))),
                         ))
                     )

    output$body <- renderUI(loginpage)

    observeEvent(input$login, {
      if (USER$login == FALSE) {
        Username <- isolate(input$user_name)
        Password <- isolate(input$passwd)
        user_index <- which(credentials$username==Username)
        if (length(user_index) == 1) {
          pasmatch  <- credentials["password"][user_index,]
          pasverify <- sodium::password_verify(pasmatch, Password)
          perm <- credentials["permission"][user_index,]
          if (pasverify) {
            USER$login <- TRUE
            output$body <- renderUI(isolate({
              tagList(
                span(
                  a(icon("sign-out-alt"), "Logout", href="javascript:window.location.reload(true)"),
                  style="position: absolute; right: 20px; top: 20px;"
                ),
                {
                  if (perm == "lab-user") {
                    mod_lab_management_ui("lab_management_1")
                  } else if (perm == "project-manager") {
                    mod_project_management_ui("project_management_1")
                  } else if (perm == "user-admin") {
                    mod_user_management_ui("user_management_1")
                  } else {
                    p("This account does not have any permission. Please contact someone with user manager permission.")
                  }
                }
              )}))
          } else {
            shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade")
            shinyjs::delay(3000, shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade"))
          }
        } else {
          shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade")
          shinyjs::delay(3000, shinyjs::toggle(id = "nomatch", anim = TRUE, time = 1, animType = "fade"))
        }
      }
    })
  })

  mod_user_management_server("user_management_1", r)
  mod_project_management_server("project_management_1", r)
  mod_lab_management_server("lab_management_1", r)
}
    
## To be copied in the UI
# mod_login_ui("login_1")
    
## To be copied in the server
# mod_login_server("login_1")
