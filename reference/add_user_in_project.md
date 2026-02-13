# Add one user

Add one user

## Usage

``` r
add_user_in_project(
  project_id = get_project_id(project_name = project_name, token = token),
  mail,
  project_name,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- project_id:

  id of the project

- mail:

  mail of the user

- project_name:

  name of the project

- verbose:

  boolean that make the function verbose

- token:

  token

## Value

id of project (character vector)

## Examples

``` r
if (FALSE) { # \dontrun{
get_project_id("test") %>% 
   add_user_in_project("jean@mail.fr")
} # }
```
