#' Get all objects inside a list
#'
#' @param token token
#'
#' @return list of all objects
#' @export
#'
#' @importFrom httr POST content
#'

get_all <- function(token = get_todoist_api_token()) {
  POST(
    "https://todoist.com/api/v8/sync",
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
#' @return list of all objects
#' @export
#'
#' @importFrom httr POST content
#'
get_projects <- function(token = get_todoist_api_token()) {
  POST(
    "https://todoist.com/api/v8/sync",
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
#'
#' @importFrom httr POST content
#'
get_tasks <- function(token = get_todoist_api_token()) {
  POST(
    "https://todoist.com/api/v8/sync",
    body = list(
      token = token,
      sync_token = "*",
      resource_types = '["items"]'
    )
  ) %>%
    content()
}
