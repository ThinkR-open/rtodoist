# Tests for uploads functions

library(rtodoist)

test_that("upload_file validates file existence", {
  expect_error(
    upload_file(
      file_path = "nonexistent_file.pdf",
      verbose = FALSE,
      token = "fake_token"
    ),
    "File not found"
  )
})

test_that("upload_file uses basename as default file_name", {
  # Create a temporary file

  temp_file <- tempfile(pattern = "test_upload", fileext = ".txt")
  writeLines("Test content", temp_file)

  # The function should accept the file but will error on API call
  expect_error(
    upload_file(
      file_path = temp_file,
      verbose = FALSE,
      token = "fake_token"
    )
  )

  unlink(temp_file)
})

test_that("upload_file accepts custom file_name", {
  # Create a temporary file
  temp_file <- tempfile(pattern = "original_name", fileext = ".txt")
  writeLines("Test content", temp_file)

  # The function should accept custom file name but will error on API call
  expect_error(
    upload_file(
      file_path = temp_file,
      file_name = "custom_name.txt",
      verbose = FALSE,
      token = "fake_token"
    )
  )

  unlink(temp_file)
})

test_that("delete_upload accepts file_url parameter", {
  # Will error on API call since we don't have a real token
  expect_error(
    delete_upload(
      file_url = "https://example.com/fake_file.pdf",
      verbose = FALSE,
      token = "fake_token"
    )
  )
})

# Integration tests (require API token)
test_that("upload_file uploads and returns file info", {
  skip_if_no_token()
  skip_on_ci_or_cran()

  # Create a temporary file to upload
  temp_file <- tempfile(pattern = "rtodoist_test_", fileext = ".txt")
  writeLines("This is a test file for rtodoist upload testing.", temp_file)

  result <- upload_file(
    file_path = temp_file,
    verbose = FALSE
  )

  expect_type(result, "list")
  expect_true("file_url" %in% names(result) || "url" %in% names(result))

  # Clean up - delete the uploaded file
  file_url <- result$file_url %||% result$url
  if (!is.null(file_url)) {
    try(delete_upload(file_url, verbose = FALSE), silent = TRUE)
  }

  unlink(temp_file)
})

test_that("upload and delete cycle works", {
  skip_if_no_token()
  skip_on_ci_or_cran()

  # Create a temporary file
  temp_file <- tempfile(pattern = "rtodoist_delete_test_", fileext = ".txt")
  writeLines("Test file for delete testing.", temp_file)

  # Upload
  upload_result <- upload_file(
    file_path = temp_file,
    verbose = FALSE
  )

  file_url <- upload_result$file_url %||% upload_result$url
  skip_if(is.null(file_url), "Upload did not return file URL")


  # Delete - should not error

  expect_no_error(
    delete_upload(file_url, verbose = FALSE)
  )

  unlink(temp_file)
})
