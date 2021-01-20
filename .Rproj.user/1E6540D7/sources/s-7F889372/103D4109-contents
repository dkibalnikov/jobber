runSelectionAsJob <- function(importEnv=FALSE, attachPackages=FALSE) {

  ## Get the document context.
  context <- rstudioapi::getActiveDocumentContext()$selection[[1]]$text

  if(attachPackages) {
    si=sessionInfo()
    packages=names(si$otherPkgs)
  }

  ## if not empty selection
  if (!is.null(context) && context != "") {

    ## save selection to a temporary file
    tf <- tempfile("jobber_tmp", fileext = ".R")
    tfc=file(tf, open='w')
    if(attachPackages) {
      writeLines("sapply(", con=tfc, )
      dput(packages, file = tfc)
      writeLines(",library, character.only=T)", con=tfc)
    }
    writeLines(context, con = tfc, sep = "\n")
    writeLines("\n", con = tfc)
    flush(tfc)

    ## delete temporary file
    on.exit({
      ## allow time for scripting to start
      Sys.sleep(5)
      close(tfc)
      unlink(tf)
    }, add=T)

    ## run the temp script as a job, returning the
    ## results to the global environment
    .rs.api.runScriptJob(
      path = path.expand(tf),
      importEnv = importEnv,
      workingDir = getwd(),
      exportEnv = "R_GlobalEnv"
    )

  }
}



runSelectionAsJobWithEnv <- function() {
  runSelectionAsJob(importEnv=TRUE, attachPackages=FALSE)
}

runSelectionAsJobWithEnvPackages <- function() {
  runSelectionAsJob(importEnv=TRUE, attachPackages=TRUE)
}
