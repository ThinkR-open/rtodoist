#' Get all objects inside a list
#' 
#' @param token token
#' 
#' @return list of all objects
#' 
#' @export
#' 
#' @examples 
#' get_all()
get_all <- function(token = get_todoist_api_token()) {
  call_api(
    body = list(
      token = token,
      sync_token = "*",
      resource_types = '["all"]'
    )
  ) %>%
    content()
}

#' List of projects
#' 
#' @param token token
#' 
#' @return list of all projects
#' 
#' @export
#' 
#' @examples
#'get_projects()
get_projects <- function(token = get_todoist_api_token()) {
  call_api(
    body = list(
      token = token,
      sync_token = "*",
      resource_types = '["projects"]'
    )
  ) %>%
    content()
}
#' List of tasks
#'
#' @param token token
#'
#' @return list of all tasks
#' @export
#' @examples 
#' get_tasks()
get_tasks <- function(token = get_todoist_api_token()) {
  call_api(
    body = list(
      token = token,
      sync_token = "*",
      resource_types = '["items"]'
    )
  ) %>%
    content()
}
