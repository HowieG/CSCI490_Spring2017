SELECT * FROM CSCI490.all_school_info;

# Note: Total Enrollment overshoots the ethnicity/gender totals by 64,252 students
SELECT SUM(total_enrollment) FROM all_school_info;
#Total: 510127 enrolled students reported

###################################### Ethnicity ######################################
SELECT
SUM(NoEthRptd) AS NoEthRptd,
SUM(AmInd) AS AmInd,
SUM(Asian) AS Asian,
SUM(PacIsl) AS PacIsl,
SUM(Filipino) AS Filipino,
SUM(Hispanic) AS Hispanic,
SUM(AfrAm) AS AfrAm,
SUM(White) AS White,
SUM(TwoOrMore) AS TwoOrMore
FROM all_school_info;
#Total: 445875 students with reported ethnicities

#1.	What is the overall distribution of ethnicities in Los Angeles County schools?
#TODO: find a percentage function to avoid hardcoding
SELECT
SUM(NoEthRptd)/4458.75 AS NoEthRptd,
SUM(AmInd)/4458.75 AS AmInd,
SUM(Asian)/4458.75 AS Asian,
SUM(PacIsl)/4458.75 AS PacIsl,
SUM(Filipino)/4458.75 AS Filipino,
SUM(Hispanic)/4458.75 AS Hispanic,
SUM(AfrAm)/4458.75 AS AfrAm,
SUM(White)/4458.75 AS White,
SUM(TwoOrMore)/4458.75 AS TwoOrMore
FROM all_school_info;

#1.	What is the ethnicity distribution at every income tier in Los Angeles County?
#Raw
SELECT
   CASE
     WHEN FRPM_eligible_percent > 0.8 THEN '80-100% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.6 AND 0.8 THEN '60-80% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.4 AND 0.6 THEN '40-60% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.2 AND 0.4 THEN '20-40% FRPM-eligible'
     ELSE '0-20% FRPM-eligible'
   END AS 'income_brackets',
	SUM(NoEthRptd) AS NoEthRptd,
	SUM(AmInd) AS AmInd,
	SUM(Asian) AS Asian,
	SUM(PacIsl) AS PacIsl,
	SUM(Filipino) AS Filipino,
	SUM(Hispanic) AS Hispanic,
	SUM(AfrAm) AS AfrAm,
	SUM(White) AS White,
	SUM(TwoOrMore) AS TwoOrMore,
    SUM(NoEthRptd)+SUM(AmInd)+SUM(Asian)+SUM(PacIsl)+SUM(Filipino)
    +SUM(Hispanic)+SUM(AfrAm)+SUM(White)+SUM(TwoOrMore) AS Total_Students
FROM all_school_info
GROUP BY income_brackets;
#0-20: 44904
#20-40: 42415
#40-60: 88628
#60-80: 183
#80-100: 196

#TODO: Percentage
SELECT
   CASE
     WHEN FRPM_eligible_percent > 0.8 THEN '80-100% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.6 AND 0.8 THEN '60-80% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.4 AND 0.6 THEN '40-60% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.2 AND 0.4 THEN '20-40% FRPM-eligible'
     ELSE '0-20% FRPM-eligible'
   END AS 'income_brackets',
	SUM(NoEthRptd) AS NoEthRptd,
	SUM(AmInd) AS AmInd,
	SUM(Asian) AS Asian,
	SUM(PacIsl) AS PacIsl,
	SUM(Filipino) AS Filipino,
	SUM(Hispanic) AS Hispanic,
	SUM(AfrAm) AS AfrAm,
	SUM(White) AS White,
	SUM(TwoOrMore) AS TwoOrMore,
    SUM(NoEthRptd)+SUM(AmInd)+SUM(Asian)+SUM(PacIsl)+SUM(Filipino)
    +SUM(Hispanic)+SUM(AfrAm)+SUM(White)+SUM(TwoOrMore) AS Total_Students
FROM all_school_info
GROUP BY income_brackets;

-- SELECT last_name, salary, RATIO_TO_REPORT(salary) OVER () AS rr
--    FROM employees
--    WHERE job_id = 'PU_CLERK';

#1.	What is the distribution of ethnicities among schools that offer Computer Science (CS)?
SELECT
SUM(NoEthRptd) AS NoEthRptd,
SUM(AmInd) AS AmInd,
SUM(Asian) AS Asian,
SUM(PacIsl) AS PacIsl,
SUM(Filipino) AS Filipino,
SUM(Hispanic) AS Hispanic,
SUM(AfrAm) AS AfrAm,
SUM(White) AS White,
SUM(TwoOrMore) AS TwoOrMore
FROM all_school_info
WHERE school_id IN (SELECT school_id FROM updated_cs_enrollments);
#Total: 165159 students with reported ethnicities in schools that offer CS

#TODO: find a percentage function to avoid hardcoding
SELECT
SUM(NoEthRptd)/1651.59 AS NoEthRptd,
SUM(AmInd)/1651.59 AS AmInd,
SUM(Asian)/1651.59 AS Asian,
SUM(PacIsl)/1651.59 AS PacIsl,
SUM(Filipino)/1651.59 AS Filipino,
SUM(Hispanic)/1651.59 AS Hispanic,
SUM(AfrAm)/1651.59 AS AfrAm,
SUM(White)/1651.59 AS White,
SUM(TwoOrMore)/1651.59 AS TwoOrMore
FROM all_school_info
WHERE school_id IN (SELECT school_id FROM updated_cs_enrollments);

# What is the ethnicity distribution at every income tier for schools that offer CS?

#Raw
SELECT
   CASE
     WHEN FRPM_eligible_percent > 0.8 THEN '80-100% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.6 AND 0.8 THEN '60-80% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.4 AND 0.6 THEN '40-60% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.2 AND 0.4 THEN '20-40% FRPM-eligible'
     ELSE '0-20% FRPM-eligible'
   END AS 'income_brackets',
	SUM(NoEthRptd) AS NoEthRptd,
	SUM(AmInd) AS AmInd,
	SUM(Asian) AS Asian,
	SUM(PacIsl) AS PacIsl,
	SUM(Filipino) AS Filipino,
	SUM(Hispanic) AS Hispanic,
	SUM(AfrAm) AS AfrAm,
	SUM(White) AS White,
	SUM(TwoOrMore) AS TwoOrMore,
    SUM(NoEthRptd)+SUM(AmInd)+SUM(Asian)+SUM(PacIsl)+SUM(Filipino)
    +SUM(Hispanic)+SUM(AfrAm)+SUM(White)+SUM(TwoOrMore) AS Total_Students
FROM all_school_info
WHERE school_id IN (SELECT school_id FROM updated_cs_enrollments)
GROUP BY income_brackets;

#TODO: percentage

###################################### Income ######################################
#1.	What is the overall distribution of income in Los Angeles County schools?
#Raw
SELECT
   CASE
     WHEN FRPM_eligible_percent > 0.8 THEN '80-100% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.6 AND 0.8 THEN '60-80% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.4 AND 0.6 THEN '40-60% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.2 AND 0.4 THEN '20-40% FRPM-eligible'
     ELSE '0-20% FRPM-eligible'
   END AS 'income_brackets',
   COUNT(*) AS num_schools
FROM all_school_info
GROUP BY income_brackets;
#0-20: 32 schools
#20-40: 34 schools
#40-60: 91 schools
#60-80: 183 schools
#80-100: 196 schools

#Percentage
SELECT
   CASE
     WHEN FRPM_eligible_percent > 0.8 THEN '80-100% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.6 AND 0.8 THEN '60-80% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.4 AND 0.6 THEN '40-60% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.2 AND 0.4 THEN '20-40% FRPM-eligible'
     ELSE '0-20% FRPM-eligible'
   END AS 'income_brackets',
   COUNT(*)/5.36 AS num_schools
FROM all_school_info
GROUP BY income_brackets;

#How many schools are there where most of their students are FRPM-eligible?
SELECT COUNT(*) FROM all_school_info WHERE FRPM_eligible_percent > 0.5;
#437 schools
#81.5% of schools

#1.	What is the distribution of income among schools that offer Computer Science?
#Raw
SELECT
   CASE
     WHEN FRPM_eligible_percent > 0.8 THEN '80-100% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.6 AND 0.8 THEN '60-80% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.4 AND 0.6 THEN '40-60% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.2 AND 0.4 THEN '20-40% FRPM-eligible'
     ELSE '0-20% FRPM-eligible'
   END AS 'income_brackets',
   COUNT(*) AS num_schools
FROM all_school_info
WHERE school_id IN (SELECT school_id FROM updated_cs_enrollments)
GROUP BY income_brackets;
#93 schools that offer CS

#Percentage
SELECT
   CASE
     WHEN FRPM_eligible_percent > 0.8 THEN '80-100% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.6 AND 0.8 THEN '60-80% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.4 AND 0.6 THEN '40-60% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.2 AND 0.4 THEN '20-40% FRPM-eligible'
     ELSE '0-20% FRPM-eligible'
   END AS 'income_brackets',
   COUNT(*)/.93 AS num_schools
FROM all_school_info
WHERE school_id IN (SELECT school_id FROM updated_cs_enrollments)
GROUP BY income_brackets;

###################################### Gender ######################################
SELECT
SUM(M) AS Male,
SUM(F) AS Female
FROM all_school_info;
#Male: 229519
#Female: 216356
#Total: 445875 students with reported genders

#1.	What is the gender distribution of Los Angeles County?
SELECT
SUM(M)/4458.75 AS Male,
SUM(F)/4458.75 AS Female
FROM all_school_info;
#Male: 51.5%
#Female: 48.5%

#What is the gender distribution at every income tier in Los Angeles County?
#Raw
SELECT
   CASE
     WHEN FRPM_eligible_percent > 0.8 THEN '80-100% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.6 AND 0.8 THEN '60-80% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.4 AND 0.6 THEN '40-60% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.2 AND 0.4 THEN '20-40% FRPM-eligible'
     ELSE '0-20% FRPM-eligible'
   END AS 'income_brackets',
	SUM(M) AS Male,
	SUM(F) AS Female,
    SUM(M)+SUM(F) AS Total_Students
FROM all_school_info
GROUP BY income_brackets;

#TODO: Percentage

#1.	What is the gender distribution among schools that offer Computer Science (CS)?
#Raw
SELECT
SUM(M) AS Male,
SUM(F) AS Female
FROM all_school_info
WHERE school_id IN (SELECT school_id FROM updated_cs_enrollments);

#Percentage
SELECT
SUM(M)/1651.59 AS Male,
SUM(F)/1651.59 AS Female
FROM all_school_info
WHERE school_id IN (SELECT school_id FROM updated_cs_enrollments);

#1.	What is the gender distribution by ethnicity in Los Angeles County? 
#TODO:  Have to make a new table with a different structure in order to get this




