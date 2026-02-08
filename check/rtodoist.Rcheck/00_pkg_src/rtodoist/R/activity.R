#' Get activity logs
#'
#' @param object_type filter by object type (e.g., "project", "item", "note")
#' @param object_id filter by specific object id
#' @param event_type filter by event type (e.g., "added", "updated", "completed")
#' @param parent_project_id filter by parent project id
#' @param parent_item_id filter by parent item id
#' @param initiator_id filter by user who initiated the action
#' @param since return events since this date (format: YYYY-MM-DDTHH:MM:SS)
#' @param until return events until this date (format: YYYY-MM-DDTHH:MM:SS)
#' @param limit maximum number of events to return (default 30, max 100)
#' @param offset offset for pagination
#' @param token todoist API token
#'
#' @return tibble of activity events
#' @export
#' @importFrom purrr map_dfr
#'
#' @examples
#' \dontrun{
#' get_activity_logs()
#' get_activity_logs(object_type = "item", event_type = "completed")
#' }
get_activity_logs <- function(object_type = NULL,
                              object_id = NULL,
                              event_type = NULL,
                              parent_project_id = NULL,
                              parent_item_id = NULL,
                              initiator_id = NULL,
                              since = NULL,
                              until = NULL,
                              limit = 30,
                              offset = 0,
                              token = get_todoist_api_token()) {
  force(token)

  params <- list(limit = limit, offset = offset)
  if (!is.null(object_type)) params$object_type <- object_type
  if (!is.null(object_id)) params$object_id <- object_id
  if (!is.null(event_type)) params$event_type <- event_type
  if (!is.null(parent_project_id)) params$parent_project_id <- parent_project_id
  if (!is.null(parent_item_id)) params$parent_item_id <- parent_item_id
  if (!is.null(initiator_id)) params$initiator_id <- initiator_id
  if (!is.null(since)) params$since <- since
  if (!is.null(until)) params$until <- until

  response <- do.call(call_api_rest, c(list("activity_logs", token = token), params))

  events <- response$events
  if (is.null(events)) {
    events <- response$results
  }

  if (is.null(events) || length(events) == 0) {
    return(data.frame(
      id = character(),
      object_type = character(),
      object_id = character(),
      event_type = character(),
      event_date = character(),
      stringsAsFactors = FALSE
    ))
  }

  map_dfr(events, function(x) {
    data.frame(
      id = x$id %||% NA_character_,
      object_type = x$object_type %||% NA_character_,
      object_id = x$object_id %||% NA_character_,
      event_type = x$event_type %||% NA_character_,
      event_date = x$event_date %||% NA_character_,
      initiator_id = x$initiator_id %||% NA_character_,
      parent_project_id = x$parent_project_id %||% NA_character_,
      parent_item_id = x$parent_item_id %||% NA_character_,
      stringsAsFactors = FALSE
    )
  })
}
