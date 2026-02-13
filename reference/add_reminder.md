# Add a reminder to a task

Add a reminder to a task

## Usage

``` r
add_reminder(
  task_id,
  due_date = NULL,
  due_datetime = NULL,
  minute_offset = NULL,
  type = "absolute",
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- task_id:

  id of the task

- due_date:

  due date for the reminder (format: YYYY-MM-DD)

- due_datetime:

  due datetime for the reminder (format: YYYY-MM-DDTHH:MM:SS)

- minute_offset:

  minutes before due time to remind (for relative reminders)

- type:

  type of reminder: "absolute", "relative", or "location"

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the new reminder

## Examples

``` r
if (FALSE) { # \dontrun{
add_reminder(task_id = "12345", due_datetime = "2024-12-25T09:00:00")
add_reminder(task_id = "12345", minute_offset = 30, type = "relative")
} # }
```
