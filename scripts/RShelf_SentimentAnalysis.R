#MICROSTRATEGY_BEGIN
#
#RVAR Text -input -string -vector
#
#RVAR FileName -parameter -string
#RVAR PlotWordCloud -parameter -boolean
#RVAR PlotHistogram -parameter -boolean
#RVAR RemoveRetweets -parameter -boolean
#RVAR SaveCSV -parameter -boolean
#
#RVAR Score -output -numeric -vector           # Metric Expression: RScriptU<[_RScriptFile]="SentimentAnalysis.R", [_OutputVar]="Score", _Params="FileName='SA_mstr', PlotWordCloud=TRUE, PlotHistogram=TRUE, RemoveRetweets=TRUE, SaveCSV=TRUE">(Text)
#RVAR Grade -output -string -vector            # Metric Expression: RScriptU<[_RScriptFile]="SentimentAnalysis.R", [_OutputVar]="Grade", _Params="FileName='SA_mstr', PlotWordCloud=TRUE, PlotHistogram=TRUE, RemoveRetweets=TRUE, SaveCSV=TRUE">(Text)
#RVAR Anger -output -string -vector            # Metric Expression: RScriptU<[_RScriptFile]="SentimentAnalysis.R", [_OutputVar]="Anger", _Params="FileName='SA_mstr', PlotWordCloud=TRUE, PlotHistogram=TRUE, RemoveRetweets=TRUE, SaveCSV=TRUE">(Text)
#RVAR Anticipation -output -string -vector     # Metric Expression: RScriptU<[_RScriptFile]="SentimentAnalysis.R", [_OutputVar]="Anticipation", _Params="FileName='SA_mstr', PlotWordCloud=TRUE, PlotHistogram=TRUE, RemoveRetweets=TRUE, SaveCSV=TRUE">(Text)
#RVAR Disgust -output -string -vector          # Metric Expression: RScriptU<[_RScriptFile]="SentimentAnalysis.R", [_OutputVar]="Disgust", _Params="FileName='SA_mstr', PlotWordCloud=TRUE, PlotHistogram=TRUE, RemoveRetweets=TRUE, SaveCSV=TRUE">(Text)
#RVAR Fear -output -string -vector             # Metric Expression: RScriptU<[_RScriptFile]="SentimentAnalysis.R", [_OutputVar]="Fear", _Params="FileName='SA_mstr', PlotWordCloud=TRUE, PlotHistogram=TRUE, RemoveRetweets=TRUE, SaveCSV=TRUE">(Text)
#RVAR Joy -output -string -vector              # Metric Expression: RScriptU<[_RScriptFile]="SentimentAnalysis.R", [_OutputVar]="Joy", _Params="FileName='SA_mstr', PlotWordCloud=TRUE, PlotHistogram=TRUE, RemoveRetweets=TRUE, SaveCSV=TRUE">(Text)
#RVAR Negative -output -string -vector         # Metric Expression: RScriptU<[_RScriptFile]="SentimentAnalysis.R", [_OutputVar]="Negative", _Params="FileName='SA_mstr', PlotWordCloud=TRUE, PlotHistogram=TRUE, RemoveRetweets=TRUE, SaveCSV=TRUE">(Text)
#RVAR Positive -output -string -vector         # Metric Expression: RScriptU<[_RScriptFile]="SentimentAnalysis.R", [_OutputVar]="Positive", _Params="FileName='SA_mstr', PlotWordCloud=TRUE, PlotHistogram=TRUE, RemoveRetweets=TRUE, SaveCSV=TRUE">(Text)
#RVAR Sadness -output -string -vector          # Metric Expression: RScriptU<[_RScriptFile]="SentimentAnalysis.R", [_OutputVar]="Sadness", _Params="FileName='SA_mstr', PlotWordCloud=TRUE, PlotHistogram=TRUE, RemoveRetweets=TRUE, SaveCSV=TRUE">(Text)
#RVAR Surprise -output -string -vector         # Metric Expression: RScriptU<[_RScriptFile]="SentimentAnalysis.R", [_OutputVar]="Surprise", _Params="FileName='SA_mstr', PlotWordCloud=TRUE, PlotHistogram=TRUE, RemoveRetweets=TRUE, SaveCSV=TRUE">(Text)
#RVAR Trust -output -string -vector            # Metric Expression: RScriptU<[_RScriptFile]="SentimentAnalysis.R", [_OutputVar]="Trust", _Params="FileName='SA_mstr', PlotWordCloud=TRUE, PlotHistogram=TRUE, RemoveRetweets=TRUE, SaveCSV=TRUE">(Text)
#RVAR WordCount -output -numeric -vector       # Metric Expression: RScript<[_RScriptFile]="SentimentAnalysis.R", [_OutputVar]="WordCount", _Params="FileName='SA_mstr', PlotWordCloud=TRUE, PlotHistogram=TRUE, RemoveRetweets=TRUE, SaveCSV=TRUE">(Text)
#RVAR TotalWordCount -output -numeric -scalar  # Metric Expression: RScriptAgg<[_RScriptFile]="SentimentAnalysis.R", [_OutputVar]="TotalWordCount", _Params="FileName='SA_mstr', PlotWordCloud=TRUE, PlotHistogram=TRUE, RemoveRetweets=TRUE, SaveCSV=TRUE">(Text)
#
#MICROSTRATEGY_END

mstr.ErrMsg<-tryCatch({

  timer0 <- proc.time()                                        #Start a timer to measure duration of this execution

  ripEnv <- environment()                                      # Remember the R environment of this execution

  ###################
  ###  FUNCTIONS  ###
  ###################

  if(exists("mstr.WorkingDir")) { setwd(mstr.WorkingDir) }     # Set Working Directory, if specified

  ### Function:  LogTask
  ###            Accumulates tasks for performance and debug
  ###            into "TaskLog" variable
  LogTask <- function(task, silent=FALSE) {
    #save.image(paste0("LogTask_", make.names(task)))
    task <- paste(format(Sys.time(), format="%H:%M:%S"), task)
    if(!silent) { print(task) }
    if(exists("TaskLog")) {
      TaskLog <- c(TaskLog, task)
    } else {
      TaskLog <- task
    }
    assign("TaskLog", TaskLog, ripEnv)
  }  #END-LogTask


  ### Function:  CheckInstall Packages
  ###            Check if package(s) are installed, install if not, and then load each package
  ###            Requires that the machine executing this script has access to the internet
  CheckInstallPackages <- function(pkgs) {                     # pkgs is a vector of strings with length >= 1
    timer <- proc.time(); funcName <- "CheckInstallPackages"
    LogTask(paste0(funcName, " - Started..."))
    x <- lapply(pkgs, function(pkg){                           # For each pkg in pkgs (attempt to load each package one at a time):
      if(!do.call("require", list(pkg))) {                     #   Load the package if available,
        try(install.packages(pkg, lib=.Library,
                             repos="http://cran.rstudio.com")) #   Silently attempt to install into the default library
        tryCatch(do.call("library", list(pkg)),                #   Now attempt to load the package, catch error if it wasn't installed
                 error = function(err) {                       #    Catch if we're unable to install into the default library
                   if(!interactive()) {                        #      If non-interactive, install into this user's personal library
                     usrLib <- Sys.getenv("R_LIBS_USER")       #        Get the path to this user's personal library
                     usrLib <- gsub("\\\\", "/", usrLib)       #        Replace any double back slashes with forward slashes
                     if(is.na(match(usrLib, .libPaths()))) {   #        If the personal library is not in the list of libraries
                       dir.create(usrLib, recursive = TRUE)    #          Then create the personal library
                       .libPaths(usrLib)                       #          And add the personal library to the list of libraries
                     }
                     install.packages(pkg, lib=usrLib,         #        Attempt to install the package into the personal library
                              repos="http://cran.rstudio.com") #          if this fails, raise the error back to the report
                     do.call("library", list(pkg,
                                             lib.loc=usrLib))  #        Finally, attempt to load the package from the personal library
                   }
                 }
        )
      }
    })
    LogTask(paste0(funcName, " - Finshed (",format((proc.time() - timer)[3], nsmall=3), "sec)"))
  }  #END-CheckInstall Packages

  ### Function:  GetWords
  ###            Process text into words while removing punction and stop words
  ###            If not analyzing tweets, comment out the first filter and mutate that follows
  GetWords <- function(tblText) {
    timer <- proc.time(); funcName <- "GetWords"
    LogTask(paste0(funcName, " - Started..."))
    reg <- "([^A-Za-z\\d#@']|'(?![A-Za-z\\d#@]))"              # RegEx that converts text
    if(RemoveRetweets) {                                       # If we're to remove Retweets
      words <- tblText %>%                                     # Start with the input text
        dplyr::filter(!str_detect(tblText$Text, '^"')) %>%     # Remove retweets (text that start with a double quote -- for twitter only)
        dplyr::mutate(Text=str_replace_all(tblText$Text,
                        "https://t.co/[A-Za-z\\d]+|&amp;","")) # Remove any URLs (for twitter only)
    } else {
      words <- tblText
    }
    words <-  words %>%                                        # Start with the input text
      unnest_tokens(word, Text, token = "regex",
                    pattern = reg) %>%                         # Break the text into words
      dplyr::filter(!word %in% stop_words$word,
                    str_detect(word, "[a-z]")) %>%             # Remove any stop words
      select(word, id)                                           # Return the words along with the id of the Text the word belongs to
    LogTask(paste0(funcName, " - Finshed (",format((proc.time() - timer)[3], nsmall=3), "sec)"))
    return(words)
  } #END-GetWords

  ### Function:  GetNrc
  ###            Convert the tidytext package's nrc lexicon of 14K english words into a table of words and which of 10 sentiments are present
  ###            The nrc lexicon has the following sentiments for each word (each word may have one or more of these indicated):
  ###              trust, fear, negative, sadness, anger, surprise, positive, disgust, joy, anticipation
  GetNrc <- function() {
    timer <- proc.time(); funcName <- "GetNrc"
    LogTask(paste0(funcName, " - Started..."))
    tblNrc <- tidytext::sentiments %>%                         # Using the sentiments from the tidytext package
      dplyr::filter(lexicon == "nrc") %>%                      # Filter rows to include only words from the nrc lexicon
      dplyr::select(word, sentiment) %>%                       # Select only the word and sentiment columns
      dplyr::mutate(qty=1) %>%                                 # Add a quantiy column where the quantity of each word is 1
      spread(sentiment, qty, fill=0)                           # Convert the sentiment column to a set of binary indicator columns for each sentiment elements where 1 indicates a word has that sentiment and is 0 otherwise
    LogTask(paste0(funcName, " - Finshed (",format((proc.time() - timer)[3], nsmall=3), "sec)"))
    return(tblNrc)                                             # Return the ncr lexicon table
  } #END-GetNrc

  ### Function:  GetAFINN
  ###            Convert the tidytext package's AFINN lexicon of 5K english words into a table of words and a measure of their positive/negative polarity score
  ###            The AFINN lexicon has the following scores of positive/negative poliarity for each word (each word has a single score):
  ###              -5 = Extremely Negative, -4 = Very Negative, -3 = Negative, -2 = Slightly Negative, -1 = Slightly Negative,
  ###               0 = Neutral,
  ###              +1 = Slightly Positive, +2 = Slightly Positive, +3 = Positive, +4 = Very Positive, +5 = Extremely Positive
  GetAFINN <- function() {
    timer <- proc.time(); funcName <- "GetAFINN"
    LogTask(paste0(funcName, " - Started..."))
    tblAFINN <- tidytext::sentiments %>%                       # Using the sentiments from the tidytext package
      dplyr::filter(lexicon == "AFINN") %>%                    # Filter rows to include only words from the AFINN lexicon
      dplyr::select(word, score)                               # Select only the word and score columns
    LogTask(paste0(funcName, " - Finshed (",format((proc.time() - timer)[3], nsmall=3), "sec)"))
    return(tblAFINN)                                           # Return the AFINN lexicon table
  } #END-GetAFINN

  ### Function:  WordCloud Plotter
  WordCloudPlotter <- function(word, n, minFreg=2, maxWords=100, colors=brewer.pal(9, "RdBu"), rotPer=.1) {
    timer <- proc.time(); funcName <- "WordCloudPlotter"
    LogTask(paste0(funcName, " - Started..."))
    wordcloud(word,                                            #     Plot these words in the wordcloud
              n,                                               #       Count for each word
              min.freq=2,
              max.words=100,                                   #       Only this many words will be plutted
              colors = brewer.pal(9,"RdBu"),                   #       Number of colors, palette used for the wordcloud
              rot.per = .1)

    LogTask(paste0(funcName, " - Finshed (",format((proc.time() - timer)[3], nsmall=3), "sec)"))
  }  #END-WordCloudPlotter

  #############################
  ###  Main Execution Flow  ###
  #############################

  LogTask("Begin Main Execution Flow")

  ### Load required packages
  CheckInstallPackages(c("tidytext", "wordcloud",
                         "dplyr", "stringr", "tidyr"))         # Check and install if not present, then load packages

  ### Data Prep:  Use "Dual Execution Mode" so this single script can be run manaully from the R Console and also automated by MicroStrategy
  LogTask("Preparing Data")
  if(exists("mstr.ExFlag")) {                                  # If executed by MicroStrategy
    if(!exists(FileName) || (nchar(FileName)==0)) {            #   Then if there is no file name
      FileName <- "SA_MSTR"                                    #      Then use a default name indicating this came from a MicroStrategy execution
    }
  } else {                                                     # Otherwise, this is executed from the console,
    #For the Text input, use the 10 sentences of Lincoln's Gettysburg Address
    Text <- c("Four score and seven years ago our fathers brought forth on this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal.",
              "Now we are engaged in a great civil war, testing whether that nation, or any nation so conceived and so dedicated, can long endure.",
              "We are met on a great battle-field of that war.",
              "We have come to dedicate a portion of that field, as a final resting place for those who here gave their lives that that nation might live.",
              "It is altogether fitting and proper that we should do this.",
              "But, in a larger sense, we can not dedicate-we can not consecrate-we can not hallow-this ground.",
              "The brave men, living and dead, who struggled here, have consecrated it, far above our poor power to add or detract.",
              "The world will little note, nor long remember what we say here, but it can never forget what they did here.",
              "It is for us the living, rather, to be dedicated here to the unfinished work which they who fought here have thus far so nobly advanced.",
              "It is rather for us to be here dedicated to the great task remaining before us-that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion-that we here highly resolve that these dead shall not have died in vain-that this nation, under God, shall have a new birth of freedom-and that government of the people, by the people, for the people, shall not perish from the earth")
    FileName <- "SA_console"                                   #   Set file name when executed from the console
    PlotHistogram <- TRUE                                      #   Yes, include the Sentiment histogram plot
    RemoveRetweets <- TRUE                                     #   Yes, remove any elements that look like a re-tweet
    PlotWordCloud <- TRUE                                      #   Yes, include the Word Cloud for all words
    SaveCSV <- TRUE                                            #   Yes, save the sentiment data as a CSV file
  }

  ### Prepare Text and Analyze Sentiments
  LogTask("Analyzing Sentiment")
  tblText <- tbl_df(data.frame(id=seq(1, length(Text)),
                               Text=Text,
                               stringsAsFactors=FALSE))        # Convert add an id for each Text element and save to a table
  tblWords <- GetWords(tblText)                                # Get the words
  tblLexicon <- left_join(GetNrc(), GetAFINN(), by="word")     # Combine the ncr and AFINN into a single lexicon table
  tblLexicon[is.na(tblLexicon)] <- 0                           # Replace any NAs with 0
  tblSents <- left_join(tblText,                               # Join the table of input text (on rows) with
              left_join(tblWords, tblLexicon, by="word") %>%   #   Join the table of words and the lexicon table
                     dplyr::group_by(id) %>%                   #     Group words by input text row id
                     dplyr::select(-word) %>%                  #     Remove the word column so we can sum up the sentiments
                     dplyr::summarize_each(funs(sum,
                                                "sum",
                                                sum(.,
                                                    na.rm=TRUE))),
                    by="id")                                   # Aggregate the sentiments for each text row
  tblSents[is.na(tblSents)] <- 0                               # Replace any NAs with 0

  ### Count Words
  LogTask("Counting Words")
  tblWordCount <- count_(tblWords, "word")                     # Create a table that tallies the count of each word
  WordCount <-  sapply(unique(tblSents$id), FUN=function(id) { # Count the words in each Text id
    return(nrow((tblWords[tblWords$id==id, ])))
  })
  totalWordCount <- sum(WordCount)                             # Get the total count of words from all ids

  ### Assign text "grades" from positive/negative polarity scores
  LogTask("Assigning Grades")
  GRADES <- c("Extremely Negative", "Very Negative",
              "Negative", "Somewhat Negative", "Slightly Negative",
              "Neutral",
              "Slightly Positive", "Somewhat Positive", "Positive",
              "Very Positive", "Extremely Positive")           # Provide text descriptions, a grade for each AFINN positive/negative polarity sentiment measure
  Grade <- sapply(tblSents$score_sum, FUN=function(x) {        # Assign a grade to each Text id
    GRADES[round(max(min(x, 5), -5))+6]
  })

  ### Build final dataset with sentiments, positive/negative polarity scores & grades, plus word counts
  ### and ensure variable names start with capital letters and the rest lower case
  LogTask("Preparing Outputs")
    tblSents <- cbind(tblSents,
                      Grade=as.character(Grade), WordCount)    # Combine Grade and WordCount with the table of Sentiments
  colnames(tblSents)[-c(1, 2, 14, 15)] <- sapply(colnames(tblSents)[-c(1, 2, 14, 15)],
                               FUN=function(n) {               # For each column in the table of sentiments
    x <- sub("_sum", "", n)                                    #   Remove any "_sum" suffix from column names (added during "summarize_each")
    x <- paste0(toupper(substr(x, 1, 1)),
                tolower(substr(x, 2, nchar(x))))               #   Capitialize the only the first character of the column name
    assign(x, tblSents[, n], ripEnv)                           #   Add this column as an output variable in the environment
    return(x)
  })

  ### Return Out-of-Band byproducts:  WordCloud, Histogram, Dataset CSV, and .Rdata of the environment
  LogTask("Returning Out-of-Band Byproducts")
  if(exists("mstr.ExFlag")) {                                  # If executed by MicroStrategy
    if(PlotWordCloud){                                         #   If requested to Persist the WordCloud as file
      jpeg(paste0(FileName, "_WordCloud.jpg"))                 #     Set the WordCloud image file name
      WordCloudPlotter(tblWordCount$word, tblWordCount$n)      #     Plot the Word Cloud
      dev.off()                                                #     Save the WordCloud as a JPEG file
    }
    if(PlotHistogram){                                         #   If requested to Plot the Histogram of sentiment scores
      jpeg(paste0(FileName, "_Histogram.jpg"))                 #     Set the histogram image file name
      hist(tblSents$Score)                                     #     Plot the histogram
      dev.off()                                                #     Save the histogram as a JPEG file
    }
  } else {                                                     # Otherwise, this is executed from the R Console
    if(PlotWordCloud) {                                        #   If requested to Plot the WordCloud
      WordCloudPlotter(tblWordCount$word, tblWordCount$n)      #     Plot the Word Cloud
    }
    if(PlotHistogram){                                         #   If requested to Plot the Histogram of sentiment scores
      hist(tblSents$Score)                                     #     Plot the histogram
    }
  }
  if(SaveCSV) {                                                #  If requestsed to save a CSV of the sentiment data
    tryCatch({
      write.csv(tblSents, file=paste0(FileName, ".csv"),
              row.names=FALSE)                                 #    Save a CSV of the Sentiment data
    }, error = function(err) {                                 # Catch block to report an error
      LogTask(err$message)
    })
  }

  ### Finish Execution
  duration <- paste0("*** Success! Total Elasped Time=",
                     format((proc.time() - timer0)[3],
                            nsmall=3), "sec")                  # Prepare success message
  LogTask(duration)                                       # Display Success Message
  save(list=ls(all=TRUE),
       file=paste0(FileName, "_FINAL.Rdata"))                  #  Finally, save all the objects in this environment to .Rdata file

  mstr.ErrMsg <- ""                                            # If we've reach here, then we're done and no errors were caught

  ### Error Handler

}, error = function(err) {                                     # Catch block to report an error
  try(print(err))                                              #  Print error message to console (using try to continue on any print error)
  save(list=ls(ripEnv, all.names=TRUE),
       file=paste0(ifelse(!exists("FileName") || nchar(FileName)==0,
                          "SentimentAnalysis",
                          FileName),
                   "_ERROR.Rdata"))                            #  Save the objects in this environment
  return(err$message)                                          #  Return error Message
})
