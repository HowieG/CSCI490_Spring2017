#Gets enrollment data for relevant schools

get_enrollment <- function(schoolyear, SchoolCodes) {
  
  #concatenate year to enrollment filename
  Enrollment_filename <- paste("../Data/SchoolEnrollment/enr", schoolyear, ".txt", sep = "")
  
  #install package to read 64 bit integers (for the CDS code)
  #install.packages("bit64") #only install once
  library(rio)
  library(bit64)
  Enrollment_Data_Complete <- import(Enrollment_filename)
  
  #truncate CDS code to just the SchoolCode
  
  for (i in nrow(Enrollment_Data_Complete$CDS_Code)) {
    CDS = as.numeric(strsplit(as.character(Enrollment_Data_Complete[i, CDS_Code]), "")[[1]])
    print(CDS)
    Enrollment_Data_Complete[i, CDS_Code] = CDS[8:14]
    print(Enrollment_Data_Complete[i, CDS_Code])
  }
  
  #rename "CDS_Code" to "SchoolCode" for consistency
  names(Enrollment_Data_Complete)[names(Enrollment_Data_Complete)=="CDS_Code"] <- "SchoolCode"
  
  View(Enrollment_Data_Complete)
  

  # 
  # #keep only the rows whose CourseCode matches the desired SchoolCodes
  # toGrab <- (FRPM_Data_Complete$SchoolCode %in% SchoolCodes)
  # 
  # #put values list into data frame
  # FRPM_Data <- FRPM_Data_Complete[toGrab,]
  # 
  # #cleanup
  # rm("toGrab")
  # 
  # #keep only School Code, Enrollment total, Free Meal Count, Percent Eligible Free, FRPM count, Percent Eligible FRPM
  # ##TODO: REPLACE COLUMN INDICES
  # 
  # valid_years <- c(1213,1314,1415)
  # case <- match(schoolyear,valid_years)
  # 
  # columns_to_keep <- switch(case,
  #                           columns_to_keep = c(4,13,14,15,16,17),
  #                           columns_to_keep = c(4,13,15,16,18,19),
  #                           columns_to_keep = c(4,18,19,20,21,22)
  # )
  # 
  # #rename income estimators for easier accessing
  # names(FRPM_Data)[columns_to_keep[2]] <- "total_enrollment"
  # names(FRPM_Data)[columns_to_keep[3]] <- "free_meal_eligible"
  # names(FRPM_Data)[columns_to_keep[4]] <- "free_meal_eligible_percent"
  # names(FRPM_Data)[columns_to_keep[5]] <- "FRPM_eligible"
  # names(FRPM_Data)[columns_to_keep[6]] <- "FRPM_eligible_percent"
  # 
  # FRPM_Data <- FRPM_Data[columns_to_keep]
  # 
  return(Enrollment_Data_Complete)
}
