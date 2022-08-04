#' accnr_helpers 
#'
#' @description A utils function
#'
#' @return A list containing the return value in $accnr and any warning messages that got generated in $warning
#'
#' @noRd
#'
#' @importFrom stringr str_detect
accnr_add <- function(start_accnr, amount) {
  ## AccNR on the form 'A2022/00245'
  parts <- strsplit(start_accnr, "/")[[1]]
  nr_str <- left_pad(parts[2], 5)
  nr <- as.numeric(nr_str)

  new_nr <- nr + amount

  warn <- ""

  if (nchar(paste(new_nr)) > 5) {
    warn <- paste0("AccNR Overflow. Trying to create an accnr of value: ", new_nr, ".")
    return(list(accnr = paste0(parts[1], "/00000"), warning = warn))
  }

  return(list(accnr = paste0(parts[1], "/", left_pad(new_nr, 5))))
}

accnr_min <- function(accnrs, offsets = 0) {
  ## AccNR on the form 'A2022/00245'
  ## This function assumes that all accnrs has the same year
  if (length(accnrs) == 0 || any(is.na(accnrs) | accnrs == "")) {
    return("")
  }
  partss <- strsplit(accnrs, "/")
  m_value <- min(unlist(lapply(partss, {
    function(parts) {
      nr_str <- left_pad(parts[2], 5)
      nr <- as.numeric(nr_str)
      nr
    }
  })) + offsets)

  paste0(partss[[1]][1], "/", left_pad(m_value, 5))
}

accnr_max <- function(accnrs, offsets = 0) {
  ## AccNR on the form 'A2022/00245'
  ## This function assumes that all accnrs has the same year
  if (length(accnrs) == 0 || any(is.na(accnrs) | accnrs == "")) {
    return("")
  }
  partss <- strsplit(accnrs, "/")
  m_value <- max(unlist(lapply(partss, {
    function(parts) {
      nr_str <- left_pad(parts[2], 5)
      nr <- as.numeric(nr_str)
      nr
    }
  })) + offsets)

  paste0(partss[[1]][1], "/", left_pad(m_value, 5))
}

valid_accnr <- function(accnr) {
  str_detect(accnr, "^[A-Za-z]([\\d]{2}|[\\d]{4})/[\\d]{5}$")
}

accnr_hom <- function(accnr, hom_size) {
  ## AccNR on the form 'A2022/00245'
  if (hom_size == 1) {
    return(accnr)
  }

  parts <- strsplit(accnr, "/")[[1]]
  nr_str <- left_pad(parts[2], 5)
  start_nr <- as.numeric(nr_str)

  end_nr <- start_nr + hom_size - 1

  if (nchar(paste(end_nr)) > nchar(nr_str)) {
    warning(paste0("AccNR Overflow. Trying to create an accnr of value: ", end_nr, "."))
    return(paste0(parts[1], "/00000"))
  }

  return(paste0(parts[1], "/", nr_str, "-", left_pad(end_nr, 5)))
}

left_pad <- function(nr, count, pad = "0") {
  paste0(paste0(rep(pad, max(count - nchar(nr), 0)), collapse = ""), nr)
}
