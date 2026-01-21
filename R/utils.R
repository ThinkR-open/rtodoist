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

#' Call project data
#'
#' @param ... any params of POST request
#' @param url url to call
#'
#' @return list
call_api_project_data <- function(..., url="https://api.todoist.com/api/v1/projects/get_data"){
  
  call_api(..., url = url)
}
