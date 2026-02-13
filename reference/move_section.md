# Move a section to another project

Move a section to another project

## Usage

``` r
move_section(
  section_id,
  project_id,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- section_id:

  id of the section

- project_id:

  target project id

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the moved section (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
move_section("12345", project_id = "67890")
} # }
```
