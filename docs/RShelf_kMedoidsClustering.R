#MICROSTRATEGY_BEGIN
#
#DESC Using the K-Medoids algorithm, this analytic clusters records "by their nature" so that records within a cluster have more in common with each other than with those records in the other clusters.  Each cluster is defined by a prototypical record, it's "medoid".
#DESC The output 'Cluster' returns the cluster to which the record belongs.
#DESC The output 'Medoids' returns the cluster if a record is the mediod of that cluster, 0 otherwise.
#DESC Revision A
#
#RVAR Vars -input -numeric -vector -repeat
#
#RVAR Exact_k -parameter NumericParam1
#RVAR Max_k -parameter NumericParam2
#RVAR FileName -parameter StringParam9
#
#RVAR Cluster -output -numeric -vector
#RVAR Medoids -output -numeric -vector
#
#Version 1.0 Metric Expressions (uses the 27 Pre-defined Parameters):
#EXP-v1 Cluster: RScript<_RScriptFile="kMedoidsClustering.R", _InputNames="Vars", NumericParam1=4, NumericParam2=10, StringParam9="">(Vars)
#EXP-v1 Medoids: RScript<_RScriptFile="kMedoidsClustering.R", _InputNames="Vars", _OutputVar="Medoids", NumericParam1=4, NumericParam2=10, StringParam9="">(Vars)
#
#Version 2.0 Metric Expressions (uses _Params for parameters):
#EXP-v2 Cluster: RScript<_RScriptFile="kMedoidsClustering.R", _InputNames="Vars", _Params="Exact_k=4, Max_k=10, FileName=''">(Vars)
#EXP-v2 Medoids: RScript<_RScriptFile="kMedoidsClustering.R", _InputNames="Vars", _OutputVar="Medoids", _Params="Exact_k=4, Max_k=10, FileName=''">(Vars)
#
#MICROSTRATEGY_END

mstr.ErrMsg <- tryCatch({                                      #tryCatch for Exception Handling
  if(exists("mstr.WorkingDir")) setwd(mstr.WorkingDir)         #Working Directory if executed by MicroStrategy
  
  CheckInstallPackages <- function(pkgs) {                     # pkgs is a vector of strings with length >= 1
    x <- lapply(pkgs, function(pkg){                           # For each pkg in pkgs (attempt to load each package one at a time):
      if(!do.call("require", list(pkg))) {                     #   Load the package if available,
        try(install.packages(pkg, lib=.Library,
                             repos="http://cran.rstudio.com")) #     Silently attempt to install into the default library
        tryCatch(do.call("library", list(pkg)),                #     Now attempt to load the package, catch error if it wasn't installed
          error = function(err) {                              #     Catch if we're unable to install into the default library
            if(!interactive()) {                               #       If non-interactive, install into this user's personal library
              personalLibPath <- Sys.getenv("R_LIBS_USER")     #         Get the path to this user's personal library
              if(is.na(match(personalLibPath, .libPaths()))) { #         If the personal library is not in the list of libraries
                dir.create(personalLibPath, recursive = TRUE)  #           Then create the personal library
                .libPaths(personalLibPath)                     #           And add the personal library to the list of libraries
              }
              install.packages(pkg, lib=personalLibPath,       #         Attempt to install the package into the personal library
                              repos="http://cran.rstudio.com") #          if this fails, raise the error back to the report
              do.call("library", list(pkg))                    #         Finally, attempt to load the package
            }
          }
        )
      }
    })
  }
  
  CheckInstallPackages("cluster")                              # Install cluster package
  if(exists("mstr.ExFlag")) {                                  # If MicroStrategy executed
    df <- as.data.frame(Vars)                                  #   Load data frame
  } else {
    Var1 <- rnorm(50, 10, 2)
    Var2 <- rnorm(50, 20, 4)
    df <- data.frame(Var1, Var2)
    Max_k <- 10
    Exact_k <- 0
	FileName <- ""
  }  
  medians <- apply(df, 2, median)                              # Compute median for each column
  mads <- apply(df, 2, mad)                                    # Compute MAD for each column 
  cluster_frame <- scale(df, center = medians, scale = mads)   # Scale data for clustering
   
  if(Exact_k > 0) {                                            # If exact number of clusters
    model <- pam(cluster_frame, Exact_k)                       #    Build model
  } else {                                                     # No exact number specified
    k_choices <- 2 : Max_k                                     #    Choices for number of clusters
    asw <- rep(0 , length(k_choices)+ 1)                       #    Average Silhouette Width vector
    for (i in (2 :(length(k_choices) + 1) )){                  #    For each possible number of clusters
      asw[i] <- pam(cluster_frame , i)$silinfo$avg.width       #       Calculate Average Silhouette Width
    }
    model <- pam(cluster_frame , which.max(asw))               #    Create the model with optimal amount of clusters
  }
  Cluster <- model$cluster                                     # Return cluster assignments
  Medoids <- rep(NA , length(df[,1]))                          # Create Medoids output
  for (i in (1 : length(df[ , 1]))) {                          # For each record
    Medoids[i] <- match(i, model$id.med, nomatch = 0)          #   Determine whether it is a prototype
  }  
  if(nchar(FileName)>0) {                                      # If FileName is not an empty string
    save(list=c("df" , "model"), 
         file=paste(FileName , ".Rdata", sep = ""))            #   Persist objects to file
  }
  if(!exists("mstr.ExFlag")) {                                 # If in console
    try(print("Success!"))                                     #   Print out Success!
  } 
  
  mstr.ErrMsg <- ""                                            #If we made it here, no errors were caught
}, error = function(err) {                                     #Catch block to report an error
  try(print(err))                                              #  Print error message to console (using try to continue on any print error)
  return(err$message)                                          #  Return error Message
})

