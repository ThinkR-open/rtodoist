# Tests for labels functions

library(rtodoist)

# Load fixtures
labels_json <- jsonlite::read_json(
  test_path("fixtures", "labels_response.json")
)

test_that("get_label_id extracts label id from list", {
  # Create a mock labels dataframe
  labels_df <- purrr::map_dfr(labels_json$results, function(x) {
    data.frame(
      id = x$id,
      name = x$name,
      color = x$color,
      is_favorite = x$is_favorite,
      stringsAsFactors = FALSE
    )
  })

  result <- get_label_id(
    label_name = "urgent",
    all_labels = labels_df,
    token = "fake_token",
    create = FALSE
  )
  expect_equal(result, "2156154810")
})

test_that("get_label_id returns error for non-existent label when create=FALSE", {
  labels_df <- purrr::map_dfr(labels_json$results, function(x) {
    data.frame(
      id = x$id,
      name = x$name,
      color = x$color,
      is_favorite = x$is_favorite,
      stringsAsFactors = FALSE
    )
  })

  expect_error(
    get_label_id(
      label_name = "NonExistent",
      all_labels = labels_df,
      token = "fake_token",
      create = FALSE
    ),
    "Label not found"
  )
})

test_that("labels dataframe has correct structure", {
  labels_df <- purrr::map_dfr(labels_json$results, function(x) {
    data.frame(
      id = x$id,
      name = x$name,
      color = x$color,
      is_favorite = x$is_favorite,
      stringsAsFactors = FALSE
    )
  })

  expect_true("id" %in% names(labels_df))
  expect_true("name" %in% names(labels_df))
  expect_true("color" %in% names(labels_df))
  expect_true("is_favorite" %in% names(labels_df))
  expect_equal(nrow(labels_df), 3)
})
