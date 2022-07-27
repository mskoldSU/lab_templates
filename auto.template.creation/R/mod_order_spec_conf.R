#' order_spec_conf UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList showNotification fileInput textOutput wellPanel h4 actionButton br showNotification observeEvent observe
mod_order_spec_conf_ui <- function(id) {
  ns <- NS(id)
  tagList(
    conditionalPanel(condition = "show_order_spec == false",
                     fileInput(inputId = ns("order_spec_file"), label = "Upload Order Specification", multiple = FALSE,
                               accept = c("text/csv", "text/comma-separated-values", ".csv")),
                     textOutput(outputId = ns("cols_check_text")),
                     wellPanel(
                       h4("Select which to specify AccNR for, then: ",
                          actionButton(inputId = ns("set_accnr_button"), label = "Set AccNR")),
                       textOutput(outputId = ns("selected_count_text")),
                       br(),
                       div(style="overflow-x: auto",
                           DT::DTOutput(ns("order_spec_table")),
                           )
                       )
                     ),
    conditionalPanel(condition = "show_order_spec == true",
                     actionButton(inputId = ns("back_to_order_spec"), label = "Back to Full Order"),
                     mod_set_accnr_ui("set_accnr_1")
                     )
  )
}

#' order_spec_conf Server Functions
#'
#' @noRd 
mod_order_spec_conf_server <- function(id, r) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    save_selected <- reactiveVal()
    selected_filtered <- reactiveVal()

    generate_order_spec_table <- function() {
      modified_order_df <- r$order_df_merged

      sheet_cols <- seq(3, ncol(modified_order_df))
      modified_order_df[,sheet_cols] <- lapply(sheet_cols, {
        function(col, pre, pre_high, suf) {
          ## modified_order_df[modified_order_df[, col] != "", col] <- paste0(pre, modified_order_df[modified_order_df[, col] != "", col], suf)
          modified_order_df[modified_order_df[, col] != "", col] <- vapply(which(modified_order_df[, col] != ""), {
            function(row) {
              if (r$order_start_accnr_df[row, col] == "" || r$order_start_provid_df[row, col] == "") {
                paste0(pre, modified_order_df[row, col], suf)
              } else {
                paste0(pre_high, modified_order_df[row, col], suf)
              }
            }
          }, FUN.VALUE = "")
          modified_order_df[,col]
        }
      }, "<div>", "<div class='highlight'>", "</div>")
      modified_order_df
    }

    observe({
      req(r$order_df)
      req(r$order_df_merged)
      req(r$order_df_col_nor)
      req(r$order_df_col_hom)
      req(r$order_start_accnr_df)
      req(r$order_start_provid_df)

      df <- generate_order_spec_table()
      output$order_spec_table <- DT::renderDT(
                                       rownames = FALSE,
                                       escape = FALSE,
                                       server = FALSE,
                                       selection =
                                         list(target = "cell", selected = isolate(save_selected())),
                                       class = "nowrap",
                                       {
                                         df
                                       })
    })

    observe({
      req(r$order_df_merged)
      req(!is.null(input$order_spec_table_cells_selected))

      s <- input$order_spec_table_cells_selected
      sf <- matrix(nrow = 0, ncol = ncol(s))
      if (nrow(input$order_spec_table_cells_selected) > 0) {
        s[,2] <- s[,2] + 1
        for (row in seq_len(nrow(s))) {
          if (s[row,2] < 3) {
            next
          }
          if (r$order_df_merged[s[row, 1], s[row, 2]] != "") {
            sf <- rbind(sf, s[row,])
          }
        }
      }

      output$selected_count_text <- renderText(paste0("Selected: ", nrow(sf)))

      selected_filtered(sf)
    })

    observeEvent(input$set_accnr_button, {
      if (is.null(r$order_df)) {
        showNotification("You must upload an order specification first.", type = "error")
        return()
      }

      sel <- input$order_spec_table_cells_selected
      if (ncol(sel) == 0) {
        showNotification("Nothing selected.", type = "message")
        return()
      }

      save_selected(input$order_spec_table_cells_selected)
      r$order_spec_selected <- selected_filtered()

      ## This is read by JS in custom_js.js and updates the variable show_order_spec in the client
      session$sendCustomMessage("show_hide_order_spec", TRUE);
    })

    observeEvent(input$back_to_order_spec, {
      ## This is read by JS in custom_js.js and updates the variable show_order_spec in the client
      session$sendCustomMessage("show_hide_order_spec", FALSE);
    })

    observeEvent(input$order_spec_file, {
      order_df <- read.csv(file = input$order_spec_file$datapath, header = TRUE, na.strings = c("NA"), stringsAsFactors = FALSE, fileEncoding = "utf8")

      required_headers <- c("Art", "Lokal")
      for (rh in required_headers) {
        if (!(rh %in% colnames(order_df))) {
          showNotification(paste("Missing required header:", rh), type = "error")
          return()
        }
      }

      colns <- colnames(order_df)[3:ncol(order_df)]
      col_hom <- colns[endsWith(colns, "_hom")]
      col_nor <- colns[!endsWith(colns, "_hom")]

      ## check that every column has both _hom and normal
      if (length(col_hom) != length(col_nor)) {
        showNotification("There must be an equal number of columns defining homogenate as there are defining number of tests.", type = "error")
        return()
      }

      for (i in seq_len(length(col_hom))) {
        if (!(paste0(col_nor[i], "_hom") %in% col_hom)) {
          showNotification(paste("The column:", col_nor[i], "is missing a corresponding:", paste0(col_nor[i], "_hom"), "column."), type = "error")
          return()
        }

        if (!(substr(col_hom[i], 1, nchar(col_hom[i]) - 4) %in% col_nor)) {
          showNotification(paste("The column:", col_hom[i], "is missing a corresponding:", substr(col_hom[i], 1, nchar(col_hom[i]) - 4), "column."), type = "error")
          return()
        }
      }

      ## check that all columns are defined in the cols df
      if (!is.null(r$cols_df)) {
        if (!setequal(col_nor, unique(r$cols_df$sheet))) {
          output$cols_check_text <- renderText(
            paste0("Categories do not match with columns. Columns contains: '",
                   paste(unique(r$cols_df$sheet), collapse = "', '"),
                   "' and order spec attempted to load contains: '",
                   paste(col_nor, collapse = "', '"),
                   "'."))
          showNotification("Category Mismatch - Categories do not match with columns.", type = "error")
          return()
        }
      } else {
        output$cols_check_text <- renderText("No Columns Loaded - Cannot Check Categories")
        showNotification("Cannot Check Categories - No Columns Data Loaded", type = "warning")
      }

      for (col in col_nor) {
        ## order_df[, col] <- as.numeric(order_df[, col])
        ## order_df[, paste0(col, "_hom")] <- as.numeric(order_df[, paste0(col, "_hom")])

        order_df[is.na(order_df[, col]) & !is.na(order_df[,paste0(col, "_hom")]), col] <- 1
        order_df[is.na(order_df[, paste0(col, "_hom")]) & !is.na(order_df[,col]), paste0(col, "_hom")] <- 1
      }

      r$order_df <- order_df
      r$order_df_col_nor <- col_nor
      r$order_df_col_hom <- col_hom

      r$order_df_merged <- data.frame(Art = r$order_df[, "Art"], Lokal = r$order_df[, "Lokal"])
      for (nor in r$order_df_col_nor) {
        r$order_df_merged[, nor] <- paste0(r$order_df[, nor], " * [", r$order_df[, paste0(nor, "_hom")], "]")
        r$order_df_merged[is.na(r$order_df[, nor]), nor] <- ""
      }

      r$order_start_accnr_df <- r$order_df_merged
      r$order_start_accnr_df[, seq(3, ncol(r$order_start_accnr_df))] <- ""

      r$order_start_provid_df <- r$order_df_merged
      r$order_start_provid_df[, seq(3, ncol(r$order_start_provid_df))] <- ""
    })
  })

  mod_set_accnr_server("set_accnr_1", r = r)
}
    
## To be copied in the UI
# mod_order_spec_conf_ui("order_spec_conf_1")
    
## To be copied in the server
# mod_order_spec_conf_server("order_spec_conf_1")
