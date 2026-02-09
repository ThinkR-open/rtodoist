#' Add a new label
#'
#' @param name name of the label
#' @param color color of the label
#' @param is_favorite boolean to mark as favorite
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the new label
#' @export
#' @importFrom glue glue
#' @importFrom purrr pluck
#'
#' @examples
#' \dontrun{
#' add_label("urgent")
#' add_label("work", color = "red")
#' }
add_label <- function(name,
                      color = NULL,
                      is_favorite = FALSE,
                      verbose = TRUE,
                      token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Creating label: {name}"))
  }

  # Check if label already exists
  existing_labels <- get_all_labels(token = token)
  if (name %in% existing_labels$name) {
    message("This label already exists")
    return(existing_labels$id[existing_labels$name == name][1])
  }

  args_parts <- c(glue('"name": "{escape_json(name)}"'))

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
    resource_types = '["labels"]',
    commands = glue('[{{"type": "label_add", "temp_id": "{temp_id}", "uuid": "{random_key()}", "args": {{{args_json}}}}}]')
  )

  # Get the label id from temp_id_mapping
  label_id <- result$temp_id_mapping[[temp_id]]
  if (is.null(label_id)) {
    # Fallback: get from labels list
    labels <- get_all_labels(token = token)
    label_id <- labels$id[labels$name == name][1]
  }

  invisible(label_id)
}

#' Get all labels
#'
#' @param token todoist API token
#'
#' @return tibble of all labels
#' @export
#' @importFrom purrr map_dfr
#'
#' @examples
#' \dontrun{
#' get_all_labels()
#' }
get_all_labels <- function(token = get_todoist_api_token()) {
  all_results <- list()
  cursor <- NULL

  repeat {
    response <- call_api_rest("labels", token = token, cursor = cursor)
    all_results <- c(all_results, response$results)

    if (is.null(response$next_cursor)) {
      break
    }
    cursor <- response$next_cursor
  }

  if (length(all_results) == 0) {
    return(data.frame(
      id = character(),
      name = character(),
      color = character(),
      is_favorite = logical(),
      stringsAsFactors = FALSE
    ))
  }

  map_dfr(all_results, function(x) {
    data.frame(
      id = x$id %||% NA_character_,
      name = x$name %||% NA_character_,
      color = x$color %||% NA_character_,
      is_favorite = x$is_favorite %||% FALSE,
      stringsAsFactors = FALSE
    )
  })
}

#' Get a single label by ID
#'
#' @param label_id id of the label
#' @param token todoist API token
#'
#' @return list with label details
#' @export
#'
#' @examples
#' \dontrun{
#' get_label("12345")
#' }
get_label <- function(label_id, token = get_todoist_api_token()) {
  force(token)
  call_api_rest(glue("labels/{label_id}"), token = token)
}

#' Get label id by name
#'
#' @param label_name name of the label
#' @param all_labels result of get_all_labels (optional)
#' @param token todoist API token
#' @param create boolean create label if needed
#'
#' @return id of the label
#' @export
#' @importFrom dplyr filter pull
#'
#' @examples
#' \dontrun{
#' get_label_id("urgent")
#' }
get_label_id <- function(label_name,
                         all_labels = get_all_labels(token = token),
                         token = get_todoist_api_token(),
                         create = TRUE) {
  force(token)

  id <- all_labels %>%
    filter(name == label_name) %>%
    pull(id)

  if (length(id) == 0) {
    if (create) {
      message("Label doesn't exist, creating it")
      id <- add_label(name = label_name, token = token, verbose = FALSE)
    } else {
      stop("Label not found: ", label_name)
    }
  }

  id[1]
}

#' Update a label
#'
#' @param label_id id of the label
#' @param label_name name of the label (for lookup if label_id not provided)
#' @param new_name new name for the label
#' @param color new color for the label
#' @param is_favorite boolean to mark as favorite
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the updated label (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' update_label(label_name = "urgent", new_name = "very_urgent")
#' }
update_label <- function(label_id = get_label_id(label_name = label_name, token = token, create = FALSE),
                         label_name,
                         new_name = NULL,
                         color = NULL,
                         is_favorite = NULL,
                         verbose = TRUE,
                         token = get_todoist_api_token()) {
  force(label_id)
  force(token)

  args_parts <- c(glue('"id": "{label_id}"'))

  if (!is.null(new_name)) {
    args_parts <- c(args_parts, glue('"name": "{escape_json(new_name)}"'))
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
    message(glue::glue("Updating label {label_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "label_update", "uuid": "{random_key()}", "args": {{{args_json}}}}}]')
  )

  invisible(label_id)
}

#' Delete a label
#'
#' @param label_id id of the label
#' @param label_name name of the label (for lookup if label_id not provided)
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' delete_label(label_name = "urgent")
#' }
delete_label <- function(label_id = get_label_id(label_name = label_name, token = token, create = FALSE),
                         label_name,
                         verbose = TRUE,
                         token = get_todoist_api_token()) {
  force(label_id)
  force(token)

  if (verbose) {
    message(glue::glue("Deleting label {label_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "label_delete", "uuid": "{random_key()}", "args": {{"id": "{label_id}"}}}}]')
  )

  invisible(NULL)
}

#' Get shared labels
#'
#' @param token todoist API token
#'
#' @return tibble of shared labels
#' @export
#' @importFrom purrr map_dfr
#'
#' @examples
#' \dontrun{
#' get_shared_labels()
#' }
get_shared_labels <- function(token = get_todoist_api_token()) {
  all_results <- list()
  cursor <- NULL

  repeat {
    response <- call_api_rest("labels/shared", token = token, cursor = cursor)
    # Shared labels endpoint returns a list directly
    if (is.null(response$results)) {
      all_results <- response
      break
    }
    all_results <- c(all_results, response$results)

    if (is.null(response$next_cursor)) {
      break
    }
    cursor <- response$next_cursor
  }

  if (length(all_results) == 0) {
    return(data.frame(name = character(), stringsAsFactors = FALSE))
  }

  # Shared labels may just be a list of names
  if (is.character(all_results[[1]])) {
    return(data.frame(name = unlist(all_results), stringsAsFactors = FALSE))
  }

  map_dfr(all_results, function(x) {
    if (is.character(x)) {
      data.frame(name = x, stringsAsFactors = FALSE)
    } else {
      data.frame(
        name = x$name %||% NA_character_,
        stringsAsFactors = FALSE
      )
    }
  })
}

#' Rename a shared label
#'
#' @param old_name current name of the shared label
#' @param new_name new name for the shared label
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom httr2 request req_headers req_body_json req_perform req_error resp_status
#'
#' @examples
#' \dontrun{
#' rename_shared_label("old_name", "new_name")
#' }
rename_shared_label <- function(old_name,
                                new_name,
                                verbose = TRUE,
                                token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Renaming shared label from '{old_name}' to '{new_name}'"))
  }

  request(paste0(TODOIST_REST_URL, "labels/shared/rename")) %>%
    req_headers(
      Authorization = glue::glue("Bearer {token}"),
      "Content-Type" = "application/json"
    ) %>%
    req_body_json(list(name = old_name, new_name = new_name)) %>%
    req_error(is_error = function(resp) resp_status(resp) >= 400) %>%
    req_perform()

  invisible(NULL)
}

#' Remove a shared label
#'
#' @param name name of the shared label to remove
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom httr2 request req_headers req_body_json req_perform req_error resp_status
#'
#' @examples
#' \dontrun{
#' remove_shared_label("label_name")
#' }
remove_shared_label <- function(name,
                                verbose = TRUE,
                                token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Removing shared label: {name}"))
  }

  request(paste0(TODOIST_REST_URL, "labels/shared/remove")) %>%
    req_headers(
      Authorization = glue::glue("Bearer {token}"),
      "Content-Type" = "application/json"
    ) %>%
    req_body_json(list(name = name)) %>%
    req_error(is_error = function(resp) resp_status(resp) >= 400) %>%
    req_perform()

  invisible(NULL)
}
