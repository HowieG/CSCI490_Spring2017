#Fills database with compiled data

# install.packages("RMySQL") #install only once
# install.packages("dbConnect") #install only once

library(RMySQL)
library(dbConnect)

mydb = dbConnect(MySQL(), user='sql3162596', password='R1FkGaph13', dbname = "CSCI490_Live", host='sql3.freemysqlhosting.net	') # change localhost to server IP
dbListTables(mydb)

#dbSendQuery(mydb, "drop table if exists schools")

create_tables <- function() {
  
  dbSendQuery(mydb, "
CREATE TABLE schoolyears (
              schoolyear_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
              schoolyear INT,
              total_enrollment INT)")
  
  dbSendQuery(mydb, "
CREATE TABLE districts (
            district_id INT AUTO_INCREMENT PRIMARY KEY,
            district_code INT,
            district_name VARCHAR(50))")
  
  dbSendQuery(mydb, "
CREATE TABLE schools (
            school_id INT AUTO_INCREMENT PRIMARY KEY,
            school_code INT,
            school_name VARCHAR(100))")
  
  dbSendQuery(mydb, "
CREATE TABLE courses (
            course_id INT AUTO_INCREMENT PRIMARY KEY,
            course_code INT,
            course_name VARCHAR(100))")
  
  dbSendQuery(mydb, "
CREATE TABLE grades (
            grade_id INT AUTO_INCREMENT PRIMARY KEY,
            grade INT)")
  
  dbSendQuery(mydb, "
CREATE TABLE genders (
            gender_id INT AUTO_INCREMENT PRIMARY KEY,
            gender VARCHAR(2))")
  
  dbSendQuery(mydb, "
CREATE TABLE ethnicities (
            ethnicity_id INT AUTO_INCREMENT PRIMARY KEY,
            ethnicity VARCHAR(10))")
  
  dbSendQuery(mydb, "
CREATE TABLE income_estimators (
            income_estimators_id INT AUTO_INCREMENT PRIMARY KEY,
            free_meal_eligible INT,
            free_meal_eligible_percent DECIMAL(10,9),
            FRPM_eligible INT,
            FRPM_eligible_percent DECIMAL(10,9))")
}

initial_fill <- function() {
  schoolyears <- c(8889,8990,9091,9192,9293,9394,9495,9596,9697,9798,9899,9900,0001,0102,
                   0203,0304,0405,0506,0607,0708,0809,0910,1011,1112,1213,1314,1415,1516)
  
  ethnicities <- c("NoEthRptd", "AmInd", "Asian", "PacIsl", "Filipino", "Hispanic", "AfrAm", "White", "TwoOrMore")
  
  grades <- c(6,7,8,9,10,11,12)
  
  genders <- c("M", "F")
  
  for(schoolyear in schoolyears) {
    #TODO FIX LEADING ZERO ISSUE
    query = paste("INSERT INTO schoolyears (schoolyear) VALUES(", schoolyear, ")")
    dbSendQuery(mydb, query)
  }
  
  for(ethnicity in ethnicities) {
    query = paste("INSERT INTO ethnicities (ethnicity) VALUES('", ethnicity, "')")
    dbSendQuery(mydb, query)
  }
  
  for(grade in grades) {
    query = paste("INSERT INTO grades (grade) VALUES('", grade, "')")
    dbSendQuery(mydb, query)
  }
  
  for(gender in genders) {
    query = paste("INSERT INTO genders (gender) VALUES('", gender, "')")
    dbSendQuery(mydb, query)
  }
  
  #adding 2014-2015 data
  df <- datalist[['1415']]
  df
  
  
  
  #add schools
  rowNum = 1
  for(row in df[, 1]) {
    schoolcode <- df$SchoolCode[rowNum]
    schoolname <- df$SchoolName[rowNum]
    # freemealeligible <- df[,22][rowNum]
    # freemealeligiblepercent <- df[,23][rowNum]
    # FRPMeligible <- df[,24][rowNum]
    # FRPMeligiblepercent <- df[,25][rowNum]
    
    query = paste("INSERT INTO schools(school_code, school_name) SELECT ", schoolcode, ", '", schoolname, "' FROM dual WHERE NOT EXISTS (SELECT * FROM schools WHERE school_code = ", schoolcode, ")")
    #query = paste("INSERT INTO income_estimators(free_meal_eligible, free_meal_eligible_percent, FRPM_eligible, FRPM_eligible_percent) SELECT ", freemealeligible, ", ", freemealeligiblepercent, ", ", FRPMeligible, ", ", FRPMeligiblepercent, " FROM dual WHERE NOT EXISTS (SELECT * FROM schools WHERE school_code = ", schoolcode, ")")
    dbSendQuery(mydb, query)
    rowNum = rowNum+1
  }
  
  # #add total enrollments per year
  # rowNum = 1
  # for(row in df[, 1]) {
  #   totalenrollments <- df$[rowNum]
  #   #hacky
  #   query = paste("INSERT INTO schools(school_code, school_name) SELECT ", schoolcode, ", '", schoolname, "' FROM dual WHERE NOT EXISTS (SELECT * FROM schools WHERE school_code = ", schoolcode, ")")
  #   dbSendQuery(mydb, query)
  #   rowNum = rowNum+1
  # }
  
  #add districts
  rowNum = 1
  for(row in df[, 1]) {
    districtcode <- df$DistrictCode[rowNum]
    districtname <- df$DistrictName[rowNum]
    #hacky
    query = paste("INSERT INTO districts(district_code, district_name) SELECT ", districtcode, ", '", districtname, "' FROM dual WHERE NOT EXISTS (SELECT * FROM districts WHERE district_code = ", districtcode, ")")
    dbSendQuery(mydb, query)
    rowNum = rowNum+1
  }
  
  #add courses
  rowNum = 1
  for(row in df[, 1]) {
    coursecode <- df$CourseCode[rowNum]
    coursename <- df$CourseName[rowNum]
    #hacky
    query = paste("INSERT INTO courses(course_code, course_name) SELECT ", coursecode, ", '", coursename, "' FROM dual WHERE NOT EXISTS (SELECT * FROM courses WHERE course_code = ", coursecode, ")")
    dbSendQuery(mydb, query)
    rowNum = rowNum+1
  }
  
}

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


fill_database <- function() {
  
}


#set working directoy to Data folder
setwd("~/Desktop/CSCI490/Data/")



#Reference functions

#dbSendQuery(mydb, "drop table if exists table1 table2 table3")
