# Update a comment

Update a comment

## Usage

``` r
update_comment(
  comment_id,
  content,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- comment_id:

  id of the comment

- content:

  new content for the comment

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

id of the updated comment (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
update_comment("12345", content = "Updated comment")
} # }
```
