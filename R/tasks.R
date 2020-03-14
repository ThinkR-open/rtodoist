#' Add task in project
#'
#'
#' @param project_id id of a project
#' @param token token
#' @param task a task
#' @param add_responsible add responsible
#' @param try_again start again the request
#' @param verbose make it talk
#'
#' @return message
#' @export
#'
#' @importFrom purrr flatten map map_lgl keep map_chr
#' @importFrom glue glue
#' @importFrom httr POST

add_task_in_project <-
  function(project_id,
             task,
             # add_responsible = NULL,
             try_again = 3,
           time_try_again = 3,
             verbose = TRUE,
             responsible = NULL,
             token = get_todoist_api_token(),
           les_taches = get_tasks(token = token)) {
    if (verbose) {
      message(glue::glue("create {task} in the {project_id} project"))
    }

    # couteux en call api on commente pour le moment

    if (!is.null(responsible)) {
      proj_id <- project_id
      id_user <- get_user_id(mail = responsible)
      add_user_in_project(project_id = proj_id, mail = responsible)
    } else {
      id_user <- "null"
    }

    tache <- les_taches %>%
      flatten() %>%
      map(`[`, c("content", "project_id"))
    tache_project <-
      map_lgl(c(1:length(tache)), ~ tache[[.x]]["project_id"] == project_id)
    tache <- keep(tache, tache_project) %>%
      map_chr("content")

    if (task %in% tache) {
      message(glue("The task {task} already exists in this project"))
      return(invisible(project_id))
    } else {
      res <- POST(
        "https://todoist.com/api/v8/sync",
        body = list(
          "token" = token,
          "sync_token" = "*",
          resource_types = '["projects","items"]',
          commands = glue(
            '[{ "type": "item_add",
            "temp_id": "<random_key()>",
            "uuid": "<random_key()>",
            "args": { "project_id": "<project_id>", "content": "<task>", "responsible_uid" : <id_user>}]',
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

        res <- POST(
          "https://todoist.com/api/v8/sync",
          body = list(
            "token" = token,
            "sync_token" = "*",
            resource_types = '["projects","items"]',
            commands = glue(
              '[{ "type": "item_add",
              "temp_id": "<random_key()>",
              "uuid": "<random_key()>",
              "args": { "project_id": "<project_id>", "content": "<task>", "responsible_uid" : <id_user> } }]',
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
      # %>%invisible()
      # print()
    }

    # on rajoute le responsable








    invisible(project_id)
  }

#' Add a list of tasks
#'
#' @param token token
#' @param project_id id of project
#' @param tasks_list list of tasks
#' @param try_again start again the request
#' @param verbose make it talk
#'
#' @export
#'
#' @importFrom purrr map
#'

add_tasks_in_project <- function(project_id,
                                 tasks_list,
                                 try_again = 3,
                                 time_try_again = 3,
                                 verbose = TRUE,
                                 responsible = NULL,
                                 token = get_todoist_api_token()) {

  les_taches <- get_tasks(token = token) # on le sort ici pour ne pas l'appeler a chaque nouvelle tache

  # on devrait virer ici de tasks_list ce qui est deja dans le projet
  tache <- les_taches %>%
    flatten() %>%
    map(`[`, c("content", "project_id"))
  tache_project <-
    map_lgl(c(1:length(tache)), ~ tache[[.x]]["project_id"] == project_id)
  tache <- keep(tache, tache_project) %>%
    map_chr("content")





setdiff(unlist(tasks_list),tache) %>%
    map(
      ~ add_task_in_project(
        project_id = project_id,
        token = token,
        try_again = try_again,time_try_again = time_try_again,
        task = .x,
        responsible = responsible,
        verbose = verbose,
        les_taches = les_taches
      )
    )
  invisible(project_id)
}


#' Add responsible to a task
#'
#' @param project_id id of the project
#' @param task the all name of the task
#' @param verbose make the function verbose
#' @param token token
#' @param add_responsible add someone to this task with mail
#'
#' @importFrom purrr pluck set_names keep map_dbl
#' @export

add_responsible_to_task <- function(project_id,
                                    add_responsible,
                                    task,
                                    verbose,
                                    token = get_todoist_api_token()) {
  res <- get_tasks(token = token) %>%
    pluck("items") %>%
    set_names(map_dbl(., "project_id"))
  tasks_of_project <- names(res) == project_id
  tasks <- keep(res, tasks_of_project)
  get_my_taks <- tasks %>%
    map(~ .x == task) %>%
    map_lgl(~ isTRUE(.x[["content"]]))
  my_task <- keep(tasks, get_my_taks) %>% flatten()
  id_task <- as.numeric(my_task[["id"]])
  id_user <- get_user_id(mail = add_responsible)
  POST(
    "https://todoist.com/api/v8/sync",
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
