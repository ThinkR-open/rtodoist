# Delete a collaborator from a project

Delete a collaborator from a project

## Usage

``` r
delete_collaborator(
  project_id = get_project_id(project_name = project_name, token = token, create = FALSE),
  project_name,
  email,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- project_id:

  id of the project

- project_name:

  name of the project (for lookup if project_id not provided)

- email:

  email of the collaborator to remove

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the project (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
delete_collaborator(project_name = "my_proj", email = "user@example.com")
} # }
```
