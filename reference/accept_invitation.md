# Accept a project invitation

Accept a project invitation

## Usage

``` r
accept_invitation(
  invitation_id,
  invitation_secret,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- invitation_id:

  id of the invitation

- invitation_secret:

  secret of the invitation

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

NULL (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
accept_invitation("12345", "secret123")
} # }
```
