
#' @importFrom stringr str_trim str_replace
#' @importFrom glue glue
clean_due <- function(due){
  
  if(is.null(due)){
    return("null")
  } 
  
  due <- map_chr(due,as.character) %>% stringr::str_trim()
  due[due==""] <- NA
  due[due==" "] <- NA
  due <- stringr::str_replace(glue::glue('"{due}"'), 
                              pattern = "^\"NA\"$","null")
  due
  
}

set_as_null_if_needed <- function(x){
  x<-x[!is.na(x)]
  x <- x[!x %in% c(""," ")]
  x
}

clean_section <- function(section_name){
  
  if(is.null(section_name)){
    section_name <- "null"
  }
  as.character(section_name)
  
}

#' @import purrr
#' @importFrom dplyr anti_join
get_tasks_to_add <- function(tasks,
                             due = due,
                             responsible_uid,
                             existing_tasks,
                             sections_id = NULL,
                             token = get_todoist_api_token()){
 
  get_tasks_to_(tasks = tasks,
                due = due ,
                responsible_uid = responsible_uid,
                existing_tasks = existing_tasks,
                sections_id = sections_id,
                token = token,join_function = dplyr::anti_join)
}





get_tasks_to_update <- function(tasks,
                                due = due,
                                responsible_uid,
                                existing_tasks,
                             sections_id = NULL,
                             token = get_todoist_api_token()){
  get_tasks_to_(tasks = tasks,
                due = due ,
                responsible_uid = responsible_uid,
                existing_tasks = existing_tasks,
                sections_id = sections_id,
                token = token,join_function = dplyr::inner_join)
  
}


#' @import purrr
#' @importFrom dplyr anti_join inner_join mutate
get_tasks_to_ <- function(tasks,
                          due = due,
                          responsible_uid,
                          existing_tasks,
                          sections_id = NULL,
                          token = get_todoist_api_token(),
                          join_function = list(dplyr::inner_join,
                                               dplyr::anti_join)
){
  
  tasks_to_add <- data.frame(
    content = tasks,
    section_id = sections_id, 
    due = due,
    responsible_uid = responsible_uid
  )
  
  tasks_to_add$section_id[is.na(tasks_to_add$section_id)] <- 0
  tasks_to_add$section_id["null" == tasks_to_add$section_id] <- 0
  if ( length(existing_tasks) > 0){
    
    tache <- existing_tasks %>%
      map(~ .x %>% modify_if(is.null, ~ 0)) %>% 
      map(~ .x %>% modify_if(is.na, ~ 0)) %>% 
      map_dfr(`[`,c("content","section_id","id","responsible_uid")) %>% 
      mutate(responsible_uid = as.character(responsible_uid))
    
    tasks_ok <- tasks_to_add %>%  join_function(tache,by = c("content", "section_id","responsible_uid"))
  } else{
    tasks_ok <- tasks_to_add
  }
  
  if(nrow(tasks_ok) == 0){
    message("Nothing to do")
    return(NULL)
  }else{
    tasks_ok
  }
  
}