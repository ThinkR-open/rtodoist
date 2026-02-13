# Get comments

Get comments

## Usage

``` r
get_comments(
  task_id = NULL,
  project_id = NULL,
  token = get_todoist_api_token()
)
```

## Arguments

- task_id:

  id of the task (either task_id or project_id required)

- project_id:

  id of the project (either task_id or project_id required)

- token:

  todoist API token

## Value

tibble of comments

## Examples

``` r
if (FALSE) { # \dontrun{
get_comments(task_id = "12345")
get_comments(project_id = "67890")
} # }
```
