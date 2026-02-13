#' Get list of backups
#'
#' @param token todoist API token
#'
#' @return tibble of available backups
#' @export
#' @importFrom purrr map_dfr
#'
#' @examples
#' \dontrun{
#' get_backups()
#' }
get_backups <- function(token = get_todoist_api_token()) {
  force(token)

  response <- call_api_rest("backups", token = token)

  backups <- response$results
  if (is.null(backups)) {
    backups <- response
  }

  if (is.null(backups) || length(backups) == 0) {
    return(data.frame(
      version = character(),
      url = character(),
      stringsAsFactors = FALSE
    ))
  }

  map_dfr(backups, function(x) {
    data.frame(
      version = x$version %||% NA_character_,
      url = x$url %||% NA_character_,
      stringsAsFactors = FALSE
    )
  })
}

#' Download a backup
#'
#' @param version version of the backup to download (from get_backups())
#' @param output_file path where to save the backup file
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return path to the saved file (invisible)
#' @export
#' @importFrom httr2 request req_headers req_perform resp_body_raw req_error resp_status
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' backups <- get_backups()
#' download_backup(backups$version[1], "backup.zip")
#' }
download_backup <- function(version,
                            output_file,
                            verbose = TRUE,
                            token = get_todoist_api_token()) {
  force(token)

  # Get the backup URL
  backups <- get_backups(token = token)
  backup <- backups[backups$version == version, ]

  if (nrow(backup) == 0) {
    stop("Backup version not found: ", version)
  }

  backup_url <- backup$url[1]

  if (verbose) {
    message(glue::glue("Downloading backup version {version}"))
  }

  response <- request(backup_url) %>%
    req_headers(
      Authorization = glue::glue("Bearer {token}")
    ) %>%
    req_error(is_error = function(resp) resp_status(resp) >= 400) %>%
    req_perform()

  content <- resp_body_raw(response)
  writeBin(content, output_file)

  if (verbose) {
    message(glue::glue("Backup saved to {output_file}"))
  }

  invisible(output_file)
}
