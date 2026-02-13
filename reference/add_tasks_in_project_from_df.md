# Add tasks in project

Add tasks in project

## Usage

``` r
add_tasks_in_project_from_df(
  project_id = get_project_id(project_name = project_name, token = token),
  tasks_as_df,
  project_name,
  verbose = FALSE,
  token = get_todoist_api_token(),
  update_only = FALSE,
  check_only = FALSE,
  que_si_necessaire = TRUE,
  all_users = get_all_users(token = token)
)
```

## Arguments

- project_id:

  id of the project

- tasks_as_df:

  data.frame of tasks with
  c("tasks_list","responsible","due","section_name") names

- project_name:

  name of the project

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

- update_only:

  boolean if true only update existing (not closed) todo

- check_only:

  boolean if true only return number of task to add

- que_si_necessaire:

  que_si_necessaire

- all_users:

  all_users

## Value

id of project (character vector)

## See also

\[add_tasks_in_project()\]
