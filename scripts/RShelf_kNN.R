#MICROSTRATEGY_BEGIN
#
#DESC k-Nearest Neighbors (kNN) is a simple classification technique that is unique in the sense that no model is explicitly trained. In the kNN process, two datasets are read in: the training dataset in which the dependent variable is already known, and the test dataset in which the dependent variable is unknown. Classifications for the test set are made by determining the k most similar records in the training dataset (known as neighbors) and returning the majority vote amongst those neighbors.
#DESC The output 'Class' returns the predicted class as a string.
#DESC The output 'ClassID' returns the predicted class as a number.
#DESC Revision A
#
#RVAR ID -input -vector
#RVAR Target -input -vector
#RVAR Training -input -numeric -vector
#RVAR Vars -input -vector -repeat
#
#RVAR TrainIncluded -parameter BooleanParam9
#RVAR k -parameter NumericParam1
#RVAR FileName -parameter StringParam9
#
#RVAR Class -output -string -vector
#RVAR ClassId -output -numeric -vector
#
#Version 1.0 Metric Expressions (uses the 27 Pre-defined Parameters):
#EXP-v1 Class: RScript<_RScriptFile="kNN.R", _InputNames="ID, Target, Training, Vars", BooleanParam9=TRUE, NumericParam1=1, StringParam9="kNN">(ID, Target, Training, Vars)
#EXP-v1 ClassId: RScript<_RScriptFile="kNN.R", _InputNames="ID, Target, Training, Vars", _OutputVar="ClassId", BooleanParam9=TRUE, NumericParam1=1, StringParam9="kNN">(ID, Target, Training, Vars)
#
#Version 2.0 Metric Expressions (uses _Params for parameters):
#EXP-v2 Class: RScript<_RScriptFile="kNN.R", _InputNames="ID, Target, Training, Vars", _Params="TrainIncluded=TRUE, k=1, FileName='kNN'">(ID, Target, Training, Vars)
#EXP-v2 ClassId: RScript<_RScriptFile="kNN.R", _InputNames="ID, Target, Training, Vars", _OutputVar="ClassId", _Params="TrainIncluded=TRUE, k=1, FileName='kNN'">(ID, Target, Training, Vars)
#
#MICROSTRATEGY_END

mstr.ErrMsg <- tryCatch({                                      #tryCatch for Exception Handling
  if(exists("mstr.WorkingDir")) setwd(mstr.WorkingDir)         #Working Directory if executed by MicroStrategy
  # Load packages
  
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
  CheckInstallPackages("class")                                #Load the "class" package                                                  
  
  # Get data
  if(exists("mstr.ExFlag")) {                                  #If MicroStrategy is executing
    vars_df <- as.data.frame(Vars)                             #  Save independent variables in a data frame
    df <- data.frame(ID = ID,Target = Target, Vars= Vars)      #  Save all variables in data frame
    
    if(TrainIncluded){                                         #  If Training Set is Included
      train_df <- data.frame(ID = ID[Training == 1]        
                             ,vars_df[Training == 1, ])        #    Partition into Training dataset
      test_df <- data.frame(ID= ID[Training == 0], 
                            vars_df[Training == 0,])           #    Partition into scoring dataset
    }
  } else {                                                     #Execution from console
    set.seed(42)
	Target <- ifelse(runif(50,0,1) >.5,1,0)                    #  Create Target variable
    ID <- 1:60                                                 #  Create ID variable
    var_1 <- runif(60,0,1)                                     #  Create first independent variable
    var_2 <- runif(60,0,1)                                     #  Create second independent variable
    df <- data.frame(ID,var_1,var_2)                           #  Create data frame
    train_df <- df[1:50,]                                      #  Partition into Training dataset
    test_df <- df[51:60,]                                      #  Partition into Test dataset
    k <- 3                                                     #  Set amount of nearest neighbors to poll
    Training <- c(rep(1,50),rep(0,10))                         #  Create vector that keeps track of training/test
    TrainIncluded <- TRUE                                      #  Training Data is Included
    FileName <- "KNN"                                          #  Set FileName
  }
  
  # Modeling
  if(TrainIncluded){                                           #If Training Data is Included                      
     model <- knn(train_df[,-1],test_df[,-1],
                  Target[Training == 1],k)                     #  Classify Test Data
     test_df$prediction <- model                               #  Append predictions to test_df 
     merged_df <- merge(df,test_df,by="ID",all.x = TRUE)       #  Merge predictions with original dataset 
     Class <- as.character(merged_df$prediction)               #  Prediction as character
     ClassId <- as.numeric(Class)                              #  Prediction as number
     objs <- c("train_df","test_df","model","Class",
               "Training","Target")                            #  List of Objects to be saved to file
     save(list = objs, file = paste(FileName,".Rdata",  
          sep=""))                                             #  Save Objects to file
  } else {                                                     #  If Training Data is not included
    load(paste(FileName,".Rdata",sep=""))                      #  Load file saved during Training
    model <- knn(train_df[,-1],vars_df,
                 Target[Training == 1],k)                      #  Classify test data
    Class <- as.character(model)                               #  Prediction as character
    ClassId <- as.numeric(Class)                               #  Prediction as number
 }
 if(!exists("mstr.ExFlag")){
   try(print("Success!"))
 }

  mstr.ErrMsg <- ""                                            #If we made it here, no errors were caught
}, error = function(err) {                                     #Catch block to report an error
  try(print(err))                                              #  Print error message to console (using try to continue on any print error)
  return(err$message)                                          #  Return error Message
})

