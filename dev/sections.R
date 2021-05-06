library(rtodoist)
library(digiforma)


session_name <- "AF9055531920"
nom_form <- "form_inter_certif1_ avril2021"


session <- function(...){
  paste0(..., nom_form,"_", session_name)
}


dates <- get_dates_from_session(code_session = session_name)

users <- get_users_from_session(code_session = session_name) 

id_project <- add_project(project_name = session())

## Les evals
id_section <- add_section(id_project, "Evaluation")

eval_chaud <- dates[nrow(dates) -1, ]$date
eval_froid <- as.Date(eval_chaud) + 30
add_task_in_project(id_project, task = session("Eval à chaud "), due = eval_chaud, section_id = id_section)
add_task_in_project(id_project, task = session("Eval à froid "), due = eval_froid, section_id = id_section)

## Qui doit etre la
users_list <- paste0(users$lastname, " ", users$firstname) #, " email : ", users$email ,"\n")

id_section <- add_section(id_project, "Users")

 add_tasks_in_project(id_project, tasks_list = users_list, section_id = id_section)

## mdp

id_section <- add_section(id_project, "credentials")


add_task_in_project(id_project, paste0("admin : ", "formateur_af9055531920-thinkr" ), section_id = id_section)
add_task_in_project(id_project, paste0("mdp : ", "xxxx" ), section_id = id_section)

## emergement

id_section <- add_section(id_project, "Tâche par session")

add_tasks_in_project(id_project, tasks_list = list( paste0("Emergement ", dates$date, " ", sample(1:1000, 1))), section_id = id_section, due = dates$date)
