#' Get id of project
#'
#' @param object result of get_project
#' @param project_name name of the project
#'
#' @return id
#' @export
#'
#' @importFrom purrr pluck map_dfr is_empty
#' @importFrom dplyr filter pull
#'
get_id_project <- function(object, project_name) {
  if (is.null(object) | !is.list(object)) {
    stop("You must pass the result of the get_all or get_projects function")
  } else {
    id <- object %>%
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
#' @param token token
#' @param project_name name of the new project
#' @param verbose make it talk
#'
#' @return id of the new project
#' @export
#'
#' @importFrom httr POST content
#' @importFrom glue glue
#' @importFrom purrr map
#'

add_project <- function(project_name,
                        verbose = TRUE,
                        token = get_todoist_api_token()) {
  if (verbose) {
    message(glue::glue("create the {project_name} project"))
  }
  name <- get_projects(token = token) %>%
    flatten() %>%
    map("name")
  if (project_name %in% name) {
    message("This project already exists")
    return(get_id_project(object = get_projects(), project_name = project_name))
  } else {
    POST(
      "https://todoist.com/api/v8/sync",
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
      get_id_project(project_name)
  }
}
