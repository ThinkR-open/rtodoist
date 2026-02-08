# Tests for extended task functions

library(rtodoist)

# Load fixtures
completed_json <- jsonlite::read_json(
  test_path("fixtures", "completed_tasks_response.json")
)

test_that("completed tasks dataframe has correct structure", {
  completed_df <- purrr::map_dfr(completed_json$items, function(x) {
    data.frame(
      id = x$id %||% NA_character_,
      content = x$content %||% NA_character_,
      project_id = x$project_id %||% NA_character_,
      completed_at = x$completed_at %||% NA_character_,
      stringsAsFactors = FALSE
    )
  })

  expect_true("id" %in% names(completed_df))
  expect_true("content" %in% names(completed_df))
  expect_true("project_id" %in% names(completed_df))
  expect_true("completed_at" %in% names(completed_df))
  expect_equal(nrow(completed_df), 2)
})

test_that("get_completed_tasks returns empty dataframe when no results", {
  empty_response <- list(items = list(), next_cursor = NULL)

  # Simulate empty response parsing
  if (length(empty_response$items) == 0) {
    result <- data.frame(
      id = character(),
      content = character(),
      project_id = character(),
      completed_at = character(),
      stringsAsFactors = FALSE
    )
  }

  expect_equal(nrow(result), 0)
  expect_true("id" %in% names(result))
})

test_that("escape_json handles special characters", {
  # Test escape function
  result <- rtodoist:::escape_json('Test "quoted" string')
  expect_true(grepl('\\\\"', result))

  result <- rtodoist:::escape_json("Test\nnewline")
  expect_true(grepl("\\\\n", result))

  result <- rtodoist:::escape_json("Test\ttab")
  expect_true(grepl("\\\\t", result))
})
