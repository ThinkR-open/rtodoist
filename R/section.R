#' add section
#'
#' @param section_name section name
#' @param token todoist API token
#' @param project_id project if
#'
#' @export
#'
add_section <- function(project_id, section_name,force=FALSE, token = get_todoist_api_token()){
  
  ii <- get_id_section(project_id = project_id,section_name =  section_name,token =  token)
  if ( ii != "null" & force == FALSE){
    return(ii)
  }
  
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

#' get id section
#'
#' @param project_id num of the project id
#' @param section_name name of the section
#' @param token token
#'
#' @export
get_id_section <- function(project_id, section_name, token = get_todoist_api_token()){
  tab <- call_api_project_data(
    body = list(
      token = token,
      project_id = project_id
    )
  ) %>%
    content() %>%
      pluck("sections") %>%
      map_dfr(`[`, c("id", "name"))
  
  if (nrow(tab) == 0) {return("null")}
  res  <- tab %>%
      filter(name == section_name) %>%
      pull(id)
  if (length(res) == 0) {return("null")}
  
  res 
}
