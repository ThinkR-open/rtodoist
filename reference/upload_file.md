# Upload a file

Upload a file

## Usage

``` r
upload_file(
  file_path,
  file_name = basename(file_path),
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- file_path:

  path to the file to upload

- file_name:

  name for the uploaded file (defaults to basename of file_path)

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

upload object with file_url

## Examples

``` r
if (FALSE) { # \dontrun{
upload <- upload_file("document.pdf")
# Use upload$file_url in a comment
} # }
```
