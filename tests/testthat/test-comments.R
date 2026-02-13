# Tests for comments functions

library(rtodoist)

# Load fixtures
comments_json <- jsonlite::read_json(
  test_path("fixtures", "comments_response.json")
)

test_that("comments dataframe has correct structure", {
  comments_df <- purrr::map_dfr(comments_json$results, function(x) {
    data.frame(
      id = x$id %||% NA_character_,
      content = x$content %||% NA_character_,
      task_id = x$task_id %||% NA_character_,
      project_id = x$project_id %||% NA_character_,
      posted_at = x$posted_at %||% NA_character_,
      stringsAsFactors = FALSE
    )
  })

  expect_true("id" %in% names(comments_df))
  expect_true("content" %in% names(comments_df))
  expect_true("task_id" %in% names(comments_df))
  expect_true("posted_at" %in% names(comments_df))
  expect_equal(nrow(comments_df), 2)
})

test_that("add_comment requires task_id or project_id", {
  expect_error(
    add_comment(
      content = "Test comment",
      task_id = NULL,
      project_id = NULL,
      token = "fake_token"
    ),
    "Either task_id or project_id must be provided"
  )
})

test_that("get_comments requires task_id or project_id", {
  expect_error(
    get_comments(
      task_id = NULL,
      project_id = NULL,
      token = "fake_token"
    ),
    "Either task_id or project_id must be provided"
  )
})
