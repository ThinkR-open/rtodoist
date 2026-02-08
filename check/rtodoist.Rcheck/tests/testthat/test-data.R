# Tests for data retrieval functions

test_that("get_all_data returns complete data structure", {
  skip_on_cran()
  skip_if_no_token()

  data <- get_all_data()

  expect_type(data, "list")

  # Should have projects
  expect_true("projects" %in% names(data))
  expect_true(length(data$projects) > 0)

  # Should have items/tasks
  expect_true("items" %in% names(data))

  # Should have sections
  expect_true("sections" %in% names(data))

  # Should have collaborators
  expect_true("collaborators" %in% names(data))
})
