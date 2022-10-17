#' long_to_wide_prover
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
long_to_wide_prover <- function(prover_lf) {
  # wf <- data.frame(art = c(), lokal = c())
  # 
  # for (row in rownames(prover_lf)) {
  #   exists <- FALSE
  #   for (wrow in rownames(wf)) {
  #     if (prover_lf[row, "art"] == wf[wrow, "art"] && prover_lf[row, "lokal"] == wf[wrow, "lokal"]) {
  #       exists <- TRUE
  #       break
  #     }
  #   }
  # 
  #   if (!exists) {
  #     wf <- rbind(wf, data.frame(art = c(prover_lf[row, "art"]), lokal = c(prover_lf[row, "lokal"])))
  #   }
  # }
  # 
  # 
  # wf_non_uniform <- data.frame(wf)
  # 
  # for (row in rownames(prover_lf)) {
  #   for (wrow in rownames(wf)) {
  #     if (prover_lf[row, "art"] == wf[wrow, "art"] && prover_lf[row, "lokal"] == wf[wrow, "lokal"]) {
  #       col <- prover_lf[row, "analystyp"]
  #       col_hom <- paste0(col, "_hom")
  #       if (!(prover_lf[row, "analystyp"] %in% colnames(wf))) {
  #         wf[, col] <- rep(0, nrow(wf))
  #         wf[, col_hom] <- rep(0, nrow(wf))
  #         wf_non_uniform[, col_hom] <- rep(FALSE, nrow(wf_non_uniform))
  #       }
  #       wf[wrow, col] <- wf[wrow, col] + 1
  #       if (wf[wrow, col_hom] != 0 && wf[wrow, col_hom] != prover_lf[row, "individer_per_prov"]) {
  #         wf_non_uniform[wrow, col_hom] <- TRUE
  #       }
  #       wf[wrow, col_hom] <- max(wf[wrow, col_hom], prover_lf[row, "individer_per_prov"])
  #       break
  #     }
  #   }
  # }
  # 
  # wf <- wf[,c(1:2, order(colnames(wf[,-1:-2])) + 2)]
  # wf_non_uniform <- wf_non_uniform[,c(1:2, order(colnames(wf_non_uniform[,-1:-2])) + 2)]
  
  summary_table <- prover_lf |> 
    dplyr::group_by(analystyp, art, lokal, individer_per_prov) |> 
    dplyr::summarise(antal_prover = dplyr::n(), 
                     status = dplyr::case_when(
                       all(is.na(accnr), is.na(provid)) ~ "not_started",
                       all(!(is.na(accnr)|(accnr == "")), !(is.na(provid)|(provid == ""))) ~ "finished",
                       any(!is.na(accnr), !is.na(provid))  ~ "started"),
                     txt = paste0(dplyr::n(), " * [", unique(individer_per_prov), "]"), 
                     .groups = "drop")
  
  wf <- summary_table |>  
    # dplyr::mutate(hom_size = individer_per_prov) |> # hom_size will be used as id-col
    dplyr::select(-status, -txt) |> 
    tidyr::pivot_wider(
      names_from = analystyp,    
      names_glue = "{analystyp}_{.value}",
      values_from = c(antal_prover, individer_per_prov),
      values_fill = 0
    ) |> 
    dplyr::rename_with(
      function(x) stringr::str_replace_all(x, c("_antal_prover" = "", "individer_per_prov" = "hom"))
    )|> 
    dplyr::select(art, lokal, sort(tidyselect::peek_vars())) |> 
    dplyr::arrange(art, lokal) |>
    as.data.frame()
  
  status_wf <- summary_table |> 
    dplyr::select(analystyp, art, lokal, status) |> 
    tidyr::pivot_wider(names_from = analystyp, values_from = status, values_fill = "") |> 
    dplyr::arrange(art, lokal) |>
    as.data.frame()
  
  
  merged_wf <- summary_table |> 
    dplyr::select(analystyp, art, lokal, txt) |> 
    tidyr::pivot_wider(names_from = analystyp, values_from = txt, values_fill = "") |> 
    dplyr::arrange(art, lokal) |>
    as.data.frame()
  
  wf_non_uniform <-  NULL
  
  list(wide = wf, non_uniform = wf_non_uniform, status = status_wf, wide_merged = merged_wf)
}

#' wide_to_long_prover
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
wide_to_long_prover <- function(prover_wf) {
  lf <- data.frame(analystyp = c(), art = c(), lokal = c(), individer_per_prov = c())
  
  colns <- colnames(prover_wf)[3:ncol(prover_wf)]
  col_hom <- colns[endsWith(colns, "_hom")]
  col_nor <- colns[!endsWith(colns, "_hom")]
  
  for (row in rownames(prover_wf)) {
    for (col in col_nor) {
      if (is.na(prover_wf[row, col])) {
        next
      }
      
      lf <- rbind(lf,
                  data.frame(
                    analystyp = col,
                    art = prover_wf[row, "art"],
                    lokal = prover_wf[row, "lokal"],
                    individer_per_prov = prover_wf[row, paste0(col, "_hom")]
                  )[rep(1, prover_wf[row, col]), ])
    }
  }
  
  lf
}

#' merge_wide
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
merge_wide <- function(wide, non_uniform = NULL) {
  colns <- colnames(wide)[3:ncol(wide)]
  col_nor <- colns[!endsWith(colns, "_hom")]
  
  wide_merged <- data.frame(art = wide[, "art"], lokal = wide[, "lokal"])
  for (nor in col_nor) {
    hom <- paste0(nor, "_hom")
    wide_merged[, nor] <- paste0(
      wide[, nor],
      " * [",
      if (!is.null(non_uniform)) sapply(non_uniform[, hom], function(x) { if (x) "~" else "" }) else "",
      wide[, hom],
      "]")
    wide_merged[wide[, nor] == 0, nor] <- ""
  }
  
  wide_merged
}
