SELECT * FROM CSCI490.updated_cs_enrollments;

SELECT COUNT( DISTINCT(school_id) ) FROM updated_cs_enrollments;
#93 public high schools offer CS in Los Angeles County

SELECT SUM(cs_enrollment) FROM updated_cs_enrollments;
#8549 students enrolled in CS in Los Angeles County

###################################### Ethnicity ######################################
#Raw
SELECT ethnicities.ethnicity, SUM(updated_cs_enrollments.cs_enrollment) AS `enrolled in CS`
FROM ethnicities
INNER JOIN updated_cs_enrollments ON ethnicities.ethnicity_id = updated_cs_enrollments.ethnicity_id
GROUP BY ethnicities.ethnicity;

#Percentage
SELECT ethnicities.ethnicity, SUM(updated_cs_enrollments.cs_enrollment)/85.49 AS `enrolled in CS`
FROM ethnicities
INNER JOIN updated_cs_enrollments ON ethnicities.ethnicity_id = updated_cs_enrollments.ethnicity_id
GROUP BY ethnicities.ethnicity;

###################################### Income ######################################
#1.	What is the distribution of income among schools that offer Computer Science?



#1.	What percentage of the students taking CS attend a low-income school? "High-income" school?*
#Raw
SELECT
   CASE
     WHEN FRPM_eligible_percent > 0.8 THEN '80-100% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.6 AND 0.8 THEN '60-80% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.4 AND 0.6 THEN '40-60% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.2 AND 0.4 THEN '20-40% FRPM-eligible'
     ELSE '0-20% FRPM-eligible'
   END AS 'income_brackets',
   SUM(updated_cs_enrollments.cs_enrollment) AS num_students
FROM all_school_info
INNER JOIN updated_cs_enrollments ON all_school_info.school_id = updated_cs_enrollments.school_id
GROUP BY income_brackets;

#Percentage
SELECT
   CASE
     WHEN FRPM_eligible_percent > 0.8 THEN '80-100% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.6 AND 0.8 THEN '60-80% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.4 AND 0.6 THEN '40-60% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.2 AND 0.4 THEN '20-40% FRPM-eligible'
     ELSE '0-20% FRPM-eligible'
   END AS 'income_brackets',
   SUM(updated_cs_enrollments.cs_enrollment)/85.49 AS num_students
FROM all_school_info
INNER JOIN updated_cs_enrollments ON all_school_info.school_id = updated_cs_enrollments.school_id
GROUP BY income_brackets;

####################################### Gender ######################################

#1.	What is the gender distribution of students enrolled in CS?
#Raw
SELECT genders.gender, SUM(updated_cs_enrollments.cs_enrollment) AS `enrolled in CS`
FROM genders
INNER JOIN updated_cs_enrollments ON genders.gender_id = updated_cs_enrollments.gender_id
GROUP BY genders.gender;
#Male: 5544
#Female: 3005

#Percentage
SELECT genders.gender, SUM(updated_cs_enrollments.cs_enrollment)/85.49 AS `enrolled in CS`
FROM genders
INNER JOIN updated_cs_enrollments ON genders.gender_id = updated_cs_enrollments.gender_id
GROUP BY genders.gender;

#What is the gender distribution of the ethnicities enrolled in CS?
#TODO: put into one table
#Raw
#Male
SELECT ethnicities.ethnicity, SUM(updated_cs_enrollments.cs_enrollment) AS `enrolled in CS`
FROM ethnicities
INNER JOIN updated_cs_enrollments ON ethnicities.ethnicity_id = updated_cs_enrollments.ethnicity_id
WHERE gender_id = 1
GROUP BY ethnicities.ethnicity;

#Female
SELECT ethnicities.ethnicity, SUM(updated_cs_enrollments.cs_enrollment) AS `enrolled in CS`
FROM ethnicities
INNER JOIN updated_cs_enrollments ON ethnicities.ethnicity_id = updated_cs_enrollments.ethnicity_id
WHERE gender_id = 2
GROUP BY ethnicities.ethnicity;

#Percentage
#Male
SELECT ethnicities.ethnicity, SUM(updated_cs_enrollments.cs_enrollment)/55.44 AS `% enrolled in CS`
FROM ethnicities
INNER JOIN updated_cs_enrollments ON ethnicities.ethnicity_id = updated_cs_enrollments.ethnicity_id
WHERE gender_id = 1
GROUP BY ethnicities.ethnicity;

#Female
SELECT ethnicities.ethnicity, SUM(updated_cs_enrollments.cs_enrollment)/30.05 AS `% enrolled in CS`
FROM ethnicities
INNER JOIN updated_cs_enrollments ON ethnicities.ethnicity_id = updated_cs_enrollments.ethnicity_id
WHERE gender_id = 2
GROUP BY ethnicities.ethnicity;


#Percentage of the Ethnicities that are Female
-- SELECT ethnicities.ethnicity, SUM(updated_cs_enrollments.cs_enrollment) AS `enrolled in CS`
-- FROM ethnicities
-- INNER JOIN updated_cs_enrollments ON ethnicities.ethnicity_id = updated_cs_enrollments.ethnicity_id
-- WHERE gender_id = 2
-- GROUP BY ethnicities.ethnicity;