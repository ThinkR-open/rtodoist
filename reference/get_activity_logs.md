# Get activity logs

Get activity logs

## Usage

``` r
get_activity_logs(
  object_type = NULL,
  object_id = NULL,
  event_type = NULL,
  parent_project_id = NULL,
  parent_item_id = NULL,
  initiator_id = NULL,
  since = NULL,
  until = NULL,
  limit = 30,
  offset = 0,
  token = get_todoist_api_token()
)
```

## Arguments

- object_type:

  filter by object type (e.g., "project", "item", "note")

- object_id:

  filter by specific object id

- event_type:

  filter by event type (e.g., "added", "updated", "completed")

- parent_project_id:

  filter by parent project id

- parent_item_id:

  filter by parent item id

- initiator_id:

  filter by user who initiated the action

- since:

  return events since this date (format: YYYY-MM-DDTHH:MM:SS)

- until:

  return events until this date (format: YYYY-MM-DDTHH:MM:SS)

- limit:

  maximum number of events to return (default 30, max 100)

- offset:

  offset for pagination

- token:

  todoist API token

## Value

tibble of activity events

## Examples

``` r
if (FALSE) { # \dontrun{
get_activity_logs()
get_activity_logs(object_type = "item", event_type = "completed")
} # }
```
