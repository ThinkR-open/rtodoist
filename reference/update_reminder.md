# Update a reminder

Update a reminder

## Usage

``` r
update_reminder(
  reminder_id,
  due_date = NULL,
  due_datetime = NULL,
  minute_offset = NULL,
  type = NULL,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- reminder_id:

  id of the reminder

- due_date:

  new due date for the reminder (format: YYYY-MM-DD)

- due_datetime:

  new due datetime for the reminder (format: YYYY-MM-DDTHH:MM:SS)

- minute_offset:

  new minutes before due time to remind

- type:

  new type of reminder

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the updated reminder (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
update_reminder("12345", due_datetime = "2024-12-26T10:00:00")
} # }
```
