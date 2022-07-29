sqlitePath <- "./data/credentials.db"
table <- "credentials"

#' save_credentials
#'
#' @description Save the credential to a SQLite db
#'
#' @return Nothing
#'
#' @noRd
#'
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbConnect dbGetQuery dbDisconnect dbWriteTable
save_credentials <- function() {
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  dbWriteTable(db, table, credentials, overwrite = TRUE)
  dbDisconnect(db)
}

#' load_credentials
#'
#' @description Load the credential from SQLite db
#'
#' @return The credentials df with username, password and permission
#'
#' @noRd
#'
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbConnect dbGetQuery dbDisconnect
load_credentials <- function() {
  # Connect to the database
  db <- dbConnect(SQLite(), sqlitePath)
  # Construct the fetching query
  query <- sprintf("SELECT * FROM %s", table)
  # Submit the fetch query and disconnect
  data <- tryCatch({
    dbGetQuery(db, query)
  }, error = function(cond) {
    NULL
  })
  dbDisconnect(db)
  data
}
