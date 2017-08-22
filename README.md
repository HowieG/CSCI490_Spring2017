# CSCI490_Spring2017
Research project to determine influence of income and ethnicity in high schools that offer Computer Science. Done as part of CSCI 490: Directed Research

Data: California school data such as course availability, course enrollment, income estimators, ethnicity, etc. which we reduce down to relevant tables. [For now Data is empty because the files exceed GitHub's 100 MB/file limit!]

Python: initial data-gathering involved web crawling/scraping in Python

R: R scripts that filter out irrelevant data, create local tables and fill database tables

Resources: Relevant reading, e.g. how data was collected, reports, etc.

Screenshots: Relevant information which we may come back to.

Data sourced from: http://www.cde.ca.gov/ds/sd/df/filesassign.asp


---------------------------------------- USAGE ----------------------------------------

*Run schoolInfoTable.R, then database_filler2.R*

There are some renamed/updated R scripts that I am keeping to avoid breaking anything.

<Ignore this file> -> <Use this file>

get_FRPM.R -> get_FRPM2.R
get_school_info.R -> get_CSCourseTable_forNewData.R
get_all_data.R -> schoolInfoTable.R
database_filler.R -> database_filler2.R

NOTE:
The data has minor inconsistencies from year to year (e.g. one random cell will be null)

TODO:
Replace setwd(...) file path with your local file path or find a more portable function