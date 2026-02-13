# Get completed tasks

Get completed tasks

## Usage

``` r
get_completed_tasks(
  project_id = NULL,
  since = NULL,
  until = NULL,
  limit = 50,
  token = get_todoist_api_token()
)
```

## Arguments

- project_id:

  project id to filter by (optional)

- since:

  return tasks completed since this date (optional, format:
  YYYY-MM-DDTHH:MM:SS)

- until:

  return tasks completed until this date (optional, format:
  YYYY-MM-DDTHH:MM:SS)

- limit:

  maximum number of tasks to return (default 50, max 200)

- token:

  todoist API token

## Value

tibble of completed tasks

## Examples

``` r
if (FALSE) { # \dontrun{
get_completed_tasks()
get_completed_tasks(project_id = "12345")
} # }
```
