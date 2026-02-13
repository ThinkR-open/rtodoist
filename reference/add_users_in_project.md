# Add a list of users

Add a list of users

## Usage

``` r
add_users_in_project(
  project_id = get_project_id(project_name = project_name, token = token),
  users_email,
  project_name,
  verbose = TRUE,
  all_users = get_all_users(token = token),
  token = get_todoist_api_token()
)
```

## Arguments

- project_id:

  id of the project

- users_email:

  emails of user as character vector

- project_name:

  name of the project

- verbose:

  boolean that make the function verbose

- all_users:

  all_users

- token:

  token

## Value

id of project (character vector)
