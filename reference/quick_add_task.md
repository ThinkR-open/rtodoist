# Quick add a task using natural language

Quick add a task using natural language

## Usage

``` r
quick_add_task(text, verbose = TRUE, token = get_todoist_api_token())
```

## Arguments

- text:

  natural language text for the task

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

task object

## Examples

``` r
if (FALSE) { # \dontrun{
quick_add_task("Buy milk tomorrow at 5pm #Shopping")
} # }
```
