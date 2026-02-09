# Null coalescing operator
`%||%` <- function(a, b) if (is.null(a)) b else a

#' Escape special characters for JSON
#'
#' @param x character string to escape
#' @return escaped string
escape_json <- function(x) {
  x <- gsub("\\\\", "\\\\\\\\", x)  # Backslash first

  x <- gsub('"', '\\\\"', x)         # Double quotes
  x <- gsub('\n', '\\\\n', x)        # Newlines
  x <- gsub('\r', '\\\\r', x)        # Carriage returns
  x <- gsub('\t', '\\\\t', x)        # Tabs
  x
}

#' Random key
#'
#' @return key
#'
#' @importFrom digest digest
#' @importFrom glue glue
#' @return random key generate with digest
random_key <- function() {
  # create a random key
  mdp <- paste0(sample(letters,
    size = 10,
    replace = TRUE
  ),
  collapse = ""
  )

  digest(glue("{Sys.time()}{mdp}"))
}

# API Base URLs
TODOIST_SYNC_URL <- "https://api.todoist.com/api/v1/sync"
TODOIST_REST_URL <- "https://api.todoist.com/api/v1/"

#' Call the Sync API
#'
#' @param ... any params of POST request
#' @param token todoist API token
#' @param url url to call
#'
#' @return list
#' @importFrom httr2 request req_headers req_body_multipart req_perform resp_body_json req_error resp_status
call_api <- function(..., url = TODOIST_SYNC_URL, token = get_todoist_api_token()) {

  request(url) %>%
    req_headers(
      Authorization = glue::glue("Bearer {token}")
    ) %>%
    req_body_multipart(...) %>%
    req_error(is_error = function(resp) resp_status(resp) >= 400) %>%
    req_perform() %>%
    resp_body_json()

}

#' Call the REST API
#'
#' @param endpoint API endpoint (e.g., "projects", "tasks")
#' @param token todoist API token
#' @param ... query parameters
#'
#' @return list
#' @importFrom httr2 req_headers req_url_query req_perform resp_body_json request req_error resp_status
call_api_rest <- function(endpoint, token = get_todoist_api_token(), ...) {

  request(paste0(TODOIST_REST_URL, endpoint)) %>%
    req_headers(
      Authorization = glue::glue("Bearer {token}")
    ) %>%
    req_url_query(...) %>%
    req_error(is_error = function(resp) resp_status(resp) >= 400) %>%
    req_perform() %>%
    resp_body_json()
}