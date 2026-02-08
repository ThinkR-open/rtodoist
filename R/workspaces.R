#' Get all workspaces
#'
#' @param token todoist API token
#'
#' @return tibble of all workspaces
#' @export
#' @importFrom purrr map_dfr pluck
#'
#' @examples
#' \dontrun{
#' get_all_workspaces()
#' }
get_all_workspaces <- function(token = get_todoist_api_token()) {
  force(token)

  result <- call_api(
    token = token,
    sync_token = "*",
    resource_types = '["workspaces"]'
  )

  workspaces <- result %>% pluck("workspaces")

  if (is.null(workspaces) || length(workspaces) == 0) {
    return(data.frame(
      id = character(),
      name = character(),
      stringsAsFactors = FALSE
    ))
  }

  map_dfr(workspaces, function(x) {
    data.frame(
      id = x$id %||% NA_character_,
      name = x$name %||% NA_character_,
      is_default = x$is_default %||% FALSE,
      stringsAsFactors = FALSE
    )
  })
}

#' Get workspace users
#'
#' @param token todoist API token
#'
#' @return tibble of workspace users
#' @export
#' @importFrom purrr map_dfr pluck
#'
#' @examples
#' \dontrun{
#' get_workspace_users()
#' }
get_workspace_users <- function(token = get_todoist_api_token()) {
  force(token)

  result <- call_api(
    token = token,
    sync_token = "*",
    resource_types = '["workspace_users"]'
  )

  users <- result %>% pluck("workspace_users")

  if (is.null(users) || length(users) == 0) {
    return(data.frame(
      user_id = character(),
      workspace_id = character(),
      name = character(),
      email = character(),
      stringsAsFactors = FALSE
    ))
  }

  map_dfr(users, function(x) {
    data.frame(
      user_id = x$user_id %||% NA_character_,
      workspace_id = x$workspace_id %||% NA_character_,
      name = x$name %||% NA_character_,
      email = x$email %||% NA_character_,
      role = x$role %||% NA_character_,
      stringsAsFactors = FALSE
    )
  })
}

#' Invite user to workspace
#'
#' @param workspace_id id of the workspace
#' @param email email of the user to invite
#' @param role role for the user (e.g., "member", "admin")
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' invite_to_workspace("12345", "user@example.com")
#' }
invite_to_workspace <- function(workspace_id,
                                email,
                                role = "member",
                                verbose = TRUE,
                                token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Inviting {email} to workspace {workspace_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "workspace_invite", "uuid": "{random_key()}", "args": {{"workspace_id": "{workspace_id}", "email": "{email}", "role": "{role}"}}}}]')
  )

  invisible(NULL)
}

#' Update a workspace
#'
#' @param workspace_id id of the workspace
#' @param name new name for the workspace
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the updated workspace (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' update_workspace("12345", name = "New Workspace Name")
#' }
update_workspace <- function(workspace_id,
                             name,
                             verbose = TRUE,
                             token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Updating workspace {workspace_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "workspace_update", "uuid": "{random_key()}", "args": {{"id": "{workspace_id}", "name": "{escape_json(name)}"}}}}]')
  )

  invisible(workspace_id)
}

#' Leave a workspace
#'
#' @param workspace_id id of the workspace
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' leave_workspace("12345")
#' }
leave_workspace <- function(workspace_id,
                            verbose = TRUE,
                            token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Leaving workspace {workspace_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "workspace_leave", "uuid": "{random_key()}", "args": {{"id": "{workspace_id}"}}}}]')
  )

  invisible(NULL)
}
