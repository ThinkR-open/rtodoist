# Tests for reminders functions

library(rtodoist)

# Load fixtures
reminders_json <- jsonlite::read_json(
  test_path("fixtures", "reminders_sync_response.json")
)

test_that("reminders dataframe has correct structure", {
  reminders_df <- purrr::map_dfr(reminders_json$reminders, function(x) {
    due_date <- if (!is.null(x$due)) x$due$date else NA_character_
    data.frame(
      id = x$id %||% NA_character_,
      item_id = x$item_id %||% NA_character_,
      type = x$type %||% NA_character_,
      due_date = due_date,
      minute_offset = x$minute_offset %||% NA_integer_,
      stringsAsFactors = FALSE
    )
  })

  expect_true("id" %in% names(reminders_df))
  expect_true("item_id" %in% names(reminders_df))
  expect_true("type" %in% names(reminders_df))
  expect_true("due_date" %in% names(reminders_df))
  expect_true("minute_offset" %in% names(reminders_df))
  expect_equal(nrow(reminders_df), 2)
})

test_that("reminders have correct types", {
  reminders_df <- purrr::map_dfr(reminders_json$reminders, function(x) {
    data.frame(
      id = x$id,
      type = x$type,
      stringsAsFactors = FALSE
    )
  })

  expect_true("absolute" %in% reminders_df$type)
  expect_true("relative" %in% reminders_df$type)
})
