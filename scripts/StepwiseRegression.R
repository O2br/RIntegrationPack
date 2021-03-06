#MICROSTRATEGY_BEGIN
#
#DESC Stepwise Linear Regression is a variant on classical Linear Regression in which variables are only included in the model if they have a significant effect on the variable we are trying to predict.
#DESC The output 'Forecast' returns the predictions from the model.
#DESC Revision A
#
#RVAR Target -input -numeric -vector
#RVAR Vars -input -vector -repeat
#
#RVAR FileName -parameter StringParam9
#RVAR Stepwise -parameter BooleanParam1
#
#RVAR Forecast -output -numeric -vector
#
#Version 1.0 Metric Expression (uses the 27 Pre-defined Parameters):
#EXP-v1 Forecast: RScript<_RScriptFile="StepwiseRegression.R", _InputNames="Target, Vars", StringParam9="StepwiseRegression", BooleanParam1=TRUE>(Target, Vars)
#
#Version 2.0 Metric Expression (uses _Params for parameters):
#EXP-v2 Forecast: RScript<_RScriptFile="StepwiseRegression.R", _InputNames="Target, Vars", _Params="FileName='StepwiseRegression', Stepwise=TRUE">(Target, Vars)
#
#MICROSTRATEGY_END

mstr.ErrMsg <- tryCatch({                                      #tryCatch for Exception Handling
  if(exists("mstr.WorkingDir")) setwd(mstr.WorkingDir)         #Working Directory if executed by MicroStrategy

#Check to see if package(s) are installed, install if not and then load
  CheckInstallPackages <- function(pkgs) {                     #pkgs is a vector of strings with length >= 1
    x <- lapply(pkgs, function(pkg){                           #For each pkg in pkgs (attempt to load each package one at a time):
      if(!do.call("require", list(pkg))) {                     #  Load the package if available,
        try(install.packages(pkg, lib=.Library,
                             repos="http://cran.rstudio.com")) #    Silently attempt to install into the default library
        tryCatch(do.call("library", list(pkg)),                #    Now attempt to load the package, catch error if it wasn't installed
          error = function(err) {                              #    Catch if we're unable to install into the default library
            if(!interactive()) {                               #      If non-interactive, install into this user's personal library
              personalLibPath <- Sys.getenv("R_LIBS_USER")     #        Get the path to this user's personal library
              if(is.na(match(personalLibPath, .libPaths()))) { #        If the personal library is not in the list of libraries
                dir.create(personalLibPath, recursive = TRUE)  #          Then create the personal library
                .libPaths(personalLibPath)                     #          And add the personal library to the list of libraries
              }
              install.packages(pkg, lib=personalLibPath,       #        Attempt to install the package into the personal library
                              repos="http://cran.rstudio.com") #          if this fails, raise the error back to the report
              do.call("library", list(pkg))                    #        Finally, attempt to load the package
            }
          }
        )
      }
    })
  }
  #Get the data
  if(exists("mstr.ExFlag")) {                                  #If this is executed by MicroStrategy
    df <- data.frame(cbind(Target, Vars))                      #  Create a data frame from the input variables
    if(length(mstr.InputNames) > 0) {                          #  If inputNames is non-empty
      colnames(df) <- make.names(mstr.InputNames)              #    Name these variables
    } 
  } else {                                                     #If this is NOT via a MicroStrategy Report Execution
    set.seed(42)                                               #  Set random number seed for consistency
    Target <- rnorm(48,10,3)                                   #  Set Target variable 
    Var1 <- rnorm(48,0,1)                                      #  Set the first indicator variable
    Var2 <- rnorm(48,5,2)                                      #  Set the second indicator variable
    Vars <- cbind(Var1,Var2)
    df <- data.frame(cbind(Target, Var1, Var2))                #  Create a data frame from the input variables
    FileName <- "SWMLR_Console"                                #  Set the name for saving output
    Stepwise <- TRUE                                           #  Default stepwise to true
  }
  #Modeling
  lm_formula <- paste(colnames(df)[1],".",sep="~")             #Create formula for lm function
  model <- lm(formula=lm_formula,data=df)			           #Train model using data from data frame
  if(Stepwise) {                                               #If the user specifies Stepwise is desired
    CheckInstallPackages(c("MASS"))                            #  Install Package
	model <- stepAIC(model)                                    #  Replace model with stepwise version
  }
  Forecast <- predict(model, newdata = df[, -1])               #Return predictions from the model
  if(nchar(FileName)>0) {                                      #If FileName is not an empty string
    save(list=c("df", "model", "Forecast"),
         file=paste(FileName, ".Rdata", sep=""))               #  Persist objects to file
    CheckInstallPackages(c("pmml","XML"))                      #  Load the pmml package
    saveXML(pmml(model), file=paste(FileName,".xml", sep=""))  #  Save the model as PMML
  }
  #Finish
  try(print("Success!"))                                       #Print completion message when run from the console                                             #If we made it here, no errors were caught (using try to continue on any print error)

  mstr.ErrMsg <- ""                                            #If we made it here, no errors were caught
}, error = function(err) {                                     #Catch block to report an error
  try(print(err))                                              #  Print error message to console (using try to continue on any print error)
  return(err$message)                                          #  Return error Message
})

