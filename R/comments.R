#' Add a comment to a task or project
#'
#' @param content content of the comment
#' @param task_id id of the task (either task_id or project_id required)
#' @param project_id id of the project (either task_id or project_id required)
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the new comment
#' @export
#' @importFrom glue glue
#' @importFrom httr2 request req_headers req_body_json req_perform resp_body_json req_error resp_status
#'
#' @examples
#' \dontrun{
#' add_comment(content = "This is a comment", task_id = "12345")
#' add_comment(content = "Project comment", project_id = "67890")
#' }
add_comment <- function(content,
                        task_id = NULL,
                        project_id = NULL,
                        verbose = TRUE,
                        token = get_todoist_api_token()) {
  force(token)

  if (is.null(task_id) && is.null(project_id)) {
    stop("Either task_id or project_id must be provided")
  }

  if (verbose) {
    if (!is.null(task_id)) {
      message(glue::glue("Adding comment to task {task_id}"))
    } else {
      message(glue::glue("Adding comment to project {project_id}"))
    }
  }

  body <- list(content = content)
  if (!is.null(task_id)) {
    body$task_id <- task_id
  }
  if (!is.null(project_id)) {
    body$project_id <- project_id
  }

  result <- request(paste0(TODOIST_REST_URL, "comments")) %>%
    req_headers(
      Authorization = glue::glue("Bearer {token}"),
      "Content-Type" = "application/json"
    ) %>%
    req_body_json(body) %>%
    req_error(is_error = function(resp) resp_status(resp) >= 400) %>%
    req_perform() %>%
    resp_body_json()

  invisible(result$id)
}

#' Get comments
#'
#' @param task_id id of the task (either task_id or project_id required)
#' @param project_id id of the project (either task_id or project_id required)
#' @param token todoist API token
#'
#' @return tibble of comments
#' @export
#' @importFrom purrr map_dfr
#'
#' @examples
#' \dontrun{
#' get_comments(task_id = "12345")
#' get_comments(project_id = "67890")
#' }
get_comments <- function(task_id = NULL,
                         project_id = NULL,
                         token = get_todoist_api_token()) {
  force(token)

  if (is.null(task_id) && is.null(project_id)) {
    stop("Either task_id or project_id must be provided")
  }

  all_results <- list()
  cursor <- NULL

  repeat {
    if (!is.null(task_id)) {
      response <- call_api_rest("comments", token = token, task_id = task_id, cursor = cursor)
    } else {
      response <- call_api_rest("comments", token = token, project_id = project_id, cursor = cursor)
    }

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
      task_id = character(),
      project_id = character(),
      posted_at = character(),
      stringsAsFactors = FALSE
    ))
  }

  map_dfr(all_results, function(x) {
    data.frame(
      id = x$id %||% NA_character_,
      content = x$content %||% NA_character_,
      task_id = x$task_id %||% NA_character_,
      project_id = x$project_id %||% NA_character_,
      posted_at = x$posted_at %||% NA_character_,
      stringsAsFactors = FALSE
    )
  })
}

#' Get a single comment by ID
#'
#' @param comment_id id of the comment
#' @param token todoist API token
#'
#' @return list with comment details
#' @export
#'
#' @examples
#' \dontrun{
#' get_comment("12345")
#' }
get_comment <- function(comment_id, token = get_todoist_api_token()) {
  force(token)
  call_api_rest(glue("comments/{comment_id}"), token = token)
}

#' Update a comment
#'
#' @param comment_id id of the comment
#' @param content new content for the comment
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the updated comment (invisible)
#' @export
#' @importFrom httr2 request req_headers req_body_json req_perform req_method req_error resp_status
#'
#' @examples
#' \dontrun{
#' update_comment("12345", content = "Updated comment")
#' }
update_comment <- function(comment_id,
                           content,
                           verbose = TRUE,
                           token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Updating comment {comment_id}"))
  }

  request(glue("{TODOIST_REST_URL}comments/{comment_id}")) %>%
    req_method("POST") %>%
    req_headers(
      Authorization = glue::glue("Bearer {token}"),
      "Content-Type" = "application/json"
    ) %>%
    req_body_json(list(content = content)) %>%
    req_error(is_error = function(resp) resp_status(resp) >= 400) %>%
    req_perform()

  invisible(comment_id)
}

#' Delete a comment
#'
#' @param comment_id id of the comment
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom httr2 request req_headers req_perform req_method req_error resp_status
#'
#' @examples
#' \dontrun{
#' delete_comment("12345")
#' }
delete_comment <- function(comment_id,
                           verbose = TRUE,
                           token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Deleting comment {comment_id}"))
  }

  request(glue("{TODOIST_REST_URL}comments/{comment_id}")) %>%
    req_method("DELETE") %>%
    req_headers(
      Authorization = glue::glue("Bearer {token}")
    ) %>%
    req_error(is_error = function(resp) resp_status(resp) >= 400) %>%
    req_perform()

  invisible(NULL)
}
