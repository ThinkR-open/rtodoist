
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
  x[x==""] <- NULL
  x[x==" "] <- NULL
  x[is.na(x)] <- NULL
  x
}

clean_section <- function(section_id){
  
  if(is.null(section_id)){
    section_id <- "null"
  }
  section_id
  
}

#' @import purrr
get_tasks_to_add <- function(tasks_list,existing_tasks){
  tache <- existing_tasks %>%
    flatten() %>%
    map(`[`, c("content", "project_id"))
  
  tache_project <- map_lgl(seq_along(tache), 
                           ~ tache[[.x]]["project_id"] == project_id)
  tache <- keep(tache, tache_project) %>%
    map_chr("content")
  
  setdiff(unlist(tasks_list), tache)
  
}