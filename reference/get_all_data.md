# Get all objects inside a list

Collect all the objects in a list. This allows you to explore your to-do
list.

## Usage

``` r
get_all_data(token = get_todoist_api_token())
```

## Arguments

- token:

  todoist API token

## Value

list of all objects

## Examples

``` r
if (FALSE) { # \dontrun{
# Set API key first
set_todoist_api_token()
# Get all objects
objects <- get_all_data()
} # }
```
