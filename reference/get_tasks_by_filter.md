# Get tasks by filter query

Get tasks by filter query

## Usage

``` r
get_tasks_by_filter(query, token = get_todoist_api_token())
```

## Arguments

- query:

  filter query string (e.g., "today", "p1 & \#Work")

- token:

  todoist API token

## Value

tibble of tasks matching the filter

## Examples

``` r
if (FALSE) { # \dontrun{
get_tasks_by_filter("today")
get_tasks_by_filter("p1 & #Work")
} # }
```
