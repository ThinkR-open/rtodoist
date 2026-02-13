#' Open todoist website
#'
#' @param verbose boolean that make the function verbose
#'
#' @importFrom utils browseURL
#'
#' @return open integration webpage from todoist website
#' @export
#'
#' @examples
#' open_todoist_website_profile()
open_todoist_website_profile <- function(verbose = TRUE) {
  if (verbose) {
    message("opening https://www.todoist.com/prefs/integrations")
  }
  browseURL("https://www.todoist.com/prefs/integrations")
}
