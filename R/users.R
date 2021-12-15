#' Get users
#' 
#' Get a tibble with emails and ids of users
#' 
#' @param token token
#' 
#' @importFrom dplyr filter pull
#' 
#' @return tibble of users
#' 
#' @export
#' 
#' @examples 
#' \dontrun{
#' get_users()
#' }
get_all_users <- function(token = get_todoist_api_token()) {
  call_api(
    body = list(
      "token" = token,
      "sync_token" = "*",
      resource_types = '["collaborators"]'
    )
  ) %>%
    content() %>%
    pluck("collaborators") %>%
    map_df(`[`, c("email", "id"))
}




#' Get users id
#'
#' @param mails mails of the person
#' @param token token
#' @importFrom dplyr filter pull left_join
#' @return id of users
get_users_id <- function(mails,
                        token = get_todoist_api_token()) {
  
  
  if (is.null(mails)) {
    return("null") 
  }
  
tab <- get_all_users(token = token) %>%
    filter(`email` %in% mails) 
  
# pour garantir la coherence d'ordre entre mails et id
id_user <- data.frame(email = unlist(mails)) %>% 
  left_join(tab,by="email") %>% 
  pull(id)

id_user[is.na(id_user) ] <- "null"
id_user %>% map_chr(as.character)
}


#' Add one user
#'
#' @param project_id id of project
#' @param token token
#' @param mail mail of the user
#' @param verbose boolean that make the function verbose
#'
#' @export
#' @importFrom glue glue
#' 
#' @return id of project (character vector)
#' @examples 
#' \dontrun{
#' get_project_id("test") %>% 
#'    add_user_in_project("jean@mail.fr")
#' }

add_user_in_project <- function(project_id,
                                mail,
                                verbose = TRUE,
                                token = get_todoist_api_token()) {
  if (verbose) {
    message(glue::glue("Add {mail} in the {project_id} project"))
  }

  res <- call_api(
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
  ) 
  if (verbose) {
    print(res)
  }
  invisible(project_id)
}


#' Add a list of users
#'
#' @param token token
#' @param project_id id of project
#' @param list_of_users list of mails
#' @param verbose boolean that make the function verbose
#' 
#' @return id of project (character vector)
#' @export
#'
#' @importFrom glue glue glue_collapse
#' @importFrom dplyr pull
#' @importFrom stringr str_detect
add_users_in_project <- function(project_id,
                                 list_of_users,
                                 verbose = TRUE,
                                 token = get_todoist_api_token()) {

  clean_users <- list_of_users %>% set_as_null_if_needed()
  test <- !stringr::str_detect(clean_users, "@")
  if(any(test)){
    sale <- clean_users[!test]
    stop("adresse mail non valide: ", paste0(sale, collapse = ", "))
  }

  existe_deja <-  get_users_in_project(token = token,project_id =  project_id) %>% 
    pull(user_id)
  
  test_if_present <- get_users_id(clean_users) %in% existe_deja
  mails <- clean_users[!test_if_present]
  
  all_users <- glue::glue_collapse( 
      map(mails, ~ {glue('{"type": "share_project",
           "temp_id": "<random_key()>",
           "uuid": "<random_key()>",
           "args": {"project_id": <project_id>, "email": "<.x>"}
           }',
          .open = "<",
          .close = ">")}) , sep = ",")
  
  if(length(mails) != 0 & !is.null(list_of_users)){
    message("Adding ", paste0(mails, collapse = ", "))
  }else{
    message("All users are already in this project")
  }
  
  res <- call_api(
    body = list(
      "token" = token,
      commands = glue("[{all_users}]")
    )
  )
  if (verbose) {
    print(res)
  }
  invisible(project_id)
}

#' Get users in projects 
#'
#' @param token token
#' @param project_id id of project
#' @importFrom purrr pluck map_df
#' @importFrom dplyr filter
#' @importFrom httr content
#' @return dataframe of users in projects
#' @export
#'
get_users_in_project<- function( project_id,token = get_todoist_api_token()){
call_api(
    body = list(
      token = token,
      sync_token = "*",
      resource_types = '["collaborators"]'
    )
  ) %>%
    content()%>%
    pluck("collaborator_states") %>%
    map_df(`[`, c("project_id", "user_id"))  %>%
    dplyr::filter(project_id == !!project_id)
}

