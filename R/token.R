#' @title get_todoist_api_token
#' @description  return the todoiste api token
#' @param ask booleen do we have to ask if missing
#' @importFrom magrittr %>%
#' @importFrom  keyring key_set_with_value
#' @import keyring
#'
#' @export
get_todoist_api_token <- function(ask = TRUE) {
  token <- NULL

  suppressWarnings(try(token <- key_get(service = "todoist_api_token"), silent = TRUE))


  if (is.null(token) & ask) {
    delete_todoist_api_token()
    token <- ask_todoist_api_token()
    token %>% key_set_with_value(service = "todoist_api_token", password = .)
  }
  token
}


#' @title set_todoist_api_token
#' @description  set the todoiste api token
#' @param token todoist api token
#' @importFrom magrittr %>%
#' @import assertthat
#' @export
set_todoist_api_token <- function(token) {
  if (missing(token)) {
    token <- ask_todoist_api_token()
  }
  if (is.null(token)) {
    return(invisible(NULL))
  }

  delete_todoist_api_token()
  assert_that(is.character(token))
  token %>% key_set_with_value(service = "todoist_api_token", password = .)

  token
}

#' @title update_todoist_api_token
#' @description  update the todoiste api token
#' @importFrom magrittr %>%
#' @export
update_todoist_api_token <- function() {
  delete_todoist_api_token()
  ask_todoist_api_token() %>% key_set_with_value(service = "todoist_api_token", password = .)
}

#' @title delete_todoist_api_token
#' @description  delete the todoiste api token
#' @export
delete_todoist_api_token <- function() {
  try(key_delete("todoist_api_token"), silent = TRUE)
}


#' @title ask_todoist_api_token
#' @param msg the message
#' @description  ask for the todoiste api token
#' @import getPass
#' @export
ask_todoist_api_token <- function(msg = "todoist api token") {
  passwd <- tryCatch({
    newpass <- getPass::getPass(msg)
  }, interrupt = NULL)
  if (!length(passwd) || !nchar(passwd)) {
    return(NULL)
  }
  else {
    return(as.character(passwd))
  }
}
