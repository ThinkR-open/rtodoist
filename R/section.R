#' add section
#'
#' @param section_name section name
#' @param token todoist API token
#' @param project_id project if
#'
#' @export
#'
add_section <- function(project_id, section_name,force=FALSE, token = get_todoist_api_token()){
  
  
  if (section_name =="null"){return("null")}
  
  ii <- get_id_section(project_id = project_id,section_name =  section_name,token =  token)
  if ( (ii != "null" & force == FALSE) & ii != 0){
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
  
  
  # to fix the order
  if (nrow(tab) == 0) {return(0)}
 tab <- tibble::tibble(name=section_name) %>%
   left_join(tab,by = "name")
  if (nrow(tab) == 0) {return(0)}
   res  <-  tab %>%   pull(id)
  if (length(res) == 0) {return(0)}
  res[is.na(res)]<- 0
  res 
}
