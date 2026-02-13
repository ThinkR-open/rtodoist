# Archive a project

Archive a project

## Usage

``` r
archive_project(
  project_id = get_project_id(project_name = project_name, token = token, create = FALSE),
  project_name,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- project_id:

  id of the project

- project_name:

  name of the project (for lookup if project_id not provided)

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the archived project (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
archive_project(project_name = "my_proj")
} # }
```
