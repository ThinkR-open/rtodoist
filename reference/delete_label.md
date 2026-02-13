# Delete a label

Delete a label

## Usage

``` r
delete_label(
  label_id = get_label_id(label_name = label_name, token = token, create = FALSE),
  label_name,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- label_id:

  id of the label

- label_name:

  name of the label (for lookup if label_id not provided)

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

NULL (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
delete_label(label_name = "urgent")
} # }
```
