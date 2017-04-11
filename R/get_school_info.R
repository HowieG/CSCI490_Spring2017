get_school_info <- function(Course_Enrollment_File, schoolyear) {
  
  #All post-2012 data uses this assignment code file
  Assignment_Code_File <- "../Data/AssignmentCodes/AssignmentCodes12On.xls"
  
  #this holds course names (AssignmentName) and course ID (AssignmentCode) for all tracked courses
  library(readxl)
  #setwd("~/Desktop/CSCI490/CSCI490_Spring2017/Data/AssignmentCodes")
  
  All_Schools <- read_excel(Assignment_Code_File)
  
  #open the Course Enrollment data (2014-2015)
  #this holds schools, courses, and course enrollment by gender/ethnicity
  #install.packages("rio") # Only install once
  library(rio)
  #setwd("~/Desktop/CSCI490/CSCI490_Spring2017/Data/CourseEnrollment")
  All_Schools <- import(Course_Enrollment_File)
  
  #make new data frame with only Computer courses
  #columns: AssignmentCode, AssignmentName
  
  #rename "AssignmentName" to "CourseName" for consistency
  names(All_Schools)[names(All_Schools)=="AssignmentName"] <- "CourseName"
  
  #rename "AssignmentCode" to "CourseCode" for consistency
  names(All_Schools)[names(All_Schools)=="AssignmentCode"] <- "CourseCode"
  
  #get rid of schools with GradeLevelCodes KN and US
  All_Schools <- subset(All_Schools,  ! All_Schools$GradeLevelCode %in% c("KN", "US", "UE"))
  
  #cast GradeLevelCode as int
  All_Schools$GradeLevelCode <- as.integer(All_Schools$GradeLevelCode)
  
  # #keep only high schools
  All_High_Schools <- subset(All_Schools, GradeLevelCode > 8)

  # #keep only Los Angeles schools
  All_LA_High_Schools <- All_High_Schools[grep("LOS ANGELES", All_High_Schools$CountyName), ]

  #remove unneeded columns
  toDrop <- c("CountyName", "ClassID", "ClassCourseID", "FileCreated")
  All_LA_High_Schools <- All_LA_High_Schools[ , !(names(All_LA_High_Schools) %in% toDrop)]
  rm("toDrop")
  
  
  View(All_LA_High_Schools)
  
  #add FRPM data
  if(!exists("get_FRPM", mode="function")) {
    source("get_FRPM.R")
  }
  FRPM_LA <- get_FRPM(schoolyear, All_LA_High_Schools$SchoolCode)

  #merge rows whose SchoolCode in All_LA_High_Schools matches the desired SchoolCode in FRPM_LA
  All_LA_High_Schools <- merge(All_LA_High_Schools, FRPM_LA, by="SchoolCode")

  #add ethnicity data
  if(!exists("get_enrollment", mode="function")) {
    source("get_enrollment.R")
  }
  Enrollment_LA <- get_enrollment(schoolyear, All_LA_High_Schools$SchoolCode)
  
  #add a CS courses count column
  
  
  # #add computer science course names
  # CourseEnrollment_ComputerCourses_LosAngeles <- merge(CourseEnrollment_ComputerCourses_LosAngeles, CourseAssignmentCodes_ComputerCourses, by="CourseCode")
  # 

  
  
  return(All_LA_High_Schools)
  
}

#Functions that may be useful in the future

#unique(datalist[["1415"]]$SchoolCode)

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
