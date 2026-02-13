# Get label id by name

Get label id by name

## Usage

``` r
get_label_id(
  label_name,
  all_labels = get_all_labels(token = token),
  token = get_todoist_api_token(),
  create = TRUE
)
```

## Arguments

- label_name:

  name of the label

- all_labels:

  result of get_all_labels (optional)

- token:

  todoist API token

- create:

  boolean create label if needed

## Value

id of the label

## Examples

``` r
if (FALSE) { # \dontrun{
get_label_id("urgent")
} # }
```
