#' accnr_helpers 
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
#'
#' @importFrom stringr str_detect
get_end_accnr <- function(start_accnr, nr_tests, nr_per_test) {
  ## AccNR on the form 'A2022/00245'
  parts <- strsplit(start_accnr, "/")[[1]]
  nr_str <- left_pad(parts[2], max(5, nchar(parts[2])))
  nr <- as.numeric(nr_str)

  new_nr <- nr + nr_tests * nr_per_test - 1

  if (nchar(paste(new_nr)) > nchar(nr_str)) {
    warning(paste0("AccNR Overflow. Trying to create an accnr of value: ", new_nr, "."))
    return(paste0(parts[1], "/00000"))
  }

  return(paste0(parts[1], "/", left_pad(new_nr, nchar(nr_str))))
}

valid_accnr <- function(accnr) {
  str_detect(accnr, "^[A-Za-z]([\\d]{2}|[\\d]{4})/[\\d]*$")
}

left_pad <- function(nr, count, pad = "0") {
  paste0(paste0(rep(pad, max(count - nchar(nr), 0)), collapse = ""), nr)
}
