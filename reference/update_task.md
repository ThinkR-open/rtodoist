# Update a task

Update a task

## Usage

``` r
update_task(
  task_id,
  content = NULL,
  description = NULL,
  priority = NULL,
  due_string = NULL,
  due_date = NULL,
  labels = NULL,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- task_id:

  id of the task to update

- content:

  new content/title for the task

- description:

  new description for the task

- priority:

  priority (1-4, 4 being highest)

- due_string:

  due date as string (e.g., "tomorrow", "every monday")

- due_date:

  due date as date (format: YYYY-MM-DD)

- labels:

  vector of label names

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the updated task (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
update_task("12345", content = "Updated task name")
} # }
```
