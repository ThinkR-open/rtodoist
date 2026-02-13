# Delete a project

Delete a project

## Usage

``` r
delete_project(
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

NULL (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
delete_project(project_name = "my_proj")
} # }
```
