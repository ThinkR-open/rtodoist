#' add section
#'
#' @param section_name section name
#' @param token todoist API token
#' @param project_name name of the project
#' @param project_id id of the project
#' @param force boolean force section creation even if already exist
#' @importFrom glue glue
#' @export
#'
add_section <- function(section_name,
                        project_id = get_project_id(project_name = project_name,token = token),
                        project_name, 
                        force=FALSE,
                        token = get_todoist_api_token()){
  
  if (section_name =="null"){return("null")}
  force(project_id)
  force(token)
  ii <- get_section_id(project_id = project_id,section_name =  section_name,token =  token)
  if ( (ii != "null" & force == FALSE) & ii != 0){
    return(ii)
  }
  
 out <-  call_api(
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
  ) %>% content() %>% print()
  
  get_section_id(project_id = project_id,section_name =  section_name,token =  token)
}

#' get id section
#'
#' @param project_name name of the project
#' @param project_id id of the project
#' @param section_name name of the section
#' @param all_section all_section
#' @param token token
#'
#' @importFrom dplyr left_join
#' @importFrom httr content
#' @importFrom purrr pluck map_dfr
#' @export
get_section_id <- function(project_id = get_project_id(project_name = project_name,token = token),
                           project_name, section_name, 
                           token = get_todoist_api_token(),
                           all_section = get_section_from_project(project_id = project_id,token = token)
                           
                           ){
  force(project_id)
  force(token)
  # tab <- call_api_project_data(
  #   body = list(
  #     token = token,
  #     project_id = project_id
  #   )
  # ) %>%
  #   content() %>%
  #     pluck("sections") %>%
  #     map_dfr(`[`, c("id", "name"))
  tab <- all_section
  
  # to fix the order
  if (nrow(tab) == 0) {return(0)}
 tab <- data.frame(name=section_name) %>%
   left_join(tab,by = "name")
  if (nrow(tab) == 0) {return(0)}
   res  <-  tab %>%   pull(id)
  if (length(res) == 0) {return(0)}
  res[is.na(res)]<- 0
  res 
}



get_section_from_project <- function(project_id, token = get_todoist_api_token()){
  
  
  tab <- call_api_project_data(
    body = list(
      token = token,
      project_id = project_id
    )
  ) %>%
    content() %>%
    pluck("sections") %>%
    map_dfr(`[`, c("id", "name"))
  
}
