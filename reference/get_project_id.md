# Get id of project

This function gives you the id of a project by name, which is useful for
adding tasks or people to the project.

## Usage

``` r
get_project_id(
  project_name,
  all_projects = get_all_projects(token = token),
  token = get_todoist_api_token(),
  create = TRUE,
  verbose = FALSE
)
```

## Arguments

- project_name:

  name of the project

- all_projects:

  result of
  [get_all_projects](https://thinkr-open.github.io/rtodoist/reference/get_all_projects.md)

- token:

  todoist API token

- create:

  boolean create project if needed

- verbose:

  boolean that make the function verbose

## Value

id of project (character vector)

## Examples

``` r
if (FALSE) { # \dontrun{
get_all_projects() %>%
    get_project_id("test")
} # }
```
