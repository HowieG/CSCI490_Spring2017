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
    query = paste("INSERT INTO schoolyears (schoolyear) VALUES('", schoolyear, "')", sep = "")
    dbSendQuery(mydb, query)
  }
}
fillDistrictsTable <- function() {
  rowNum = 1
  for(row in df[, 1]) {
    districtcode <- df$DistrictCode[rowNum]
    districtname <- df$DistrictName[rowNum]
    districtname = dbEscapeStrings(mydb, districtname)
    
    query = paste("INSERT INTO districts(district_code, district_name) SELECT ", districtcode,", '", districtname,
                  "' FROM dual WHERE NOT EXISTS (SELECT * FROM districts WHERE district_code = ", districtcode, ")", sep = "")
    dbSendQuery(mydb, query)
    rowNum = rowNum+1
  }
}
fillSchoolsTable <- function() {
  #add schools
  for(rowNum in 1:nrow(df)) {
    schoolcode = df$SchoolCode[rowNum]
    schoolname = df$SchoolName[rowNum]
    schoolname = dbEscapeStrings(mydb, schoolname)
    districtcode = df$DistrictCode[rowNum]
    
    district_id_query = paste("SELECT district_id FROM districts WHERE district_code =", districtcode)
    res = dbGetQuery(mydb, district_id_query)
    district_id = res$district_id
    
    query = paste("INSERT INTO schools(school_code, district_id, school_name) SELECT ", schoolcode, ", ", district_id,
                  ", '", schoolname,"' FROM dual WHERE NOT EXISTS (SELECT * FROM schools WHERE school_code = ", schoolcode, ")", sep = "")
    dbSendQuery(mydb, query)
  }
}
fillCoursesTable <- function() {
  rowNum = 1
  for(row in df[, 1]) {
    coursecode <- df$CourseCode[rowNum]
    coursename <- df$CourseName[rowNum]
    query = paste("INSERT INTO courses(course_code, course_name) SELECT ", coursecode, ", '", coursename,
                  "' FROM dual WHERE NOT EXISTS (SELECT * FROM courses WHERE course_code = ", coursecode, ")", sep = "")
    dbSendQuery(mydb, query)
    rowNum = rowNum+1
  }
}
fillGradeLevelsTable <- function() {
  gradelevels <- c(0,6,7,8,9,10,11,12) #0 represents "US", a GradeLevelCode encountered in schoolyear 1213
  for(gradelevel in gradelevels) {
    query = paste("INSERT INTO grade_levels (grade_level) VALUES('", gradelevel, "')", sep = "")
    dbSendQuery(mydb, query)
  }
}
fillGendersTable <- function() {
  dbSendQuery(mydb, "INSERT INTO genders(gender) VALUES('M');")
  dbSendQuery(mydb, "INSERT INTO genders(gender) VALUES('F');")
}
fillEthnicitiesTable <- function() {
  ethnicities <- c("NoEthRptd", "AmInd", "Asian", "PacIsl", "Filipino", "Hispanic", "AfrAm", "White", "TwoOrMore", "EL")
  for(ethnicity in ethnicities) {
    query = paste("INSERT INTO ethnicities (ethnicity) VALUES('", ethnicity, "')", sep = "")
    dbSendQuery(mydb, query)
  }
}
fillIncomeEstimatorsTable <- function() {
  income_estimators <- c("free_meal_eligible", "free_meal_eligible_percent", "FRPM_eligible", "FRPM_eligible_percent")
  for(income_estimator in income_estimators) {
    query = paste("INSERT INTO income_estimators (income_estimator_type) VALUES('", income_estimator, "')", sep = "")
    dbSendQuery(mydb, query)
  }
}
fillSchoolInfoTable <- function() {
  #get column names for school_info table
  res <- getColumnNames("school_info")
  #save table columns/fields to a vector
  column_names = res[[1]]
  #save to one string so the query doesn't get too long
  params = paste(column_names[2:nrow(res)], collapse = ', ')
  
  #add schools
  rowNum = 1
  for(row in df[, 1]) {
    
    sy = df$AcademicYear[rowNum]
    sc = df$SchoolCode[rowNum]
    te = df$total_enrollment[rowNum]
    fme = df$free_meal_eligible[rowNum]
    fmep = df$free_meal_eligible_percent[rowNum]
    frpme = df$FRPM_eligible[rowNum]
    frpmep = df$FRPM_eligible_percent[rowNum]
    
    #get schoolyear id corresponding to the schoolyear
    #NOTE: schoolyear is saved as a VARCHAR!
    schoolyear_id_query = paste("SELECT schoolyear_id FROM schoolyears WHERE schoolyear = '", sy, "';", sep = "")
    res = dbGetQuery(mydb, schoolyear_id_query)
    sy_id = res$schoolyear_id
    
    #get school id corresponding to the school code
    school_id_query = paste("SELECT school_id FROM schools WHERE school_code = ", sc, sep = "")
    res = dbGetQuery(mydb, school_id_query)
    s_id = res$school_id
    
    values = paste(sy_id, ", ", s_id, ", ",te, ", ", fme, ", ", fmep, ", ",frpme, ", ", frpmep, sep = "")
    
    query = paste("INSERT INTO school_info(", params, ") SELECT ", values, " FROM dual WHERE NOT EXISTS (SELECT * FROM school_info WHERE school_id = ", s_id, ")", sep = "")
    
    dbSendQuery(mydb, query)
    rowNum = rowNum+1
  }
}
fillCSEnrollmentsTable <- function() { 
  #get column names for cs_enrollments table
  res <- getColumnNames("cs_enrollments")
  #save table columns/fields to a vector
  column_names = res[[1]]
  #save to one string so the query doesn't get too long
  params = paste(column_names[2:nrow(res)], collapse = ', ')
  
  for(rowNum in 1:nrow(df)) {
    #this is probably the better way to access elements in the df....
    sy = df[rowNum, "AcademicYear"]
    sc = df[rowNum, "SchoolCode"]
    cc = df[rowNum, "CourseCode"]
    gen = df[rowNum, "GenderCode"]
    gr = df[rowNum, "GradeLevelCode"]
    #placeholder until better solution. Maybe default is to return 0?
    if(gr == "US") {
      gr = 0
    }
    
    schoolyear_id_query = paste("SELECT schoolyear_id FROM schoolyears WHERE schoolyear = '", sy, "';", sep = "")
    res = dbGetQuery(mydb, schoolyear_id_query)
    sy_id = res$schoolyear_id
    
    school_id_query = paste("SELECT school_id FROM schools WHERE school_code = ", sc, sep = "")
    res = dbGetQuery(mydb, school_id_query)
    s_id = res$school_id
    
    course_id_query = paste("SELECT course_id FROM courses WHERE course_code = ", cc, sep = "")
    res = dbGetQuery(mydb, course_id_query)
    c_id = res$course_id
    
    grade_level_id_query = paste("SELECT grade_level_id FROM grade_levels WHERE grade_level = ", gr, sep = "")
    res = dbGetQuery(mydb, grade_level_id_query)
    gr_id = res$grade_level_id
    
    gender_id_query = paste("SELECT gender_id FROM genders WHERE gender = '", gen, "';", sep = "")
    res = dbGetQuery(mydb, gender_id_query)
    gen_id = res$gender_id
    
    #get enrollment of each ethnicity
    res = getColumn("ethnicities", "ethnicity")
    ethnicities = res[[1]]
    for(eth_id in 1:length(ethnicities)) {
      eth_col = paste("Enroll", ethnicities[eth_id], sep = "")
      enr = df[rowNum,eth_col]
      values = paste(sy_id, ", ", s_id, ", ",c_id, ", ", gr_id, ", ", gen_id, ", ",eth_id, ", ", enr, sep = "")
      query = paste("INSERT INTO cs_enrollments(", params, ") SELECT ", values, sep = "")
      dbSendQuery(mydb, query)
    }
  }
}
##############################################################################################################
########################################### Table action functions ###########################################
##############################################################################################################
dropTable <- function(tablename) {
  dropQuery = paste("drop table if exists", tablename)
  dbSendQuery(mydb, dropQuery)
}
listAllTables <- function() {
  dbListTables(mydb)
}
getColumnNames <- function(tablename) {
  getColumnNameQuery = paste("SELECT COLUMN_NAME FROM information_schema.columns WHERE table_schema = 'CSCI490' AND table_name = '",tablename,"';", sep="")
  dbGetQuery(mydb, getColumnNameQuery)
}
getColumn <- function(tablename, colname) {
  query = paste("SELECT", colname, "FROM", tablename, ";")
  dbGetQuery(mydb, query)
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
  df <- datalist[['1314']] #can't set it this way. df is global.
  
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

fill <- function() {
  
  df <- datalist[['1314']] #can't set it this way. df is global.
  
  #only execute these functions. The other fields are set and don't change
  fillDistrictsTable()
  fillSchoolsTable()
  fillSchoolInfoTable()
  fillCoursesTable()
  fillCSEnrollmentsTable()
}

##############################################################################################################
################################################ Test queries ################################################
##############################################################################################################
query = "SELECT * FROM schools WHERE school_name = 'Arcadia High'"
res = dbGetQuery(mydb, query)

query = "SELECT * FROM cs_enrollments WHERE school_id = 5"
res = dbGetQuery(mydb, query)

query = "SELECT * FROM cs_enrollments WHERE course_id = 7"
res = dbGetQuery(mydb, query)
##############################################################################################################
################################################### Notes ####################################################
##############################################################################################################

#Probably have to make some of the fill____Tables take in a year as a parameter

#Possibility of trying to add data for a school that closed before 2014, and so would not be in the school table

#Using dbSendQuery may give an error:  "...connection with pending rows, close resultSet before continuing"
#From Stackoverflow: http://stackoverflow.com/questions/4084028/how-to-close-resultset-in-rmysql
#dbClearResult(dbListResults(mydb)[[1]])

#Schoolyear 1213 is missing a single gradelevel... run df[380,"GradeLevelCode"] = 09 before filling the tables
#1213 has grade_level_code US....

#Data innacuracy: Arcadia High has 

#Execution
# > df <- datalist[['1415']]
# > fillCSEnrollmentsTable()
# > df <- datalist[['1314']]
# > fillCSEnrollmentsTable()
# > df <- datalist[['1213']]
# > df[380,"GradeLevelCode"] = 09
# > fillCSEnrollmentsTable()

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