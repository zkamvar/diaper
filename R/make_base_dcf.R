#' Add dependencies to a DESCRIPTION file
#'
#' @param replacements A character string of packages to add/replace
#' @param field Which field should be modified (defaults to "Imports")
#' @param file The DESCRIPTION file.
#' @param name The name of the project (in the case that the DESCRIPTION does not exist.)
#' @param write a logical. If `TRUE`, DESCRIPTION file will be overwritten, if `FALSE`, the file will be printed to screen.
#'
#' @return if `write = TRUE`, NULL, if `write = FALSE`, the DESCRIPTION file will be printed to screen.
#' @export
#'
#' @examples
#' # a superficial example with this package's DESCRIPTION file
#' LIB <- .libPaths()[1]
#' pkg <- file.path(LIB, "diaper", "DESCRIPTION")
#' # note the Dependency version for R
#' write.dcf(read.dcf(pkg))
#' # now we change it to be 3.0
#' add_deps(replacements = "R (>= 3.0.0)", field = "Depends",
#'          file = pkg, write = FALSE)
add_deps <- function(replacements = c("utils", "stats", "grDevices"), field = "Imports", file = "DESCRIPTION", name = "myAnalysis", write = FALSE){
  if (!file.exists(file)){
    make_base_dcf(name, file)
  }
  x        <- read.dcf(file, all = TRUE)
  if (!any(names(x) == field)) x[[field]] <- ""
  deps     <- gsub("\n", "", trimws(strsplit(x[[field]], ",")[[1]]))
  depsplit <- vapply(strsplit(deps, " *\\("), "[", character(1), 1)
  newsplit <- vapply(strsplit(replacements, " *\\("), "[", character(1), 1)
  the_match <- match(depsplit, newsplit, nomatch = 0)
  deps[the_match > 0] <- replacements[the_match]
  deps <- unique(c(deps, replacements))
  x[[field]] <- paste0(deps, collapse = ", ")
  write.dcf(x, file = if (write) file else "")
}


#' Create a base DESCRIPTION file for your project
#'
#' @param name the name of your analysis
#' @param out the output file
#'
#' @return NULL
#' @export
#' @examples
#' tmp <- tempfile()
#' make_base_dcf(out = tmp)
#' write.dcf(read.dcf(tmp))
#' @importFrom utils modifyList
make_base_dcf <- function(name = "myAnalysis", out = "DESCRIPTION"){
  # This part of the function was lifted from devtools:::build_description
  default <- list(Package = name, Title = "",
        Version = "0.0.0.9000", Author = "Me",
        Description = "An analysis of...",
        Depends = paste0("R (>= ", as.character(getRversion()),
            ")"), License = "Choose your license", Encoding = "UTF-8",
        LazyData = "true")
  write.dcf(as.data.frame(default), file = out)
}