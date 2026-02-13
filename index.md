# rtodoist ![](reference/figures/logo.png)

This package allows to use the todoist API. You will be able to add
projects and tasks to your todoist account.

To find information about todoist API :

<https://developer.todoist.com/api/v1/>

## Installation

You can install from CRAN :

``` r
install.packages("rtodoist")
```

You can install the development version of rtodoist with:

``` r
remotes::install_github("ThinkR-open/rtodoist")
```

## Example

``` r
library(rtodoist)

add_project("test") %>%
  add_tasks_in_project("my_task")
```

To find more details about the features, look at the ‘How it works’
vignette.
