# Close (complete) a task

Close (complete) a task

## Usage

``` r
close_task(task_id, verbose = TRUE, token = get_todoist_api_token())
```

## Arguments

- task_id:

  id of the task to close

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the closed task (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
close_task("12345")
} # }
```
