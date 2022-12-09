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
call_api <- function(...,url= "https://todoist.com/api/v8/sync"){
  
  message("call_api")
  
  POST(
    url,
    ...)
}

#' Call project data
#'
#' @param ... any params of POST request
#' @param url url to call
#'
#' @return list
call_api_project_data <- function(..., url="https://api.todoist.com/sync/v8/projects/get_data"){
  
  call_api(..., url = url)
}
