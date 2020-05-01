usethis::use_build_ignore("devtools_history.R")
usethis::use_build_ignore("test.R")

usethis::use_package("glue")
usethis::use_package("digest")
usethis::use_package("httr")
usethis::use_package("purrr")
usethis::use_package("dplyr")

## CI

# CI github
usethis::use_github_actions()
usethis::use_github_action(name = "check-standard")
usethis::use_github_actions_badge("R-CMD-check")
usethis::use_github_action(name = "pkgdown")

#utils
thinkridentity::add_thinkr_css(path = "vignettes")
usethis::use_pipe()
usethis::use_mit_license("Cervan Girard")
pkgdown::build_site()
usethis::use_git_ignore("docs/")
usethis::use_build_ignore("pkgdown/")
usethis::use_build_ignore("docs/")

#ignore

usethis::use_git_ignore(".Rhistory")

#git init

usethis::use_git()

#vignette

usethis::use_vignette("How_it_works")
