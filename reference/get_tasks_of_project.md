# List of tasks of project

List of tasks of project

## Usage

``` r
get_tasks_of_project(
  project_id = get_project_id(project_name = project_name, token = token),
  project_name,
  token = get_todoist_api_token()
)
```

## Arguments

- project_id:

  id of the project

- project_name:

  name of the project

- token:

  todoist API token

## Value

list of all tasks
