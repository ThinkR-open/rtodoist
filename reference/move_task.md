# Move a task to another project or section

Move a task to another project or section

## Usage

``` r
move_task(
  task_id,
  project_id = NULL,
  section_id = NULL,
  parent_id = NULL,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- task_id:

  id of the task to move

- project_id:

  new project id (optional)

- section_id:

  new section id (optional)

- parent_id:

  new parent task id (optional)

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the moved task (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
move_task("12345", project_id = "67890")
} # }
```
