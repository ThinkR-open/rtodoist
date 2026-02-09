to_no_date <- function(v){
  ifelse(v=="null",yes = "no date",no = v)
}


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
                                 all_users = get_all_users(token = token),
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
    stringr::str_subset(".",negate = FALSE)  %>% # passage de "" a "." 
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

        # Échapper le contenu pour JSON
        a_escaped <- escape_json(a)

        # Gérer les valeurs null correctement pour JSON
        assigned_part <- if (is.null(b) || is.na(b) || b == "null") 'null' else glue('"{b}"')
        due_part <- if (is.null(c) || is.na(c) || c == "null") 'null' else glue('{{"date" : "{c}"}}')
        sect_part <- if (is.null(d) || is.na(d) || d == "null" || d == "0") 'null' else glue('"{d}"')

        glue('{{ "type": "{action_to_do}",
            "temp_id": "{random_key()}",
            "uuid": "{random_key()}",
            "args": {{ "project_id": "{project_id}", "content": "{a_escaped}",
            "responsible_uid" : {assigned_part}, "due" : {due_part},
            "section_id" : {sect_part}  }}
          }}')
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
    # all_tasks <- glue::glue_collapse(pmap(list(task_ok$content, 
    #                                            task_ok$responsible_uid, to_no_date(task_ok$due), task_ok$section_id, 
    #                                            task_ok$id, action_to_do), function(a, b, c, d, 
    #                                                                                   e, action_to_do) {
    #                                              # browser()
    #                                              
    #                                              
    #                                            a <-  glue("{ \"type\": \"<action_to_do>\",\n            \"temp_id\": \"<random_key()>\",
    #                                          \n            \"uuid\": \"<random_key()>\",
    #                                          \n            \"args\": { \"project_id\": \"<project_id>\",
    #                                          \"content\": \"<a>\", \"id\": \"<e>\",
    #                                               \n            \"responsible_uid\" : \"<b>\",", 
    #                                                       .open = "<", .close = ">")
    #                                              
    #                                              
    #                                            if ( c == "no date"){
    #                                            
    #                                            
    #                                            b<-  glue(" \"due\" : {\"string\" : \"<c>\"},
    #                                               \n            \"section_id\" : \"<d>\"  } \n          }", 
    #                                                   .open = "<", .close = ">")
    #                                            }else{
    #                                              b<-  glue(" \"due\" : {\"date\" : \"<c>\"},
    #                                               \n            \"section_id\" : \"<d>\"  } \n          }", 
    #                                                        .open = "<", .close = ">")
    #                                              
    #                                              
    #                                            }
    #                                              glue::glue("{a} {b}")
    #                                              
    #                                              
    #                                              }), sep = ",")
    
    
    
    
    all_tasks <- glue::glue_collapse(
      pmap(list(task_ok$content, task_ok$responsible_uid, task_ok$due, task_ok$section_id, task_ok$id, action_to_do), function(a, b, c, d, e, action_to_do){

        # Échapper le contenu pour JSON
        a_escaped <- escape_json(a)

        # Gérer les valeurs null correctement pour JSON
        assigned_part <- if (is.null(b) || is.na(b) || b == "null") 'null' else glue('"{b}"')
        due_part <- if (is.null(c) || is.na(c) || c == "null") 'null' else glue('{{"date" : "{c}"}}')
        sect_part <- if (is.null(d) || is.na(d) || d == "null" || d == "0") 'null' else glue('"{d}"')

        glue('{{ "type": "{action_to_do}",
        "temp_id": "{random_key()}",
        "uuid": "{random_key()}",
        "args": {{ "id": "{e}", "project_id": "{project_id}", "content": "{a_escaped}",
        "responsible_uid" : {assigned_part}, "due" : {due_part},
        "section_id" : {sect_part} }}
      }}')
      }), sep = ",")
    
    
  }
  

  

  if (  check_only == FALSE ){
    
    
    
if (nrow(task_ok) > 0){
  


  res <- call_api(
      "token" = token,
    # body = list(
      "sync_token" = "*",
      resource_types = '["projects","items"]',
      commands = glue("[{all_tasks}]")
    # )
  )
  
  # if (verbose) {
    # print(res)
  # }
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
  force(token)
  
  res <- get_tasks(token = token) %>%
    pluck("items") %>%
    set_names(
      map_chr(., "project_id")
    )
  tasks_of_project <- names(res) == project_id
  tasks <- keep(res, tasks_of_project)
  get_my_taks <- tasks %>%
    map(~ .x == task) %>%
    map_lgl(~ isTRUE(.x[["content"]]))
  my_task <- keep(tasks, get_my_taks) %>% flatten()
  id_task <- my_task[["id"]]
  responsible_uid <- get_users_id(mails = responsible,token= token,  all_users = all_users)
  # we need to add this user to project
  
  # ici ne le faire que si necessaire TODO
  
  responsible %>% unique() %>% 
    add_users_in_project(project_id = project_id,
                         users_email= .,
                         verbose = verbose,
                         token = token)
  
  res <- call_api(
      "token" = token,
      "sync_token" = "*",
      commands = glue(
        '[{{ "type": "item_update",
          "temp_id": "{random_key()}",
          "uuid": "{random_key()}",
          "args": {{ "id": "{id_task}", "responsible_uid" : "{responsible_uid}"}}}}]'
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
  force(token)
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

#' Delete a task
#'
#' @param task_id id of the task to delete
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' delete_task("12345")
#' }
delete_task <- function(task_id,
                        verbose = TRUE,
                        token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Deleting task {task_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "item_delete", "uuid": "{random_key()}", "args": {{"id": "{task_id}"}}}}]')
  )

  invisible(NULL)
}

#' Close (complete) a task
#'
#' @param task_id id of the task to close
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the closed task (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' close_task("12345")
#' }
close_task <- function(task_id,
                       verbose = TRUE,
                       token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Closing task {task_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "item_close", "uuid": "{random_key()}", "args": {{"id": "{task_id}"}}}}]')
  )

  invisible(task_id)
}

#' Reopen (uncomplete) a task
#'
#' @param task_id id of the task to reopen
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the reopened task (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' reopen_task("12345")
#' }
reopen_task <- function(task_id,
                        verbose = TRUE,
                        token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Reopening task {task_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "item_uncomplete", "uuid": "{random_key()}", "args": {{"id": "{task_id}"}}}}]')
  )

  invisible(task_id)
}

#' Move a task to another project or section
#'
#' @param task_id id of the task to move
#' @param project_id new project id (optional)
#' @param section_id new section id (optional)
#' @param parent_id new parent task id (optional)
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the moved task (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' move_task("12345", project_id = "67890")
#' }
move_task <- function(task_id,
                      project_id = NULL,
                      section_id = NULL,
                      parent_id = NULL,
                      verbose = TRUE,
                      token = get_todoist_api_token()) {
  force(token)

  args_parts <- c(glue('"id": "{task_id}"'))

  if (!is.null(project_id)) {
    args_parts <- c(args_parts, glue('"project_id": "{project_id}"'))
  }
  if (!is.null(section_id)) {
    args_parts <- c(args_parts, glue('"section_id": "{section_id}"'))
  }
  if (!is.null(parent_id)) {
    args_parts <- c(args_parts, glue('"parent_id": "{parent_id}"'))
  }

  args_json <- paste(args_parts, collapse = ", ")

  if (verbose) {
    message(glue::glue("Moving task {task_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "item_move", "uuid": "{random_key()}", "args": {{{args_json}}}}}]')
  )

  invisible(task_id)
}

#' Get completed tasks
#'
#' @param project_id project id to filter by (optional)
#' @param since return tasks completed since this date (optional, format: YYYY-MM-DDTHH:MM:SS)
#' @param until return tasks completed until this date (optional, format: YYYY-MM-DDTHH:MM:SS)
#' @param limit maximum number of tasks to return (default 50, max 200)
#' @param token todoist API token
#'
#' @return tibble of completed tasks
#' @export
#' @importFrom purrr map_dfr
#'
#' @examples
#' \dontrun{
#' get_completed_tasks()
#' get_completed_tasks(project_id = "12345")
#' }
get_completed_tasks <- function(project_id = NULL,
                                since = NULL,
                                until = NULL,
                                limit = 50,
                                token = get_todoist_api_token()) {
  force(token)

  params <- list(limit = limit)
  if (!is.null(project_id)) params$project_id <- project_id
  if (!is.null(since)) params$since <- since
  if (!is.null(until)) params$until <- until

  all_results <- list()
  cursor <- NULL

  repeat {
    params$cursor <- cursor
    response <- do.call(call_api_rest, c(list("tasks/completed/by_completion_date", token = token), params))

    if (!is.null(response$items)) {
      all_results <- c(all_results, response$items)
    }

    if (is.null(response$next_cursor)) {
      break
    }
    cursor <- response$next_cursor
  }

  if (length(all_results) == 0) {
    return(data.frame(
      id = character(),
      content = character(),
      project_id = character(),
      completed_at = character(),
      stringsAsFactors = FALSE
    ))
  }

  map_dfr(all_results, function(x) {
    data.frame(
      id = x$id %||% NA_character_,
      content = x$content %||% NA_character_,
      project_id = x$project_id %||% NA_character_,
      completed_at = x$completed_at %||% NA_character_,
      stringsAsFactors = FALSE
    )
  })
}

#' Quick add a task using natural language
#'
#' @param text natural language text for the task
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return task object
#' @export
#' @importFrom httr2 request req_headers req_body_json req_perform resp_body_json req_error resp_status
#'
#' @examples
#' \dontrun{
#' quick_add_task("Buy milk tomorrow at 5pm #Shopping")
#' }
quick_add_task <- function(text,
                           verbose = TRUE,
                           token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Quick adding task: {text}"))
  }

  result <- request(paste0(TODOIST_REST_URL, "tasks/quick")) %>%
    req_headers(
      Authorization = glue::glue("Bearer {token}"),
      "Content-Type" = "application/json"
    ) %>%
    req_body_json(list(text = text)) %>%
    req_error(is_error = function(resp) resp_status(resp) >= 400) %>%
    req_perform() %>%
    resp_body_json()

  result
}

#' Get a single task by ID
#'
#' @param task_id id of the task
#' @param token todoist API token
#'
#' @return list with task details
#' @export
#'
#' @examples
#' \dontrun{
#' get_task("12345")
#' }
get_task <- function(task_id, token = get_todoist_api_token()) {
  force(token)
  call_api_rest(glue("tasks/{task_id}"), token = token)
}

#' Update a task
#'
#' @param task_id id of the task to update
#' @param content new content/title for the task
#' @param description new description for the task
#' @param priority priority (1-4, 4 being highest)
#' @param due_string due date as string (e.g., "tomorrow", "every monday")
#' @param due_date due date as date (format: YYYY-MM-DD)
#' @param labels vector of label names
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the updated task (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' update_task("12345", content = "Updated task name")
#' }
update_task <- function(task_id,
                        content = NULL,
                        description = NULL,
                        priority = NULL,
                        due_string = NULL,
                        due_date = NULL,
                        labels = NULL,
                        verbose = TRUE,
                        token = get_todoist_api_token()) {
  force(token)

  args_parts <- c(glue('"id": "{task_id}"'))

  if (!is.null(content)) {
    args_parts <- c(args_parts, glue('"content": "{escape_json(content)}"'))
  }
  if (!is.null(description)) {
    args_parts <- c(args_parts, glue('"description": "{escape_json(description)}"'))
  }
  if (!is.null(priority)) {
    args_parts <- c(args_parts, glue('"priority": {priority}'))
  }
  if (!is.null(due_string)) {
    args_parts <- c(args_parts, glue('"due": {{"string": "{escape_json(due_string)}"}}'))
  } else if (!is.null(due_date)) {
    args_parts <- c(args_parts, glue('"due": {{"date": "{due_date}"}}'))
  }
  if (!is.null(labels)) {
    labels_json <- paste0('"', labels, '"', collapse = ", ")
    args_parts <- c(args_parts, glue('"labels": [{labels_json}]'))
  }

  args_json <- paste(args_parts, collapse = ", ")

  if (verbose) {
    message(glue::glue("Updating task {task_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "item_update", "uuid": "{random_key()}", "args": {{{args_json}}}}}]')
  )

  invisible(task_id)
}
