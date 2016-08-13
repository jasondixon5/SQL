SELECT country, description, year, value 
FROM data LEFT JOIN countries ON countries.code = data.country_code LEFT JOIN indicators ON data.indicator_code = indicators.code
WHERE country_code='NPL' AND indicator_code='20070';

/*
20070, Enrolment in upper secondary education, both sexes (number)
20071, Enrolment in upper secondary education, female (number)
Enrolment in upper secondary education, male (Calculated)

SAP_3, Population of the official age for upper secondary education, both sexes (number)
SAP_3_F, Population of the official age for upper secondary education, female (number)
SAP_3_M, Population of the official age for upper secondary education, male (number)
*/

/* For each year, want to see enrollment in upper secondary education / population of official age for secondary education
/*SELECT country, description, year, (value/(SELECT value FROM data WHERE ) 
FROM data LEFT JOIN countries ON countries.code = data.country_code LEFT JOIN indicators ON data.indicator_code = indicators.code
WHERE country_code='NPL' AND indicator_code='20070'
GROUP BY description;
*/
/* Write one query for the first indicator, write a second query for the second indicator; then join the two queries on country and year. Then select from that join tablea.value / tableb.value, year, country
*/

/* Find enrollment ratio for both sexes - enrollment divided by population */

SELECT a.country_code, a.year, a.value/b.value as high_school_enrollment_ratio_both_sexes FROM 

(SELECT value, year, country_code from data WHERE indicator_code="20070") as a
INNER JOIN
(SELECT value, year, country_code from data WHERE indicator_code="SAP_3") as b
ON
a.year = b.year AND a.country_code = b.country_code;

SELECT a.country_code, a.year, a.value/b.value as high_school_enrollment_ratio_female FROM 

(SELECT value, year, country_code from data WHERE indicator_code="20071") as a
INNER JOIN
(SELECT value, year, country_code from data WHERE indicator_code="SAP_3_F") as b
ON
a.year = b.year AND a.country_code = b.country_code;

/* 
Calculate male value for high-school enrollment and divide it by male population to obtain the male high-school enrollment ratio
*/


SELECT a.country_code, a.year, ((a.value - b.value)/c.value) as high_school_enrollment_ratio_male
FROM

(SELECT value, year, country_code FROM data WHERE indicator_code="20070") as a
INNER JOIN
(SELECT value, year, country_code FROM data WHERE indicator_code="20071") as b
INNER JOIN
(SELECT value, year, country_code FROM data WHERE indicator_code="SAP_3_M") as c
ON
a.year = b.year AND a.country_code = b.country_code AND b.year=c.year AND b.country_code = c.country_code;


SELECT a.country_code, a.year, b.value/a.value as proportion_high_school_enrollment_female
FROM

(SELECT value, year, country_code FROM data WHERE indicator_code="20070") as a
INNER JOIN 
(SELECT value, year, country_code FROM data WHERE indicator_code="20071") as b
ON
a.year = b.year AND a.country_code = b.country_code;

SELECT a.country_code, a.year, ((a.value-b.value)/a.value) as proportion_high_school_enrollment_male
FROM

(SELECT value, year, country_code FROM data WHERE indicator_code="20070") as a
INNER JOIN 
(SELECT value, year, country_code FROM data WHERE indicator_code="20071") as b
ON
a.year = b.year AND a.country_code = b.country_code;

SELECT a.country_code, a.year, b.value/a.value as proportion_high_school_public_enrollment_both_sexes

FROM
(SELECT value, year, country_code FROM data WHERE indicator_code="20070") as a
INNER JOIN
(SELECT value, year, country_code FROM data WHERE indicator_code="20010") as b
ON
a.year = b.year AND a.country_code = b.country_code;

SELECT a.country_code, a.year, b.value/a.value as proportion_high_school_public_enrollment_female
FROM
(SELECT value, year, country_code FROM data WHERE indicator_code="20010") as a
INNER JOIN
(SELECT value, year, country_code FROM data WHERE indicator_code="20011") as b
ON
a.year = b.year AND a.country_code = b.country_code;

SELECT a.country_code, a.year, ((a.value - b.value)/a.value) as proportion_high_school_public_enrollment_male
FROM
(SELECT country_code, year, value FROM data WHERE indicator_code='20010') as a
INNER JOIN
(SELECT country_code, year, value FROM data WHERE indicator_code='20011') as b
ON
a.country_code = b.country_code AND a.year = b.year;

SELECT a.country_code, a.year, b.value/a.value as proportion_high_school_private_enrollment_both_sexes
FROM
(SELECT value, year, country_code FROM data WHERE indicator_code="20070") as a
INNER JOIN
(SELECT value, year, country_code FROM data WHERE indicator_code="20040") as b
ON
a.year = b.year AND a.country_code = b.country_code;

SELECT a.country_code, a.year, b.value/a.value as proportion_high_school_private_enrollment_female
FROM
(SELECT value, year, country_code FROM data WHERE indicator_code="20040") as a
INNER JOIN
(SELECT value, year, country_code FROM data WHERE indicator_code="20041") as b
ON
a.year = b.year AND a.country_code = b.country_code;

SELECT a.country_code, a.year, ((a.value-b.value)/a.value) as proportion_high_school_private_enrollment_male
FROM
(SELECT country_code, year, value FROM data WHERE indicator_code='20040') as a
INNER JOIN
(SELECT country_code, year, value FROM data WHERE indicator_code='20041') as b
ON
a.country_code = b.country_code AND a.year = b.year;

/*
PRP_5T8	Percentage of enrolment in tertiary education in private institutions (%)
*/
SELECT country_code, year, value FROM data WHERE indicator_code='PRP_5T8';

/*
25053	Enrolment in tertiary education, all programmes, both sexes (number)
25057	Enrolment in tertiary education, all programmes, female (number)
*/
SELECT a.country_code, a.year, b.value/a.value as proportion_college_enrollment_female
FROM
(SELECT country_code, year, value FROM data WHERE indicator_code='25053') as a
INNER JOIN
(SELECT country_code, year, value FROM data WHERE indicator_code='25057') as b
ON
a.country_code = b.country_code AND a.year = b.year;

SELECT a.country_code, a.year, ((a.value - b.value)/a.value) as proportion_college_enrollment_male
FROM
(SELECT country_code, year, value FROM data WHERE indicator_code='25053') as a
INNER JOIN
(SELECT country_code, year, value FROM data WHERE indicator_code='25057') as b
ON
a.country_code = b.country_code AND a.year = b.year;

/*
FOSEP_5T8_F140	Percentage of students in tertiary education enrolled in Education programmes, both sexes (%)
FOSEP_5T8_F140
FOSEP_5T8_F140_F
FOSEP_5T8_F140_M
*/

SELECT country_code, year, value FROM data WHERE indicator_code='FOSEP_5T8_F140';

SELECT a.country_code, a.year, a.value as college_major_EDUC_both_sexes, b.value as college_major_EDUC_female, c.value as college_major_EDUC_male FROM 

(SELECT country_code, year, value FROM data WHERE indicator_code='FOSEP_5T8_F140') as a
INNER JOIN
(SELECT country_code, year, value FROM data WHERE indicator_code='FOSEP_5T8_F140_F') as b
INNER JOIN
(SELECT country_code, year, value FROM data WHERE indicator_code='FOSEP_5T8_F140_M') as c
ON
a.country_code = b.country_code AND b.country_code = c.country_code AND a.year = b.year AND b.year = c.year;

/* TEST ONLY, NOT FOR PRODUCTION - test of LEFT JOIN with this data set
Displays result row for each year that the indicator_code supplied has a value populated. 

SELECT country_code, year, indicator_code, description FROM data
LEFT JOIN
indicators
ON indicators.code = data.indicator_code
WHERE indicator_code = 'FOSEP_5T8_F140';
*/

/*NOTE: The issue with the LEFT OUTER JOIN was that the ON condition needs to be coded immediately after each JOIN statement.
*/

CREATE OR REPLACE VIEW educ_majors AS SELECT country_code, year, value FROM data WHERE indicator_code='FOSEP_5T8_F140';

CREATE OR REPLACE VIEW educ_majors_female AS SELECT country_code, year, value FROM data WHERE indicator_code='FOSEP_5T8_F140_F';

CREATE OR REPLACE VIEW educ_majors_male AS SELECT country_code, year, value FROM data WHERE indicator_code='FOSEP_5T8_F140_M';

SELECT a.country_code, a.year, a.value as college_major_EDUC_both_sexes, b.value as college_major_EDUC_female, c.value as college_major_EDUC_male FROM 

educ_majors as a
LEFT OUTER JOIN

educ_majors_female as b
ON
a.country_code = b.country_code AND a.year = b.year
LEFT OUTER JOIN

educ_majors_male as c
ON
b.country_code = c.country_code AND b.year = c.year

ORDER BY country_code DESC, year;
