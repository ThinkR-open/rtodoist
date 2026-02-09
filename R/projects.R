#' Get id of project
#'
#' This function gives you the id of a project by name, which is useful for adding tasks or people to the project.
#'
#' @param all_projects result of \link[rtodoist]{get_all_projects}
#' @param project_name name of the project
#' @param token todoist API token
#' @param create boolean create project if needed
#' @param verbose boolean that make the function verbose
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
get_project_id <- function(
                           project_name,
                           all_projects = get_all_projects(token = token),
                           token = get_todoist_api_token(),create=TRUE,verbose = FALSE) {
  if (is.null(all_projects) | !is.list(all_projects)) {
    stop("You must pass the result of the get_all_data or get_all_projects() function")
  } else {
    id <- all_projects %>%
      pluck("projects") %>%
      map_dfr(`[`, c("id", "name")) %>%
      filter(name == project_name) %>%
      pull(id)
    
    if (length(id)>1){
      message("multiple project with same name ?! only the first will be used")
      id <- id[[1]]
    }
    
    if (length(id)==0){
      message("project doesnt exist")
      if (create){
      message("we create it")
        id <- add_project(project_name = project_name,token = token,verbose = verbose)
        
      }
      # id <- get_project_id(project_name = project_name,token = token,all_projects = get_all_projects(token = token),create=FALSE)
    }
    
    
    
    
    if (is_empty(id)) {
      stop("Are you sure about the name of the project :) ?")
    } else {
      return(id)
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
    return(get_project_id(all_projects = all_projects, project_name = project_name,token = token))
  } else {
    call_api(
        "token" = token,
      # body = list(
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
      # )
    ) %>%
      # content() %>%
      get_project_id(all_projects = .,project_name = project_name,token = token)
  }
}

#' Update a project
#'
#' @param project_id id of the project
#' @param project_name name of the project (for lookup if project_id not provided)
#' @param new_name new name for the project
#' @param color new color for the project
#' @param is_favorite boolean to mark as favorite
#' @param view_style view style ("list" or "board")
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the updated project (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' update_project(project_name = "my_proj", new_name = "new_name")
#' }
update_project <- function(project_id = get_project_id(project_name = project_name, token = token, create = FALSE),
                           project_name,
                           new_name = NULL,
                           color = NULL,
                           is_favorite = NULL,
                           view_style = NULL,
                           verbose = TRUE,
                           token = get_todoist_api_token()) {
  force(project_id)
  force(token)

  args_parts <- c(glue('"id": "{project_id}"'))

  if (!is.null(new_name)) {
    args_parts <- c(args_parts, glue('"name": "{escape_json(new_name)}"'))
  }
  if (!is.null(color)) {
    args_parts <- c(args_parts, glue('"color": "{color}"'))
  }
  if (!is.null(is_favorite)) {
    fav_val <- ifelse(is_favorite, "true", "false")
    args_parts <- c(args_parts, glue('"is_favorite": {fav_val}'))
  }
  if (!is.null(view_style)) {
    args_parts <- c(args_parts, glue('"view_style": "{view_style}"'))
  }

  args_json <- paste(args_parts, collapse = ", ")

  if (verbose) {
    message(glue::glue("Updating project {project_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "project_update", "uuid": "{random_key()}", "args": {{{args_json}}}}}]')
  )

  invisible(project_id)
}

#' Delete a project
#'
#' @param project_id id of the project
#' @param project_name name of the project (for lookup if project_id not provided)
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' delete_project(project_name = "my_proj")
#' }
delete_project <- function(project_id = get_project_id(project_name = project_name, token = token, create = FALSE),
                           project_name,
                           verbose = TRUE,
                           token = get_todoist_api_token()) {
  force(project_id)
  force(token)

  if (verbose) {
    message(glue::glue("Deleting project {project_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "project_delete", "uuid": "{random_key()}", "args": {{"id": "{project_id}"}}}}]')
  )

  invisible(NULL)
}

#' Archive a project
#'
#' @param project_id id of the project
#' @param project_name name of the project (for lookup if project_id not provided)
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the archived project (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' archive_project(project_name = "my_proj")
#' }
archive_project <- function(project_id = get_project_id(project_name = project_name, token = token, create = FALSE),
                            project_name,
                            verbose = TRUE,
                            token = get_todoist_api_token()) {
  force(project_id)
  force(token)

  if (verbose) {
    message(glue::glue("Archiving project {project_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "project_archive", "uuid": "{random_key()}", "args": {{"id": "{project_id}"}}}}]')
  )

  invisible(project_id)
}

#' Unarchive a project
#'
#' @param project_id id of the project
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the unarchived project (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' unarchive_project(project_id = "12345")
#' }
unarchive_project <- function(project_id,
                              verbose = TRUE,
                              token = get_todoist_api_token()) {
  force(project_id)
  force(token)

  if (verbose) {
    message(glue::glue("Unarchiving project {project_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "project_unarchive", "uuid": "{random_key()}", "args": {{"id": "{project_id}"}}}}]')
  )

  invisible(project_id)
}

#' Get archived projects
#'
#' @param token todoist API token
#'
#' @return tibble of archived projects
#' @export
#' @importFrom purrr map_dfr
#'
#' @examples
#' \dontrun{
#' get_archived_projects()
#' }
get_archived_projects <- function(token = get_todoist_api_token()) {
  all_results <- list()
  cursor <- NULL

  repeat {
    response <- call_api_rest("projects/archived", token = token, cursor = cursor)
    all_results <- c(all_results, response$results)

    if (is.null(response$next_cursor)) {
      break
    }
    cursor <- response$next_cursor
  }

  if (length(all_results) == 0) {
    return(data.frame(
      id = character(),
      name = character(),
      color = character(),
      is_favorite = logical(),
      stringsAsFactors = FALSE
    ))
  }

  map_dfr(all_results, `[`, c("id", "name", "color", "is_favorite"))
}

#' Get a single project by ID
#'
#' @param project_id id of the project
#' @param token todoist API token
#'
#' @return list with project details
#' @export
#'
#' @examples
#' \dontrun{
#' get_project("12345")
#' }
get_project <- function(project_id, token = get_todoist_api_token()) {
  force(token)
  call_api_rest(glue("projects/{project_id}"), token = token)
}
