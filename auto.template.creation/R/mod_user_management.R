#' user_management UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_user_management_ui <- function(id){
  ns <- NS(id)
  tagList(
    p("Edit users by double-clicking on a cell."),
    p("Enter the password in clear text and the hash will be automatically genereted (and shown)."),
    p("To remove a user, clear the username."),
    actionButton(inputId = ns("add_user"), label = "Add User"),
    DT::DTOutput(outputId = ns("user_table"))
  )
}
    
#' user_management Server Functions
#'
#' @noRd 
mod_user_management_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    last_rendered_user_table <- reactiveVal(NULL)

    updateUserDT <- function() {
      output$user_table <- DT::renderDT(
                                 editable = list(target = "cell"),
                                 selection = "none",
                                 colnames = c("username", "password hash", "permission"),
                                 options = list(paging = FALSE),
                                 {
                                   c <- credentials
                                   rownames(c) <- seq_len(nrow(c))
                                   c
                                 }
                               )

      last_rendered_user_table(credentials)
    }

    observeEvent(input$add_user, {
      if ("newuser" %in% credentials$username) {
        showNotification("Username: 'newuser' already taken", type = "message")
        return()
      }

      new_row <- nrow(credentials) + 1
      credentials[new_row,] <<- ""
      credentials[new_row, "username"] <<- "newuser"
      credentials <<- credentials[order(credentials$username),]
      save_credentials()
      updateUserDT()
    })

    observeEvent(input$user_table_cell_edit, {
      if (!all(last_rendered_user_table() == credentials)) {
        showNotification("The user-table has been edited since it was renedered. Your attempted edit was discarded and your table has been updated.", type = "message")
        updateUserDT()
        return()
      }
      row  <- input$user_table_cell_edit$row
      col <- input$user_table_cell_edit$col

      if (row < 1 || row > nrow(credentials) || col < 1 || col > ncol(credentials)) {
        updateUserDT()
        return()
      }

      if (colnames(credentials)[col] == "password") {
        credentials[row, col] <<- sodium::password_store(input$user_table_cell_edit$value)
      } else if (colnames(credentials)[col] == "username") {
        if (input$user_table_cell_edit$value == "") {
          credentials <<- credentials[-row,]
        } else if (input$user_table_cell_edit$value %in% credentials[,"username"]) {
          showNotification(paste0("Username: '", input$user_table_cell_edit$value, "' is already taken."), type = "message")
        } else {
          credentials[row, col] <<- input$user_table_cell_edit$value
        }
      } else {
        credentials[row, col] <<- input$user_table_cell_edit$value
      }

      credentials <<- credentials[order(credentials$username),]
      save_credentials()
      updateUserDT()
    })

    updateUserDT()
  })
}

## To be copied in the UI
# mod_user_management_ui("user_management_1")

## To be copied in the server
# mod_user_management_server("user_management_1")
