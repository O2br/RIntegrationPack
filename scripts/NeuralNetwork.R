#MICROSTRATEGY_BEGIN
#
#DESC Neural Network is an advanced machine learning classification technique wherein a model is constructed that aims to simulate the thought process performed by the human brain. A model consists of  “neurons” that are interconnected by an activation function.   Every record is then passed through the network from the appropriate input neuron to the proper output neuron through a series of weights and transformations defined by the activation function.
#DESC The output 'Class' returns the predicted class as a string.
#DESC The output 'ClassID' returns the predicted class as a number.
#DESC Revision A
#
#RVAR Target -input -vector
#RVAR Vars -input -vector -repeat
#
#RVAR FileName -parameter StringParam9
#RVAR TrainMode -parameter BooleanParam9
#RVAR NumLayer -parameter NumericParam1
#RVAR Seed -parameter NumericParam2
#
#RVAR Class -output -string -vector
#RVAR ClassId -output -numeric -vector
#
#Version 1.0 Metric Expressions (uses the 27 Pre-defined Parameters):
#EXP-v1 Class: RScript<_RScriptFile="NeuralNetwork.R", _InputNames="Target, Vars", StringParam9="NeuralNetwork", BooleanParam9=TRUE, NumericParam1=3, NumericParam2=42>(Target, Vars)
#EXP-v1 ClassId: RScript<_RScriptFile="NeuralNetwork.R", _InputNames="Target, Vars", _OutputVar="ClassId", StringParam9="NeuralNetwork", BooleanParam9=TRUE, NumericParam1=3, NumericParam2=42>(Target, Vars)
#
#Version 2.0 Metric Expressions (uses _Params for parameters):
#EXP-v2 Class: RScript<_RScriptFile="NeuralNetwork.R", _InputNames="Target, Vars", _Params="FileName='NeuralNetwork', TrainMode=TRUE, NumLayer=3, Seed=42">(Target, Vars)
#EXP-v2 ClassId: RScript<_RScriptFile="NeuralNetwork.R", _InputNames="Target, Vars", _OutputVar="ClassId", _Params="FileName='NeuralNetwork', TrainMode=TRUE, NumLayer=3, Seed=42">(Target, Vars)
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
  CheckInstallPackages("nnet")                                 #Load the "nnet" package
  
  #Get the data
  if(exists("mstr.ExFlag")) {                                  #If this is executed by MicroStrategy
    df <- data.frame(cbind(Target, Vars))                      #  Create a data frame from the target and input variables
    if(length(mstr.InputNames) > 0) {
    colnames(df) <- mstr.InputNames                            #    Name these variables
  }
  set.seed(Seed)
  } else {                                                     #If this is NOT via a MicroStrategy Report Execution
    set.seed(42)
  var1 <- seq(1:1000)
    var2 <- rep(seq(1:200),5)
    var3 <- (seq(1:1000) * (0.8 + (0.4*runif(50, 0, 1))))
    Target <- ifelse(runif(1000)>.5,1,0)                       #  Set the target variable
    df <- data.frame(cbind(Target, var1, var2, var3))          #  Create a data frame from the input variables
    TrainMode = TRUE                                           #  Assuming we're training
    FileName = "NeuralNetwork_Console"
    NumLayer = 2
  }
  
  #Modeling
  if(TrainMode) {                                              #If training,
    model <- nnet(factor(df[, 1]) ~ .,
                  size=NumLayer, data=df[, -1])                #  Create the model
    dfTrain <- df                                              #  Create a copy of the training data for saving
  } else load(paste(FileName, ".Rdata",sep = ""))              #Otherwise, load the model for scoring
  Class <- as.character(predict(model, newdata=df[, -1],
                     type="class"))                            #Return predictions from the model
  ClassId <- as.numeric(Class)                                 #Return predictions as numbers
  timerXeq <-(proc.time() - timer)                             #Capture Execution Timer for Rdata file
  if(TrainMode) {                                              #If training, save the model and other objects
    objs <- c("dfTrain", "model", "Class", "timerXeq")         #  List the objects to save
    if(nchar(FileName)>0){
    save(list=objs,
           file=paste(FileName, ".Rdata",sep=""))              #  Persist objects to file
  }
  }
  if(!exists("mstr.ExFlag")) {
    try(print(paste0("Success! Elasped Time=",
                     format((proc.time() - timer)[3],
                            nsmall=3), "sec")))                #  Print success message with overall time
  }
  
  mstr.ErrMsg <- ""                                            #If we made it here, no errors were caught
}, error = function(err) {                                     #Catch block to report an error
  try(print(err))                                              #  Print error message to console (using try to continue on any print error)
  return(err$message)                                          #  Return error Message
})

