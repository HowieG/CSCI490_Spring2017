#Gets FRPM data for relevant schools

get_FRPM <- function(schoolyear, SchoolCodes) {
  
  setwd("~/Desktop/CSCI490/CSCI490_Spring2017/Data")
  FRPM_filename <- paste("FRPM/frpm", schoolyear, ".xls", sep = "")
  
  #concatenate year to FRPM filename
  library(readxl)
  FRPM_Data_Complete <- read_excel(FRPM_filename, sheet = 2) # "2" gets second sheet, as the Excel data has 3 sheets.

  #rename "School Code" to "SchoolCode" for consistency
  names(FRPM_Data_Complete)[names(FRPM_Data_Complete)=="School Code"] <- "SchoolCode"
  
  #keep only the rows whose CourseCode matches the desired SchoolCodes
  toGrab <- (FRPM_Data_Complete$SchoolCode %in% SchoolCodes)
  
  #put values list into data frame
  FRPM_Data <- FRPM_Data_Complete[toGrab,]
  
  #cleanup
  rm("toGrab")
  
  #keep only School Code, Enrollment total, Free Meal Count, Percent Eligible Free, FRPM count, Percent Eligible FRPM
  ##TODO: REPLACE COLUMN INDICES
  
  valid_years <- c(1213,1314,1415)
  case <- match(schoolyear,valid_years)
  
  columns_to_keep <- switch(case,
                            columns_to_keep = c(4,13,14,15,16,17),
                            columns_to_keep = c(4,13,15,16,18,19),
                            columns_to_keep = c(4,18,19,20,21,22)
  )
  
  #rename income estimators for easier accessing
  names(FRPM_Data)[columns_to_keep[2]] <- "total_enrollment"
  names(FRPM_Data)[columns_to_keep[3]] <- "free_meal_eligible"
  names(FRPM_Data)[columns_to_keep[4]] <- "free_meal_eligible_percent"
  names(FRPM_Data)[columns_to_keep[5]] <- "FRPM_eligible"
  names(FRPM_Data)[columns_to_keep[6]] <- "FRPM_eligible_percent"
  
  FRPM_Data <- FRPM_Data[columns_to_keep]
  
  return(FRPM_Data)
}
