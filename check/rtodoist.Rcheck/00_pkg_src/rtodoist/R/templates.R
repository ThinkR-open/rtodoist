#' Import a template into a project
#'
#' @param project_id id of the project to import into
#' @param project_name name of the project (for lookup if project_id not provided)
#' @param file_path path to the template file (CSV format)
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return NULL (invisible)
#' @export
#' @importFrom httr2 request req_headers req_body_multipart req_perform
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' import_template(project_name = "my_proj", file_path = "template.csv")
#' }
import_template <- function(project_id = get_project_id(project_name = project_name, token = token, create = FALSE),
                            project_name,
                            file_path,
                            verbose = TRUE,
                            token = get_todoist_api_token()) {
  force(project_id)
  force(token)

  if (!file.exists(file_path)) {
    stop("Template file not found: ", file_path)
  }

  if (verbose) {
    message(glue::glue("Importing template into project {project_id}"))
  }

  request(glue("https://api.todoist.com/api/v1/templates/import_into_project?project_id={project_id}")) %>%
    req_headers(
      Authorization = glue::glue("Bearer {token}")
    ) %>%
    req_body_multipart(file = curl::form_file(file_path)) %>%
    req_perform()

  invisible(NULL)
}

#' Export a project as a template
#'
#' @param project_id id of the project to export
#' @param project_name name of the project (for lookup if project_id not provided)
#' @param output_file path where to save the template file
#' @param verbose boolean that make the function verbose
#' @param token todoist API token
#'
#' @return path to the saved file (invisible)
#' @export
#' @importFrom httr2 request req_headers req_perform resp_body_string
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' export_template(project_name = "my_proj", output_file = "template.csv")
#' }
export_template <- function(project_id = get_project_id(project_name = project_name, token = token, create = FALSE),
                            project_name,
                            output_file,
                            verbose = TRUE,
                            token = get_todoist_api_token()) {
  force(project_id)
  force(token)

  if (verbose) {
    message(glue::glue("Exporting project {project_id} as template"))
  }

  response <- request(glue("https://api.todoist.com/api/v1/templates/export_as_file?project_id={project_id}")) %>%
    req_headers(
      Authorization = glue::glue("Bearer {token}")
    ) %>%
    req_perform()

  content <- resp_body_string(response)
  writeLines(content, output_file)

  if (verbose) {
    message(glue::glue("Template saved to {output_file}"))
  }

  invisible(output_file)
}
