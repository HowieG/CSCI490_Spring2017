get_all_data <- function(years) {
  
  if(!exists("getCSCourseTable_forNewData", mode="function")) {
    
    setwd("~/Desktop/CSCI490/CSCI490_Spring2017/R")
    source("get_school_info.R")
    
    datalist <- list()
    
    for (schoolyear in years) {
      
      CourseEnrollmentFile <-  paste("../Data/CourseEnrollment/CourseEnroll", schoolyear, ".txt", sep = "")
      schoolyear <- paste(schoolyear, (schoolyear+1), sep = "")
      
      data <- get_school_info(CourseEnrollmentFile, schoolyear)
      
      key <- schoolyear
      value <- data
      
      datalist[[ key ]] <- value #ACCESS WITH datalist[["1415"]]
    }
    
    #schoolyear 1213 is missing one element...
    #datalist[["1213"]][380,"GradeLevelCode"] = 09
    
    return(datalist)
  }
}

main <- function() {
  rm(list=ls(all=TRUE))
  years <- c(14) #REPLACE
  #years <- c(12,13,14)
  datalist <- get_all_data(years)
  return(datalist)
}

datalist <- main()

#TODO
#find better place to check if function exists
#modularize to allow to search by course, city, etc.
#get rid of setwd() for portability
