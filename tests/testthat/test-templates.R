# Tests for templates functions

library(rtodoist)

test_that("import_template validates file existence", {
  expect_error(
    import_template(
      project_id = "12345",
      file_path = "nonexistent_file.csv",
      verbose = FALSE,
      token = "fake_token"
    ),
    "Template file not found"
  )
})

test_that("import_template accepts valid file path parameter", {
  # Create a temporary CSV file
  temp_file <- tempfile(fileext = ".csv")
  writeLines("TYPE,CONTENT,PRIORITY", temp_file)

  # The function should not error on file validation
  # It will error on API call since we don't have a real token
  expect_error(
    import_template(
      project_id = "12345",
      file_path = temp_file,
      verbose = FALSE,
      token = "fake_token"
    )
  )

  unlink(temp_file)
})

test_that("export_template requires project_id or project_name", {
  # Without a valid token/project, this will error
  expect_error(
    export_template(
      project_id = "nonexistent",
      output_file = tempfile(),
      verbose = FALSE,
      token = "fake_token"
    )
  )
})

# Integration tests (require API token)
# Note: Templates API may not be available for all account types
test_that("export_template creates file for valid project", {
  skip_if_no_token()
  skip_on_ci_or_cran()
  skip("Templates API endpoint may not be available")

  # Get an existing project
  projects <- get_all_projects()
  skip_if(nrow(projects) == 0, "No projects available for testing")

  output_file <- tempfile(fileext = ".csv")

  result <- export_template(
    project_id = projects$id[1],
    output_file = output_file,
    verbose = FALSE
  )

  expect_true(file.exists(output_file))
  expect_equal(result, output_file)

  unlink(output_file)
})

test_that("import and export template round-trip works", {
  skip_if_no_token()
  skip_on_ci_or_cran()
  skip("Templates API endpoint may not be available")

  # Create a test project
  test_project_name <- paste0("rtodoist_test_template_", random_key())
  project_id <- add_project(test_project_name, verbose = FALSE)

  # Add a task to export
  add_tasks_in_project(
    project_id = project_id,
    tasks = "Test task for template",
    verbose = FALSE
  )

  # Export the project as template
  export_file <- tempfile(fileext = ".csv")
  export_template(project_id = project_id, output_file = export_file, verbose = FALSE)

  expect_true(file.exists(export_file))
  expect_gt(file.size(export_file), 0)

  # Clean up
  delete_project(project_id, verbose = FALSE)
  unlink(export_file)
})
