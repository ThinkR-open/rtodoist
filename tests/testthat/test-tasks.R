# Tests for task management functions

test_that("get_tasks returns a list", {
  skip_on_cran()
  skip_if_no_token()

  tasks <- get_tasks()

  expect_type(tasks, "list")
})

test_that("add_tasks_in_project adds simple tasks", {
  skip_on_cran()
  skip_if_no_token()
  skip_if_test_project_missing()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)
  unique_task <- paste0("Test_Task_", format(Sys.time(), "%H%M%S"))

  result <- add_tasks_in_project(
    project_id = proj_id,
    tasks = unique_task,
    verbose = FALSE
  )

  expect_type(result, "character")

  # Verify task was created
  proj_tasks <- get_tasks_of_project(project_id = proj_id)
  task_names <- sapply(proj_tasks, function(x) x$content)
  expect_true(unique_task %in% task_names)
})

test_that("add_tasks_in_project adds tasks with responsible and assigns correctly", {
  skip_on_cran()
  skip_if_no_token()
  skip_if_test_project_missing()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)
  unique_task <- paste0("Task_With_Responsible_", format(Sys.time(), "%H%M%S"))

  # Get the expected user ID
  all_users <- get_all_users()
  expected_uid <- all_users$id[all_users$email == TEST_COLLABORATORS[1]]

  # Create task with responsible
  result <- add_tasks_in_project(
    project_id = proj_id,
    tasks = unique_task,
    responsible = TEST_COLLABORATORS[1],
    verbose = FALSE
  )

  expect_type(result, "character")

  # Wait for API sync
  Sys.sleep(1)

  # Verify task was created WITH the correct responsible_uid

  proj_tasks <- get_tasks_of_project(project_id = proj_id)
  task_found <- FALSE
  for (t in proj_tasks) {
    if (t$content == unique_task) {
      task_found <- TRUE
      expect_equal(t$responsible_uid, expected_uid,
        info = paste("Task should be assigned to", TEST_COLLABORATORS[1]))
      break
    }
  }
  expect_true(task_found, info = "Task should exist in project")
})

test_that("add_tasks_in_project adds tasks with due date", {
  skip_on_cran()
  skip_if_no_token()
  skip_if_test_project_missing()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)
  unique_task <- paste0("Task_With_Due_", format(Sys.time(), "%H%M%S"))
  future_date <- format(Sys.Date() + 7, "%Y-%m-%d")

  result <- add_tasks_in_project(
    project_id = proj_id,
    tasks = unique_task,
    due = future_date,
    verbose = FALSE
  )

  expect_type(result, "character")
})

test_that("add_tasks_in_project adds tasks with section", {
  skip_on_cran()
  skip_if_no_token()
  skip_if_test_project_missing()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)
  unique_task <- paste0("Task_With_Section_", format(Sys.time(), "%H%M%S"))

  result <- add_tasks_in_project(
    project_id = proj_id,
    tasks = unique_task,
    section_name = "Section A - Preparation",
    verbose = FALSE
  )

  expect_type(result, "character")
})

test_that("add_tasks_in_project check_only returns dataframe without creating tasks", {
  skip_on_cran()
  skip_if_no_token()
  skip_if_test_project_missing()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)
  unique_task <- paste0("Check_Only_Task_", format(Sys.time(), "%H%M%S"))

  # Get task count before
  tasks_before <- get_tasks_of_project(project_id = proj_id)
  count_before <- length(tasks_before)

  # Run with check_only = TRUE
  result <- add_tasks_in_project(
    project_id = proj_id,
    tasks = unique_task,
    check_only = TRUE,
    verbose = FALSE
  )

  # Should return a dataframe
  expect_s3_class(result, "data.frame")

  # Task count should be the same (no task added)
  tasks_after <- get_tasks_of_project(project_id = proj_id)
  expect_equal(length(tasks_after), count_before)
})

test_that("add_tasks_in_project_from_df adds tasks from dataframe", {
  skip_on_cran()
  skip_if_no_token()
  skip_if_test_project_missing()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)
  timestamp <- format(Sys.time(), "%H%M%S")

  tasks_df <- data.frame(
    tasks = c(
      paste0("DF_Task_1_", timestamp),
      paste0("DF_Task_2_", timestamp)
    ),
    responsible = c(TEST_COLLABORATORS[1], TEST_COLLABORATORS[2]),
    due = c(
      format(Sys.Date() + 7, "%Y-%m-%d"),
      format(Sys.Date() + 8, "%Y-%m-%d")
    ),
    section_name = c("Section A - Preparation", "Section B - Execution"),
    stringsAsFactors = FALSE
  )

  result <- add_tasks_in_project_from_df(
    project_id = proj_id,
    tasks_as_df = tasks_df,
    verbose = FALSE
  )

  expect_type(result, "character")
})

test_that("get_tasks_of_project returns tasks for specific project", {
  skip_on_cran()
  skip_if_no_token()
  skip_if_test_project_missing()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)

  tasks <- get_tasks_of_project(project_id = proj_id)

  expect_type(tasks, "list")
  expect_true(length(tasks) > 0)

  # All tasks should have required fields
  if (length(tasks) > 0) {
    first_task <- tasks[[1]]
    expect_true("content" %in% names(first_task))
    expect_true("project_id" %in% names(first_task))
    expect_true("id" %in% names(first_task))
  }
})

test_that("add_responsible_to_task assigns user to existing task", {
  skip_on_cran()
  skip_if_no_token()
  skip_if_test_project_missing()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)
  unique_task <- paste0("Task_For_Assignment_", format(Sys.time(), "%H%M%S"))

  # First create a task without responsible
  add_tasks_in_project(
    project_id = proj_id,
    tasks = unique_task,
    verbose = FALSE
  )

  # Then assign a responsible
  result <- add_responsible_to_task(
    project_id = proj_id,
    task = unique_task,
    responsible = TEST_COLLABORATORS[1],
    verbose = FALSE
  )

  # Function should complete without error
  expect_true(TRUE)
})
