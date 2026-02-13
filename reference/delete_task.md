# Delete a task

Delete a task

## Usage

``` r
delete_task(task_id, verbose = TRUE, token = get_todoist_api_token())
```

## Arguments

- task_id:

  id of the task to delete

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

NULL (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
delete_task("12345")
} # }
```
