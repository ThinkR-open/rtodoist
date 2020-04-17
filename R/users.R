#' Get user id
#'
#' @param mail mail of the person
#' @param token token
#' @importFrom dplyr filter pull
#' @return id of user
#' @export
get_user_id <- function(mail,
                        token = get_todoist_api_token()) {
call_api(
    body = list(
      "token" = token,
      "sync_token" = "*",
      resource_types = '["collaborators"]'
    )
  ) %>%
    content() %>%
    pluck("collaborators") %>%
    map_df(`[`, c("email", "id")) %>%
    filter(`email` == mail) %>%
    pull(id)
}

#' Add one user
#'
#' @param project_id id of project
#' @param token token
#' @param mail mail of the user
#' @param verbose make it talk
#'
#' @export
#' @importFrom glue glue

add_user_in_project <- function(project_id,
                                mail,
                                verbose = TRUE,
                                token = get_todoist_api_token()) {
  if (verbose) {
    message(glue::glue("add {mail} in the {project_id} project"))
  }

  call_api(
    body = list(
      token = token,
      commands = glue(
        '[
           {"type": "share_project",
           "temp_id": "<random_key()>",
           "uuid": "<random_key()>",
           "args": {"project_id": <project_id>, "email": "<mail>"}}]',
        .open = "<",
        .close = ">"
      )
    )
  ) %>%
    print()
  invisible(project_id)
}


#' Add a list of users
#'
#' @param token token
#' @param project_id id of project
#' @param list_of_users list of mails
#' @param verbose make it talk
#' @export
#'
#' @importFrom glue glue
add_users_in_project <- function(project_id,
                                 list_of_users,
                                 verbose = TRUE,
                                 token = get_todoist_api_token()) {
  map(list_of_users, ~ add_user_in_project(project_id = project_id,
                                           token = token,
                                           mail = .x,
                                           verbose = verbose))
  invisible(project_id)
}
