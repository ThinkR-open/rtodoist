# Add a new label

Add a new label

## Usage

``` r
add_label(
  name,
  color = NULL,
  is_favorite = FALSE,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- name:

  name of the label

- color:

  color of the label

- is_favorite:

  boolean to mark as favorite

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the new label

## Examples

``` r
if (FALSE) { # \dontrun{
add_label("urgent")
add_label("work", color = "red")
} # }
```
