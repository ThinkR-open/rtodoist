# Tests for project management functions

test_that("get_all_projects returns a list with projects", {
  skip_on_cran()
  skip_if_no_token()

  result <- get_all_projects()

  expect_type(result, "list")
  expect_true("projects" %in% names(result))
  expect_true(length(result$projects) > 0)
})

test_that("get_project_id returns project ID for existing project", {
  skip_on_cran()
  skip_if_no_token()

  # Use the test project
  proj_id <- get_project_id(
    project_name = TEST_PROJECT_NAME,
    create = FALSE,
    verbose = FALSE
  )

  expect_type(proj_id, "character")
  expect_true(nchar(proj_id) > 0)
})

test_that("get_project_id with create=TRUE returns same ID for existing project", {
  skip_on_cran()
  skip_if_no_token()

  proj_id1 <- get_project_id(
    project_name = TEST_PROJECT_NAME,
    create = FALSE,
    verbose = FALSE
  )

  proj_id2 <- get_project_id(
    project_name = TEST_PROJECT_NAME,
    create = TRUE,
    verbose = FALSE
  )

  expect_equal(proj_id1, proj_id2)
})

test_that("add_project creates a new project and returns ID", {
  skip_on_cran()
  skip_if_no_token()

  # Create a unique test project name
  unique_name <- paste0("test_rtodoist_", format(Sys.time(), "%Y%m%d%H%M%S"))

  proj_id <- add_project(project_name = unique_name, verbose = FALSE)

  expect_type(proj_id, "character")
  expect_true(nchar(proj_id) > 0)

  # Verify project exists
  all_projects <- get_all_projects()
  project_names <- sapply(all_projects$projects, function(x) x$name)
  expect_true(unique_name %in% project_names)
})
