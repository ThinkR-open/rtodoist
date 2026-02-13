# Add section

Add section

## Usage

``` r
add_section(
  section_name,
  project_id = get_project_id(project_name = project_name, token = token),
  project_name,
  force = FALSE,
  token = get_todoist_api_token()
)
```

## Arguments

- section_name:

  section name

- project_id:

  id of the project

- project_name:

  name of the project

- force:

  boolean force section creation even if already exist

- token:

  todoist API token

## Value

section id (character)
