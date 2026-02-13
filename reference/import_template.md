# Import a template into a project

Import a template into a project

## Usage

``` r
import_template(
  project_id = get_project_id(project_name = project_name, token = token, create = FALSE),
  project_name,
  file_path,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- project_id:

  id of the project to import into

- project_name:

  name of the project (for lookup if project_id not provided)

- file_path:

  path to the template file (CSV format)

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

NULL (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
import_template(project_name = "my_proj", file_path = "template.csv")
} # }
```
