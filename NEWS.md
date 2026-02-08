# rtodoist 0.4.0

## Breaking changes

* API functions now use `req_error()` from httr2 for proper HTTP error handling

## New features

* Added comprehensive test coverage for workspaces, activity logs, backups, templates, and uploads modules
* Added `skip_if_test_project_missing()` helper for more robust integration tests

## Improvements

* Updated GitHub Actions workflow to use modern action versions (v2/v4)
* Removed debug message from `call_api()` function
* API base URLs now defined as package constants (`TODOIST_SYNC_URL`, `TODOIST_REST_URL`)
* Fixed `glue()` to character conversion in `templates.R` for httr2 compatibility
* Improved test robustness by skipping tests when required resources are unavailable

## Bug fixes

* Fixed templates export/import functions failing due to glue object type issue

# rtodoist 0.3.0

* Added pagination support for REST API endpoints
* Fixed JSON escaping for special characters
* Fixed string ID handling for API v1 compatibility
* Added comprehensive testthat test suite

# rtodoist 0.2.1

* Migration to Todoist API v1
* Moved from httr to httr2

# rtodoist 0.2.0

* Initial release with full Todoist API support
* Projects, tasks, sections, labels, comments management
* User collaboration features
* Secure token storage via keyring
