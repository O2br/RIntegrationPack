#MICROSTRATEGY_BEGIN
#
#DESC One of the most common applications of predictive analytics is to forecast time-based data. This analytic uses the Auto-Regressive Integrated with Moving Average (ARIMA) algorithm to project a sequence of values ahead into the future, based on the assumption that data points taken over time may have an internal structure that can be measured.   While ARIMA tends to be esoteric and complex, this analytic uses the Ã¢â‚¬Å“auto.arimaÃ¢â‚¬Â function from RÃ¢â‚¬â„¢s Ã¢â‚¬Å“forecastÃ¢â‚¬Â package to search through a variety of possible models in order to find the best one.  Not only does this script generate the expected forecast values, it also provides outputs based on confidence bands, nominally set at 80% and 95% confidence levels.
#DESC The output 'Forecast' returns the forecasted value.
#DESC The output 'ForecastLo1' returns the forecasted lower value of the first confidence band.
#DESC The output 'ForecastHi1' returns the forecasted upper value of the first confidence band.
#DESC The output 'ForecastLo2' returns the forecasted lower value of the second confidence band.
#DESC The output 'ForecastHi2' returns the forecasted upper value of the second confidence band.
#DESC Revision A
#
#RVAR Target -input -numeric -vector
#
#RVAR CycleLength -parameter NumericParam1
#RVAR Horizon -parameter NumericParam2
#RVAR Conf1 -parameter NumericParam3
#RVAR Conf2 -parameter NumericParam4
#RVAR ImageName -parameter StringParam8
#RVAR FileName -parameter StringParam9
#
#RVAR Forecast -output -numeric -vector
#RVAR ForecastLo1 -output -numeric -vector
#RVAR ForecastHi1 -output -numeric -vector
#RVAR ForecastLo2 -output -numeric -vector
#RVAR ForecastHi2 -output -numeric -vector
#
#Version 1.0 Metric Expressions (uses the 27 Pre-defined Parameters):
#EXP-v1 Forecast: RScript<_RScriptFile="ARIMA.R", _InputNames="Target", SortBy=(Month), NumericParam1=12, NumericParam2=12, NumericParam3=80, NumericParam4=95, StringParam8="", StringParam9="">(Target)
#EXP-v1 ForecastLo1: RScript<_RScriptFile="ARIMA.R", _InputNames="Target", _OutputVar="ForecastLo1", SortBy=(Month), NumericParam1=12, NumericParam2=12, NumericParam3=80, NumericParam4=95, StringParam8="", StringParam9="">(Target)
#EXP-v1 ForecastHi1: RScript<_RScriptFile="ARIMA.R", _InputNames="Target", _OutputVar="ForecastHi1", SortBy=(Month), NumericParam1=12, NumericParam2=12, NumericParam3=80, NumericParam4=95, StringParam8="", StringParam9="">(Target)
#EXP-v1 ForecastLo2: RScript<_RScriptFile="ARIMA.R", _InputNames="Target", _OutputVar="ForecastLo2", SortBy=(Month), NumericParam1=12, NumericParam2=12, NumericParam3=80, NumericParam4=95, StringParam8="", StringParam9="">(Target)
#EXP-v1 ForecastHi2: RScript<_RScriptFile="ARIMA.R", _InputNames="Target", _OutputVar="ForecastHi2", SortBy=(Month), NumericParam1=12, NumericParam2=12, NumericParam3=80, NumericParam4=95, StringParam8="", StringParam9="">(Target)
#
#Version 2.0 Metric Expressions (uses _Params for parameters):
#EXP-v2 Forecast: RScript<_RScriptFile="ARIMA.R", _InputNames="Target", SortBy=(Month), _Params="CycleLength=12, Horizon=12, Conf1=80, Conf2=95, ImageName='', FileName=''">(Target)
#EXP-v2 ForecastLo1: RScript<_RScriptFile="ARIMA.R", _InputNames="Target", _OutputVar="ForecastLo1", SortBy=(Month), _Params="CycleLength=12, Horizon=12, Conf1=80, Conf2=95, ImageName='', FileName=''">(Target)
#EXP-v2 ForecastHi1: RScript<_RScriptFile="ARIMA.R", _InputNames="Target", _OutputVar="ForecastHi1", SortBy=(Month), _Params="CycleLength=12, Horizon=12, Conf1=80, Conf2=95, ImageName='', FileName=''">(Target)
#EXP-v2 ForecastLo2: RScript<_RScriptFile="ARIMA.R", _InputNames="Target", _OutputVar="ForecastLo2", SortBy=(Month), _Params="CycleLength=12, Horizon=12, Conf1=80, Conf2=95, ImageName='', FileName=''">(Target)
#EXP-v2 ForecastHi2: RScript<_RScriptFile="ARIMA.R", _InputNames="Target", _OutputVar="ForecastHi2", SortBy=(Month), _Params="CycleLength=12, Horizon=12, Conf1=80, Conf2=95, ImageName='', FileName=''">(Target)
#
#MICROSTRATEGY_END

mstr.ErrMsg <- tryCatch({                                      #tryCatch for Exception Handling
  if(exists("mstr.WorkingDir")) setwd(mstr.WorkingDir)         #Working Directory if executed by MicroStrategy
  
  timer <- proc.time()                                         #Start a timer to measure how long it takes
    
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
  
  #Load packages
  CheckInstallPackages("forecast")                             #Load the "forecast" package
  
  #Get the data
  if(!exists("mstr.ExFlag")) {                                 #If this is NOT via a MicroStrategy Report Execution
    set.seed(42)                                               #  Set the random number generator seed
    Target <- (seq(1:36) * (0.8 + (0.4*runif(36, 0, 1))))      #  Set some linear but noisy values for the Target
    FileName <- "ARIMA_Rconsole"                               #  Set the Model Name
    CycleLength <- 12                                          #  It's Monthly Data
    Horizon <- 12                                              #  Forecast Horizon of 12 months
    Conf1  <- 80                                               #  Lower confidence band is 80%
    Conf2  <- 95                                               #  Upper confidence band is 95%
    ImageName = "ARIMA_Console"
    FileName = ImageName
  }
  
  #Modeling
  tsObj <- ts(Target[!is.na(Target)],
              frequency=CycleLength)                           #Create a time series object with this data -- without any nulls
  model <- auto.arima(tsObj, stepwise=TRUE,
                      trace=FALSE)                             #Build an ARIMA model using the "auto" ARIMA function
                                     
  arimaFcst <- forecast(model,
                        h=Horizon,
                        level=c(Conf1, Conf2))                 #Create the forecast
  Forecast <- append(tsObj, arimaFcst$mean)                    #Output for the mean or expected value
  ForecastLo1 <- append(tsObj, arimaFcst$lower)                #Output for the first lower confidence band
  ForecastHi1 <- append(tsObj, arimaFcst$upper)                #Output for the first upper confidence band
  ForecastLo2 <- append(tsObj, arimaFcst$lower[, 2])           #Output for the second lower confidence band
  ForecastHi2 <- append(tsObj, arimaFcst$upper[, 2])           #Output for the second upper confidence band
  
  timerXeq <-(proc.time() - timer)                             #Capture Execution Timer for Rdata file
  
  #Additional results saved to files
  if(nchar(FileName)>0) {                                      #If FileName is not an empty string
    save(list=c("Target", "model", "arimaFcst", "Forecast"),
         file=paste(FileName, ".Rdata", sep=""))               #Persist objects to file
  }
  if(nchar(ImageName)>0) {                                     #If FileName is not an empty string
    jpeg(paste(ImageName, ".jpg", sep=""))                     #  Output the ARIMA chart
    plot(forecast(model, h=Horizon))                           #  to a file
	    dev.off()                                                  #  close the file
  }
  if(!exists("mstr.ExFlag")) {                                 #If this is via a MicroStrategy Report Execution
    plot(forecast(model, h=Horizon))                           #  Plot the ARIMA Chart
  }
  
  if(!exists("mstr.ExFlag")) {
    try(print(paste0("Success! Elasped Time=",
                     format((proc.time() - timer)[3],
                            nsmall=3), "sec")))                #Print success message with overall time
  }  

  mstr.ErrMsg <- ""                                            #If we made it here, no errors were caught
}, error = function(err) {                                     #Catch block to report an error
  try(print(err))                                              #  Print error message to console (using try to continue on any print error)
  return(err$message)                                          #  Return error Message
})

