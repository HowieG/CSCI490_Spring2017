#Gets enrollment data for all LA County schools

schoolyear <- "1415"

#TODO: change to schoolyear
get_all_school_info <- function(schoolyear) {
  
  library(dplyr)
  library(stringr)
  library(readr)
  
  #concatenate year with enrollment filename
  Enrollment_filename = paste("../Data/SchoolEnrollment/enr", schoolyear, ".txt", sep = "")
  
  #read in CDS_CODE as character so that we can later truncate it
  Enrollment_Data_Complete <- read_delim(Enrollment_filename, col_types = list(CDS_CODE = col_character()), delim = "\t")
  
  #truncate CDS code to just the SchoolCode
  Enrollment_Data_Complete$CDS_CODE = str_sub(Enrollment_Data_Complete$CDS_CODE, start = 8, end = 14)
  
  #rename CDS_CODE to SchoolCode
  Enrollment_Data_Complete<-rename(Enrollment_Data_Complete, SchoolCode = CDS_CODE)
  
  #rename SCHOOL to SchoolName
  Enrollment_Data_Complete<-rename(Enrollment_Data_Complete, SchoolName = SCHOOL)
  
  #rename ETHNIC to ethnicity
  Enrollment_Data_Complete<-rename(Enrollment_Data_Complete, ethnicity = ETHNIC)
  
  #rename GENDER to gender
  Enrollment_Data_Complete<-rename(Enrollment_Data_Complete, gender = GENDER)
  
  #rename ENR_TOTAL to enrolled
  Enrollment_Data_Complete<-rename(Enrollment_Data_Complete, enrolled = ENR_TOTAL)
  
  #keep only Los Angeles County schools
  Enrollment_Data_Complete <- filter(Enrollment_Data_Complete, COUNTY == "Los Angeles")
  
  #keep only high schools (KGDN...GR_8 = 0)
  Enrollment_Data_Complete <- filter(Enrollment_Data_Complete, KDGN == 0, GR_1 == 0, GR_2 == 0, GR_3 == 0, GR_4 == 0, GR_5 == 0, GR_6 == 0, GR_7 == 0, GR_8 == 0, UNGR_ELM == 0, enrolled > 0)

  #remove invalid data
  Enrollment_Data_Complete <- filter(Enrollment_Data_Complete, SchoolCode != "0000000", SchoolCode != "0000001")
  
  #remove extraneous columns
  Enrollment_Data_Complete <- select(Enrollment_Data_Complete, 1,4,5,6,22)
  
  ############################# IMPORTANT #############################
  #ethinicity codes in CALPADS are in zero-based but MySQL is one-based so add 1 to each ethnicity code
  #EXCEPT FOR "Code 9 = Two or More Races, Not Hispanic" because they skip Code 8, making this one ok
  Enrollment_Data_Complete$ethnicity[Enrollment_Data_Complete$ethnicity == 9] = 8
  Enrollment_Data_Complete$ethnicity = Enrollment_Data_Complete$ethnicity + 1
  
  View(Enrollment_Data_Complete)
  
}
  