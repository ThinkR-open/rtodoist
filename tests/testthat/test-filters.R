# Tests for filters functions

library(rtodoist)

# Load fixtures
filters_json <- jsonlite::read_json(
  test_path("fixtures", "filters_sync_response.json")
)

test_that("filters dataframe has correct structure", {
  filters_df <- purrr::map_dfr(filters_json$filters, function(x) {
    data.frame(
      id = x$id %||% NA_character_,
      name = x$name %||% NA_character_,
      query = x$query %||% NA_character_,
      color = x$color %||% NA_character_,
      is_favorite = x$is_favorite %||% FALSE,
      stringsAsFactors = FALSE
    )
  })

  expect_true("id" %in% names(filters_df))
  expect_true("name" %in% names(filters_df))
  expect_true("query" %in% names(filters_df))
  expect_true("color" %in% names(filters_df))
  expect_true("is_favorite" %in% names(filters_df))
  expect_equal(nrow(filters_df), 2)
})

test_that("get_filter_id extracts filter id from list", {
  filters_df <- purrr::map_dfr(filters_json$filters, function(x) {
    data.frame(
      id = x$id,
      name = x$name,
      query = x$query,
      color = x$color,
      is_favorite = x$is_favorite,
      stringsAsFactors = FALSE
    )
  })

  result <- get_filter_id(
    filter_name = "Urgent Today",
    all_filters = filters_df,
    token = "fake_token"
  )
  expect_equal(result, "1234567")
})

test_that("get_filter_id returns error for non-existent filter", {
  filters_df <- purrr::map_dfr(filters_json$filters, function(x) {
    data.frame(
      id = x$id,
      name = x$name,
      query = x$query,
      color = x$color,
      is_favorite = x$is_favorite,
      stringsAsFactors = FALSE
    )
  })

  expect_error(
    get_filter_id(
      filter_name = "NonExistent",
      all_filters = filters_df,
      token = "fake_token"
    ),
    "Filter not found"
  )
})
