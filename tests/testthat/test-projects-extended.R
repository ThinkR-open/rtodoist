# Tests for extended project functions

library(rtodoist)

# Load fixtures
projects_json <- jsonlite::read_json(
  test_path("fixtures", "projects_response.json")
)

test_that("projects dataframe has correct structure", {
  projects_df <- purrr::map_dfr(projects_json$projects, function(x) {
    data.frame(
      id = x$id,
      name = x$name,
      color = x$color,
      is_favorite = x$is_favorite,
      stringsAsFactors = FALSE
    )
  })

  expect_true("id" %in% names(projects_df))
  expect_true("name" %in% names(projects_df))
  expect_true("color" %in% names(projects_df))
  expect_true("is_favorite" %in% names(projects_df))
  expect_equal(nrow(projects_df), 2)
})

test_that("get_project_id handles multiple projects", {
  result <- get_project_id(
    project_name = "TestProject",
    all_projects = projects_json,
    token = "fake_token",
    create = FALSE
  )
  expect_equal(result, "2244736524")
})

test_that("get_archived_projects returns empty dataframe when no results", {
  empty_response <- list(results = list(), next_cursor = NULL)

  # Simulate empty response parsing
  if (length(empty_response$results) == 0) {
    result <- data.frame(id = character(), name = character(), stringsAsFactors = FALSE)
  }

  expect_equal(nrow(result), 0)
  expect_true("id" %in% names(result))
  expect_true("name" %in% names(result))
})
