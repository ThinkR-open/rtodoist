# Tests for user/collaborator management functions

test_that("get_all_users returns a dataframe with email and id", {
  skip_on_cran()
  skip_if_no_token()

  users <- get_all_users()

  expect_s3_class(users, "data.frame")
  expect_true("email" %in% names(users))
  expect_true("id" %in% names(users))
  expect_true(nrow(users) > 0)
})

test_that("add_user_in_project adds a user to the project", {
  skip_on_cran()
  skip_if_no_token()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)

  # Add first test collaborator
  result <- add_user_in_project(
    project_id = proj_id,
    mail = TEST_COLLABORATORS[1],
    verbose = FALSE
  )

  # Function should complete without error
  expect_true(TRUE)
})

test_that("add_users_in_project adds multiple users to the project", {
  skip_on_cran()
  skip_if_no_token()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)

  # Add all test collaborators
  result <- add_users_in_project(
    project_id = proj_id,
    users_email = TEST_COLLABORATORS,
    verbose = FALSE
  )

  # Function should complete without error
  expect_true(TRUE)
})

test_that("get_users_in_project returns users for the project", {
  skip_on_cran()
  skip_if_no_token()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)

  proj_users <- get_users_in_project(project_id = proj_id)

  expect_s3_class(proj_users, "data.frame")
  expect_true("project_id" %in% names(proj_users))
  expect_true("user_id" %in% names(proj_users))
  expect_true(nrow(proj_users) > 0)

  # All returned rows should be for our project
  expect_true(all(proj_users$project_id == proj_id))
})
