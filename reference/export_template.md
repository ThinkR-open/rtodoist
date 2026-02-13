# Export a project as a template

Export a project as a template

## Usage

``` r
export_template(
  project_id = get_project_id(project_name = project_name, token = token, create = FALSE),
  project_name,
  output_file,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- project_id:

  id of the project to export

- project_name:

  name of the project (for lookup if project_id not provided)

- output_file:

  path where to save the template file

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

path to the saved file (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
export_template(project_name = "my_proj", output_file = "template.csv")
} # }
```
