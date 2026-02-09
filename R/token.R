#' Get token stored by keyring
#' 
#' Return the todoist API token. If this is the first time, you will need to setup your token.
#' 
#' @param ask booleen do we have to ask if missing
#' @importFrom magrittr %>%
#'
#' @export
#' @return token (character vector)
#' @examples 
#' \dontrun{
#' get_todoist_api_token()
#' }
get_todoist_api_token <- function(ask = TRUE) {
  token <- NULL
  
  suppressWarnings(try(token <- key_get(service = "todoist_api_token"), silent = TRUE))
  
  if (is.null(token) & ask) {
    delete_todoist_api_token()
    token <- ask_todoist_api_token()
    token %>% 
      key_set_with_value(service = "todoist_api_token",
                         password = .)
  }
  token
}


#' Set todoist API token
#' 
#' This function use keyring to store your token from your todoist profile. To find your token from todoist website, use \code{\link{open_todoist_website_profile}}
#' @param token todoist API token
#' @importFrom magrittr %>%
#' 
#' @return token
#' @export
set_todoist_api_token <- function(token) {
  if (missing(token)) {
    token <- ask_todoist_api_token()
  }
  if (is.null(token)) {
    return(invisible(NULL))
  }
  
  delete_todoist_api_token()
  if (is.character(token)) {
    token %>% 
      key_set_with_value(service = "todoist_api_token",
                         password = .)
  }else{
    stop("Token must be a character vector.")
  }
  token
}

#' Update Todoist Api Token
#' 
#' @description  Remove the old token and register a new one.
#' 
#' @importFrom magrittr %>%
#' 
#' @return nothing, storing your token
#' @export
update_todoist_api_token <- function() {
  delete_todoist_api_token()
  ask_todoist_api_token() %>%
    key_set_with_value(service = "todoist_api_token", password = .)
}

#' Delete todoist api token
#' 
#' @return nothing, delete the api token
#' @export
delete_todoist_api_token <- function() {
  try(key_delete("todoist_api_token"), silent = TRUE)
}


#' Pop-up to save the token
#' 
#' @param msg message to print in the pop-up
#' @importFrom getPass getPass
#' 
#' @return password (character vector)
#' @export
ask_todoist_api_token <- function(msg = "Register Todoist Api Token") {
  passwd <- tryCatch({
    getPass(msg)
  }, interrupt = function(e) NULL)
  if (!length(passwd) || !nchar(passwd)) {
    return(NULL)
  }
  else {
    return(as.character(passwd))
  }
}
