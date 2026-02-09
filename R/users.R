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
 out<- call_api(
      "token" = token,

      "sync_token" = "*",
      resource_types = '["collaborators"]'

  ) %>%
    pluck("collaborators") %>%
    map_df(`[`, c("email", "id"))
 
 if (nrow(out) == 0){
   out <- data.frame(email = character(),id=character())
   
 }
 out
}




#' Get users id
#'
#' @param mails mails of the person
#' @param all_users all_users
#' @param token token
#'
#' @importFrom dplyr filter pull left_join
#' @return id of users
get_users_id <- function(mails,
                         all_users = get_all_users(token = token),
                        token = get_todoist_api_token()) {
  
  
  if (is.null(mails)) {
    return("null") 
  }
  
tab <- all_users %>%
    dplyr::filter(`email` %in% mails) 
  
# pour garantir la coherence d'ordre entre mails et id
id_user <- data.frame(email = unlist(mails)) %>% 
  left_join(tab,by="email") %>% 
  pull(id)

id_user[is.na(id_user) ] <- "null"
id_user %>% map_chr(as.character)
}


#' Add one user
#'
#' @param project_name name of the project
#' @param project_id id of the project
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

add_user_in_project <- function(
  project_id = get_project_id(project_name = project_name,token = token),
                                mail,project_name,
                                verbose = TRUE,
                                token = get_todoist_api_token()) {
  
  force(project_id)
  force(token)
  if (verbose) {
    message(glue::glue("Add {mail} in the {project_id} project"))
  }

  res <- call_api(
      token = token,
    # body = list(
      commands = glue(
        '[
           {"type": "share_project",
           "temp_id": "<random_key()>",
           "uuid": "<random_key()>",
           "args": {"project_id": "<project_id>", "email": "<mail>"}}]',
        .open = "<",
        .close = ">"
      # )
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
#' @param project_name name of the project
#' @param project_id id of the project
#' @param users_email emails of user as character vector
#' @param verbose boolean that make the function verbose
#' @param all_users all_users
#' 
#' @return id of project (character vector)
#' @export
#'
#' @importFrom glue glue glue_collapse
#' @importFrom dplyr pull
#' @importFrom stringr str_detect
add_users_in_project <- function(project_id = get_project_id(project_name = project_name,token = token),
                                 users_email,
                                 project_name,
                                 verbose = TRUE,all_users = get_all_users(token = token),
                                 token = get_todoist_api_token()) {
  force(project_id)
  force(token)
  clean_users <- users_email %>% set_as_null_if_needed() %>% unique()
  if (is.null(clean_users)){
    message("no users to add in project")
    return(invisible(project_id))
      }
  test <- !stringr::str_detect(clean_users, "@")
  if(any(test)){
    sale <- clean_users[!test]
    stop("adresse mail non valide: ", paste0(sale, collapse = ", "))
  }

  existe_deja <-  get_users_in_project(token = token,project_id =  project_id) %>% 
    pull(user_id)
  
  test_if_present <- get_users_id(clean_users,token = token,all_users = all_users) %in% existe_deja
  mails <- clean_users[!test_if_present]
  
  all_users <- glue::glue_collapse( 
      map(mails, ~ {glue('{"type": "share_project",
           "temp_id": "<random_key()>",
           "uuid": "<random_key()>",
           "args": {"project_id": "<project_id>", "email": "<.x>"}
           }',
          .open = "<",
          .close = ">")}) , sep = ",")
  
  if(length(mails) != 0 & !is.null(users_email)){
    message("Adding ", paste0(mails, collapse = ", "))
    
    
    
    res <- call_api(
        "token" = token,
      # body = list(
        commands = glue("[{all_users}]")
      # )
    )
    if (verbose) {
      print(res)
    }
    
    
    
    
    
  }else{
    message("All users are already in this project")
  }
  

  invisible(project_id)
}

#' Get users in projects 
#'
#' @param token token
#' @param project_name name of the project
#' @param project_id id of the project
#' @importFrom purrr pluck map_df
#' @importFrom dplyr filter
#' @importFrom httr content
#' @return dataframe of users in projects
#' @export
#'

get_users_in_project<- function( project_id = get_project_id(project_name = project_name,token = token),
                                 project_name,token = get_todoist_api_token()){
  force(project_id)
  force(token)
    out <- call_api(
      token = token,
      # body = list(

      sync_token = "*",
      resource_types = '["collaborators"]'
    ) %>%
      # content() %>%
      pluck("collaborator_states") %>%
      map_df(`[`, c("project_id", "user_id"))  %>%
      dplyr::filter(project_id == !!project_id)


    if (nrow(out) == 0) {
      out <- data.frame(project_id = character(), user_id = character())

    }
    out
  }

#' Get current user info
#'
#' @param token todoist API token
#'
#' @return list with user information
#' @export
#' @importFrom purrr pluck
#'
#' @examples
#' \dontrun{
#' get_user_info()
#' }
get_user_info <- function(token = get_todoist_api_token()) {
  force(token)

  result <- call_api(
    token = token,
    sync_token = "*",
    resource_types = '["user"]'
  )

  result %>% pluck("user")
}

#' Get productivity stats
#'
#' @param token todoist API token
#'
#' @return list with productivity statistics
#' @export
#' @importFrom purrr pluck
#'
#' @examples
#' \dontrun{
#' get_productivity_stats()
#' }
get_productivity_stats <- function(token = get_todoist_api_token()) {
  force(token)

  result <- call_api(
    token = token,
    sync_token = "*",
    resource_types = '["user"]'
  )

  user <- result %>% pluck("user")
  if (is.null(user)) {
    return(list())
  }

  list(
    karma = user$karma,
    karma_trend = user$karma_trend,
    completed_today = user$completed_today,
    days_items = user$days_items,
    week_items = user$week_items
  )
}

#' Delete a collaborator from a project
#'
#' @param project_id id of the project
#' @param project_name name of the project (for lookup if project_id not provided)
#' @param email email of the collaborator to remove
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the project (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' delete_collaborator(project_name = "my_proj", email = "user@example.com")
#' }
delete_collaborator <- function(project_id = get_project_id(project_name = project_name, token = token, create = FALSE),
                                project_name,
                                email,
                                verbose = TRUE,
                                token = get_todoist_api_token()) {
  force(project_id)
  force(token)

  if (verbose) {
    message(glue::glue("Removing {email} from project {project_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "collaborator_delete", "uuid": "{random_key()}", "args": {{"project_id": "{escape_json(project_id)}", "email": "{escape_json(email)}"}}}}]')
  )

  invisible(project_id)
}

#' Accept a project invitation
#'
#' @param invitation_id id of the invitation
#' @param invitation_secret secret of the invitation
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' accept_invitation("12345", "secret123")
#' }
accept_invitation <- function(invitation_id,
                              invitation_secret,
                              verbose = TRUE,
                              token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Accepting invitation {invitation_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "accept_invitation", "uuid": "{random_key()}", "args": {{"invitation_id": "{escape_json(invitation_id)}", "invitation_secret": "{escape_json(invitation_secret)}"}}}}]')
  )

  invisible(NULL)
}

#' Reject a project invitation
#'
#' @param invitation_id id of the invitation
#' @param invitation_secret secret of the invitation
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' reject_invitation("12345", "secret123")
#' }
reject_invitation <- function(invitation_id,
                              invitation_secret,
                              verbose = TRUE,
                              token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Rejecting invitation {invitation_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "reject_invitation", "uuid": "{random_key()}", "args": {{"invitation_id": "{escape_json(invitation_id)}", "invitation_secret": "{escape_json(invitation_secret)}"}}}}]')
  )

  invisible(NULL)
}

#' Delete an invitation
#'
#' @param invitation_id id of the invitation
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' delete_invitation("12345")
#' }
delete_invitation <- function(invitation_id,
                              verbose = TRUE,
                              token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Deleting invitation {invitation_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "delete_invitation", "uuid": "{random_key()}", "args": {{"invitation_id": "{escape_json(invitation_id)}"}}}}]')
  )

  invisible(NULL)
}

