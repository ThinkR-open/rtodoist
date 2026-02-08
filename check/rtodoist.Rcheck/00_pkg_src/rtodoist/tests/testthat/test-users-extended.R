# Tests for extended user functions

library(rtodoist)

# Load fixtures
user_json <- jsonlite::read_json(
  test_path("fixtures", "user_sync_response.json")
)

test_that("user info has correct structure", {
  user <- user_json$user

  expect_true(!is.null(user$id))
  expect_true(!is.null(user$email))
  expect_true(!is.null(user$full_name))
  expect_true(!is.null(user$karma))
  expect_true(!is.null(user$karma_trend))
})

test_that("productivity stats can be extracted from user data", {
  user <- user_json$user

  stats <- list(
    karma = user$karma,
    karma_trend = user$karma_trend,
    completed_today = user$completed_today,
    days_items = user$days_items,
    week_items = user$week_items
  )

  expect_true(!is.null(stats$karma))
  expect_equal(stats$karma, 1500)
  expect_equal(stats$karma_trend, "up")
  expect_equal(stats$completed_today, 5)
})

test_that("null coalescing operator works correctly", {
  # Test the %||% operator
  `%||%` <- rtodoist:::`%||%`

  expect_equal(NULL %||% "default", "default")
  expect_equal("value" %||% "default", "value")
  expect_equal(NA %||% "default", NA)
})
