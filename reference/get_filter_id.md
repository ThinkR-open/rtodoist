# Get filter id by name

Get filter id by name

## Usage

``` r
get_filter_id(
  filter_name,
  all_filters = get_all_filters(token = token),
  token = get_todoist_api_token()
)
```

## Arguments

- filter_name:

  name of the filter

- all_filters:

  result of get_all_filters (optional)

- token:

  todoist API token

## Value

id of the filter

## Examples

``` r
if (FALSE) { # \dontrun{
get_filter_id("Urgent Today")
} # }
```
