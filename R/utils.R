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

#' Call the good version of API
#'
#' @param ... any params of POST request
#' @param token todoist API token
#' @param url url to call
#'
#' @return list
#' @importFrom httr2 request req_headers req_body_multipart req_perform resp_body_json
call_api <- function(...,url= "https://api.todoist.com/api/v1/sync",token = get_todoist_api_token()){
  
  message("call_api")

  
  request(base_url = url) %>% 
    req_headers(
      Authorization = glue::glue("Bearer {token}"),
    ) %>% 

    req_body_multipart(...) %>%
    req_perform() %>% 
    resp_body_json()
  
}

#' @importFrom httr2 req_headers req_url_query req_perform resp_body_json request
call_api_rest <- function(endpoint, token = get_todoist_api_token(), ...) {
  
  request(paste0("https://api.todoist.com/api/v1/", endpoint)) %>%
    req_headers(
      Authorization = glue::glue("Bearer {token}")
    ) %>%
    req_url_query(...) %>%
    req_perform() %>%
    resp_body_json()
}