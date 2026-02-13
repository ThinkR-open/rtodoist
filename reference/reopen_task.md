# Reopen (uncomplete) a task

Reopen (uncomplete) a task

## Usage

``` r
reopen_task(task_id, verbose = TRUE, token = get_todoist_api_token())
```

## Arguments

- task_id:

  id of the task to reopen

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the reopened task (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
reopen_task("12345")
} # }
```
