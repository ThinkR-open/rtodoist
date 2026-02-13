# Invite user to workspace

Invite user to workspace

## Usage

``` r
invite_to_workspace(
  workspace_id,
  email,
  role = "member",
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- workspace_id:

  id of the workspace

- email:

  email of the user to invite

- role:

  role for the user (e.g., "member", "admin")

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

NULL (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
invite_to_workspace("12345", "user@example.com")
} # }
```
