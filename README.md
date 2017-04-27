
<!-- README.md is generated from README.Rmd. Please edit that file -->
diaper
======

This is a package to create a `DESCRIPTION` file for your project that lists specific dependencies and versions of packages needed for analysis. Yes, packages like [packrat](https://cran.r-project.org/package=packrat) exist, but I've found it to be a bit cumbersome. With a `DESCRIPTION` file, it's possible to list the packages you need for an analysis and install them with [devtools](https://cran.r-project.org/package=devtools).

[![Project Status: WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip) [![Travis-CI Build Status](https://travis-ci.org/zkamvar/diaper.svg?branch=master)](https://travis-ci.org/zkamvar/diaper)

Making Your DESCRIPTION file
----------------------------

Here's an example of creating a DESCRIPTION file using the [RClone](https://cran.r-project.org/package=RClone) and [dplyr](https://cran.r-project.org/package=dplyr) packages.

First, you use `add()` to add dependiencies to your DESCRIPTION file. If the file doesn't exist, it will simply be created.

``` r
tmp <- tempdir() # when using this for your own project, simply keep this as
                 # your current directory
diaper::add(c("RClone (>= 1.0.2)", "dplyr (>= 0.5.0)"), 
            field = "Imports", 
            file = file.path(tmp, "DESCRIPTION"), 
            name = "RCanalysis",
            write = TRUE)
# View the file that we just created
write.dcf(read.dcf(file.path(tmp, "DESCRIPTION")))
#> Package: RCanalysis
#> Title:
#> Version: 0.0.0.9000
#> Author: Me
#> Description: An analysis of...
#> Depends: R (>= 3.4.0)
#> License: Choose your license
#> Encoding: UTF-8
#> LazyData: true
#> Imports: RClone (>= 1.0.2), dplyr (>= 0.5.0)
```

Now with [devtools](https://cran.r-project.org/package=devtools), we can install the package!

``` r
devtools::install(tmp)
#> Installing RCanalysis
#> Installing dplyr
#> '/Library/Frameworks/R.framework/Resources/bin/R' --no-site-file  \
#>   --no-environ --no-save --no-restore --quiet CMD INSTALL  \
#>   '/private/var/folders/qd/dpdhfsz12wb3c7wz0xdm6dbm0000gn/T/Rtmpz36E4t/devtools9b866e583fdf/dplyr'  \
#>   --library='/Users/zhian/R' --install-tests
#> 
#> Installing RClone
#> '/Library/Frameworks/R.framework/Resources/bin/R' --no-site-file  \
#>   --no-environ --no-save --no-restore --quiet CMD INSTALL  \
#>   '/private/var/folders/qd/dpdhfsz12wb3c7wz0xdm6dbm0000gn/T/Rtmpz36E4t/devtools9b866f817f1b/RClone'  \
#>   --library='/Users/zhian/R' --install-tests
#> 
#> '/Library/Frameworks/R.framework/Resources/bin/R' --no-site-file  \
#>   --no-environ --no-save --no-restore --quiet CMD INSTALL  \
#>   '/private/var/folders/qd/dpdhfsz12wb3c7wz0xdm6dbm0000gn/T/Rtmpz36E4t'  \
#>   --library='/Users/zhian/R' --install-tests
#> 
```

We can also update fields such as the default version of R. Note that we don't need the `name` parameter here, because the file already exists.

``` r
diaper::add("R (>= 3.2.0)",
            field = "Depends",
            file = file.path(tmp, "DESCRIPTION"),
            write = TRUE)
write.dcf(read.dcf(file.path(tmp, "DESCRIPTION")))
#> Package: RCanalysis
#> Title:
#> Version: 0.0.0.9000
#> Author: Me
#> Description: An analysis of...
#> Depends: R (>= 3.2.0)
#> License: Choose your license
#> Encoding: UTF-8
#> LazyData: true
#> Imports: RClone (>= 1.0.2), dplyr (>= 0.5.0)
```

Roadmap
-------

This may be the only iteration of the package, but if there is interest, it could be made more user-friendly with the following:

-   Customization of more DESCRIPTION fields (i.e. <Authors@R>)
-   Bioconductor repositories
-   Remotes
-   SystemRequirements
-   RStudio add-in
-   Shiny app
