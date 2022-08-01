credentials_sqlite_path <- "./data/credentials.db"
credentials_table <- "credentials"

projects_sqlite_path <- "./data/projects.db"
projects_table <- "projects"

projects_folder_sqlite_path <- "./data/projects/"
projects_table_analyzes <- "analyser"
projects_table_samples <- "prover"
projects_table_matrices <- "matriser"
projects_table_parameters <- "parametrar"

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
  db <- dbConnect(SQLite(), credentials_sqlite_path)
  dbWriteTable(db, credentials_table, credentials, overwrite = TRUE)
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
  db <- dbConnect(SQLite(), credentials_sqlite_path)
  query <- sprintf("SELECT * FROM %s", credentials_table)
  data <- tryCatch({
    dbGetQuery(db, query)
  }, error = function(cond) {
    NULL
  })
  dbDisconnect(db)
  data
}

#' ensure_projects_table_exists
#'
#' @description Make sure the table 'projects' exists
#'
#' @return Nothing
#'
#' @noRd
#'
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbConnect dbExecute dbDisconnect
ensure_projects_table_exists <- function() {
  db <- dbConnect(SQLite(), projects_sqlite_path)
  query <- sprintf("SELECT name FROM sqlite_master WHERE type='table' AND name='%s';", projects_table)
  table <- dbGetQuery(db, query)

  if (nrow(table) == 0) {
    message("Creating projects table")
    query <- sprintf(
"CREATE TABLE `%s` (
  `project_id` TEXT NOT NULL,
  `project_name` TEXT,
  `project_manager` TEXT,
  `database` TEXT,
  `created_by` TEXT NOT NULL,
  `created_date` TEXT NOT NULL,
  PRIMARY KEY(project_id)
);", projects_table)
    table <- dbExecute(db, query)
  }
  dbDisconnect(db)
}

#' load_projects
#'
#' @description Load the projects from SQLite db
#'
#' @return The projects df with project_name, project_manager, database, created_by, and created_date
#'
#' @noRd
#'
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbConnect dbGetQuery dbDisconnect
load_projects <- function() {
  ensure_projects_table_exists()
  db <- dbConnect(SQLite(), projects_sqlite_path)
  query <- sprintf("SELECT * FROM %s;", projects_table)
  data <- dbGetQuery(db, query)
  dbDisconnect(db)
  data
}

#' insert_project
#'
#' @description Create a new project entry in the projects database
#'
#' @return Nothing
#'
#' @noRd
#'
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbConnect dbExecute dbDisconnect
insert_project <- function(project_id, database, by, date) {
  ensure_projects_table_exists()
  db <- dbConnect(SQLite(), projects_sqlite_path)
  query <- sprintf(
    "INSERT INTO %s (%s) VALUES ('%s');",
    projects_table,
    paste(c("project_id", "database", "created_by", "created_date"), collapse = ", "),
    paste(c(project_id, database, by, date), collapse = "', '")
  )
  dbExecute(db, query)
  dbDisconnect(db)
}

#' update_project
#'
#' @description Update a project entry
#'
#' @return Nothing
#'
#' @noRd
#'
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbConnect dbExecute dbDisconnect
update_project <- function(project_id, col, data) {
  if (!(col %in% c("project_name", "project_manager"))) {
    warning(paste0("Can only edit project_name and project_manager in projects table. Attempt to edit: '", col, "'"))
    return()
  }

  ensure_projects_table_exists()
  db <- dbConnect(SQLite(), projects_sqlite_path)
  query <- paste0("UPDATE projects SET ", col, " = '", data, "' WHERE project_id = '", project_id, "';")
  dbExecute(db, query)
  dbDisconnect(db)
}

#' ensure_project_tables_exists
#'
#' @description Make sure the tables 'analyser', 'prover', 'matriser' and 'parametrar' exists in a project database.
#'
#' @return Nothing
#'
#' @noRd
#'
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbConnect dbExecute dbDisconnect
ensure_project_tables_exists <- function(project_database) {
  db <- dbConnect(SQLite(), paste0(projects_folder_sqlite_path, project_database))
  query <- "SELECT name FROM sqlite_master WHERE type='table' AND name='analyser';"
  table <- dbGetQuery(db, query)

  if (nrow(table) == 0) {
    message(paste0("Creating 'analyser' table in project: ", project_database))
    query <- sprintf(
"CREATE TABLE `%s` (
  `analys_typ` TEXT,
  `labb` TEXT,
  `utforarlabb` TEXT,
  `provtillstans` TEXT,
  `provberedning` TEXT,
  `forvaringskarl` TEXT,
  `analys_metod` TEXT,
  `analys_instrument` TEXT
);", projects_table_analyzes)
    table <- dbExecute(db, query)
  }

  query <- "SELECT name FROM sqlite_master WHERE type='table' AND name='prover';"
  table <- dbGetQuery(db, query)

  if (nrow(table) == 0) {
    message(paste0("Creating 'prover' table in project: ", project_database))
    query <- sprintf(
"CREATE TABLE `%s` (
  `analys_typ` TEXT,
  `art` TEXT,
  `lokal` TEXT,
  `individer_per_prov` TEXT
);", projects_table_samples)
    table <- dbExecute(db, query)
  }

  query <- "SELECT name FROM sqlite_master WHERE type='table' AND name='matriser';"
  table <- dbGetQuery(db, query)

  if (nrow(table) == 0) {
    message(paste0("Creating 'matriser' table in project: ", project_database))
    query <- sprintf(
"CREATE TABLE `%s` (
  `analys_typ` TEXT,
  `art` TEXT,
  `organ` TEXT
);", projects_table_matrices)
    table <- dbExecute(db, query)
  }

  query <- "SELECT name FROM sqlite_master WHERE type='table' AND name='parametrar';"
  table <- dbGetQuery(db, query)

  if (nrow(table) == 0) {
    message(paste0("Creating 'parametrar' table in project: ", project_database))
    query <- sprintf(
"CREATE TABLE `%s` (
  `analys_typ` TEXT,
  `parameternamn` TEXT,
  `matenhet` TEXT
);", projects_table_parameters)
    table <- dbExecute(db, query)
  }

  dbDisconnect(db)
}

#' load_project
#'
#' @description Load the 'anaylzes', 'samples', 'matrices', and 'parameters' tables
#'
#' @return A list containing 'analyzes', 'samples', 'matrices' and 'parameters' dataframe
#'
#' @noRd
#'
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbConnect dbGetQuery dbDisconnect dbWriteTable
load_project <- function(database_file) {
  ensure_project_tables_exists(database_file)
  db <- dbConnect(SQLite(), paste0(projects_folder_sqlite_path, database_file))

  query <- sprintf("SELECT * FROM %s;", projects_table_analyzes)
  analyzes <- dbGetQuery(db, query)
  query <- sprintf("SELECT * FROM %s;", projects_table_samples)
  samples <- dbGetQuery(db, query)
  query <- sprintf("SELECT * FROM %s;", projects_table_matrices)
  matrices <- dbGetQuery(db, query)
  query <- sprintf("SELECT * FROM %s;", projects_table_parameters)
  parameters <- dbGetQuery(db, query)
  dbDisconnect(db)

  list(analyzes = analyzes, samples = samples, matrices = matrices, parameters = parameters)
}

## TODO: Function to validate a project table contains the correct column, and then insert/override that table, or if not, return the missing columns
