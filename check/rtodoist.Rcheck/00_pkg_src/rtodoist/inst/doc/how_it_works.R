## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  eval=FALSE,
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
# library(rtodoist)
# rtodoist::open_todoist_website_profile()
# token <- "YOURTOKEN" # copied and pasted from website
# library(lubridate)

## -----------------------------------------------------------------------------
# set_todoist_api_token(token)

## -----------------------------------------------------------------------------
# id_proj <- add_project(project_name = "test",verbose = TRUE)

## -----------------------------------------------------------------------------
# id_proj %>%
#   add_tasks_in_project("my_tasks")

## -----------------------------------------------------------------------------
# id_proj %>%
#   add_users_in_project(users_email = "your@mail.fr")

## -----------------------------------------------------------------------------
# id <-  add_project(project_name = "test",verbose = TRUE) %>%
#   add_tasks_in_project(tasks =
#                          c("First task",
#                               "Second task")
#                        )
# id <-  add_project(project_name = "test",verbose = TRUE) %>%
#   add_tasks_in_project(tasks =
#                          c("First task",
#                               "Second task")
#                        )
# id %>%
#   add_responsible_to_task("First task", add_responsible = "user2@mail.com")
# 

## -----------------------------------------------------------------------------
# id_proj %>%
#   add_tasks_in_project(tasks = c("t1","t2"),responsible = c("user1@mail.com"),due = today())

## -----------------------------------------------------------------------------
# 
# id_proj %>%
#   add_tasks_in_project(tasks = c("t1","t2"),responsible = c("user1@mail.com"),due = today() + days(1:2))

## -----------------------------------------------------------------------------
# id_proj %>%
#   add_tasks_in_project(tasks = c("t1","t2"),responsible = c("user1@mail.com","user2@mail.com"),due = lubridate::today(),section_name = c("S1","S2"))

## -----------------------------------------------------------------------------
# 
# tasks_df <- data.frame(
#   "tasks" = LETTERS[1:5],
#   "responsible" = glue::glue("user{1:5}@mail.com"),
#   "due" = today()+ days(1:5),
#   "section_name" = c("S1","S1","S3","S3","S3")
# 
# )
# 
# add_tasks_in_project_from_df(project_id = id_proj,tasks_as_df = tasks_df)

