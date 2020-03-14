#' Random key
#'
#' @return key
#'
#' @importFrom digest digest
#' @importFrom glue glue
#'

random_key <- function() {
  # create a random key
  mdp <- paste0(sample(letters,
    size = 10,
    replace = TRUE
  ),
  collapse = ""
  )

  digest(glue("{Sys.time()}{mdp}"))
}
