#Fills database with compiled data (for all school data only)

# install.packages("RMySQL") #install only once
# install.packages("dbConnect") #install only once

library(RMySQL)
library(dbConnect)

#TODO: change localhost to server IP
mydb = dbConnect(MySQL(), user='root', password='south677', dbname = "CSCI490", host='localhost')

##############################################################################################################
########################################## Table creation functions ##########################################
##############################################################################################################
createAllSchoolsTable <- function() {
  dbSendQuery(mydb, "
              CREATE TABLE all_schools (
              school_id INT AUTO_INCREMENT PRIMARY KEY,
              school_code INT,
              school_name VARCHAR(100))")
}
#all information relevant to the school for a given year
createAllSchoolInfoTable <- function() {
  dbSendQuery(mydb, "
              CREATE TABLE all_school_info (
              school_id INT PRIMARY KEY,
              schoolyear_id INT,
              NoEthRptd INT DEFAULT 0,
              AmInd INT DEFAULT 0,
              Asian INT DEFAULT 0,
              PacIsl INT DEFAULT 0,
              Filipino INT DEFAULT 0,
              Hispanic INT DEFAULT 0,
              AfrAm INT DEFAULT 0,
              White INT DEFAULT 0,
              TwoOrMore INT DEFAULT 0,
              M INT DEFAULT 0,
              F INT DEFAULT 0,
              total_enrollment INT DEFAULT 0,
              free_meal_eligible INT,
              free_meal_eligible_percent DECIMAL(10,9),
              FRPM_eligible INT,
              FRPM_eligible_percent DECIMAL(10,9))")
}

#TODO update the CS_enrollments table because the schoolIDs are now all different
createCSEnrollmentsTable <- function() {
  dbSendQuery(mydb, "
              CREATE TABLE updated_cs_enrollments (
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
fillAllSchoolsTable <- function() {
  
  df = Enrollment_Data_Complete
  
  #add schools
  for(rowNum in 1:nrow(df)) {
    schoolcode = df$SchoolCode[rowNum]
    schoolname = df$SchoolName[rowNum]
    schoolname = dbEscapeStrings(mydb, schoolname)
    
    query = paste("INSERT INTO all_schools(school_code, school_name) SELECT ", schoolcode,
                  ", '", schoolname,"' FROM dual WHERE NOT EXISTS (SELECT * FROM all_schools WHERE school_code = ", schoolcode, ")", sep = "")
    dbSendQuery(mydb, query)
  }
}

fillAllSchoolInfoTable <- function() {
  
  df = Enrollment_Data_Complete
  
  #add schools
  for(rowNum in 1:nrow(df)) {
    
    #schoolyear hardcoded for now
    sy = "1415"
    sc = df[rowNum, "SchoolCode"]
    enr = df[rowNum, "enrolled"]
    eth = df[rowNum, "ethnicity"]
    gen = df[rowNum, "gender"]
    
    #schoolyear hardcoded for now
    sy_id = 27
    
    #get ethnicity column name for corresponding ethnicity id
    ethnicity_query = paste("SELECT ethnicity FROM ethnicities WHERE ethnicity_id =", eth)
    res = dbGetQuery(mydb, ethnicity_query)
    eth = res$ethnicity
    
    #get school id corresponding to the school code
    school_id_query = paste("SELECT school_id FROM all_schools WHERE school_code = ", sc, sep = "")
    res = dbGetQuery(mydb, school_id_query)
    s_id = res$school_id
    
    params = paste("school_id, schoolyear_id, ", eth,", ", gen, sep = "")
    values = paste(s_id, ", ",sy_id, ", ", enr, ", ", enr, sep = "")
    update = paste("ON DUPLICATE KEY UPDATE ", eth, " = ", eth, " + ", enr, ", ", gen, " = ", gen, " + ", enr, ";", sep = "")
    
    query = paste("INSERT INTO all_school_info(", params , ") VALUES (", values, ") ", update, sep = "")
    
    #print(query)
    
    dbSendQuery(mydb, query)
  }
}

fillFRPMData <- function() {
  
  df = FRPM_Data_Complete
  
  #get FRPM-related column names for all_school_info table
  res <- getColumnNames("all_school_info")
  #save table columns/fields to a vector
  column_names = res[[1]]
  #save to one string so the query doesn't get too long
  p = column_names[14:18]
  
  #add schools
  for(rowNum in 1:nrow(df)) {
    
    #schoolyear hardcoded for now
    sy = "1415"
    sc = df[rowNum, "SchoolCode"]
    te = df[rowNum, "total_enrollment"]
    fme = df[rowNum, "free_meal_eligible"]
    fmep = df[rowNum, "free_meal_eligible_percent"]
    frpme = df[rowNum, "FRPM_eligible"]
    frpmep = df[rowNum, "FRPM_eligible_percent"]
    
    #schoolyear hardcoded for now
    sy_id = 27
    
    #cast to an int to get rid of leading zero
    sc = as.numeric(sc)
    
    if(is.na(sc)) {
      next
    }
    
    #get school id corresponding to the school code
    school_id_query = paste("SELECT school_id FROM all_schools WHERE school_code = ", sc, sep = "")
    res = dbGetQuery(mydb, school_id_query)
    s_id = res$school_id
    
    #leave for loop if did not find matching SchoolCode
    if(nrow(res) == 0) {
      next
    }
    
    values = paste(te, ", ",fme, ", ", fmep, ", ", frpme, ", ", frpmep, sep = "")
    update = paste(p[1]," = ",te,",",p[2], " = ",fme,",",p[3]," = ",fmep,",",p[4]," = ",frpme,",",p[5]," = ",frpmep," ", sep = "")
    
    print(update)
    
    query = paste("UPDATE all_school_info SET ", update, "WHERE school_id = ", s_id, ";", sep = "")
    
    print(query)
    
    dbSendQuery(mydb, query)
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
  createAllSchoolsTable()
  createAllSchoolInfoTable()
  createCSEnrollmentsTable()
}
initial_fill <- function() {
  #adding 2014-2015 data
  df <- datalist[['1314']] #can't set it this way. df is global.
  
  fillAllSchoolsTable()
  fillAllSchoolInfoTable()
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

#going to have to change the fill___() functions to accomodate the duplicate school_ids for different schoolyears

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