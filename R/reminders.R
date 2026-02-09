#' Add a reminder to a task
#'
#' @param task_id id of the task
#' @param due_date due date for the reminder (format: YYYY-MM-DD)
#' @param due_datetime due datetime for the reminder (format: YYYY-MM-DDTHH:MM:SS)
#' @param minute_offset minutes before due time to remind (for relative reminders)
#' @param type type of reminder: "absolute", "relative", or "location"
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the new reminder
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' add_reminder(task_id = "12345", due_datetime = "2024-12-25T09:00:00")
#' add_reminder(task_id = "12345", minute_offset = 30, type = "relative")
#' }
add_reminder <- function(task_id,
                         due_date = NULL,
                         due_datetime = NULL,
                         minute_offset = NULL,
                         type = "absolute",
                         verbose = TRUE,
                         token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Adding reminder to task {task_id}"))
  }

  args_parts <- c(glue('"item_id": "{escape_json(task_id)}"'), glue('"type": "{escape_json(type)}"'))

  if (!is.null(due_datetime)) {
    args_parts <- c(args_parts, glue('"due": {{"date": "{escape_json(due_datetime)}"}}'))
  } else if (!is.null(due_date)) {
    args_parts <- c(args_parts, glue('"due": {{"date": "{escape_json(due_date)}"}}'))
  }

  if (!is.null(minute_offset)) {
    args_parts <- c(args_parts, glue('"minute_offset": {minute_offset}'))
  }

  args_json <- paste(args_parts, collapse = ", ")
  temp_id <- random_key()

  result <- call_api(
    token = token,
    sync_token = "*",
    resource_types = '["reminders"]',
    commands = glue('[{{"type": "reminder_add", "temp_id": "{temp_id}", "uuid": "{random_key()}", "args": {{{args_json}}}}}]')
  )

  reminder_id <- result$temp_id_mapping[[temp_id]]
  invisible(reminder_id)
}

#' Get all reminders
#'
#' @param token todoist API token
#'
#' @return tibble of all reminders
#' @export
#' @importFrom purrr map_dfr pluck
#'
#' @examples
#' \dontrun{
#' get_all_reminders()
#' }
get_all_reminders <- function(token = get_todoist_api_token()) {
  force(token)

  result <- call_api(
    token = token,
    sync_token = "*",
    resource_types = '["reminders"]'
  )

  reminders <- result %>% pluck("reminders")

  if (is.null(reminders) || length(reminders) == 0) {
    return(data.frame(
      id = character(),
      item_id = character(),
      type = character(),
      due_date = character(),
      minute_offset = integer(),
      stringsAsFactors = FALSE
    ))
  }

  map_dfr(reminders, function(x) {
    due_date <- if (!is.null(x$due)) x$due$date else NA_character_
    data.frame(
      id = x$id %||% NA_character_,
      item_id = x$item_id %||% NA_character_,
      type = x$type %||% NA_character_,
      due_date = due_date,
      minute_offset = x$minute_offset %||% NA_integer_,
      stringsAsFactors = FALSE
    )
  })
}

#' Update a reminder
#'
#' @param reminder_id id of the reminder
#' @param due_date new due date for the reminder (format: YYYY-MM-DD)
#' @param due_datetime new due datetime for the reminder (format: YYYY-MM-DDTHH:MM:SS)
#' @param minute_offset new minutes before due time to remind
#' @param type new type of reminder
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return id of the updated reminder (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' update_reminder("12345", due_datetime = "2024-12-26T10:00:00")
#' }
update_reminder <- function(reminder_id,
                            due_date = NULL,
                            due_datetime = NULL,
                            minute_offset = NULL,
                            type = NULL,
                            verbose = TRUE,
                            token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Updating reminder {reminder_id}"))
  }

  args_parts <- c(glue('"id": "{escape_json(reminder_id)}"'))

  if (!is.null(due_datetime)) {
    args_parts <- c(args_parts, glue('"due": {{"date": "{escape_json(due_datetime)}"}}'))
  } else if (!is.null(due_date)) {
    args_parts <- c(args_parts, glue('"due": {{"date": "{escape_json(due_date)}"}}'))
  }

  if (!is.null(minute_offset)) {
    args_parts <- c(args_parts, glue('"minute_offset": {minute_offset}'))
  }

  if (!is.null(type)) {
    args_parts <- c(args_parts, glue('"type": "{escape_json(type)}"'))
  }

  args_json <- paste(args_parts, collapse = ", ")

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "reminder_update", "uuid": "{random_key()}", "args": {{{args_json}}}}}]')
  )

  invisible(reminder_id)
}

#' Delete a reminder
#'
#' @param reminder_id id of the reminder
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' delete_reminder("12345")
#' }
delete_reminder <- function(reminder_id,
                            verbose = TRUE,
                            token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Deleting reminder {reminder_id}"))
  }

  call_api(
    token = token,
    sync_token = "*",
    commands = glue('[{{"type": "reminder_delete", "uuid": "{random_key()}", "args": {{"id": "{escape_json(reminder_id)}"}}}}]')
  )

  invisible(NULL)
}
