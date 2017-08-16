-- SELECT * FROM CSCI490.cs_enrollments;

-- CS enrollment by enthinicty for 2014-2015
-- SELECT ethnicities.ethnicity, SUM(`cs_enrollment`) AS `cs_enrollment`
-- FROM ethnicities
-- INNER JOIN cs_enrollments ON cs_enrollments.ethnicity_id=ethnicities.ethnicity_id
-- WHERE schoolyear_id = 27
-- GROUP BY ethnicities.ethnicity;

-- CS enrollment by enthinicty as a percentage from 2012-2015 (until we add in more years)
-- SELECT ethnicities.ethnicity, SUM(`cs_enrollment`) AS `cs_enrollment`
-- FROM ethnicities
-- INNER JOIN cs_enrollments ON cs_enrollments.ethnicity_id=ethnicities.ethnicity_id
-- GROUP BY ethnicities.ethnicity;

