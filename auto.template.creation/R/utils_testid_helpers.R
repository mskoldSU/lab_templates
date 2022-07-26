#' testid_helpers 
#'
#' @description A utils function
#'
#' @return A list containing the return value in $testid and any warning messages that got generated in $warning
#'
#' @noRd
#'
#' @importFrom stringr str_detect
testid_add <- function(start_testid, amount) {
  ## TestID on the form 'Q2022/00245'
  parts <- strsplit(start_testid, "/")[[1]]
  nr_str <- left_pad(parts[2], 5)
  nr <- as.numeric(nr_str)

  new_nr <- nr + amount

  warn <- ""

  if (nchar(paste(new_nr)) > 5) {
    warn <- paste0("TestID Overflow. Trying to create an accnr of value: ", new_nr, ".")
    return(list(testid = paste0(parts[1], "/00000"), warning = warn))
  }

  return(list(testid = paste0(parts[1], "/", left_pad(new_nr, 5))))
}

valid_testid <- function(testid) {
  str_detect(testid, "^[A-Za-z]([\\d]{2}|[\\d]{4})/[\\d]{5}$")
}

testid_hom <- function(testid, hom_size) {
  ## SampleIDs on the form 'Q2022/00245'
  if (hom_size == 1) {
    return(testid)
  }

  parts <- strsplit(testid, "/")[[1]]
  nr_str <- left_pad(parts[2], 5)
  start_nr <- as.numeric(nr_str)

  end_nr <- start_nr + hom_size - 1

  if (nchar(paste(end_nr)) > nchar(nr_str)) {
    warning(paste0("TestID Overflow. Trying to create an accnr of value: ", end_nr, "."))
    return(paste0(parts[1], "/00000"))
  }

  return(paste0(parts[1], "/", nr_str, "-", left_pad(end_nr, 5)))
}

left_pad <- function(nr, count, pad = "0") {
  paste0(paste0(rep(pad, max(count - nchar(nr), 0)), collapse = ""), nr)
}
