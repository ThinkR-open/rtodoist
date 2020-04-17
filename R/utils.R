#' Random key
#'
#' @return key
#'
#' @importFrom digest digest
#' @importFrom glue glue
#'

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
#'
#' @return list
call_api <- function(...){
  POST(
    "https://todoist.com/api/v8/sync",
    ...)
}
