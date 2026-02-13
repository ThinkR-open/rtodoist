# Download a backup

Download a backup

## Usage

``` r
download_backup(
  version,
  output_file,
  verbose = TRUE,
  token = get_todoist_api_token()
)
```

## Arguments

- version:

  version of the backup to download (from get_backups())

- output_file:

  path where to save the backup file

- verbose:

  boolean that make the function verbose

- token:

  todoist API token

## Value

path to the saved file (invisible)

## Examples

``` r
if (FALSE) { # \dontrun{
backups <- get_backups()
download_backup(backups$version[1], "backup.zip")
} # }
```
