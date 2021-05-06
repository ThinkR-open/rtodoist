
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
  # x[x==""] <- NULL
  # x[x==" "] <- NULL
  # x[is.na(x)] <- NULL
  # x
  x<-x[!is.na(x)]
  x <- x[!x %in% c(""," ")]
  x
}

clean_section <- function(section_id){
  
  if(is.null(section_id)){
    section_id <- "null"
  }
  as.character(section_id)
  
}

#' @import purrr
get_tasks_to_add <- function(tasks_list,existing_tasks,project_id, sections_id = NULL){
  
  sections_id <- as.integer(sections_id)
  
  if(is.data.frame(tasks_list)){
    
  }else{
    
  }
  
  if(!is.null(sections_id)){
    tasks_to_add <- map2_df(tasks_list, sections_id,~ list(content = .x, section_id = .y))
  }else{
    tasks_to_add <- tasks_list
  }
  
  tache <- existing_tasks %>%
    map(~ .x %>% modify_if(is.null, ~ 0)) %>% 
    map(~ .x %>% modify_if(is.na, ~ 0)) %>% 
    map_dfr(`[`,c("content","section_id")) 
  
  tasks <- tasks_to_add %>% anti_join(tache)
  
  if(nrow(tasks) == 0){
    message("All tasks in the project")
    return(NULL)
  }else{
    tasks
  }
  
}