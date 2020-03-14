#' Get the token
#'
#' @param app_id name of the app
#' @param client_id client id
#' @param client_secret client secret
#'
#' @return object of connection
#' @export
#'
#' @importFrom httr oauth_endpoint oauth_app oauth2.0_token

ask_todoist_app_api_token <- function(app_id = rstudioapi::showPrompt("Name of app", ""),
                                      client_id = rstudioapi::showPrompt("Client ID of the app", message = "Client ID"),
                                      client_secret = rstudioapi::askForPassword(prompt = "Client Secret of app")) {
  ep <- httr::oauth_endpoint(
    authorize = "https://todoist.com/oauth/authorize",
    access = "https://todoist.com/oauth/access_token"
  )
  app <- httr::oauth_app(
    appname = app_id,
    key = client_id,
    secret = client_secret
  )
  token <- httr::oauth2.0_token(
    ep,
    app,
    scope = c("data:read_write,data:delete"),
    user_params = list(state = random_key())
  )
  token$credentials$access_token
}
