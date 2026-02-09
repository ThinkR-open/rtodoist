#' Add a new filter
#'
#' @param name name of the filter
#' @param query filter query string (e.g., "today | overdue", "p1 & #Work")
#' @param color color of the filter
#' @param is_favorite boolean to mark as favorite
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the new filter
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' add_filter("Urgent Today", query = "today & p1")
#' add_filter("Work Tasks", query = "#Work", color = "blue")
#' }
add_filter <- function(name,
                       query,
                       color = NULL,
                       is_favorite = FALSE,
                       verbose = TRUE,
                       token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Creating filter: {name}"))
  }

  args_parts <- c(
    glue('"name": "{escape_json(name)}"'),
    glue('"query": "{escape_json(query)}"')
  )

  if (!is.null(color)) {
    args_parts <- c(args_parts, glue('"color": "{color}"'))
  }
  if (is_favorite) {
    args_parts <- c(args_parts, '"is_favorite": true')
  }

  args_json <- paste(args_parts, collapse = ", ")
  temp_id <- random_key()

  result <- call_api(
    token = token,
    sync_token = "*",
    resource_types = '["filters"]',
    commands = glue('[{{"type": "filter_add", "temp_id": "{temp_id}", "uuid": "{random_key()}", "args": {{{args_json}}}}}]')
  )

  filter_id <- result$temp_id_mapping[[temp_id]]
  invisible(filter_id)
}

#' Get all filters
#'
#' @param token todoist API token
#'
#' @return tibble of all filters
#' @export
#' @importFrom purrr map_dfr pluck
#'
#' @examples
#' \dontrun{
#' get_all_filters()
#' }
get_all_filters <- function(token = get_todoist_api_token()) {
  force(token)

  result <- call_api(
    token = token,
    sync_token = "*",
    resource_types = '["filters"]'
  )

  filters <- result %>% pluck("filters")

  if (is.null(filters) || length(filters) == 0) {
    return(data.frame(
      id = character(),
      name = character(),
      query = character(),
      color = character(),
      is_favorite = logical(),
      stringsAsFactors = FALSE
    ))
  }

  map_dfr(filters, function(x) {
    data.frame(
      id = x$id %||% NA_character_,
      name = x$name %||% NA_character_,
      query = x$query %||% NA_character_,
      color = x$color %||% NA_character_,
      is_favorite = x$is_favorite %||% FALSE,
      stringsAsFactors = FALSE
    )
  })
}

#' Get a single filter by ID
#'
#' @param filter_id id of the filter
#' @param token todoist API token
#'
#' @return list with filter details
#' @export
#' @importFrom purrr pluck keep
#'
#' @examples
#' \dontrun{
#' get_filter("12345")
#' }
get_filter <- function(filter_id, token = get_todoist_api_token()) {
  force(token)

  result <- call_api(
    token = token,
    sync_token = "*",
    resource_types = '["filters"]'
  )

  filters <- result %>% pluck("filters")

  if (is.null(filters) || length(filters) == 0) {
    return(NULL)
  }

  matching <- keep(filters, ~ .x$id == filter_id)
  if (length(matching) == 0) {
    return(NULL)
  }

  matching[[1]]
}

#' Get filter id by name
#'
#' @param filter_name name of the filter
#' @param all_filters result of get_all_filters (optional)
#' @param token todoist API token
#'
#' @return id of the filter
#' @export
#' @importFrom dplyr filter pull
#'
#' @examples
#' \dontrun{
#' get_filter_id("Urgent Today")
#' }
get_filter_id <- function(filter_name,
                          all_filters = get_all_filters(token = token),
                          token = get_todoist_api_token()) {
  force(token)

  id <- all_filters %>%
    dplyr::filter(name == filter_name) %>%
    pull(id)

  if (length(id) == 0) {
    stop("Filter not found: ", filter_name)
  }

  id[1]
}

#' Update a filter
#'
#' @param filter_id id of the filter
#' @param filter_name name of the filter (for lookup if filter_id not provided)
#' @param new_name new name for the filter
#' @param query new query string
#' @param color new color
#' @param is_favorite boolean to mark as favorite
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the updated filter (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' update_filter(filter_name = "Urgent Today", query = "today & p1 & #Work")
#' }
update_filter <- function(filter_id = get_filter_id(filter_name = filter_name, token = token),
                          filter_name,
                          new_name = NULL,
                          query = NULL,
                          color = NULL,
                          is_favorite = NULL,
                          verbose = TRUE,
                          token = get_todoist_api_token()) {
  force(filter_id)
  force(token)

  args_parts <- c(glue('"id": "{filter_id}"'))

  if (!is.null(new_name)) {
    args_parts <- c(args_parts, glue('"name": "{escape_json(new_name)}"'))
  }
  if (!is.null(query)) {
    args_parts <- c(args_parts, glue('"query": "{escape_json(query)}"'))
  }
  if (!is.null(color)) {
    args_parts <- c(args_parts, glue('"color": "{color}"'))
  }
  if (!is.null(is_favorite)) {
    fav_val <- ifelse(is_favorite, "true", "false")
    args_parts <- c(args_parts, glue('"is_favorite": {fav_val}'))
  }

  args_json <- paste(args_parts, collapse = ", ")

  if (verbose) {
    message(glue::glue("Updating filter {filter_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "filter_update", "uuid": "{random_key()}", "args": {{{args_json}}}}}]')
  )

  invisible(filter_id)
}

#' Delete a filter
#'
#' @param filter_id id of the filter
#' @param filter_name name of the filter (for lookup if filter_id not provided)
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' delete_filter(filter_name = "Urgent Today")
#' }
delete_filter <- function(filter_id = get_filter_id(filter_name = filter_name, token = token),
                          filter_name,
                          verbose = TRUE,
                          token = get_todoist_api_token()) {
  force(filter_id)
  force(token)

  if (verbose) {
    message(glue::glue("Deleting filter {filter_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "filter_delete", "uuid": "{random_key()}", "args": {{"id": "{filter_id}"}}}}]')
  )

  invisible(NULL)
}

#' Get tasks by filter query
#'
#' @param query filter query string (e.g., "today", "p1 & #Work")
#' @param token todoist API token
#'
#' @return tibble of tasks matching the filter
#' @export
#' @importFrom purrr map_dfr
#'
#' @examples
#' \dontrun{
#' get_tasks_by_filter("today")
#' get_tasks_by_filter("p1 & #Work")
#' }
get_tasks_by_filter <- function(query,
                                token = get_todoist_api_token()) {
  force(token)

  all_results <- list()
  cursor <- NULL

  repeat {
    response <- call_api_rest("tasks/filter", token = token, query = query, cursor = cursor)
    all_results <- c(all_results, response$results)

    if (is.null(response$next_cursor)) {
      break
    }
    cursor <- response$next_cursor
  }

  if (length(all_results) == 0) {
    return(data.frame(
      id = character(),
      content = character(),
      project_id = character(),
      section_id = character(),
      priority = integer(),
      due_date = character(),
      stringsAsFactors = FALSE
    ))
  }

  map_dfr(all_results, function(x) {
    due_date <- if (!is.null(x$due)) x$due$date else NA_character_
    data.frame(
      id = x$id %||% NA_character_,
      content = x$content %||% NA_character_,
      project_id = x$project_id %||% NA_character_,
      section_id = x$section_id %||% NA_character_,
      priority = x$priority %||% NA_integer_,
      due_date = due_date,
      stringsAsFactors = FALSE
    )
  })
}
