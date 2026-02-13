# rtodoist 0.4.0

## Breaking changes
* API functions now use `req_error()` from httr2 for proper HTTP error handling
* `unarchive_project()` no longer accepts unused `project_name` parameter
* Removed unused `httr` dependency (fully migrated to httr2)

## New features

### Labels module (new)
* `add_label()`: Create a new label
* `get_label()`: Get a single label by ID
* `get_all_labels()`: Get all labels
* `get_label_id()`: Get label ID by name
* `update_label()`: Update an existing label
* `delete_label()`: Delete a label
* `get_shared_labels()`: Get all shared labels
* `rename_shared_label()`: Rename a shared label
* `remove_shared_label()`: Remove a shared label

### Comments module (new)
* `add_comment()`: Add a comment to a task or project
* `get_comment()`: Get a single comment by ID
* `get_comments()`: Get all comments for a task or project
* `update_comment()`: Update an existing comment
* `delete_comment()`: Delete a comment

### Filters module (new)
* `add_filter()`: Create a new filter
* `get_filter()`: Get a single filter by ID
* `get_all_filters()`: Get all filters
* `get_filter_id()`: Get filter ID by name
* `update_filter()`: Update an existing filter
* `delete_filter()`: Delete a filter

### Reminders module (new)
* `add_reminder()`: Add a reminder to a task
* `get_all_reminders()`: Get all reminders
* `update_reminder()`: Update an existing reminder
* `delete_reminder()`: Delete a reminder

### Workspaces module (new)
* `get_all_workspaces()`: Get all workspaces
* `get_workspace_users()`: Get users in a workspace
* `update_workspace()`: Update workspace settings
* `invite_to_workspace()`: Invite a user to a workspace
* `leave_workspace()`: Leave a workspace

### Activity and stats (new)
* `get_activity_logs()`: Get activity logs
* `get_productivity_stats()`: Get user productivity statistics
* `get_user_info()`: Get current user information

### Backups module (new)
* `get_backups()`: List available backups
* `download_backup()`: Download a backup file

### Templates module (new)
* `export_template()`: Export a project as template
* `import_template()`: Import a template into a project

### Uploads module (new)
* `upload_file()`: Upload a file attachment
* `delete_upload()`: Delete an uploaded file

### Projects enhancements
* `get_project()`: Get a single project by ID
* `update_project()`: Update project name, color, favorite status, or view style
* `delete_project()`: Delete a project
* `archive_project()`: Archive a project
* `unarchive_project()`: Unarchive a project
* `get_archived_projects()`: Get all archived projects

### Sections enhancements
* `get_section()`: Get a single section by ID
* `get_all_sections()`: Get all sections across projects
* `update_section()`: Rename a section
* `delete_section()`: Delete a section
* `move_section()`: Move a section to another project
* `archive_section()`: Archive a section
* `unarchive_section()`: Unarchive a section

### Tasks enhancements
* `get_task()`: Get a single task by ID
* `update_task()`: Update task content, due date, priority, labels, or description
* `delete_task()`: Delete a task
* `close_task()`: Mark a task as complete
* `reopen_task()`: Reopen a completed task
* `move_task()`: Move a task to another project, section, or parent
* `get_completed_tasks()`: Get completed tasks with date filtering
* `get_tasks_by_filter()`: Get tasks using a filter query
* `quick_add_task()`: Quick add a task with natural language parsing

### Collaboration enhancements
* `delete_collaborator()`: Remove a collaborator from a project
* `accept_invitation()`: Accept a project invitation
* `reject_invitation()`: Reject a project invitation
* `delete_invitation()`: Delete a pending invitation

## Improvements
* Added `escape_json()` to all Sync API commands for proper JSON escaping
* Added token validation in `call_api()` and `call_api_rest()` with clear error messages
* API base URLs now defined as package constants (`TODOIST_SYNC_URL`, `TODOIST_REST_URL`)
* Empty data.frames now return consistent column structure with non-empty results
* Standardized error handling with `req_error()` across all REST endpoints
* Replaced `print()` with `message()` for user-facing output (CRAN compliance)
* Updated GitHub Actions workflow to use modern action versions (v2/v4)
* Removed debug message from `call_api()` function
* Added comprehensive test coverage for all new modules
* Added `skip_if_test_project_missing()` helper for more robust integration tests

## Bug fixes
* Fixed `move_task()` to properly escape IDs preventing JSON injection
* Fixed templates export/import functions failing due to glue object type issue
* Fixed `get_comments()` empty result missing `task_id` and `project_id` columns
* Fixed `get_all_reminders()` empty result missing `due_date` and `minute_offset` columns
* Fixed `get_activity_logs()` empty result missing `initiator_id`, `parent_project_id`, `parent_item_id` columns
* Fixed `get_tasks_by_filter()` empty result missing `due_date` column
* Fixed `get_archived_projects()` empty result missing `color` and `is_favorite` columns
* Fixed `get_all_sections()` empty result missing `order` column
* Fixed `get_all_workspaces()` empty result missing `is_default` column
* Fixed `get_workspace_users()` empty result missing `role` column
* Fixed `quick_add_task()` using hardcoded URL instead of `TODOIST_REST_URL`
* Added missing `req_error()` to `quick_add_task()` and `upload_file()`

## Internal
* Removed unused `httptest2` and `mockery` from Suggests
* Removed unused `lubridate` from Suggests
* Cleaned up mocking test infrastructure
* Added `@return` tags to all exported functions for CRAN compliance

# rtodoist 0.3.0

* Added pagination support for REST API endpoints
* Fixed JSON escaping for special characters
* Fixed string ID handling for API v1 compatibility
* Added comprehensive testthat test suite

# rtodoist 0.2.1

* Migration to Todoist API v1
* Moved from httr to httr2

# rtodoist 0.2.0

* Initial CRAN release
* Projects, tasks, sections management
* User collaboration features
* Secure token storage via keyring
