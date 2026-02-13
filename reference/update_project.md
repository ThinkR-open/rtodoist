# Update a project

Update a project

## Usage

``` r
update_project(
  project_id = get_project_id(project_name = project_name, token = token, create = FALSE),
  project_name,
  new_name = NULL,
  color = NULL,
  is_favorite = NULL,
  view_style = NULL,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- project_id:

  id of the project

- project_name:

  name of the project (for lookup if project_id not provided)

- new_name:

  new name for the project

- color:

  new color for the project

- is_favorite:

  boolean to mark as favorite

- view_style:

  view style ("list" or "board")

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the updated project (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
update_project(project_name = "my_proj", new_name = "new_name")
} # }
```
