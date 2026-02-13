# Update a section

Update a section

## Usage

``` r
update_section(
  section_id,
  new_name,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- section_id:

  id of the section

- new_name:

  new name for the section

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the updated section (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
update_section("12345", new_name = "New Section Name")
} # }
```
