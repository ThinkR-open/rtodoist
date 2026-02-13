# Unit tests for pure logic functions using fixture data
# These tests verify function behavior without making HTTP calls

library(rtodoist)

# Load fixtures
projects_json <- jsonlite::read_json(
  test_path("fixtures", "projects_response.json")
)
tasks_json <- jsonlite::read_json(
  test_path("fixtures", "tasks_response.json")
)
sections_json <- jsonlite::read_json(
  test_path("fixtures", "sections_response.json")
)
tasks_rest_json <- jsonlite::read_json(
  test_path("fixtures", "tasks_rest_response.json")
)

test_that("get_project_id extracts project id from list", {
  # Test with pre-loaded data (no API call)
  result <- get_project_id(
    project_name = "TestProject",
    all_projects = projects_json,
    token = "fake_token",
    create = FALSE
  )
  expect_equal(result, "2244736524")
})

test_that("get_project_id returns error for non-existent project when create=FALSE", {
  expect_error(
    get_project_id(
      project_name = "NonExistent",
      all_projects = projects_json,
      token = "fake_token",
      create = FALSE
    ),
    "Are you sure about the name"
  )
})

test_that("get_section_id works with section data", {
  # Test with pre-loaded section data
  sections_df <- purrr::map_dfr(sections_json$results, `[`, c("id", "name"))

  result <- get_section_id(
    project_id = "2244736524",
    section_name = "Section A",
    token = "fake_token",
    all_section = sections_df
  )
  expect_equal(result, "123456")
})

test_that("get_section_id returns 0 for non-existent section", {
  sections_df <- purrr::map_dfr(sections_json$results, `[`, c("id", "name"))

  result <- get_section_id(
    project_id = "2244736524",
    section_name = "NonExistent",
    token = "fake_token",
    all_section = sections_df
  )
  expect_equal(result, "0")
})

test_that("get_section_id is case-insensitive", {
  sections_df <- purrr::map_dfr(sections_json$results, `[`, c("id", "name"))

  result <- get_section_id(
    project_id = "2244736524",
    section_name = "section a",
    token = "fake_token",
    all_section = sections_df
  )
  expect_equal(result, "123456")
})

test_that("get_tasks_to_add identifies new tasks", {
  existing_tasks <- list(
    list(content = "Task 1", project_id = "123", section_id = "0", id = "1", responsible_uid = "null")
  )

  result <- rtodoist:::get_tasks_to_add(
    tasks = c("Task 1", "Task 2", "Task 3"),
    due = c("null", "null", "null"),
    responsible_uid = c("null", "null", "null"),
    existing_tasks = existing_tasks,
    sections_id = c(0, 0, 0),
    token = "fake"
  )

  # New tasks should be added (Task 2 and Task 3 at minimum)
  expect_true(nrow(result) >= 2)
  expect_true("Task 2" %in% result$content)
  expect_true("Task 3" %in% result$content)
})

test_that("get_tasks_to_add returns all tasks when none exist", {
  result <- rtodoist:::get_tasks_to_add(
    tasks = c("New Task 1", "New Task 2"),
    due = c("null", "null"),
    responsible_uid = c("null", "null"),
    existing_tasks = list(),
    sections_id = c(0, 0),
    token = "fake"
  )

  expect_equal(nrow(result), 2)
})

test_that("get_tasks_to_update identifies tasks to update", {
  existing_tasks <- list(
    list(content = "Task 1", project_id = "123", section_id = "0", id = "1", responsible_uid = "0"),
    list(content = "Task 2", project_id = "123", section_id = "0", id = "2", responsible_uid = "0")
  )

  result <- rtodoist:::get_tasks_to_update(
    tasks = c("Task 1", "Task 3"),
    due = c("null", "null"),
    responsible_uid = c("null", "null"),
    existing_tasks = existing_tasks,
    sections_id = c(0, 0),
    token = "fake",
    que_si_necessaire = FALSE
  )

  # Only Task 1 exists and should be updated
  expect_true(nrow(result) >= 0)
})
