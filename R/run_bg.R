#' Use background jobs interactively
#'
#' Set of function to make interactive work faster
#'
#' Group of functions Details paragraph.
#'
#' @describeIn run_bg Runs the selected code as a background job importing objects and packages from original session
#'
#'
#' @param cntx a string param containing code to launch (mostly for debug purpose)
#' @param view a boolean param available only for `run_bg()`
#'
#' @return `run_bg()` and `run_bg_view` returns objects from background environment to global one
#' `run_bg_view` and `run_view` launch `View()` function to show result
run_bg <- function(cntx=NULL, view=FALSE){

  # Fork logic for debug purpose
  if(is.null(cntx)){
    # Get selected context
    context <- rstudioapi::getActiveDocumentContext()$selection[[1]]$text
  }else{
    context <- cntx
  }

  # Get list of packages from environment
  packages <- names(utils::sessionInfo()$otherPkgs)

  # Save selection to a temporary file
  tf <- tempfile("jobber_tmp", fileext = ".R")
  tfc <- file(tf, open='w')
  .jobber <- NULL

  # Write selected code to background environment
  if(!is.null(context) && context != "") {
    # Write code to load packages in background environment
    if(!is.null(packages)){
      writeLines("lapply(", con=tfc)
      dput(packages, file = tfc)
      writeLines(",library, character.only=T)", con=tfc)
    }
    if(view){
      context_vw <- paste0(".jobber <- {", context, "}")
      writeLines(context_vw, con = tfc, sep = "\n")
    }else{
      writeLines(context, con = tfc, sep = "\n")
    }
    writeLines("\n", con = tfc)
    flush(tfc)

    # Delete temporary file
    on.exit({
      ## allow time for scripting to start
      Sys.sleep(5)
      close(tfc)
      unlink(tf)
    }, add=TRUE)

    # Run the temp script as a job, returning the
    # Results to the global environment
    rstudioapi::jobRunScript(
      path = path.expand(tf),
      importEnv = TRUE,
      workingDir = getwd(),
      exportEnv = "R_GlobalEnv"
    )
    if(view){utils::View(.jobber, "jobber")}
  }
}
#'
#' @describeIn run_bg Runs the selected code and then performs View
run_view <- function(cntx=NULL){
  # Fork logic for string purpose
  if(is.null(cntx)){
    # Get selected context
    context <- rstudioapi::getActiveDocumentContext()$selection[[1]]$text
  }else{
    context <- cntx
  }
  # View result of selected run
  utils::View(eval(str2expression(paste0("{", context, "}"))), title = 'jobber')

}
#'
#' @describeIn run_bg Runs the selected code as a background job importing objects and packages from original session and finally views a result
run_bg_view<- function(cntx=NULL){
  run_bg(cntx, view = TRUE)
}


