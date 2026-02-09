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
  if ( (all(ii != "null") & force == FALSE) & all(ii != 0)){
    return(ii[length(ii)])
  }
  
 out <-  call_api(
      "token" = token,
    # body = list(
      "sync_token" = "*",
      commands = glue(
        '[{ "type": "section_add",
          "temp_id": "<random_key()>",
          "uuid": "<random_key()>",
          "args": { "name": "<section_name>", "project_id" : "<project_id>"}}]',
        .open = "<",
        .close = ">"
      )
    # )
  ) 
  
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
  stringi::stri_trans_general(tolower(section_name),id = "Latin-ASCII")
  # to fix the order
  if (nrow(tab) == 0) {return(0)}
 tab <- data.frame(name=  stringi::stri_trans_general(tolower(section_name),id = "Latin-ASCII")) %>%
   left_join(tab %>% mutate(name = stringi::stri_trans_general(tolower(name),id = "Latin-ASCII")),by = "name")
  if (nrow(tab) == 0) {return(0)}
   res  <-  tab %>%   pull(id)
  if (length(res) == 0) {return(0)}
  res[is.na(res)]<- 0
  res 
}



get_section_from_project <- function(project_id, token = get_todoist_api_token()) {
  all_results <- list()
  cursor <- NULL

  repeat {
    response <- call_api_rest("sections", project_id = project_id, cursor = cursor)
    all_results <- c(all_results, response$results)

    if (is.null(response$next_cursor)) {
      break
    }
    cursor <- response$next_cursor
  }
# browser()
  map_dfr(all_results, `[`, c("id", "name"))
}

#' Update a section
#'
#' @param section_id id of the section
#' @param new_name new name for the section
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the updated section (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' update_section("12345", new_name = "New Section Name")
#' }
update_section <- function(section_id,
                           new_name,
                           verbose = TRUE,
                           token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Updating section {section_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "section_update", "uuid": "{random_key()}", "args": {{"id": "{section_id}", "name": "{escape_json(new_name)}"}}}}]')
  )

  invisible(section_id)
}

#' Delete a section
#'
#' @param section_id id of the section
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' delete_section("12345")
#' }
delete_section <- function(section_id,
                           verbose = TRUE,
                           token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Deleting section {section_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "section_delete", "uuid": "{random_key()}", "args": {{"id": "{section_id}"}}}}]')
  )

  invisible(NULL)
}

#' Move a section to another project
#'
#' @param section_id id of the section
#' @param project_id target project id
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the moved section (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' move_section("12345", project_id = "67890")
#' }
move_section <- function(section_id,
                         project_id,
                         verbose = TRUE,
                         token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Moving section {section_id} to project {project_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "section_move", "uuid": "{random_key()}", "args": {{"id": "{section_id}", "project_id": "{project_id}"}}}}]')
  )

  invisible(section_id)
}

#' Archive a section
#'
#' @param section_id id of the section
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the archived section (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' archive_section("12345")
#' }
archive_section <- function(section_id,
                            verbose = TRUE,
                            token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Archiving section {section_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "section_archive", "uuid": "{random_key()}", "args": {{"id": "{section_id}"}}}}]')
  )

  invisible(section_id)
}

#' Unarchive a section
#'
#' @param section_id id of the section
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the unarchived section (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' unarchive_section("12345")
#' }
unarchive_section <- function(section_id,
                              verbose = TRUE,
                              token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Unarchiving section {section_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "section_unarchive", "uuid": "{random_key()}", "args": {{"id": "{section_id}"}}}}]')
  )

  invisible(section_id)
}

#' Get a single section by ID
#'
#' @param section_id id of the section
#' @param token todoist API token
#'
#' @return list with section details
#' @export
#'
#' @examples
#' \dontrun{
#' get_section("12345")
#' }
get_section <- function(section_id, token = get_todoist_api_token()) {
  force(token)
  call_api_rest(glue("sections/{section_id}"), token = token)
}

#' Get all sections
#'
#' @param token todoist API token
#'
#' @return tibble of all sections
#' @export
#' @importFrom purrr map_dfr
#'
#' @examples
#' \dontrun{
#' get_all_sections()
#' }
get_all_sections <- function(token = get_todoist_api_token()) {
  all_results <- list()
  cursor <- NULL

  repeat {
    response <- call_api_rest("sections", token = token, cursor = cursor)
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
      project_id = character(),
      order = integer(),
      stringsAsFactors = FALSE
    ))
  }

  map_dfr(all_results, `[`, c("id", "name", "project_id", "order"))
}
