# Tests for section management functions

test_that("add_section creates a section and returns ID", {
  skip_on_cran()
  skip_if_no_token()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)
  unique_section <- paste0("Test_Section_", format(Sys.time(), "%H%M%S"))

  section_id <- add_section(
    section_name = unique_section,
    project_id = proj_id
  )

  expect_type(section_id, "character")
  expect_true(nchar(section_id) > 0)
})

test_that("add_section with force=FALSE returns existing section ID", {
  skip_on_cran()
  skip_if_no_token()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)
  section_name <- "Section A - Preparation"

  section_id_1 <- add_section(
    section_name = section_name,
    project_id = proj_id,
    force = FALSE
  )

  section_id_2 <- add_section(
    section_name = section_name,
    project_id = proj_id,
    force = FALSE
  )

  expect_equal(section_id_1, section_id_2)
})

test_that("get_section_id returns correct ID for existing section", {
  skip_on_cran()
  skip_if_no_token()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)

  # First create a section
  section_name <- "Section A - Preparation"
  created_id <- add_section(
    section_name = section_name,
    project_id = proj_id,
    force = FALSE
  )

  # Then retrieve it
  retrieved_id <- get_section_id(
    project_id = proj_id,
    section_name = section_name
  )

  expect_equal(retrieved_id, created_id)
})

test_that("get_section_id returns vector for multiple sections", {
  skip_on_cran()
  skip_if_no_token()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)

  section_ids <- get_section_id(
    project_id = proj_id,
    section_name = c("Section A - Preparation", "Section B - Execution")
  )

  expect_type(section_ids, "character")
  expect_length(section_ids, 2)
})

test_that("get_section_id returns 0 for non-existent section", {
  skip_on_cran()
  skip_if_no_token()

  proj_id <- get_project_id(TEST_PROJECT_NAME, create = FALSE)

  result <- get_section_id(
    project_id = proj_id,
    section_name = "Non_Existent_Section_12345"
  )

  # Returns "0" as character or 0 as numeric
  expect_true(result == 0 || result == "0")
})
