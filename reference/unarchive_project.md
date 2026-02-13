# Unarchive a project

Unarchive a project

## Usage

``` r
unarchive_project(project_id, verbose = TRUE, token = get_todoist_api_token())
```

## Arguments

- project_id:

  id of the project

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the unarchived project (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
unarchive_project(project_id = "12345")
} # }
```
