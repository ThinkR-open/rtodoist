#' Get id of project
#'
#' This function gives you the id of a project by name, which is useful for adding tasks or people to the project.
#'
#' @param all_projects result of \link[rtodoist]{get_all_projects}
#' @param project_name name of the project
#' @param token todoist API token
#' @importFrom dplyr filter pull
#' @importFrom purrr pluck map_dfr is_empty
#' @return id of project (character vector)
#' @export
#'
#' @examples 
#' \dontrun{
#' get_all_projects() %>%
#'     get_project_id("test")
#' }
get_project_id <- function(all_projects = get_all_projects(token = token), project_name,
                           token = get_todoist_api_token()) {
  if (is.null(all_projects) | !is.list(all_projects)) {
    stop("You must pass the result of the get_all_data or get_all_projects() function")
  } else {
    id <- all_projects %>%
      pluck("projects") %>%
      map_dfr(`[`, c("id", "name")) %>%
      filter(name == project_name) %>%
      pull(id)
    if (is_empty(id)) {
      stop("Are you sure about the name of the project :) ?")
    } else {
      id
    }
  }
}

#' Add a new project
#'
#' @param token todoist API token
#' @param project_name name of the new project
#' @param verbose boolean that make the function verbose
#'
#' @return id of the new project
#' @export
#' @importFrom purrr flatten map
#' @importFrom httr content
#' @importFrom glue glue
#' @examples
#' \dontrun{
#' add_project("my_proj")
#' }
add_project <- function(project_name,
                        verbose = TRUE,
                        token = get_todoist_api_token()) {
  if (verbose) {
    message(glue::glue("create the {project_name} project"))
  }
  
  all_projects <- get_all_projects(token = token)
  
  name <- all_projects %>%
    flatten() %>%
    map("name")
  if (project_name %in% name) {
    message("This project already exists")
    return(get_project_id(all_projects = all_projects, project_name = project_name))
  } else {
    call_api(
      body = list(
        "token" = token,
        "sync_token" = "*",
        resource_types = '["projects"]',
        commands = glue(
          '[{ "type": "project_add",
          "temp_id": "<random_key()>",
          "uuid": "<random_key()>",
          "args": { "name": "<project_name>" } }]',
          .open = "<",
          .close = ">"
        )
      )
    ) %>%
      content() %>%
      get_project_id(project_name = project_name)
  }
}
