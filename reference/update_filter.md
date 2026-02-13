# Update a filter

Update a filter

## Usage

``` r
update_filter(
  filter_id = get_filter_id(filter_name = filter_name, token = token),
  filter_name,
  new_name = NULL,
  query = NULL,
  color = NULL,
  is_favorite = NULL,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- filter_id:

  id of the filter

- filter_name:

  name of the filter (for lookup if filter_id not provided)

- new_name:

  new name for the filter

- query:

  new query string

- color:

  new color

- is_favorite:

  boolean to mark as favorite

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the updated filter (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
update_filter(filter_name = "Urgent Today", query = "today & p1 & #Work")
} # }
```
