usethis::use_build_ignore("devtools_history.R")
usethis::use_build_ignore("test.R")

usethis::use_package("glue")
usethis::use_package("digest")
usethis::use_package("httr")
usethis::use_package("purrr")
usethis::use_package("dplyr")

#utils

usethis::use_pipe()
usethis::use_mit_license("Cervan Girard")


#ignore

usethis::use_git_ignore(".Rhistory")

#git init

usethis::use_git()

#vignette

usethis::use_vignette("How_it_works")
