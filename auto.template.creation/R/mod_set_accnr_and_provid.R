#' set_accnr_and_provid UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList checkboxInput tags
mod_set_accnr_and_provid_ui <- function(id){
  ns <- NS(id)
  tagList(
    checkboxInput(inputId = ns("expand"), label = "Expand"),
    tags$div(class="set_accnr_categories")
  )
}

#' set_accnr_and_provid Server Functions
#'
#' @noRd 
mod_set_accnr_and_provid_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    proxies <- reactiveValues()
    cell_edits <- reactiveValues()
    rendered_table <- reactiveValues()

    observeEvent(input$accnr_start_change, {
      req(r$selected_project_dfs$samples)
      req(nrow(r$selected_project_dfs$samples) > 0)

      rows <- which(r$selected_project_dfs$samples$art == r$wide_merged[input$accnr_start_change$row, "art"] &
                    r$selected_project_dfs$samples$lokal == r$wide_merged[input$accnr_start_change$row, "lokal"] &
                    r$selected_project_dfs$samples$analystyp == colnames(r$wide_merged[input$accnr_start_change$col]))

      if (input$accnr_start_change$value == "") {
        ## Clear all
        r$selected_project_dfs$samples[rows, "accnr"] <- ""

        update_accnrs_and_provids(
          r$projects$database[r$projects$project_id == r$selected_project_id],
          r$selected_project_dfs$samples$ind[rows],
          r$selected_project_dfs$samples$accnr[rows],
          r$selected_project_dfs$samples$provid[rows])

        updateDTs()
      } else if (valid_accnr(input$accnr_start_change$value)) {
        ## Set all
        accnr <- input$accnr_start_change$value
        for (row in rows) {
          r$selected_project_dfs$samples[row, "accnr"] <- accnr

          added_accnr <- accnr_add(accnr, r$selected_project_dfs$samples[row, "individer_per_prov"])
          if ("warning" %in% names(added_accnr)) {
            showNotification(added_accnr$warning, type = "warning")
            r$selected_project_dfs <- load_project(r$projects$database[r$projects$project_id == r$selected_project_id])
            updateDTs()
            return()
          }
          accnr <- added_accnr$accnr
        }

        update_accnrs_and_provids(
          r$projects$database[r$projects$project_id == r$selected_project_id],
          r$selected_project_dfs$samples$ind[rows],
          r$selected_project_dfs$samples$accnr[rows],
          r$selected_project_dfs$samples$provid[rows])

        updateDTs()
      } else {
        showNotification("Invalid AccNR. Please enter on the form: A2022/00001", type = "warning")
      }
    })

    observeEvent(input$provid_start_change, {
      req(r$selected_project_dfs$samples)
      req(nrow(r$selected_project_dfs$samples) > 0)

      rows <- which(r$selected_project_dfs$samples$art == r$wide_merged[input$provid_start_change$row, "art"] &
                    r$selected_project_dfs$samples$lokal == r$wide_merged[input$provid_start_change$row, "lokal"] &
                    r$selected_project_dfs$samples$analystyp == colnames(r$wide_merged[input$provid_start_change$col]))

      if (input$provid_start_change$value == "") {
        ## Clear all
        r$selected_project_dfs$samples[rows, "provid"] <- ""

        update_accnrs_and_provids(
          r$projects$database[r$projects$project_id == r$selected_project_id],
          r$selected_project_dfs$samples$ind[rows],
          r$selected_project_dfs$samples$accnr[rows],
          r$selected_project_dfs$samples$provid[rows])

        updateDTs()
      } else if (valid_provid(input$provid_start_change$value)) {
        ## Set all
        provid <- input$provid_start_change$value
        for (row in rows) {
          r$selected_project_dfs$samples[row, "provid"] <- provid

          added_provid <- provid_add(provid, 1)
          if ("warning" %in% names(added_provid)) {
            showNotification(added_provid$warning, type = "warning")
            r$selected_project_dfs <- load_project(r$projects$database[r$projects$project_id == r$selected_project_id])
            updateDTs()
            return()
          }
          provid <- added_provid$provid
        }

        update_accnrs_and_provids(
          r$projects$database[r$projects$project_id == r$selected_project_id],
          r$selected_project_dfs$samples$ind[rows],
          r$selected_project_dfs$samples$accnr[rows],
          r$selected_project_dfs$samples$provid[rows])

        updateDTs()
      } else {
        showNotification("Invalid Provid. Please enter on the form: A2022/00001", type = "warning")
      }
    })

    observeEvent(input$add_entry, {
      ## Clear all
      rows <- which(r$selected_project_dfs$samples$art == input$add_entry$art &
                    r$selected_project_dfs$samples$lokal == input$add_entry$lokal &
                    r$selected_project_dfs$samples$analystyp == input$add_entry$analystyp)
      r$selected_project_dfs$samples[rows, "accnr"] <- ""
      r$selected_project_dfs$samples[rows, "provid"] <- ""

      update_accnrs_and_provids(
        r$projects$database[r$projects$project_id == r$selected_project_id],
        r$selected_project_dfs$samples$ind[rows],
        r$selected_project_dfs$samples$accnr[rows],
        r$selected_project_dfs$samples$provid[rows])

      ## Add new row
      new_row <- data.frame(
        ind = max(r$selected_project_dfs$samples$ind) + 1,
        analystyp = input$add_entry$analystyp,
        art = input$add_entry$art,
        lokal = input$add_entry$lokal,
        individer_per_prov = max(r$selected_project_dfs$samples$individer_per_prov[rows]),
        accnr = NA,
        provid = NA)

      r$selected_project_dfs$samples <- rbind(r$selected_project_dfs$samples, new_row)

      insert_sample_entry(
        r$projects$database[r$projects$project_id == r$selected_project_id],
        new_row$ind,
        new_row$analystyp,
        new_row$art,
        new_row$lokal,
        new_row$individer_per_prov
      )

      updateDTs()
    })

    updateDTs <- function() {
      rows <- unique(r$order_spec_selected[, 1])

      lapply(rows, {
        function(row) {
          cols <- r$order_spec_selected[r$order_spec_selected[, 1] == row, 2]
          art <- r$wide_merged[row, "art"]
          lokal <- r$wide_merged[row, "lokal"]
          matrices <- r$selected_project_dfs$matrices |> 
            dplyr::filter(stringr::str_detect(r$wide_merged[row, "art"], art)) |> 
            dplyr::select(-art)

          long_matches <- lapply(cols, {
            function (col) {
              which(
                r$selected_project_dfs$samples$art == art &
                r$selected_project_dfs$samples$lokal == lokal &
                r$selected_project_dfs$samples$analystyp == colnames(r$wide_merged[col])
              )
            }
          })
          names(long_matches) <- cols

          id <- paste0(row, "accnr_table")
          if (input$expand) {
            coln <- c("", "Organ", "Count", "AccNR", "ProvID", "", "Index")
            df <- data.frame(
              ANALYSTYP = unlist(lapply(cols, {
                function (col) {
                  rep(colnames(r$wide_merged[col]), nrow(r$selected_project_dfs$samples[long_matches[[paste(col)]], ]))
                }
              })),
              # ORGAN = unlist(lapply(cols, {
              #   function (col) {
              #     rep({ function () {
              #       if (is.null(r$selected_project_dfs$matrices) || nrow(r$selected_project_dfs$matrices) == 0) {
              #         return("No Organ Table")
              #       }
              # 
              #       organ <- r$selected_project_dfs$matrices[
              #                                         r$selected_project_dfs$matrices$art == art &
              #                                         r$selected_project_dfs$matrices$analystyp == colnames(r$wide_merged[col]),
              #                                         "organ"]
              # 
              #       if (length(organ) == 0) {
              #         return("")
              #       } else if (length(organ) > 1) {
              #         showNotification(sprintf("Found multiple matching organs: %s.", paste(organ, collapse = ", ")), type = "message")
              #         return("Multiple")
              #       } else {
              #         return(organ)
              #       }
              #     }}(), nrow(r$selected_project_dfs$samples[long_matches[[paste(col)]], ]))
              #   }
              # })),
              COUNT = unlist(lapply(cols, {
                function (col) {
                  r$selected_project_dfs$samples[long_matches[[paste(col)]], "individer_per_prov"]
                }
              })),
              ACCNR = unlist(lapply(cols, {
                function (col) {
                  r$selected_project_dfs$samples[long_matches[[paste(col)]], "accnr"]
                }
              })),
              PROVID = unlist(lapply(cols, {
                function (col) {
                  r$selected_project_dfs$samples[long_matches[[paste(col)]], "provid"]
                }
              })),
              SPACER = as.character(div(style="width=100%;")),
              INDEX = unlist(lapply(cols, {
                function (col) {
                  r$selected_project_dfs$samples[long_matches[[paste(col)]], "ind"]
                }
              }))
            ) |> dplyr::left_join(matrices, by = c("ANALYSTYP" = "analystyp")) |> 
              dplyr::select(ANALYSTYP, ORGAN = organ, dplyr::everything()) |> 
              dplyr::mutate(ACCNR = ifelse(valid_accnr(ACCNR), accnr_hom(ACCNR, COUNT), ACCNR))
          } else {
            coln <- c("", "Organ", "Count", "AccNR", "", "", "ProvID", "", "", "")
            df <- data.frame(
              ANALYSTYP = colnames(r$wide_merged[cols]),
              # ORGAN = unlist(lapply(cols, {
              #   function (col) {
              #     if (is.null(r$selected_project_dfs$matrices) || nrow(r$selected_project_dfs$matrices) == 0) {
              #       return("No Organ Table")
              #     }
              # 
              #     organ <- r$selected_project_dfs$matrices[
              #                                       r$selected_project_dfs$matrices$art == art &
              #                                       r$selected_project_dfs$matrices$analystyp == colnames(r$wide_merged[col]),
              #                                       "organ"]
              # 
              #     if (length(organ) == 0) {
              #       return("")
              #     } else if (length(organ) > 1) {
              #       showNotification(sprintf("Found multiple matching organs: %s.", paste(organ, collapse = ", ")), type = "message")
              #       return("Multiple")
              #     } else {
              #       return(organ)
              #     }
              #   }
              # })),
              COUNT = unlist(lapply(cols, {
                function (col) {
                  r$wide_merged[row, col]
                }
              })),
              ACCNR = unlist(lapply(cols, {
                function (col) {
                  paste0(
                    "<input class='accnrinput' onchange='Shiny.setInputValue(\"",
                    ns("accnr_start_change"),
                    "\", { row: ",
                    row,
                    ", col: ",
                    col,
                    ", value: this.value}, { priority: \"event\"});' value='",
                    if (is.na(r$selected_project_dfs$samples$accnr[long_matches[[paste(col)]]][1])) "" else r$selected_project_dfs$samples$accnr[long_matches[[paste(col)]]][1],
                    "'/>")
                }
              })),
              ARROW1 = rep("->", length(cols)),
              UPPER_ACCNR = unlist(lapply(cols, {
                function (col) {
                  col_name <- colnames(r$wide_merged)[col]
                  if (is.na(r$selected_project_dfs$samples$accnr[long_matches[[paste(col)]]][1]) || !valid_accnr(r$selected_project_dfs$samples$accnr[long_matches[[paste(col)]]][1])) {
                    return("-")
                  } else {
                    added_accnr <- accnr_add(r$selected_project_dfs$samples$accnr[long_matches[[paste(col)]]][1], sum(r$selected_project_dfs$samples$individer_per_prov[long_matches[[paste(col)]]]) - 1)
                    if ("warning" %in% names(added_accnr)) {
                      showNotification(added_accnr$warning, type = "warning")
                    }
                    return (added_accnr$accnr)
                  }
                }
              })),
              PROVID = unlist(lapply(cols, {
                function (col) {
                  paste0(
                    "<input class='providinput' onchange='Shiny.setInputValue(\"",
                    ns("provid_start_change"),
                    "\", { row: ",
                    row,
                    ", col: ",
                    col,
                    ", value: this.value}, { priority: \"event\"});' value='",
                    if (is.na(r$selected_project_dfs$samples$provid[long_matches[[paste(col)]]][1])) "" else r$selected_project_dfs$samples$provid[long_matches[[paste(col)]]][1],
                    "'/>")
                }
              })),
              ARROW2 = rep("->", length(cols)),
              UPPER_PROVID = unlist(lapply(cols, {
                function (col) {
                  col_name <- colnames(r$wide_merged)[col]
                  if (is.na(r$selected_project_dfs$samples$provid[long_matches[[paste(col)]]][1]) || !valid_provid(r$selected_project_dfs$samples$provid[long_matches[[paste(col)]]][1])) {
                    return("-")
                  } else {
                    added_provid <- provid_add(r$selected_project_dfs$samples$provid[long_matches[[paste(col)]]][1], length(long_matches[[paste(col)]]) - 1)
                    if ("warning" %in% names(added_provid)) {
                      showNotification(added_provid$warning, type = "warning")
                    }
                    return (added_provid$provid)
                  }
                }
              })),
              SPACER = rep(as.character(div(style="width=100%;")), length(cols))
            ) |> dplyr::left_join(matrices, by = c("ANALYSTYP" = "analystyp")) |> 
              dplyr::select(ANALYSTYP, ORGAN = organ, dplyr::everything())
          }

          rendered_table[[id]] <- df

          if (isolate(is.null(proxies[[id]]) || input$expand != proxies[[paste0(id, "last_expand")]])) {
            opt <- list(
              dom = "t",
              paging = FALSE,
              ordering = FALSE,
              autoWidth = TRUE,
              columnDefs = list(list(visible = FALSE, targets = c(0)))
            )
            edit <- FALSE
            if (input$expand) {
              button_function <- paste0("function(rows, group) {",
                                        "  return '<button onclick=\\'Shiny.setInputValue(\\\"",
                                        ns("add_entry"),
                                        "\\\", { art: \\\"",
                                        art,
                                        "\\\", lokal: \\\"",
                                        lokal,
                                        "\\\", analystyp: \\\"' + `${group}` + '\\\" }, { priority: \\\"event\\\" });",
                                        "\\'>Add another entry for ' + `${group}` + '</button>'; }")
              opt$rowGroup <- list(
                dataSrc = 1,
                endRender = DT::JS(button_function)
              )
              edit <- list(target = "cell", disable = list(columns = c(0:2,4:5)))
            }

            output[[id]] <- DT::renderDT(
                                  escape = FALSE, selection = "none", server = TRUE,
                                  colnames = coln,
                                  editable = edit,
                                  extensions = 'RowGroup',
                                  options = opt,
                                  {
                                    df
                                  }
                                )
            proxies[[id]] <- DT::dataTableProxy(id)
            proxies[[paste0(id, "last_expand")]] <- input$expand

            if (input$expand) {
              if (!is.null(cell_edits[[id]])) {
                cell_edits[[id]]$destroy()
              }

              cell_edits[[id]] <- observeEvent(input[[paste0(id, "_cell_edit")]],
              {
                row <- input[[paste0(id, "_cell_edit")]]$row
                ind <- rendered_table[[id]][row, "INDEX"]

                if (input[[paste0(id, "_cell_edit")]]$value > 0) {
                  update_individer_per_prov(
                    r$projects$database[r$projects$project_id == r$selected_project_id],
                    ind,
                    input[[paste0(id, "_cell_edit")]]$value
                  )
                  r$selected_project_dfs$samples$individer_per_prov[r$selected_project_dfs$samples$ind == ind] <-
                    input[[paste0(id, "_cell_edit")]]$value
                }

                art <- r$selected_project_dfs$samples$art[r$selected_project_dfs$samples$ind == ind]
                lokal <- r$selected_project_dfs$samples$lokal[r$selected_project_dfs$samples$ind == ind]
                analystyp <- r$selected_project_dfs$samples$analystyp[r$selected_project_dfs$samples$ind == ind]

                rows <- which(r$selected_project_dfs$samples$art == art &
                              r$selected_project_dfs$samples$lokal == lokal &
                              r$selected_project_dfs$samples$analystyp == analystyp)

                r$selected_project_dfs$samples[rows, "accnr"] <- ""
                r$selected_project_dfs$samples[rows, "provid"] <- ""

                update_accnrs_and_provids(
                  r$projects$database[r$projects$project_id == r$selected_project_id],
                  r$selected_project_dfs$samples$ind[rows],
                  r$selected_project_dfs$samples$accnr[rows],
                  r$selected_project_dfs$samples$provid[rows])

                if (input[[paste0(id, "_cell_edit")]]$value <= 0) {
                  r$selected_project_dfs$samples <-
                    r$selected_project_dfs$samples[r$selected_project_dfs$samples$ind != ind,]
                  delete_sample_row(
                    r$projects$database[r$projects$project_id == r$selected_project_id],
                    ind
                  )
                }

                updateDTs()
              },
              ## NOTE (Elias): This is used since if the user has already edited any table with id e.g. 'table1' the observeEvent would run when initialized, thus repeating the last action
              ## which could remove the first line for example
              ignoreInit = TRUE
              )
            }
          } else {
            DT::replaceData(isolate(proxies[[id]]), df, resetPaging = FALSE)
            DT::updateFilters(isolate(proxies[[id]]), df)
          }
        }
      })
    }

    updateList <- function() {
      removeUI("div.accnr_setter", multiple = TRUE)

      rows <- unique(r$order_spec_selected[, 1])

      lapply(rows, {
        function(row) {
          cols <- r$order_spec_selected[r$order_spec_selected[, 1] == row, 2]

          id <- paste0(row, "accnr_table")
          proxies[[id]] <- NULL
          if (!is.null(cell_edits[[id]])) {
            cell_edits[[id]]$destroy()
          }
          cell_edits[[id]] <- NULL
          rendered_table[[id]] <- NULL

          insertUI("div.set_accnr_categories", where = "afterEnd",
                   tags$div(class = "accnr_setter",
                            hr(),
                            fluidRow(
                              column(width = 2,
                                     h4(r$wide_merged[row, 1]),
                                     h4(r$wide_merged[row, 2]),
                                     ),
                              column(width = 10,
                                     HTML(
                                       paste0(
                                         "<button ",
                                         "onclick='",
                                         "let v = this.parentElement.querySelector(\"input.accnrinput\").value;\n",
                                         "this.parentElement.querySelectorAll(\"input.accnrinput\").forEach((i) => {i.value = v; i.onchange(); });",
                                         "'>",
                                         "Copy AccNR from first to rest",
                                         "</button>"
                                       )
                                     ),
                                     div(class="set_accnr_div_dt_holder",
                                         DT::DTOutput(outputId = ns(id))
                                         )
                                     )
                            )
                            )
                   )
        }
      })

      updateDTs()
    }

    observeEvent(input$expand, {
      if (input$expand) {
        r$wide_merged_used <- FALSE
      } else {
        ## NOTE (Elias): We only need to recalculate this once. We know the wide format doesn't need to change while viewer the set_accnr_and_provid view
        w <- long_to_wide_prover(r$selected_project_dfs$samples)
        r$wide_merged <- w$wide_merged # merge_wide(w$wide, w$non_uniform)
        r$status <- w$status
      }

      updateDTs()
    })

    observe({
      r$order_spec_selected
      ## Maybe make sure this only runs if the tables are visible
      isolate(updateList())
    })

  })
}
    
## To be copied in the UI
# mod_set_accnr_and_provid_ui("set_accnr_and_provid_1")
    
## To be copied in the server
# mod_set_accnr_and_provid_server("set_accnr_and_provid_1")
