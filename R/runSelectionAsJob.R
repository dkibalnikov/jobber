runSelectionAsJob <- function(cntx=NULL, view=FALSE){

  # Fork logic for cntxing purpose
  if(is.null(cntx)){
    # Get selected context
    context <- rstudioapi::getActiveDocumentContext()$selection[[1]]$text
  }else{
    context <- cntx
  }

  # Get list of packages from environment
  packages <- names(sessionInfo()$otherPkgs)

  # Save selection to a temporary file
  tf <- tempfile("jobber_tmp", fileext = ".R")
  tfc <- file(tf, open='w')

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
    if(view){View(.jobber)}
  }
}

viewSelection <- function(cntx=NULL){
  # Fork logic for string purpose
  if(is.null(cntx)){
    # Get selected context
    context <- rstudioapi::getActiveDocumentContext()$selection[[1]]$text
  }else{
    context <- cntx
  }
  # View result of selected run
  eval(str2expression(paste0("View(", context, ")")))
}

viewSelectionAsJob <- function(cntx=NULL){
  runSelectionAsJob(cntx, view = TRUE)
}


