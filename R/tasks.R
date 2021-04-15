#' Add tasks in project
#'
#' @param token todoist API token
#' @param project_id id of project
#' @param tasks_list list of tasks
#' @param verbose make it talk
#' @param responsible add people in project
#' @param due due date
#' @param section_id section id
#' @param existing_tasks existing tasks
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
                                 verbose = FALSE,
                                 responsible = NULL,
                                 due = NULL,
                                 section_id = NULL,
                                 existing_tasks = get_tasks(token = token),
                                 token = get_todoist_api_token()) {
  
  id_user <- get_users_id(mails = responsible, token = token)
  
  responsible %>%
    add_users_in_project(project_id = project_id,
                         list_of_users = .,
                         verbose = verbose,token = token)
  
  due <- clean_due(due)
  section_id <- clean_section(section_id)
  task <-  get_tasks_to_add(tasks_list = tasks_list,
                            existing_tasks = existing_tasks,
                            project_id = project_id)



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
#' @param token todoist API token
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
  id_user <- get_users_id(mails = add_responsible)
  res <- call_api(
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
  invisible(res)
}
