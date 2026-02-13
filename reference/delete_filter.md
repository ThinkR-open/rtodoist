# Delete a filter

Delete a filter

## Usage

``` r
delete_filter(
  filter_id = get_filter_id(filter_name = filter_name, token = token),
  filter_name,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- filter_id:

  id of the filter

- filter_name:

  name of the filter (for lookup if filter_id not provided)

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

NULL (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
delete_filter(filter_name = "Urgent Today")
} # }
```
