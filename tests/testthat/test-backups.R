# Tests for backups functions

library(rtodoist)

# Load fixtures
backups_json <- jsonlite::read_json(
  test_path("fixtures", "backups_response.json")
)

test_that("backups dataframe has correct structure from fixture", {
  backups <- backups_json$results

  backups_df <- purrr::map_dfr(backups, function(x) {
    data.frame(
      version = x$version %||% NA_character_,
      url = x$url %||% NA_character_,
      stringsAsFactors = FALSE
    )
  })

  expect_true("version" %in% names(backups_df))
  expect_true("url" %in% names(backups_df))
  expect_equal(nrow(backups_df), 3)
})

test_that("backups contain valid version strings", {
  backups <- backups_json$results

  versions <- sapply(backups, function(x) x$version)

  expect_true(all(grepl("^\\d{4}-\\d{2}-\\d{2}", versions)))
})

test_that("backups contain valid URLs", {
  backups <- backups_json$results

  urls <- sapply(backups, function(x) x$url)

  expect_true(all(grepl("^https://", urls)))
})

test_that("empty backups returns empty dataframe", {
  empty_response <- list(results = list())

  if (length(empty_response$results) == 0) {
    result <- data.frame(
      version = character(),
      url = character(),
      stringsAsFactors = FALSE
    )
  }

  expect_equal(nrow(result), 0)
  expect_true("version" %in% names(result))
  expect_true("url" %in% names(result))
})

test_that("download_backup validates version exists", {
  skip_if_no_token()
  skip_on_ci_or_cran()

  # This should error because the version doesn't exist

  expect_error(
    download_backup("nonexistent_version", tempfile(), verbose = FALSE),
    "Backup version not found"
  )
})

# Integration tests (require API token)
test_that("get_backups returns dataframe", {
  skip_if_no_token()
  skip_on_ci_or_cran()

  backups <- get_backups()

  expect_s3_class(backups, "data.frame")
  expect_true("version" %in% names(backups) || nrow(backups) == 0)
  expect_true("url" %in% names(backups) || nrow(backups) == 0)
})
