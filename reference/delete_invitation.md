# Delete an invitation

Delete an invitation

## Usage

``` r
delete_invitation(
  invitation_id,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- invitation_id:

  id of the invitation

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

NULL (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
delete_invitation("12345")
} # }
```
