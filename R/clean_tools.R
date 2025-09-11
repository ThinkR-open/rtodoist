
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
                             token = get_todoist_api_token(),
                             que_si_necessaire = TRUE
                             
                             ){
 out <-  get_tasks_to_(tasks = tasks,
                due = due ,
                responsible_uid = responsible_uid,
                existing_tasks = existing_tasks,
                sections_id = sections_id,
                token = token,join_function = dplyr::inner_join,que_si_necessaire = que_si_necessaire)
  
 return(out)
}


#' @import purrr
#' @importFrom dplyr anti_join inner_join mutate mutate_if case_when
get_tasks_to_ <- function(tasks,
                          due = due,
                          responsible_uid,
                          existing_tasks,
                          sections_id = NULL,
                          token = get_todoist_api_token(),
                          join_function = list(dplyr::inner_join,
                                               dplyr::anti_join),que_si_necessaire = FALSE
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
      map(~ .x %>% modify_if(is.null, ~ "0")) %>% 
      map(~ .x %>% modify_if(is.na, ~ "0")) %>% 
      map_dfr(`[`,c("content","section_id","id","responsible_uid")) %>% 
      mutate(responsible_uid = as.character(responsible_uid))
    
    # ce qui est a "0" doit etre mis en null avant la jointure
    
    tache <-   tache %>%
      mutate_if(is.character,
                ~case_when(.x == "0"~ "null",
                           TRUE ~.x
                           )
                ) %>%
      mutate("section_id" = as.character(section_id))

    # browser()
    tasks_ok <- tasks_to_add %>% mutate(
      savecontent = content,
      content = tolower(content)) %>% 
      mutate("section_id" = as.character(section_id)) %>% 
      join_function(tache %>% mutate(content = tolower(content)),by = c("content", "section_id","responsible_uid")) %>% 
      mutate(content = savecontent) %>% select(-savecontent)
    
    # ici il ya un soucis si le responsible_ui est manquant
   
    
    # on test une autre approche
    # browser()
    tasks_ok <- tasks_to_add %>%
      mutate("section_id" = as.character(section_id)) %>%
      join_function(tache %>% dplyr::select(-responsible_uid),by = c("content", "section_id"))

    # A %>%  inner_join(B %>% select(-responsible_uid),by = c("content", "section_id"))
    tasks_ok <- tasks_to_add %>% mutate(
      savecontent = content,
      content = tolower(content)) %>% 
      mutate("section_id" = as.character(section_id)) %>% 
      join_function(tache %>% mutate(content = tolower(content))%>% dplyr::select(-responsible_uid),by = c("content", "section_id"
                                                                                                           # ,"responsible_uid"
                                                                                                           )) %>% 
      mutate(content = savecontent) %>% select(-savecontent)
    
    if ( que_si_necessaire) {
      
      tasks_ok <- tasks_ok %>%  anti_join(tache,by = c("content", "section_id","responsible_uid")) 
      
      
    }
    
    
    
  } else{
    tasks_ok <- tasks_to_add
  }
  
  if(nrow(tasks_ok) == 0){
    message("Nothing to do")
    return(data.frame())
  }else{
    tasks_ok
  }
  
}