
#' @importFrom stringr str_trim str_replace
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
get_tasks_to_add <- function(tasks_list,existing_tasks,project_id, sections_id = NULL){
 
  if(!is.null(sections_id) ){ #& !is.na(sections_id)
    tasks_to_add <- map2_df(tasks_list, sections_id,~list(content = .x, section_id = .y)   )
  }else{
    tasks_to_add <- tasks_list
  }
  
  tasks_to_add$section_id[is.na(tasks_to_add$section_id)] <- 0
  tasks_to_add$section_id["null" == tasks_to_add$section_id] <- 0
  
  if ( length(existing_tasks) > 0){
  
  tache <- existing_tasks %>%
    map(~ .x %>% modify_if(is.null, ~ 0)) %>% 
    map(~ .x %>% modify_if(is.na, ~ 0)) %>% 
    map_dfr(`[`,c("content","section_id")) 
  
  tasks <- tasks_to_add %>% anti_join(tache,by = c("content", "section_id"))
  
  } else{
    tasks <- tasks_to_add
  }
  
  if(nrow(tasks) == 0){
    message("All tasks are already in the project")
    return(NULL)
  }else{
    tasks
  }
  
}