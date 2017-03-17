#Gets CS course enrollment for Los Angeles merged with FRPM data

get_CSCourseTable_forNewData <- function(Course_Enrollment_File, schoolyear) {
  
  #All post-2012 data uses this assignment code file
  Assignment_Code_File <- "AssignmentCodes12On.xls"
  
  #this holds course names (AssignmentName) and course ID (AssignmentCode) for all tracked courses
  library(readxl)
  setwd("~/Desktop/CSCI490/Data/AssignmentCodes")
  CourseAssignmentCodes_Complete <- read_excel(Assignment_Code_File)
  
  #open the Course Enrollment data (2014-2015)
  #this holds schools, courses, and course enrollment by gender/ethnicity
  #install.packages("rio") # Only install once
  library(rio)
  setwd("~/Desktop/CSCI490/Data/CourseEnrollment")
  CourseEnrollment_Complete <- import(Course_Enrollment_File)
  
  #make new data frame with only Computer courses
  #columns: AssignmentCode, AssignmentName
  
  #rename "AssignmentName" to "CourseName" for consistency
  names(CourseAssignmentCodes_Complete)[names(CourseAssignmentCodes_Complete)=="AssignmentName"] <- "CourseName"
  
  #rename "AssignmentCode" to "CourseCode" for consistency
  names(CourseAssignmentCodes_Complete)[names(CourseAssignmentCodes_Complete)=="AssignmentCode"] <- "CourseCode"
  
  #new data frame with only rows that contain "Computer" in their AssignmentName
  CourseAssignmentCodes_ComputerCourses <- CourseAssignmentCodes_Complete[grep("Computer", CourseAssignmentCodes_Complete$CourseName), ]
  
  #keep only the relevant computer courses
  CourseAssignmentCodes_ComputerCourses <- CourseAssignmentCodes_ComputerCourses[grep("science|programming|Science|Programming", CourseAssignmentCodes_ComputerCourses$CourseName), ]
  
  #keep only CourseCode, CourseName
  CourseAssignmentCodes_ComputerCourses <- CourseAssignmentCodes_ComputerCourses[,c("CourseCode","CourseName")]
  
  
  ##make new data frame of Los Angeles schools with enrollment in relevant Computer courses
  
  #keep only Los Angeles schools
  CourseEnrollment_LosAngeles <- CourseEnrollment_Complete[grep("LOS ANGELES", CourseEnrollment_Complete$CountyName), ]
  
  #keep only the rows whose CourseCode matches the desired AssignmentCodes
  toGrab <- (CourseEnrollment_LosAngeles$CourseCode %in% CourseAssignmentCodes_ComputerCourses$CourseCode)
  
  #put values list into data frame
  CourseEnrollment_ComputerCourses_LosAngeles <- CourseEnrollment_LosAngeles[toGrab,]
  
  #cleanup
  rm("toGrab")
  
  #take out unnecessary table columns
  toDrop <- c("CountyName", "ClassID", "ClassCourseID", "FileCreated")
  CourseEnrollment_ComputerCourses_LosAngeles <- CourseEnrollment_ComputerCourses_LosAngeles[ , !(names(CourseEnrollment_ComputerCourses_LosAngeles) %in% toDrop)]
  
  rm("toDrop")
  
  #add computer science course names
  CourseEnrollment_ComputerCourses_LosAngeles <- merge(CourseEnrollment_ComputerCourses_LosAngeles, CourseAssignmentCodes_ComputerCourses, by="CourseCode")
  
  if(!exists("getCSCourseTable_forNewData", mode="function")) {
    
    setwd("~/Desktop/CSCI490/R")
    source("get_FRPM.R") 
    FRPM_ComputerCourses_LosAngeles <- get_FRPM(schoolyear, CourseEnrollment_ComputerCourses_LosAngeles$SchoolCode)
  }
  
  #merge rows whose SchoolCode in CourseEnrollment_ComputerCourses_LosAngeles matches the desired SchoolCode in FRPM_ComputerCourses_LosAngeles
  FRPM_CourseEnrollment_ComputerCourses_LosAngeles <- merge(CourseEnrollment_ComputerCourses_LosAngeles, FRPM_ComputerCourses_LosAngeles, by="SchoolCode")
  
  return(FRPM_CourseEnrollment_ComputerCourses_LosAngeles)
  
}

#Functions that may be useful in the future

# #take out unnecessary table columns
# toDrop <- c("AcademicYear","DistrictCode", "SchoolCode", "CountyName", "ClassID", "ClassCourseID", "FileCreated")
# CourseEnrollment_ComputerCourses_LosAngeles <- CourseEnrollment_ComputerCourses_LosAngeles[ , !(names(CourseEnrollment_ComputerCourses_LosAngeles) %in% toDrop)]
# 
# rm("toDrop")
# 
# #TODO
# #combine all grade levels and genders for duplicate courses
# toDrop <- c("GradeLevelCode","GenderCode")
# CourseEnrollment_ComputerCourses_LosAngeles_AllGrades_AllGenders <- CourseEnrollment_ComputerCourses_LosAngeles[ , !(names(CourseEnrollment_ComputerCourses_LosAngeles) %in% toDrop)]
# 
# rm("toDrop")
# 
# #
# library(data.table)
# CourseEnrollment_ComputerCourses_LosAngeles_AllGrades_AllGenders <- data.table(CourseEnrollment_ComputerCourses_LosAngeles_AllGrades_AllGenders)
# CourseEnrollment_ComputerCourses_LosAngeles_AllGrades_AllGenders <- CourseEnrollment_ComputerCourses_LosAngeles_AllGrades_AllGenders[, lapply(.SD, sum), by=list(DistrictName, SchoolName, CourseCode)]
#
