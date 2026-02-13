# Get users in projects

Get users in projects

## Usage

``` r
get_users_in_project(
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

  token

## Value

dataframe of users in projects
