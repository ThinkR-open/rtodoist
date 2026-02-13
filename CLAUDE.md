# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Package Overview

rtodoist is an R package that wraps the Todoist API v1 for programmatic management of projects, tasks, sections, and collaborators. The package uses secure token storage via keyring.

## Common Commands

```r
# Install dependencies
remotes::install_deps(dependencies = TRUE)

# Generate documentation (NAMESPACE and man/*.Rd files)
devtools::document()

# Run all tests
devtools::test()

# Run a single test file
testthat::test_file("tests/testthat/test-tasks.R")

# Run R CMD CHECK
rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning")

# Build package
R CMD build .
```

## Architecture

### Two API Communication Patterns

1. **Sync API** (`call_api()` in `R/utils.R`): Used for write operations via `/api/v1/sync`. Commands are sent as JSON with UUID-based temp_id generation.

2. **REST API** (`call_api_rest()` in `R/utils.R`): Used for read operations with cursor-based pagination support.

### Key Design Patterns

- **Lazy parameter evaluation**: Functions accept both `project_name` or `project_id`. Default parameters call lookup functions (e.g., `get_project_id()`), so use `force()` before API calls.

- **Pipe-friendly returns**: Write functions return IDs invisibly for chaining:
  ```r
  add_project("test") %>% add_tasks_in_project(c("task1", "task2"))
  ```

- **Vector parameter matching**: `add_tasks_in_project()` accepts vectors for tasks, responsible users, due dates, and sections. Single values are recycled; otherwise lengths must match.

### Source File Organization

| File | Purpose |
|------|---------|
| `R/projects.R` | Project CRUD operations |
| `R/tasks.R` | Task operations (add, update, get, assign) |
| `R/section.R` | Section management |
| `R/users.R` | User/collaboration management |
| `R/token.R` | API token management via keyring |
| `R/utils.R` | `call_api()`, `call_api_rest()`, `escape_json()`, `random_key()` |
| `R/all_objects.R` | `get_all_data()` for full sync |
| `R/clean_tools.R` | Data cleaning utilities |

### Utility Functions to Reuse

- `call_api(commands, token)`: Sync API calls with JSON command batch
- `call_api_rest(endpoint, params, token)`: REST API with pagination
- `escape_json(x)`: Escape special characters for JSON strings
- `random_key()`: Generate UUIDs for Sync API commands
- `clean_due()`, `clean_section()`: Normalize NULL/"" to "null" for API

## Testing

Uses testthat v3 with two test strategies:

1. **Unit tests** (`test-unit-logic.R`): Tests pure logic functions using fixture data from `tests/testthat/fixtures/`. No API token required.

2. **Integration tests**: Require a valid API token. Skip automatically on CI/CRAN via helpers in `tests/testthat/helper.R`.

### Test Helpers

```r
skip_if_no_token()     # Skip if no API token available
skip_on_ci_or_cran()   # Skip on CI environments
```

## API Token Setup

For testing, get your token from https://www.todoist.com/prefs/integrations/developer then:
```r
rtodoist::set_todoist_api_token("your_token")
```

## Adding New API Functions

Follow the existing pattern:
```r
add_xxx <- function(name, ..., verbose = TRUE, token = get_todoist_api_token()) {
  force(token)
  # Build JSON command using glue() and escape_json()
  # Call via call_api() or call_api_rest()
  # Return ID invisibly for pipe chaining
}
```

See `PLAN_IMPLEMENTATION.md` for the roadmap of missing features (labels, comments, filters, reminders, etc.).
