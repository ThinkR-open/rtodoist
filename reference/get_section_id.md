# Get section id

Get section id

## Usage

``` r
get_section_id(
  project_id = get_project_id(project_name = project_name, token = token),
  project_name,
  section_name,
  token = get_todoist_api_token(),
  all_section = get_section_from_project(project_id = project_id, token = token)
)
```

## Arguments

- project_id:

  id of the project

- project_name:

  name of the project

- section_name:

  name of the section

- token:

  token

- all_section:

  all_section

## Value

section id (character). Returns 0 if section not found.
