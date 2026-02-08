#' Upload a file
#'
#' @param file_path path to the file to upload
#' @param file_name name for the uploaded file (defaults to basename of file_path)
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return upload object with file_url
#' @export
#' @importFrom httr2 request req_headers req_body_multipart req_perform resp_body_json
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' upload <- upload_file("document.pdf")
#' # Use upload$file_url in a comment
#' }
upload_file <- function(file_path,
                        file_name = basename(file_path),
                        verbose = TRUE,
                        token = get_todoist_api_token()) {
  force(token)

  if (!file.exists(file_path)) {
    stop("File not found: ", file_path)
  }

  if (verbose) {
    message(glue::glue("Uploading file: {file_name}"))
  }

  result <- request("https://api.todoist.com/api/v1/uploads") %>%
    req_headers(
      Authorization = glue::glue("Bearer {token}")
    ) %>%
    req_body_multipart(
      file = curl::form_file(file_path),
      file_name = file_name
    ) %>%
    req_perform() %>%
    resp_body_json()

  if (verbose) {
    message(glue::glue("File uploaded successfully"))
  }

  result
}

#' Delete an uploaded file
#'
#' @param file_url URL of the file to delete
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom httr2 request req_headers req_body_json req_perform req_method
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' delete_upload("https://...")
#' }
delete_upload <- function(file_url,
                          verbose = TRUE,
                          token = get_todoist_api_token()) {
  force(token)

  if (verbose) {
    message(glue::glue("Deleting uploaded file"))
  }

  request("https://api.todoist.com/api/v1/uploads") %>%
    req_method("DELETE") %>%
    req_headers(
      Authorization = glue::glue("Bearer {token}"),
      "Content-Type" = "application/json"
    ) %>%
    req_body_json(list(file_url = file_url)) %>%
    req_perform()

  invisible(NULL)
}
