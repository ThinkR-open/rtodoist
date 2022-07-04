#' Add tasks in project
#'
#' @param project_name name of the project
#' @param project_id id of the project
#' @param tasks tasks to add, as character vector
#' @param verbose boolean that make the function verbose
#' @param responsible add people in project
#' @param due due date
#' @param section_name section name
#' @param token todoist API token
#' @param update_only boolean if true, only update existing (not closed) todo
#' @param all_users all_users
#' @param check_only check_only
#' @param que_si_necessaire que_si_necessaire
#'
#' @export
#' @importFrom stats na.omit
#' 
#' @return id of project (character vector)
#' @examples 
#' \dontrun{
#' add_project("my_proj") %>%
#'    add_tasks_in_project(c("First task", "Second task"))
#' }
add_tasks_in_project <- function(project_id = get_project_id(project_name = project_name,token = token),
                                 tasks,
                                 project_name,
                                 verbose = FALSE,
                                 responsible = NULL,
                                 due = NULL,
                                 section_name = NULL,
                                 token = get_todoist_api_token(),
                                 # all_users = get_all_users(token = token),
                                 all_users = get_all_users(),
                                 update_only = FALSE,
                                 check_only = FALSE,
                                 que_si_necessaire = TRUE) {
  
  if (!is.null(section_name)){
  if (length(section_name) > 1 & length(tasks) != length(section_name)){
    stop("error, not enough or too many section_name for the number of task, either only one section_name or as many as the number of task")
    }
  }
  
  if (!is.null(responsible)){
  if (length(responsible) > 1 & length(tasks) != length(responsible)){
    stop("error, not enough or too many responsible for the number of task, either only one responsible or as many as the number of task")
    }
  }
  if (!is.null(due)){
  if (length(due) > 1 & length(tasks) != length(due)){
    stop("error, not enough or too many due for the number of task, either only one due or as many as the number of task")
    }
  }
  
  force(project_id) 
  force(token)
  # on clean un peu
  due <- clean_due(due)
  section_name <- clean_section(section_name)
  
  
  
 responsible_uid <- get_users_id(mails = responsible,
                                  all_users = all_users,
                                  token = token)
  

  
  if (!update_only){# si on ne fait que mettre a jour alors on ne fait pas les section.. 
    # voir ce qui se passe si on update avec une nouvelle section, à l'occase
    
    
 
  
  # on invite les responsables
  
  responsible %>% unique() %>% 
    add_users_in_project(project_id = project_id,
                         users_email = .,
                         verbose = verbose,
                         token = token)
  
  
  
  # on init les sections
  unique(section_name) %>% 
    stringr::str_subset("",negate = FALSE)  %>%
    na.omit() %>% 
    map(~add_section(project_id = project_id,section_name = .x, token=token))
  
  }
  
  section_id <- get_section_id(project_id = project_id,section_name = section_name,token = token)
  
  existing_tasks <- get_tasks_of_project(project_id = project_id,token =  token)
  
  if (verbose) {
    message(length(existing_tasks), "existing tasks in project")
  }
  if ( ! update_only) {
 
    action_to_do <-"item_add"
    task_ok  <- get_tasks_to_add(tasks = tasks,
    due = due,responsible_uid = responsible_uid,
                              existing_tasks = get_tasks_of_project(project_id = project_id,token =  token),
                              sections_id = section_id,token = token)
    
    
    if (verbose) {
      message(nrow(task_ok),"tasks to ADD")
    }
    
    
    try(task_ok$section_id[is.na(task_ok$section_id)]<-"null")
    all_tasks <- glue::glue_collapse( 
      pmap(list(task_ok$content,task_ok$responsible_uid,task_ok$due,task_ok$section_id,action_to_do), function(a,b,c,d,action_to_do){
        glue('{ "type": "<action_to_do>",
            "temp_id": "<random_key()>",
            "uuid": "<random_key()>",
            "args": { "project_id": "<project_id>", "content": "<a>", 
            "responsible_uid" : <b>, "due" : {"date" : <c>},
            "section_id" : <d>  } 
          }',
             .open = "<",
             .close = ">")
      }), sep = ",")
    
    
    
  } else{
    
    
    if (verbose) {
      message("->update")
    }
    action_to_do <-"item_update"
    task_ok <-  get_tasks_to_update(tasks = tasks,
                                    due = due,
                                    responsible_uid = responsible_uid,
                                    existing_tasks = existing_tasks,
                                    sections_id = section_id,token = token,que_si_necessaire=que_si_necessaire)
    try(task_ok$section_id[is.na(task_ok$section_id)]<-"null")
    if (verbose) {
      message(nrow(task_ok)," tasks to UPDATE")
    }
    all_tasks <- glue::glue_collapse( 
      pmap(list(task_ok$content,task_ok$responsible_uid,task_ok$due,task_ok$section_id,task_ok$id,action_to_do), function(a,b,c,d,e,action_to_do){
        glue('{ "type": "<action_to_do>",
            "temp_id": "<random_key()>",
            "uuid": "<random_key()>",
            "args": { "project_id": "<project_id>", "content": "<a>", "id": "<e>", 
            "responsible_uid" : <b>, "due" : {"date" : <c>},
            "section_id" : <d>  } 
          }',
             .open = "<",
             .close = ">")
      }), sep = ",")
    
  }
  

  

  if (  check_only == FALSE ){
    
    
    
if (nrow(task_ok) > 0){
  


  res <- call_api(
    body = list(
      "token" = token,
      "sync_token" = "*",
      resource_types = '["projects","items"]',
      commands = glue("[{all_tasks}]")
    )
  )
  
  if (verbose) {
    print(res)
  }
}else{
  message("rien a faire, vraiment")
  
}
  out <- invisible(project_id)
  } else{
    
    out <- task_ok
    
  }
  
  
  
  out
}

#' Add responsible to a task
#'
#' @param project_name name of the project
#' @param project_id id of the project
#' @param task the full name of the task
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#' @param responsible add someone to this task with mail
#' @param all_users all_users
#'
#' @return http request
#' @export
add_responsible_to_task <- function(project_id = get_project_id(project_name = project_name,token = token),
                                    project_name,
                                    responsible,
                                    task,
                                    verbose = FALSE,
                                    all_users = get_all_users(token = token),
                                    token = get_todoist_api_token()) {
  
  force(project_id)
  
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
  responsible_uid <- get_users_id(mails = responsible,token= token,  all_users = all_users)
  # we need to add this user to project
  
  # ici ne le faire que si necessaire TODO
  
  responsible %>% unique() %>% 
    add_users_in_project(project_id = project_id,
                         users_email= .,
                         verbose = verbose,
                         token = token)
  
  res <- call_api(
    body = list(
      "token" = token,
      "sync_token" = "*",
      commands = glue(
        '[{ "type": "item_update",
          "temp_id": "<random_key()>",
          "uuid": "<random_key()>",
          "args": { "id": "<id_task>", "responsible_uid" : <responsible_uid>}}]',
        .open = "<",
        .close = ">"
      )
    )
  )
  invisible(res)
}




#' Add tasks in project
#'
#' @param tasks_as_df data.frame of tasks with
#'  c("tasks_list","responsible","due","section_name") names
#' @param token todoist API token
#' @param project_name name of the project
#' @param project_id id of the project
#' @param verbose boolean that make the function verbose
#' @param update_only boolean if true only update existing (not closed) todo
#' @param check_only boolean if true only return number of task to add
#' @param que_si_necessaire que_si_necessaire
#' @param all_users all_users
#'
#' @export
#' 
#' @seealso [add_tasks_in_project()]
#' 
#' @return id of project (character vector)

add_tasks_in_project_from_df <- function(project_id = get_project_id(project_name = project_name,token = token),
                                 tasks_as_df,
                                 project_name,
                                 verbose = FALSE,
                                 token = get_todoist_api_token(),
                                 update_only = FALSE,
                                 check_only = FALSE,
                                 que_si_necessaire = TRUE,
                                 all_users = get_all_users(token = token)) {
  
force(project_id)
  
    if (verbose){
  message("project_id ",project_id)
  }
  if ( !"tasks" %in% names(tasks_as_df)){
    stop(" tasks is missing in column names")
  }
 
not_used <- setdiff(names(tasks_as_df),c("tasks","responsible","due","section_name"))
   if (length(not_used)> 0){
     message("not used : ", paste(collapse=" ",not_used))
     message("please use : ",paste(c("tasks","responsible","due","section_name"),collapse=" "))
     }
  
 out <- add_tasks_in_project(project_id = project_id,
                       tasks = tasks_as_df$tasks,
                       responsible = tasks_as_df$responsible,
                       due = tasks_as_df$due,
                       section_name = tasks_as_df$section_name,
                       verbose = verbose,all_users=all_users,
                       token = token,update_only = update_only,check_only =check_only,que_si_necessaire = que_si_necessaire
                       )
  
  if (check_only) {return(out)}
  project_id
}
