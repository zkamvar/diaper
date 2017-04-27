split_field <- function(x, field) gsub("\n", "", trimws(strsplit(x[[field]], ",")[[1]]))
strip_parens <- function(x) vapply(strsplit(x, " *\\("), "[", character(1), 1)

#' Add dependencies to a DESCRIPTION file
#'
#' @param replacements A character string of packages to add/replace
#' @param field Which field should be modified (defaults to "Imports")
#' @param file The DESCRIPTION file.
#' @param name The name of the project (in the case that the DESCRIPTION does not exist.)
#' @param write a logical. If `TRUE`, DESCRIPTION file will be overwritten, if `FALSE`, the file will be printed to screen.
#' @rdname add
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
#' add(replacements = "R (>= 3.0.0)", field = "Depends",
#'     file = pkg, write = FALSE)
add <- function(replacements = c("utils", "stats", "grDevices"), field = "Imports", file = "DESCRIPTION", name = "myAnalysis", write = FALSE){
  if (!file.exists(file)){
    # create a temporary file so nothing is truely overwritten
    tmp <- tempfile()
    make_base_dcf(name, tmp)
    x <- read.dcf(tmp, all = TRUE)
  } else {
    x <- read.dcf(file, all = TRUE)
  }
  if (!any(names(x) == field)) x[[field]] <- ""
  deps     <- split_field(x, field)
  depsplit <- strip_parens(deps)
  newsplit <- strip_parens(replacements)
  the_match <- match(depsplit, newsplit, nomatch = 0)
  deps[the_match > 0] <- replacements[the_match]
  deps <- unique(c(deps, replacements))
  x[[field]] <- paste0(deps, collapse = ", ")
  write.dcf(x, file = if (write) file else "")
}




#' Remove dependencies from a DESCRIPTION file
#'
#' This function will remove any entries that don't belong in the description
#' file, regardless of version number. This can be used to remove misspelled or
#' unused dependencies.
#'
#' @param to_remove a list of dependencies to remove
#' @inheritParams add
#'
#' @return if `write = TRUE`, the specified file will be modified. If `write =
#'   FALSE`, the proposed changes.
#' @export
#'
#' @examples
#'
#' tmp <- tempdir()
#' add(file = file.path(tmp, "DESCRIPTION"), write = TRUE)
#' write.dcf(read.dcf(file.path(tmp, "DESCRIPTION")))
#' remove("utils", file = file.path(tmp, "DESCRIPTION"))
#'
remove <- function(to_remove = c("utlis"), field = "Imports", file = "DESCRIPTION", write = FALSE){
  if (!file.exists(file)){
    msg <- paste("the file", normalizePath(file), "doesn't exist.",
                 "I can't remove something that isn't there.")
    stop(msg)
  }
  x <- read.dcf(file, all = TRUE)
  entries  <- split_field(x, field)
  stripped <- strip_parens(entries)
  entries <- entries[!stripped %in% to_remove]
  x[[field]] <- paste0(entries, collapse = ", ")
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