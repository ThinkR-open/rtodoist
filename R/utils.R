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
#' @param url url to call
#' @return list
call_api <- function(...,url= "https://todoist.com/api/v9/sync",token = get_todoist_api_token()){
  
  message("call_api")
  
  # POST(
  #   url,
  #   ...)
  
  request(base_url = url) %>% 
    req_headers(
      Authorization = glue::glue("Bearer {token}"),
    ) %>% 
    # req_body_multipart(sync_token="*", 
    #                    resource_types='[\"projects\"]') %>%
    req_body_multipart(...) %>%
    
    # req_dry_run()
    req_perform() %>% 
    resp_body_json()
  
  
  
  
  
}

#' Call project data
#'
#' @param ... any params of POST request
#' @param url url to call
#'
#' @return list
call_api_project_data <- function(..., url="https://api.todoist.com/sync/v9/projects/get_data"){
  
  call_api(..., url = url)
}
