#' long_to_wide_prover
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
long_to_wide_prover <- function(prover_lf) {
  wf <- data.frame(art = c(), lokal = c())

  for (row in rownames(prover_lf)) {
    exists <- FALSE
    for (wrow in rownames(wf)) {
      if (prover_lf[row, "art"] == wf[wrow, "art"] && prover_lf[row, "lokal"] == wf[wrow, "lokal"]) {
        exists <- TRUE
        break
      }
    }

    if (!exists) {
      wf <- rbind(wf, data.frame(art = c(prover_lf[row, "art"]), lokal = c(prover_lf[row, "lokal"])))
    }
  }

  for (row in rownames(prover_lf)) {
    for (wrow in rownames(wf)) {
      if (prover_lf[row, "art"] == wf[wrow, "art"] && prover_lf[row, "lokal"] == wf[wrow, "lokal"]) {
        col <- prover_lf[row, "analystyp"]
        col_hom <- paste0(col, "_hom")
        if (!(prover_lf[row, "analystyp"] %in% colnames(wf))) {
          wf[, col] <- rep(0, nrow(wf))
          wf[, col_hom] <- rep(0, nrow(wf))
        }
        wf[wrow, col] <- wf[wrow, col] + 1
        wf[wrow, col_hom] <- max(wf[wrow, col_hom], prover_lf[row, "individer_per_prov"])
        break
      }
    }
  }

  wf
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
