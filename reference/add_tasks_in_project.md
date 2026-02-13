# Add tasks in project

Add tasks in project

## Usage

``` r
add_tasks_in_project(
  project_id = get_project_id(project_name = project_name, token = token),
  tasks,
  project_name,
  verbose = FALSE,
  responsible = NULL,
  due = NULL,
  section_name = NULL,
  token = get_todoist_api_token(),
  all_users = get_all_users(token = token),
  update_only = FALSE,
  check_only = FALSE,
  que_si_necessaire = TRUE
)
```

## Arguments

- project_id:

  id of the project

- tasks:

  tasks to add, as character vector

- project_name:

  name of the project

- verbose:

  boolean that make the function verbose

- responsible:

  add people in project

- due:

  due date

- section_name:

  section name

- token:

  todoist API token

- all_users:

  all_users

- update_only:

  boolean if true, only update existing (not closed) todo

- check_only:

  check_only

- que_si_necessaire:

  que_si_necessaire

## Value

id of project (character vector)

## Examples

``` r
if (FALSE) { # \dontrun{
add_project("my_proj") %>%
   add_tasks_in_project(c("First task", "Second task"))
} # }
```
