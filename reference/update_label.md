# Update a label

Update a label

## Usage

``` r
update_label(
  label_id = get_label_id(label_name = label_name, token = token, create = FALSE),
  label_name,
  new_name = NULL,
  color = NULL,
  is_favorite = NULL,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- label_id:

  id of the label

- label_name:

  name of the label (for lookup if label_id not provided)

- new_name:

  new name for the label

- color:

  new color for the label

- is_favorite:

  boolean to mark as favorite

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the updated label (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
update_label(label_name = "urgent", new_name = "very_urgent")
} # }
```
