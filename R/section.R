#' Title
#'
#' @param project_id 
#' @param section_name 
#'
#' @return
#' @export
#'
#' @examples
add_section <- function(project_id, section_name, token = get_todoist_api_token()){
  call_api(
    body = list(
      "token" = token,
      "sync_token" = "*",
      commands = glue(
        '[{ "type": "section_add",
          "temp_id": "<random_key()>",
          "uuid": "<random_key()>",
          "args": { "name": "<section_name>", "project_id" : <project_id>}}]',
        .open = "<",
        .close = ">"
      )
    )
  )
  
  get_id_section(project_id, section_name, token)
}

#' id section
#'
#' @param project_id num of the project id
#' @param section_name name of the section
#'

#' @export
get_id_section <- function(project_id, section_name, token = get_todoist_api_token()){
  call_api_project_data(
    body = list(
      token = token,
      project_id = project_id
    )
  ) %>%
    content() %>%
      pluck("sections") %>%
      map_dfr(`[`, c("id", "name")) %>%
      filter(name == section_name) %>%
      pull(id)
}
