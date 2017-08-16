SELECT * FROM CSCI490.school_info;

SELECT
   CASE
     WHEN FRPM_eligible_percent > 0.8 THEN '80-100% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.6 AND 0.8 THEN '60-80% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.4 AND 0.6 THEN '40-60% FRPM-eligible'
     WHEN FRPM_eligible_percent BETWEEN 0.2 AND 0.4 THEN '20-40% FRPM-eligible'
     ELSE '0-20% FRPM-eligible'
   END AS 'income_brackets',
   COUNT(*) AS num_schools
FROM school_info
GROUP BY income_brackets;