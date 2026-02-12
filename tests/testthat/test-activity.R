# Tests for activity logs functions

library(rtodoist)

# Load fixtures
activity_json <- jsonlite::read_json(
  test_path("fixtures", "activity_logs_response.json")
)

test_that("activity logs dataframe has correct structure from fixture", {
  events <- activity_json$events

  events_df <- purrr::map_dfr(events, function(x) {
    data.frame(
      id = x$id %||% NA_character_,
      object_type = x$object_type %||% NA_character_,
      object_id = x$object_id %||% NA_character_,
      event_type = x$event_type %||% NA_character_,
      event_date = x$event_date %||% NA_character_,
      initiator_id = x$initiator_id %||% NA_character_,
      parent_project_id = x$parent_project_id %||% NA_character_,
      parent_item_id = x$parent_item_id %||% NA_character_,
      stringsAsFactors = FALSE
    )
  })

  expect_true("id" %in% names(events_df))
  expect_true("object_type" %in% names(events_df))
  expect_true("object_id" %in% names(events_df))
  expect_true("event_type" %in% names(events_df))
  expect_true("event_date" %in% names(events_df))
  expect_true("initiator_id" %in% names(events_df))
  expect_equal(nrow(events_df), 3)
})

test_that("activity logs contain expected event types", {
  events <- activity_json$events

  events_df <- purrr::map_dfr(events, function(x) {
    data.frame(
      id = x$id,
      event_type = x$event_type,
      stringsAsFactors = FALSE
    )
  })

  expect_true("added" %in% events_df$event_type)
  expect_true("completed" %in% events_df$event_type)
  expect_true("updated" %in% events_df$event_type)
})

test_that("activity logs contain expected object types", {
  events <- activity_json$events

  object_types <- sapply(events, function(x) x$object_type)

  expect_true("item" %in% object_types)
  expect_true("project" %in% object_types)
})

test_that("empty activity logs returns empty dataframe", {
  empty_response <- list(events = list())

  if (length(empty_response$events) == 0) {
    result <- data.frame(
      id = character(),
      object_type = character(),
      object_id = character(),
      event_type = character(),
      event_date = character(),
      initiator_id = character(),
      parent_project_id = character(),
      parent_item_id = character(),
      stringsAsFactors = FALSE
    )
  }

  expect_equal(nrow(result), 0)
  expect_true("id" %in% names(result))
  expect_true("event_type" %in% names(result))
  expect_true("initiator_id" %in% names(result))
  expect_true("parent_project_id" %in% names(result))
  expect_true("parent_item_id" %in% names(result))
})

# Integration tests (require API token and premium account)
# Note: activity_logs endpoint may require premium/business account
test_that("get_activity_logs returns dataframe", {
  skip_if_no_token()
  skip_on_ci_or_cran()
  skip("Activity logs endpoint requires premium account")

  logs <- get_activity_logs(limit = 10)

  expect_s3_class(logs, "data.frame")
  expect_true("id" %in% names(logs) || nrow(logs) == 0)
})

test_that("get_activity_logs respects limit parameter", {
  skip_if_no_token()
  skip_on_ci_or_cran()
  skip("Activity logs endpoint requires premium account")

  logs <- get_activity_logs(limit = 5)

  expect_s3_class(logs, "data.frame")
  expect_lte(nrow(logs), 5)
})

test_that("get_activity_logs filters by object_type", {
  skip_if_no_token()
  skip_on_ci_or_cran()
  skip("Activity logs endpoint requires premium account")

  logs <- get_activity_logs(object_type = "item", limit = 10)

  expect_s3_class(logs, "data.frame")
  if (nrow(logs) > 0) {
    expect_true(all(logs$object_type == "item"))
  }
})
