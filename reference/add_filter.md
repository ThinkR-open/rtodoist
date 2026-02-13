# Add a new filter

Add a new filter

## Usage

``` r
add_filter(
  name,
  query,
  color = NULL,
  is_favorite = FALSE,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- name:

  name of the filter

- query:

  filter query string (e.g., "today \| overdue", "p1 & \#Work")

- color:

  color of the filter

- is_favorite:

  boolean to mark as favorite

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the new filter

## Examples

``` r
if (FALSE) { # \dontrun{
add_filter("Urgent Today", query = "today & p1")
add_filter("Work Tasks", query = "#Work", color = "blue")
} # }
```
