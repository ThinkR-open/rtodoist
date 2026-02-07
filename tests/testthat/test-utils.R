# Tests for utility functions (no API calls needed)

test_that("escape_json escapes backslashes", {
  expect_equal(rtodoist:::escape_json("a\\b"), "a\\\\b")
})

test_that("escape_json escapes double quotes", {
 expect_equal(rtodoist:::escape_json('say "hello"'), 'say \\"hello\\"')
})

test_that("escape_json escapes newlines", {
  expect_equal(rtodoist:::escape_json("line1\nline2"), "line1\\nline2")
})

test_that("escape_json escapes carriage returns", {
  expect_equal(rtodoist:::escape_json("line1\rline2"), "line1\\rline2")
})

test_that("escape_json escapes tabs", {
  expect_equal(rtodoist:::escape_json("col1\tcol2"), "col1\\tcol2")
})

test_that("escape_json handles multiple special characters", {
  input <- "He said:\n\t\"Hello\\World\""
  expected <- "He said:\\n\\t\\\"Hello\\\\World\\\""
 expect_equal(rtodoist:::escape_json(input), expected)
})

test_that("escape_json handles empty string", {
  expect_equal(rtodoist:::escape_json(""), "")
})

test_that("random_key returns a string", {
  key <- rtodoist:::random_key()
  expect_type(key, "character")
  expect_true(nchar(key) > 0)
})

test_that("random_key returns different values on each call", {
  key1 <- rtodoist:::random_key()
  key2 <- rtodoist:::random_key()
  expect_false(key1 == key2)
})

test_that("clean_due returns 'null' for NULL input", {
  expect_equal(rtodoist:::clean_due(NULL), "null")
})

test_that("clean_due trims whitespace", {
  expect_equal(rtodoist:::clean_due("  2024-01-01  "), "2024-01-01")
})

test_that("clean_due converts empty strings to 'null'", {
  expect_equal(rtodoist:::clean_due(""), "null")
  expect_equal(rtodoist:::clean_due(" "), "null")
})

test_that("clean_due converts NA to 'null'", {
  expect_equal(rtodoist:::clean_due(NA), "null")
})

test_that("clean_due handles vector input", {
  result <- rtodoist:::clean_due(c("2024-01-01", "", NA, "2024-02-01"))
  expect_equal(result, c("2024-01-01", "null", "null", "2024-02-01"))
})

test_that("clean_section returns 'null' for NULL input", {
  expect_equal(rtodoist:::clean_section(NULL), "null")
})

test_that("clean_section converts to character", {
  expect_equal(rtodoist:::clean_section("Section A"), "Section A")
  expect_type(rtodoist:::clean_section(123), "character")
})

test_that("set_as_null_if_needed removes NA values", {
  result <- rtodoist:::set_as_null_if_needed(c("a", NA, "b"))
  expect_equal(result, c("a", "b"))
})

test_that("set_as_null_if_needed removes empty strings", {
  result <- rtodoist:::set_as_null_if_needed(c("a", "", " ", "b"))
  expect_equal(result, c("a", "b"))
})
