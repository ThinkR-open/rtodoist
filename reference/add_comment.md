# Add a comment to a task or project

Add a comment to a task or project

## Usage

``` r
add_comment(
  content,
  task_id = NULL,
  project_id = NULL,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- content:

  content of the comment

- task_id:

  id of the task (either task_id or project_id required)

- project_id:

  id of the project (either task_id or project_id required)

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the new comment

## Examples

``` r
if (FALSE) { # \dontrun{
add_comment(content = "This is a comment", task_id = "12345")
add_comment(content = "Project comment", project_id = "67890")
} # }
```
