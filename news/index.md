# Changelog

## rtodoist 0.4.0

### Breaking changes

- API functions now use `req_error()` from httr2 for proper HTTP error
  handling
- [`unarchive_project()`](https://thinkr-open.github.io/rtodoist/reference/unarchive_project.md)
  no longer accepts unused `project_name` parameter
- Removed unused `httr` dependency (fully migrated to httr2)

### New features

#### Labels module (new)

- [`add_label()`](https://thinkr-open.github.io/rtodoist/reference/add_label.md):
  Create a new label
- [`get_label()`](https://thinkr-open.github.io/rtodoist/reference/get_label.md):
  Get a single label by ID
- [`get_all_labels()`](https://thinkr-open.github.io/rtodoist/reference/get_all_labels.md):
  Get all labels
- [`get_label_id()`](https://thinkr-open.github.io/rtodoist/reference/get_label_id.md):
  Get label ID by name
- [`update_label()`](https://thinkr-open.github.io/rtodoist/reference/update_label.md):
  Update an existing label
- [`delete_label()`](https://thinkr-open.github.io/rtodoist/reference/delete_label.md):
  Delete a label
- [`get_shared_labels()`](https://thinkr-open.github.io/rtodoist/reference/get_shared_labels.md):
  Get all shared labels
- [`rename_shared_label()`](https://thinkr-open.github.io/rtodoist/reference/rename_shared_label.md):
  Rename a shared label
- [`remove_shared_label()`](https://thinkr-open.github.io/rtodoist/reference/remove_shared_label.md):
  Remove a shared label

#### Comments module (new)

- [`add_comment()`](https://thinkr-open.github.io/rtodoist/reference/add_comment.md):
  Add a comment to a task or project
- [`get_comment()`](https://thinkr-open.github.io/rtodoist/reference/get_comment.md):
  Get a single comment by ID
- [`get_comments()`](https://thinkr-open.github.io/rtodoist/reference/get_comments.md):
  Get all comments for a task or project
- [`update_comment()`](https://thinkr-open.github.io/rtodoist/reference/update_comment.md):
  Update an existing comment
- [`delete_comment()`](https://thinkr-open.github.io/rtodoist/reference/delete_comment.md):
  Delete a comment

#### Filters module (new)

- [`add_filter()`](https://thinkr-open.github.io/rtodoist/reference/add_filter.md):
  Create a new filter
- [`get_filter()`](https://thinkr-open.github.io/rtodoist/reference/get_filter.md):
  Get a single filter by ID
- [`get_all_filters()`](https://thinkr-open.github.io/rtodoist/reference/get_all_filters.md):
  Get all filters
- [`get_filter_id()`](https://thinkr-open.github.io/rtodoist/reference/get_filter_id.md):
  Get filter ID by name
- [`update_filter()`](https://thinkr-open.github.io/rtodoist/reference/update_filter.md):
  Update an existing filter
- [`delete_filter()`](https://thinkr-open.github.io/rtodoist/reference/delete_filter.md):
  Delete a filter

#### Reminders module (new)

- [`add_reminder()`](https://thinkr-open.github.io/rtodoist/reference/add_reminder.md):
  Add a reminder to a task
- [`get_all_reminders()`](https://thinkr-open.github.io/rtodoist/reference/get_all_reminders.md):
  Get all reminders
- [`update_reminder()`](https://thinkr-open.github.io/rtodoist/reference/update_reminder.md):
  Update an existing reminder
- [`delete_reminder()`](https://thinkr-open.github.io/rtodoist/reference/delete_reminder.md):
  Delete a reminder

#### Workspaces module (new)

- [`get_all_workspaces()`](https://thinkr-open.github.io/rtodoist/reference/get_all_workspaces.md):
  Get all workspaces
- [`get_workspace_users()`](https://thinkr-open.github.io/rtodoist/reference/get_workspace_users.md):
  Get users in a workspace
- [`update_workspace()`](https://thinkr-open.github.io/rtodoist/reference/update_workspace.md):
  Update workspace settings
- [`invite_to_workspace()`](https://thinkr-open.github.io/rtodoist/reference/invite_to_workspace.md):
  Invite a user to a workspace
- [`leave_workspace()`](https://thinkr-open.github.io/rtodoist/reference/leave_workspace.md):
  Leave a workspace

#### Activity and stats (new)

- [`get_activity_logs()`](https://thinkr-open.github.io/rtodoist/reference/get_activity_logs.md):
  Get activity logs
- [`get_productivity_stats()`](https://thinkr-open.github.io/rtodoist/reference/get_productivity_stats.md):
  Get user productivity statistics
- [`get_user_info()`](https://thinkr-open.github.io/rtodoist/reference/get_user_info.md):
  Get current user information

#### Backups module (new)

- [`get_backups()`](https://thinkr-open.github.io/rtodoist/reference/get_backups.md):
  List available backups
- [`download_backup()`](https://thinkr-open.github.io/rtodoist/reference/download_backup.md):
  Download a backup file

#### Templates module (new)

- [`export_template()`](https://thinkr-open.github.io/rtodoist/reference/export_template.md):
  Export a project as template
- [`import_template()`](https://thinkr-open.github.io/rtodoist/reference/import_template.md):
  Import a template into a project

#### Uploads module (new)

- [`upload_file()`](https://thinkr-open.github.io/rtodoist/reference/upload_file.md):
  Upload a file attachment
- [`delete_upload()`](https://thinkr-open.github.io/rtodoist/reference/delete_upload.md):
  Delete an uploaded file

#### Projects enhancements

- [`get_project()`](https://thinkr-open.github.io/rtodoist/reference/get_project.md):
  Get a single project by ID
- [`update_project()`](https://thinkr-open.github.io/rtodoist/reference/update_project.md):
  Update project name, color, favorite status, or view style
- [`delete_project()`](https://thinkr-open.github.io/rtodoist/reference/delete_project.md):
  Delete a project
- [`archive_project()`](https://thinkr-open.github.io/rtodoist/reference/archive_project.md):
  Archive a project
- [`unarchive_project()`](https://thinkr-open.github.io/rtodoist/reference/unarchive_project.md):
  Unarchive a project
- [`get_archived_projects()`](https://thinkr-open.github.io/rtodoist/reference/get_archived_projects.md):
  Get all archived projects

#### Sections enhancements

- [`get_section()`](https://thinkr-open.github.io/rtodoist/reference/get_section.md):
  Get a single section by ID
- [`get_all_sections()`](https://thinkr-open.github.io/rtodoist/reference/get_all_sections.md):
  Get all sections across projects
- [`update_section()`](https://thinkr-open.github.io/rtodoist/reference/update_section.md):
  Rename a section
- [`delete_section()`](https://thinkr-open.github.io/rtodoist/reference/delete_section.md):
  Delete a section
- [`move_section()`](https://thinkr-open.github.io/rtodoist/reference/move_section.md):
  Move a section to another project
- [`archive_section()`](https://thinkr-open.github.io/rtodoist/reference/archive_section.md):
  Archive a section
- [`unarchive_section()`](https://thinkr-open.github.io/rtodoist/reference/unarchive_section.md):
  Unarchive a section

#### Tasks enhancements

- [`get_task()`](https://thinkr-open.github.io/rtodoist/reference/get_task.md):
  Get a single task by ID
- [`update_task()`](https://thinkr-open.github.io/rtodoist/reference/update_task.md):
  Update task content, due date, priority, labels, or description
- [`delete_task()`](https://thinkr-open.github.io/rtodoist/reference/delete_task.md):
  Delete a task
- [`close_task()`](https://thinkr-open.github.io/rtodoist/reference/close_task.md):
  Mark a task as complete
- [`reopen_task()`](https://thinkr-open.github.io/rtodoist/reference/reopen_task.md):
  Reopen a completed task
- [`move_task()`](https://thinkr-open.github.io/rtodoist/reference/move_task.md):
  Move a task to another project, section, or parent
- [`get_completed_tasks()`](https://thinkr-open.github.io/rtodoist/reference/get_completed_tasks.md):
  Get completed tasks with date filtering
- [`get_tasks_by_filter()`](https://thinkr-open.github.io/rtodoist/reference/get_tasks_by_filter.md):
  Get tasks using a filter query
- [`quick_add_task()`](https://thinkr-open.github.io/rtodoist/reference/quick_add_task.md):
  Quick add a task with natural language parsing

#### Collaboration enhancements

- [`delete_collaborator()`](https://thinkr-open.github.io/rtodoist/reference/delete_collaborator.md):
  Remove a collaborator from a project
- [`accept_invitation()`](https://thinkr-open.github.io/rtodoist/reference/accept_invitation.md):
  Accept a project invitation
- [`reject_invitation()`](https://thinkr-open.github.io/rtodoist/reference/reject_invitation.md):
  Reject a project invitation
- [`delete_invitation()`](https://thinkr-open.github.io/rtodoist/reference/delete_invitation.md):
  Delete a pending invitation

### Improvements

- Added
  [`escape_json()`](https://thinkr-open.github.io/rtodoist/reference/escape_json.md)
  to all Sync API commands for proper JSON escaping
- Added token validation in
  [`call_api()`](https://thinkr-open.github.io/rtodoist/reference/call_api.md)
  and
  [`call_api_rest()`](https://thinkr-open.github.io/rtodoist/reference/call_api_rest.md)
  with clear error messages
- API base URLs now defined as package constants (`TODOIST_SYNC_URL`,
  `TODOIST_REST_URL`)
- Empty data.frames now return consistent column structure with
  non-empty results
- Standardized error handling with `req_error()` across all REST
  endpoints
- Replaced [`print()`](https://rdrr.io/r/base/print.html) with
  [`message()`](https://rdrr.io/r/base/message.html) for user-facing
  output (CRAN compliance)
- Updated GitHub Actions workflow to use modern action versions (v2/v4)
- Removed debug message from
  [`call_api()`](https://thinkr-open.github.io/rtodoist/reference/call_api.md)
  function
- Added comprehensive test coverage for all new modules
- Added `skip_if_test_project_missing()` helper for more robust
  integration tests

### Bug fixes

- Fixed
  [`move_task()`](https://thinkr-open.github.io/rtodoist/reference/move_task.md)
  to properly escape IDs preventing JSON injection
- Fixed templates export/import functions failing due to glue object
  type issue
- Fixed
  [`get_comments()`](https://thinkr-open.github.io/rtodoist/reference/get_comments.md)
  empty result missing `task_id` and `project_id` columns
- Fixed
  [`get_all_reminders()`](https://thinkr-open.github.io/rtodoist/reference/get_all_reminders.md)
  empty result missing `due_date` and `minute_offset` columns
- Fixed
  [`get_activity_logs()`](https://thinkr-open.github.io/rtodoist/reference/get_activity_logs.md)
  empty result missing `initiator_id`, `parent_project_id`,
  `parent_item_id` columns
- Fixed
  [`get_tasks_by_filter()`](https://thinkr-open.github.io/rtodoist/reference/get_tasks_by_filter.md)
  empty result missing `due_date` column
- Fixed
  [`get_archived_projects()`](https://thinkr-open.github.io/rtodoist/reference/get_archived_projects.md)
  empty result missing `color` and `is_favorite` columns
- Fixed
  [`get_all_sections()`](https://thinkr-open.github.io/rtodoist/reference/get_all_sections.md)
  empty result missing `order` column
- Fixed
  [`get_all_workspaces()`](https://thinkr-open.github.io/rtodoist/reference/get_all_workspaces.md)
  empty result missing `is_default` column
- Fixed
  [`get_workspace_users()`](https://thinkr-open.github.io/rtodoist/reference/get_workspace_users.md)
  empty result missing `role` column
- Fixed
  [`quick_add_task()`](https://thinkr-open.github.io/rtodoist/reference/quick_add_task.md)
  using hardcoded URL instead of `TODOIST_REST_URL`
- Added missing `req_error()` to
  [`quick_add_task()`](https://thinkr-open.github.io/rtodoist/reference/quick_add_task.md)
  and
  [`upload_file()`](https://thinkr-open.github.io/rtodoist/reference/upload_file.md)

### Internal

- Removed unused `httptest2` and `mockery` from Suggests
- Removed unused `lubridate` from Suggests
- Cleaned up mocking test infrastructure
- Added `@return` tags to all exported functions for CRAN compliance

## rtodoist 0.3.0

- Added pagination support for REST API endpoints
- Fixed JSON escaping for special characters
- Fixed string ID handling for API v1 compatibility
- Added comprehensive testthat test suite

## rtodoist 0.2.1

- Migration to Todoist API v1
- Moved from httr to httr2

## rtodoist 0.2.0

CRAN release: 2026-01-22

- Initial CRAN release
- Projects, tasks, sections management
- User collaboration features
- Secure token storage via keyring
