#' Get all objects inside a list
#'
#' Collect all the objects in a list.
#' This allows you to explore your to-do list.
#'
#' @param token todoist API token
#'
#' @return list of all objects
#' @export
#'
#' @examples
#' \dontrun{
#' # Set API key first
#' set_todoist_api_token()
#' # Get all objects
#' objects <- get_all_data()
#' }
get_all_data <- function(token = get_todoist_api_token()) {
  call_api(
      token = token,
    # body = list(
      sync_token = "*",
      resource_types = '["all"]'
    # )
  )
}

#' List of projects
#'
#' @param token todoist API token
#'
#' @return list of all projects
#' @export
#'
#' @examples
#' \dontrun{
#' # Set API key first
#' set_todoist_api_token()
#' # Get all projects
#' projects <- get_all_projects()
#' }
get_all_projects <- function(token = get_todoist_api_token()) {
  call_api(token = token,
      sync_token = "*",
      resource_types = '["projects"]'
    
  ) 
}
#' List of tasks
#'
#' @param token todoist API token
#'
#' @return list of all tasks
#' @export
#'
#' @examples
#' \dontrun{
#' # Set API key first
#' set_todoist_api_token()
#' # Get all tasks
#' tasks <- get_tasks()
#' }
get_tasks <- function(token = get_todoist_api_token()) {

  call_api(token = token,
           sync_token = "*",
           resource_types = '["items"]'
           
  ) 
  
}

#' List of tasks of project
#'
#' @param token todoist API token
#' @param project_name name of the project
#' @param project_id id of the project
#'
#' @return list of all tasks
#' @export
#'
get_tasks_of_project <- function(
    project_id = get_project_id(project_name = project_name, token = token),
    project_name,
    token = get_todoist_api_token()) {
  
  force(project_id)
  force(token)
  
  call_api_rest("tasks", token = token, project_id = project_id) %>%
    pluck("results") %>%  # <-- extraire results ici
    map(`[`, c("content", "project_id", "section_id", "id", "responsible_uid"))
}