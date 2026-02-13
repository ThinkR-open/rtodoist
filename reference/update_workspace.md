# Update a workspace

Update a workspace

## Usage

``` r
update_workspace(
  workspace_id,
  name,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- workspace_id:

  id of the workspace

- name:

  new name for the workspace

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the updated workspace (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
update_workspace("12345", name = "New Workspace Name")
} # }
```
