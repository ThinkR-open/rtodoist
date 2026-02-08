# Tests for token management functions

library(rtodoist)

test_that("set_todoist_api_token rejects non-character input", {
  expect_error(
    set_todoist_api_token(123),
    "Token must be a character vector"
  )
})

test_that("set_todoist_api_token rejects list input", {
  expect_error(
    set_todoist_api_token(list(token = "abc")),
    "Token must be a character vector"
  )
})

test_that("delete_todoist_api_token runs without error", {
  # Should not error even if no token exists
  expect_no_error(delete_todoist_api_token())
})

test_that("get_todoist_api_token with ask=FALSE returns NULL when no token", {
  # First delete any existing token
  delete_todoist_api_token()

  # Should return NULL without prompting
  result <- get_todoist_api_token(ask = FALSE)
  expect_null(result)
})
