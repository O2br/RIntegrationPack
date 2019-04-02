#MICROSTRATEGY_BEGIN
#
#DESC One of the most common applications of predictive analytics is to forecast time-based data. This analytic uses R’s ordinary least squares regression algorithm to fit the best curve that captures the general trend and season variability of numeric data so it can use to predict future values.
#DESC The output 'Forecast' returns the forecasted values. 
#DESC Revision A
#
#RVAR Target -input -numeric -vector
#RVAR Trend -input -numeric -vector
#RVAR Season -input -vector
#
#RVAR FileName -parameter StringParam9
#
#RVAR Forecast -output -numeric -vector
#
#Version 1.0 Metric Expression (uses the 27 Pre-defined Parameters):
#EXP-v1 Forecast: RScript<_RScriptFile="SeasonalForecasting.R", _InputNames="Target, Trend, Season", StringParam9="">(Target, Trend, Season)
#
#Version 2.0 Metric Expression (uses _Params for parameters):
#EXP-v2 Forecast: RScript<_RScriptFile="SeasonalForecasting.R", _InputNames="Target, Trend, Season", _Params="FileName=''">(Target, Trend, Season)
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
    df <- data.frame(cbind(Target, Trend, Season))             #  Create a data frame from the input variables
    if(length(mstr.InputNames) > 0) {                          #  If inputNames is non-empty
      colnames(df) <- mstr.InputNames                          #    Name these variables
    }
  } else {                                                     #If this is NOT via a MicroStrategy Report Execution
    set.seed(42)                                               #  Set random number seed for consistency
    Trend <- seq(1:48)                                         #  Set Trend variable for 48 months
    Season <- rep(seq(1:12), 4)                                #  Set Season variable for 4 years of 12 months
    Target <- (seq(1:36) * (0.8 + (0.4*runif(36, 0, 1))))      #  Set 3 years of linear but noisy values for the Target
    Target <- append(Target, c(rep(NA, 12)))                   #  Add the forecast horizon
    df <- data.frame(cbind(Target, Trend, Season))             #  Create a data frame from the input variables
    FileName <- "SeasonalForecasting_console"                  #  Set the name for saving output
  }

  #Modeling
  model <- lm(Target ~ Trend + factor(Season),
              data=df[!is.na(Target), ])                       #Train model on all records with Target values
  Forecast <- predict(model, newdata = df[, -1])               #Return predictions from the model
  if(nchar(FileName)>0) {                                      #If FileName is not an empty string
    save(list=c("df", "model", "Forecast"),
         file=paste(FileName, ".Rdata", sep=""))               #  Persist objects to file
    CheckInstallPackages(c("pmml"))                            #  Load the pmml package
    saveXML(pmml(model), paste(FileName,".xml", sep=""))       #  Save the model as PMML
  }

  #Finish
  try(print("Success!"))                                       #Print completion message when run from the console
  
  mstr.ErrMsg <- ""                                            #If we made it here, no errors were caught
}, error = function(err) {                                     #Catch block to report an error
  try(print(err))                                              #  Print error message to console (using try to continue on any print error)
  return(err$message)                                          #  Return error Message
})

