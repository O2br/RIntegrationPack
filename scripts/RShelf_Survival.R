#MICROSTRATEGY_BEGIN
#
#DESC On a long enough timeline, the survival rate for everything drops to zero, including events such as a component failure or a customer being lost. This analytic uses the Cox Regression algorithm to quantify the effect that each independent variable has on the likelihood that such an event will occur at some point in the future.
#DESC The output 'Risk" returns the risk of an event occurring relative to the average.
#DESC Revision A
#
#RVAR Time -input -numeric -vector
#RVAR Status -input -vector
#RVAR Vars -input -vector -repeat
#
#RVAR TrainMode -parameter BooleanParam9
#RVAR FileName -parameter StringParam9
#
#RVAR Risk -output -numeric -vector
#
#Version 1.0 Metric Expression (uses the 27 Pre-defined Parameters):
#EXP-v1 Risk: RScript<_RScriptFile="Survival.R", _InputNames="Time, Status, Vars", BooleanParam9=FALSE, StringParam9="">(Time, Status, Vars)
#
#Version 2.0 Metric Expression (uses _Params for parameters):
#EXP-v2 Risk: RScript<_RScriptFile="Survival.R", _InputNames="Time, Status, Vars", _Params="TrainMode=FALSE, FileName=''">(Time, Status, Vars)
#
#MICROSTRATEGY_END

mstr.ErrMsg <- tryCatch({                                      #tryCatch for Exception Handling
  if(exists("mstr.WorkingDir")) setwd(mstr.WorkingDir)         #Working Directory if executed by MicroStrategy

  timer <- proc.time()                                         #Start a timer to measure how long it takes
  
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
  #Load packages
  CheckInstallPackages("survival")                             #Load the "survival" package    
  
  #Get the data
  if(exists("mstr.ExFlag")) {                                  #If this is executed by MicroStrategy
    df <- data.frame(cbind(Time,Status,Vars))                  #  Create a data frame with the variables
    if(length(mstr.InputNames)>0){
      colnames(df) <- mstr.InputNames                            #   Set input names
    }
  } else {                                                    #If this is NOT via a MicroStrategy Report Execution
    Time <- ceiling(runif(48, 12, 60))                         #  Set the months variable 
    Status <- (runif(48, 0, 1)<0.5)                            #  Set the churn variable
    income <- ceiling(runif(48, 0.01, 7))                      #  Set the income covariate
    hhSize <- (seq(1:48)*(0.8+(0.4*runif(48, 0, 1))))          #  Set the household size covariate
    df <- data.frame(cbind(Time,Status, income, hhSize))       #  Create a data frame with the variables
    TrainMode=TRUE                                             #  Assuming we're training
    FileName <- "survival_console"                             #  Set file name to store output
  }
   
  #Modeling
  if(TrainMode) {                                              #If training,
    dfTrain <- df                                               
    model <- coxph(Surv(df[, 1],df[ , 2]) ~ .
                  ,data=df[ , -c(1:2)])                        #  Create the proportional hazards model
    Risk <- predict(model, type = "risk")                      #  Return predictions
    timerXeq <-(proc.time() - timer)                           #  Capture Execution Timer for Rdata file
    if(nchar(FileName)>0) {
      objs <- c("dfTrain", "model", "Risk", "timerXeq")        #  List the objects to save
      save(list = objs, file = paste(FileName, ".Rdata",
                                     sep=""))                  #  Persist objects to file
      #CheckInstallPackages("pmml")                            #  Load the pmml package
      #saveXML(pmml(model),paste(FileName,".xml"))             #  Save the exponential portion as a PMML Regression Equation
    }
  } else {                                                     #Otherwise, generate scores from the persisted model  
    load(paste(FileName, ".Rdata",sep=""))                     #  Load the model for scoring
    Risk <- predict(model,  
                      newdata=df[ , -c(1:2)], type= "risk")    #  Return predictions from the model
  }
  
  #Execution Complete
  if(!exists("mstr.ExFlag")){                                  #If executed from the console
    try(print(paste0("Success! Elasped Time=", 
                     format((proc.time() - timer)[3], 
                            nsmall=3), "sec")))                #  Print success message with overall time
  }

  mstr.ErrMsg <- ""                                            #If we made it here, no errors were caught (using try to continue on any print error)
}, error = function(err) {                                     #Catch block to report an error
  try(print(err))                                              #  Print error message to console (using try to continue on any print error)
  return(err$message)                                          #  Return error Message
})

