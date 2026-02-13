# Rename a shared label

Rename a shared label

## Usage

``` r
rename_shared_label(
  old_name,
  new_name,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- old_name:

  current name of the shared label

- new_name:

  new name for the shared label

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

NULL (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
rename_shared_label("old_name", "new_name")
} # }
```
