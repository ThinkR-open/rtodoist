#' Add tasks in project
#'
#' @param token todoist API token
#' @param project_id id of project
#' @param tasks_list list of tasks
#' @param verbose boolean that make the function verbose
#' @param responsible add people in project
#' @param due due date
#' @param section_name section name
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
add_tasks_in_project <- function(project_id,
                                 tasks_list,
                                 verbose = FALSE,
                                 responsible = NULL,
                                 due = NULL,
                                 section_name = NULL,
                                 token = get_todoist_api_token()) {
  
  if (!is.null(section_name)){
  if (length(section_name) > 1 & length(tasks_list) != length(section_name)){
    stop("error, not enough or too many section_name for the number of task, either only one section_name or as many as the number of task")
    }
  }
  
  if (!is.null(responsible)){
  if (length(responsible) > 1 & length(tasks_list) != length(responsible)){
    stop("error, not enough or too many responsible for the number of task, either only one responsible or as many as the number of task")
    }
  }
  if (!is.null(due)){
  if (length(due) > 1 & length(tasks_list) != length(due)){
    stop("error, not enough or too many due for the number of task, either only one due or as many as the number of task")
    }
  }
  
  
  id_user <- get_users_id(mails = responsible, token = token)
  
  # on invite les responsables
  
  responsible %>%
    add_users_in_project(project_id = project_id,
                         list_of_users = .,
                         verbose = verbose,
                         token = token)
  
  # on clen un peu
  due <- clean_due(due)
  section_name <- clean_section(section_name)
  
  # on init les sections
  unique(section_name) %>% 
    stringr::str_subset("",negate = FALSE)  %>%
    na.omit() %>% 
    map(add_section,project_id = project_id)
  
  
  section_id <- get_section_id(project_id = project_id,section_name = section_name)
  
  task <-  get_tasks_to_add(tasks_list = tasks_list,
                            existing_tasks = get_tasks_of_project(project_id = project_id,token =  token),
                            project_id = project_id,
                            sections_id = section_id)

  try(
task$section_id[is.na(task$section_id)]<-"null"
)
  
all_tasks <- glue::glue_collapse( 
  pmap(list(task$content,id_user,due,task$section_id), function(a,b,c,d){
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
  if (verbose) {
    print(res)
  }
  invisible(project_id)
}

#' Add responsible to a task
#'
#' @param project_id id of project
#' @param task the full name of the task
#' @param verbose boolean that make the function verbose
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




#' Add tasks in project
#'
#' @param tasks_list_df data.frame of tasks with
#'  c("tasks_list","responsible","due","section_name") names
#' @param token todoist API token
#' @param project_id id of project
#' @param verbose boolean that make the function verbose
#'
#' @export
#' 
#' @seealso [add_tasks_in_project()]
#' 
#' @return id of project (character vector)

add_tasks_in_project_from_df <- function(project_id,
                                 tasks_list_df,
                                 verbose = FALSE,
                                 token = get_todoist_api_token()) {
  
  if ( !"tasks_list" %in% names(tasks_list_df)){
    stop(" tasks_list is missing in column name")
  }
 
not_used <- setdiff(names(tasks_list_df),c("tasks_list","responsible","due","section_name"))
   if (length(not_used)> 0){
     message("not used : ", paste(collapse=" ",not_used))
     message("please use : ",paste(c("tasks_list","responsible","due","section_name"),collapse=" "))
     }
  
  add_tasks_in_project(project_id = project_id,
                       tasks_list = tasks_list_df$tasks_list,
                       responsible = tasks_list_df$responsible,
                       due = tasks_list_df$due,
                       section_name = tasks_list_df$section_name,
                       verbose = verbose,
                       token = token
                       )
  
}
