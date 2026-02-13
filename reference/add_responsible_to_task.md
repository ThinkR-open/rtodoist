# Add responsible to a task

Add responsible to a task

## Usage

``` r
add_responsible_to_task(
  project_id = get_project_id(project_name = project_name, token = token),
  project_name,
  responsible,
  task,
  verbose = FALSE,
  all_users = get_all_users(token = token),
  token = get_todoist_api_token()
)
```

## Arguments

- project_id:

  id of the project

- project_name:

  name of the project

- responsible:

  add someone to this task with mail

- task:

  the full name of the task

- verbose:

  boolean that make the function verbose

- all_users:

  all_users

- token:

  todoist API token

## Value

http request
