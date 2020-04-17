#' Open todoist website
#'
#' @param verbose make it talk
#'
#' @importFrom utils browseURL
#'
#' @return open a webpage
#' @export
#' @examples 
#' open_todoist_website_profile()
open_todoist_website_profile <- function(verbose = TRUE) {
  if (verbose) {
    message("opening https://todoist.com/prefs/integrations")
  }
  browseURL("https://todoist.com/prefs/integrations")
}
