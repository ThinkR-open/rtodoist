#' Add task in project
#' 
#' To work, it needs a project id. 
#'
#' @param project_id id of a project
#' @param token token
#' @param task a task
#' @param try_again start again the request
#' @param verbose make it talk
#' @param time_try_again number of tries
#' @param responsible add people in project with email. To know user email, use \code{\link{get_users}}.
#' @param exiting_tasks list of tasks already in the project
#'
#' @return project id
#' @export
#' 
#' @examples 
#' \dontrun{
#' add_project("my_proj") %>%
#'    add_task_in_project("Add tasks")
#'}
add_task_in_project <- function(project_id,
                                task,
                                try_again = 3,
                                time_try_again = 3,
                                verbose = TRUE,
                                responsible = NULL,
                                due = NULL,
                                section_id = NULL, 
                                token = get_todoist_api_token(),
                                exiting_tasks = get_tasks(token = token)) {
  if (verbose) {
    message(glue::glue("create {task} in the {project_id} project"))
  }
  
  if (!is.null(responsible)) {
    proj_id <- project_id
    id_user <- get_user_id(mail = responsible)
    add_user_in_project(project_id = proj_id, mail = responsible)
  } else {
    id_user <- "null"
  }
  
  if(is.null(due)){
    due <- "null"
  }else{
    due <- paste0("\"",due,"\"")
  }
  
  if(is.null(section_id)){
    section_id <- "null"
  }
  
  tache <- exiting_tasks %>%
    flatten() %>%
    map(`[`, c("content", "project_id"))
  tache_project <- map_lgl( seq_along(tache),
                            ~ tache[[.x]]["project_id"] == project_id)
  tache <- keep(tache, tache_project) %>%
    map_chr("content")
  
  if (task %in% tache) {
    message(glue("The task {task} already exists in this project"))
    return(invisible(project_id))
  } else {
    res <- call_api(
      body = list(
        "token" = token,
        "sync_token" = "*",
        resource_types = '["projects","items"]',
        commands = glue(
          '[{ "type": "item_add",
            "temp_id": "<random_key()>",
            "uuid": "<random_key()>",
            "args": { "project_id": "<project_id>", "content": "<task>", "responsible_uid" : <id_user>, "due" : {"date" : <due>}, "section_id" : <section_id> } 
          }]',
          .open = "<",
          .close = ">"
        )
      )
    )
    
    try <- 0
    
    while (res$status_code != 200 & try <= try_again) {
      time_try_again <- time_try_again + 2
      message(glue::glue(" try again in {time_try_again} seconds [{try}/{try_again}]"))
      Sys.sleep(time_try_again)
      
      res <- call_api(
        body = list(
          "token" = token,
          "sync_token" = "*",
          resource_types = '["projects","items"]',
          commands = glue(
            '[{ "type": "item_add",
              "temp_id": "<random_key()>",
              "uuid": "<random_key()>",
              "args": { "project_id": "<project_id>", "content": "<task>", "responsible_uid" : <id_user>, "due" : {"date" : "<due>"}, "section_id" : <section_id> }  
            }]',
            .open = "<",
            .close = ">"
          )
        )
      )
      try <- try + 1
    }
    if (res$status_code != 200) {
      message(glue::glue("ERROR : we cant create {task} in the {project_id} project"))
    }
  }
  invisible(project_id)
}

#' Add a list of tasks
#'
#' @param token token
#' @param project_id id of project
#' @param tasks_list list of tasks
#' @param try_again start again the request
#' @param verbose make it talk
#' @param time_try_again number of tries
#' @param responsible add people in project
#'
#' @export
#' 
#' @seealso [add_task_in_project()]
#' 
#' @return id of project (character vector)
#' @examples 
#' \dontrun{
#' add_project("my_proj") %>%
#'    add_tasks_in_project(list("First task", "Second task"))
#' }
add_tasks_in_project <- function(project_id,
                                 tasks_list,
                                 try_again = 3,
                                 time_try_again = 3,
                                 # verbose = TRUE,
                                 responsible = NULL,
                                 due = NULL,
                                 section_id = NULL,
                                 token = get_todoist_api_token()) {
  
  exiting_tasks <- get_tasks(token = token) 
  
  
  if (!is.null(responsible)) {
    # browser()
    proj_id <- project_id
    # id_user <- get_user_id(mail = responsible)
    id_user <-  responsible %>% map(get_user_id) #%>% compact()
    
    
    id_user[id_user %>% map(length) == 0 ] <- "null"
    id_user <- id_user %>% map_chr(as.character) #%>% unlist()
    responsible[responsible==""] <- NULL
    responsible[responsible==" "] <- NULL
    responsible[is.na(responsible)] <- NULL
    
    responsible %>% 
      # map(get_user_id) %>%
      # compact() %>% 
    add_users_in_project(project_id = proj_id,list_of_users = .,verbose = TRUE)
  } else {
    id_user <- "null"
  }
  
  if(is.null(due)){
    due <- "null"
  } else{

   due <- map_chr(due,as.character) %>% stringr::str_trim()
   due[due==""] <- NA
   due[due==" "] <- NA
   due <- stringr::str_replace(glue::glue('"{due}"'), 
                               pattern = "^\"NA\"$","null")
    
  }
  
  if(is.null(section_id)){
    section_id <- "null"
  }
  
  # on devrait virer ici de tasks_list ce qui est deja dans le projet
  tache <- exiting_tasks %>%
    flatten() %>%
    map(`[`, c("content", "project_id"))
  
  tache_project <- map_lgl(seq_along(tache), 
                           ~ tache[[.x]]["project_id"] == project_id)
  tache <- keep(tache, tache_project) %>%
    map_chr("content")
  
task <- setdiff(unlist(tasks_list), tache)
  
all_tasks <- glue::glue_collapse( 
  pmap(list(task,id_user,due,section_id), function(a,b,c,d){
    glue('{ "type": "item_add",
            "temp_id": "<random_key()>",
            "uuid": "<random_key()>",
            "args": { "project_id": "<project_id>", "content": "<a>", 
            "responsible_uid" : <b>, "due" : {"date" : <c>},
            "section_id" : <d>  } 
          }',
         .open = "<",
         .close = ">")
  }), sep = ",")
 
 
  
  
  res <- call_api(
    body = list(
      "token" = token,
      "sync_token" = "*",
      resource_types = '["projects","items"]',
      commands = glue("[{all_tasks}]")
    )
  )
  print(res)
  invisible(project_id)
}

#' Add responsible to a task
#'
#' @param project_id id of the project
#' @param task the full name of the task
#' @param verbose make the function verbose
#' @param token token
#' @param add_responsible add someone to this task with mail
#'
#' @return http request
#' @export
add_responsible_to_task <- function(project_id,
                                    add_responsible,
                                    task,
                                    verbose,
                                    token = get_todoist_api_token()) {
  res <- get_tasks(token = token) %>%
    pluck("items") %>%
    set_names(
      map_dbl(., "project_id")
    )
  tasks_of_project <- names(res) == project_id
  tasks <- keep(res, tasks_of_project)
  get_my_taks <- tasks %>%
    map(~ .x == task) %>%
    map_lgl(~ isTRUE(.x[["content"]]))
  my_task <- keep(tasks, get_my_taks) %>% flatten()
  id_task <- as.numeric(my_task[["id"]])
  id_user <- get_user_id(mail = add_responsible)
  call_api(
    body = list(
      "token" = token,
      "sync_token" = "*",
      commands = glue(
        '[{ "type": "item_update",
          "temp_id": "<random_key()>",
          "uuid": "<random_key()>",
          "args": { "id": "<id_task>", "responsible_uid" : <id_user>}}]',
        .open = "<",
        .close = ">"
      )
    )
  )
}
