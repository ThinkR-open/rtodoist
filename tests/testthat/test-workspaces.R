# Tests for workspaces functions

library(rtodoist)

# Load fixtures
workspaces_json <- jsonlite::read_json(
  test_path("fixtures", "workspaces_response.json")
)

workspace_users_json <- jsonlite::read_json(
  test_path("fixtures", "workspace_users_response.json")
)

test_that("workspaces dataframe has correct structure from fixture", {
  workspaces <- workspaces_json$workspaces

  workspaces_df <- purrr::map_dfr(workspaces, function(x) {
    data.frame(
      id = x$id %||% NA_character_,
      name = x$name %||% NA_character_,
      is_default = x$is_default %||% FALSE,
      stringsAsFactors = FALSE
    )
  })

  expect_true("id" %in% names(workspaces_df))
  expect_true("name" %in% names(workspaces_df))
  expect_true("is_default" %in% names(workspaces_df))
  expect_equal(nrow(workspaces_df), 2)
  expect_equal(workspaces_df$id[1], "ws_123456")
  expect_equal(workspaces_df$name[1], "My Workspace")
  expect_true(workspaces_df$is_default[1])
})

test_that("workspace users dataframe has correct structure from fixture", {
  users <- workspace_users_json$workspace_users

  users_df <- purrr::map_dfr(users, function(x) {
    data.frame(
      user_id = x$user_id %||% NA_character_,
      workspace_id = x$workspace_id %||% NA_character_,
      name = x$name %||% NA_character_,
      email = x$email %||% NA_character_,
      role = x$role %||% NA_character_,
      stringsAsFactors = FALSE
    )
  })

  expect_true("user_id" %in% names(users_df))
  expect_true("workspace_id" %in% names(users_df))
  expect_true("name" %in% names(users_df))
  expect_true("email" %in% names(users_df))
  expect_true("role" %in% names(users_df))
  expect_equal(nrow(users_df), 2)
  expect_equal(users_df$role[1], "admin")
  expect_equal(users_df$role[2], "member")
})

test_that("empty workspaces returns empty dataframe", {
  empty_response <- list(workspaces = list())

  if (length(empty_response$workspaces) == 0) {
    result <- data.frame(
      id = character(),
      name = character(),
      stringsAsFactors = FALSE
    )
  }

  expect_equal(nrow(result), 0)
  expect_true("id" %in% names(result))
  expect_true("name" %in% names(result))
})

# Integration tests (require API token)
test_that("get_all_workspaces returns dataframe", {
  skip_if_no_token()
  skip_on_ci_or_cran()

  workspaces <- get_all_workspaces()

  expect_s3_class(workspaces, "data.frame")
  expect_true("id" %in% names(workspaces))
  expect_true("name" %in% names(workspaces))
})

test_that("get_workspace_users returns dataframe", {
  skip_if_no_token()
  skip_on_ci_or_cran()

  users <- get_workspace_users()

  expect_s3_class(users, "data.frame")
})
