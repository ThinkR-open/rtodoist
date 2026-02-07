# Helper functions for rtodoist tests

# Skip tests if no API token is available
skip_if_no_token <- function() {
  token <- tryCatch(
    get_todoist_api_token(ask = FALSE),
    error = function(e) NULL
  )
  if (is.null(token) || token == "") {
    skip("No Todoist API token available")
  }
}

# Skip on CI environments to avoid rate limiting issues
skip_on_ci_or_cran <- function() {
  skip_on_cran()
  skip_on_ci()
}

# Test project name for integration tests
TEST_PROJECT_NAME <- "depuisclaude"

# Test collaborators
TEST_COLLABORATORS <- c("vincent@thinkr.fr", "murielle@thinkr.fr")

# Clean up function to delete test project (to be used in teardown)
cleanup_test_project <- function(project_name = TEST_PROJECT_NAME) {
  # Note: rtodoist doesn't have a delete_project function

  # Manual cleanup may be needed
  message("Remember to manually delete project: ", project_name)
}
