#Fills database with compiled data

# install.packages("RMySQL") #install only once
# install.packages("dbConnect") #install only once

#set working directoy to Data folder
#setwd("~/Desktop/CSCI490/CSCI490_Spring2017/Data/")

library(RMySQL)
library(dbConnect)

#TODO: change localhost to server IP
mydb = dbConnect(MySQL(), user='root', password='south677', dbname = "CSCI490", host='localhost')

##############################################################################################################
########################################## Table creation functions ##########################################
##############################################################################################################
createSchoolyearsTable <- function() {
  #stored as VARCHAR to keep leading zeroes!
  dbSendQuery(mydb, "
              CREATE TABLE schoolyears (
              schoolyear_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
              schoolyear VARCHAR(5))")
}
createDistrictsTable <- function() {
  dbSendQuery(mydb, "
              CREATE TABLE districts (
              district_id INT AUTO_INCREMENT PRIMARY KEY,
              district_code INT,
              district_name VARCHAR(50))")
}
createSchoolsTable <- function() {
  dbSendQuery(mydb, "
              CREATE TABLE schools (
              school_id INT AUTO_INCREMENT PRIMARY KEY,
              school_code INT,
              district_id INT,
              school_name VARCHAR(100))")
}
createCoursesTable <- function() {
  dbSendQuery(mydb, "
              CREATE TABLE courses (
              course_id INT AUTO_INCREMENT PRIMARY KEY,
              course_code INT,
              course_name VARCHAR(100))")
}
createGradeLevelsTable <- function() {
  dbSendQuery(mydb, "
              CREATE TABLE grade_levels (
              grade_level_id INT AUTO_INCREMENT PRIMARY KEY,
              grade_level INT)")
}
createGendersTable <- function() {
  dbSendQuery(mydb, "
              CREATE TABLE genders (
              gender_id INT AUTO_INCREMENT PRIMARY KEY,
              gender VARCHAR(2))")
}
createEthnicitiesTable <- function() {
  dbSendQuery(mydb, "
              CREATE TABLE ethnicities (
              ethnicity_id INT AUTO_INCREMENT PRIMARY KEY,
              ethnicity VARCHAR(10))")
}
createIncomeEstimatorsTable <- function() {
  dbSendQuery(mydb, "
              CREATE TABLE income_estimators (
              income_estimator_id INT AUTO_INCREMENT PRIMARY KEY,
              income_estimator_type VARCHAR(50))")
}
#all information relevant to the school for a given year
createSchoolInfoTable <- function() {
  dbSendQuery(mydb, "
              CREATE TABLE school_info (
              school_info_id INT AUTO_INCREMENT PRIMARY KEY,
              schoolyear_id INT,
              school_id INT,
              total_enrollment INT,
              free_meal_eligible INT,
              free_meal_eligible_percent DECIMAL(10,9),
              FRPM_eligible INT,
              FRPM_eligible_percent DECIMAL(10,9))")
}
createCSEnrollmentsTable <- function() {
  dbSendQuery(mydb, "
              CREATE TABLE cs_enrollments (
              cs_enrollments_id INT AUTO_INCREMENT PRIMARY KEY,
              schoolyear_id INT,
              school_id INT,
              course_id INT,
              gradelevel_id INT,
              gender_id INT,
              ethnicity_id INT,
              cs_enrollment INT)")
}
##############################################################################################################
########################################## Table filling functions ###########################################
##############################################################################################################
fillSchoolyearsTable <- function() {
  schoolyears <- c("8889","8990","9091","9192","9293","9394","9495","9596","9697","9798","9899","9900","0001","0102",
                   "0203","0304","0405","0506","0607","0708","0809","0910","1011","1112","1213","1314","1415","1516")
  for(schoolyear in schoolyears) {
    query = paste("INSERT INTO schoolyears (schoolyear) VALUES('", schoolyear, "')")
    dbSendQuery(mydb, query)
  }
}
fillDistrictsTable <- function() {
  rowNum = 1
  for(row in df[, 1]) {
    districtcode <- df$DistrictCode[rowNum]
    districtname <- df$DistrictName[rowNum]
    #hacky
    query = paste("INSERT INTO districts(district_code, district_name) SELECT ", districtcode,", '", districtname,
                  "' FROM dual WHERE NOT EXISTS (SELECT * FROM districts WHERE district_code = ", districtcode, ")")
    dbSendQuery(mydb, query)
    rowNum = rowNum+1
  }
}
fillSchoolsTable <- function() {
  #add schools
  rowNum = 1
  for(row in df[, 1]) {
    schoolcode <- df$SchoolCode[rowNum]
    schoolname <- df$SchoolName[rowNum]
    districtcode <- df$DistrictCode[rowNum]
    
    district_id_query = paste("SELECT district_id FROM districts WHERE district_code = ", districtcode)
    res = dbGetQuery(mydb, district_id_query)
    district_id = res$district_id
    
    query = paste("INSERT INTO schools(school_code, district_id, school_name) SELECT ", schoolcode, ", ", district_id, ", '", schoolname,"' FROM dual WHERE NOT EXISTS (SELECT * FROM schools WHERE school_code = ", schoolcode, ")")
    dbSendQuery(mydb, query)
    rowNum = rowNum+1
  }
}
fillCoursesTable <- function() {
  rowNum = 1
  for(row in df[, 1]) {
    coursecode <- df$CourseCode[rowNum]
    coursename <- df$CourseName[rowNum]
    query = paste("INSERT INTO courses(course_code, course_name) SELECT ", coursecode, ", '", coursename,
                  "' FROM dual WHERE NOT EXISTS (SELECT * FROM courses WHERE course_code = ", coursecode, ")")
    dbSendQuery(mydb, query)
    rowNum = rowNum+1
  }
}
fillGradeLevelsTable <- function() {
  gradelevels <- c(6,7,8,9,10,11,12)
  for(gradelevel in gradelevels) {
    query = paste("INSERT INTO grade_levels (grade_level) VALUES('", gradelevel, "')")
    dbSendQuery(mydb, query)
  }
}
fillGendersTable <- function() {
  genders <- c("M", "F")
  for(gender in genders) {
    query = paste("INSERT INTO genders (gender) VALUES('", gender, "')")
    dbSendQuery(mydb, query)
  }
}
fillEthnicitiesTable <- function() {
  ethnicities <- c("NoEthRptd", "AmInd", "Asian", "PacIsl", "Filipino", "Hispanic", "AfrAm", "White", "TwoOrMore")
  for(ethnicity in ethnicities) {
    query = paste("INSERT INTO ethnicities (ethnicity) VALUES('", ethnicity, "')")
    dbSendQuery(mydb, query)
  }
}
fillIncomeEstimatorsTable <- function() {
  income_estimators <- c("free_meal_eligible", "free_meal_eligible_percent", "FRPM_eligible", "FRPM_eligible_percent")
  for(income_estimator in income_estimators) {
    query = paste("INSERT INTO income_estimators (income_estimator_type) VALUES('", income_estimator, "')")
    dbSendQuery(mydb, query)
  }
fillSchoolInfoTable <- function() {
  # freemealeligible <- df[,22][rowNum]
  # freemealeligiblepercent <- df[,23][rowNum]
  # FRPMeligible <- df[,24][rowNum]
  # FRPMeligiblepercent <- df[,25][rowNum]
}
fillCSEnrollmentsTable <- function() {
  
}
  
}
##############################################################################################################
########################################### Table action functions ###########################################
##############################################################################################################
dropTable <- function(tablename) {
  dropquery = paste("drop table if exists ", tablename)
  print(dropquery)
  dbSendQuery(mydb, dropquery)
}
listAllTables <- function() {
  dbListTables(mydb)
}
##############################################################################################################
############################################## Excuting queries ##############################################
##############################################################################################################
create_tables <- function() {
  createSchoolyearsTable()
  createDistrictsTable()
  createSchoolsTable()
  createCoursesTable()
  createGradeLevelsTable()
  createGendersTable()
  createEthnicitiesTable()
  createIncomeEstimatorsTable()
  createSchoolInfoTable()
  createCSEnrollmentsTable()
}
initial_fill <- function() {
  #adding 2014-2015 data
  df <- datalist[['1415']]
  
  fillSchoolyearsTable()
  fillDistrictsTable()
  fillSchoolsTable()
  fillCoursesTable()
  fillGradeLevelsTable()
  fillGendersTable()
  fillEthnicitiesTable()
  fillIncomeEstimatorsTable()
  fillSchoolInfoTable()
  fillCSEnrollmentsTable()
}
fill_database <- function() {
  create_tables()
  initial_fill()
}

##############################################################################################################
################################################### Notes ####################################################
##############################################################################################################

#Probably have to make some of the fill____Tables take in a year as a parameter
#Possibility of trying to add data for a school that closed before 2014, and so would not be in the school table

##############################################################################################################
################################################### Misc. ####################################################
##############################################################################################################
#bad logic
# getYears <- function(startyear, endyear) {
#   years <- startyear:endyear
#   schoolyears <- list()
#   i <- 1
#   for(year in years) {
#     year <- as.character(year)
#     year <- as.numeric(unlist(strsplit(year, "")))
#     schoolyear <- paste(year[3], year[4], year[3], year[4]+1, sep="")
#     schoolyears[[i]] <- schoolyear
#     i <- i + 1
#   }
#   return(schoolyears)
# }