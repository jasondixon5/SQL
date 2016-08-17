/*opsResultsQueries.sql*/
/*Tested practice queries using QAResults database*/


SELECT sum(YES_MEETS)/sum(OPPORTUNITIES) as 'Success_Rate' FROM evaluations;

SELECT (1-sum(DEFECTS)/sum(OPPORTUNITIES)) as 'Success_Rate' FROM evaluations;

SELECT program, count(program) from evaluations GROUP BY program;

SELECT program, sum(DEFECTS)/sum(OPPORTUNITIES) as 'Defect_Rate' from evaluations GROUP BY program;

SELECT program, (1-sum(DEFECTS)/sum(OPPORTUNITIES)) as 'Success_Rate' from evaluations GROUP BY program;

SELECT program, count(DISTINCT (OBSERVATION_ID)) as 'observation_count', (1-sum(DEFECTS)/sum(OPPORTUNITIES)) as 'Success_Rate' from evaluations GROUP BY program;


SELECT OBSERVATION_ID from evaluations;

SELECT COUNT(OBSERVATION_ID) AS 'observation_count' from evaluations;

/* Dataset repeats row (including evaluation ID) for each behavior, so need unique eval ID to get count of actual evals */
SELECT COUNT(DISTINCT (OBSERVATION_ID)) AS 'observation_count' from evaluations;

SELECT CALL_REASON, COUNT(DISTINCT (OBSERVATION_ID)) as 'observation_count' from evaluations WHERE program = 'OS' GROUP BY CALL_REASON; 

/*
SELECT CALL_REASON, COUNT(DISTINCT (OBSERVATION_ID)) as 'observation_count', sum(DEFECTS)/sum(OPPORTUNITIES) as 'Defect_Rate' from evaluations WHERE program = 'OS' GROUP BY CALL_REASON ORDER BY CALL_REASON ASC; 
*/
/* THE ABOVE ORDER BY IS NOT WORKING WHEN DO IT BY 'Defect_Rate' OR BY CALL_REASON.*/

SELECT CALL_REASON, COUNT(DISTINCT (OBSERVATION_ID)) AS 'Observation_Count', 
SUM(defects)/SUM(opportunities) AS 'Defect_Rate' 
from evaluations 
GROUP BY call_reason;

SELECT e.CALL_REASON, COUNT(DISTINCT (e.OBSERVATION_ID)) AS 'Observation_Count', 
SUM(e.defects)/sum(e.opportunities) as 'Defect_Rate' 
from evaluations as e GROUP BY e.call_reason;

SELECT e.CALL_REASON, p.program_name, 
COUNT(DISTINCT (e.OBSERVATION_ID)) AS 'Observation_Count', 
SUM(e.defects)/sum(e.opportunities) as 'Defect_Rate' from 
evaluations as e 
INNER JOIN programs as p
ON
e.program = p.program
GROUP BY e.call_reason, p.program_name;

SELECT agency_name, supervisor_name, SUM(defects)/SUM(opportunities) AS 'Defect_Rate'
FROM evaluations
WHERE program = 'OS'
GROUP BY agency_name, supervisor_name;

SELECT agency_name, COUNT(DISTINCT (observation_ID)) AS 'Observation_Count' from evaluations
WHERE program = 'OS'
GROUP BY agency_name;

SELECT agency_name, COUNT(DISTINCT (supervisor_name)) as 'Supervisor_Count' 
FROM evaluations
GROUP BY agency_name;

SELECT agency_name, COUNT(DISTINCT (agent_name)) as 'Agent_Count' 
FROM evaluations
GROUP BY agency_name;

SELECT agency_name, count(distinct agent_name), count(distinct supervisor_name), count(distinct agent_name)/count(distinct supervisor_name) as 'Average_Agents_Per_Supervisor'
FROM evaluations
GROUP BY agency_name;

SELECT agency_name, program, count(distinct agent_name), count(distinct supervisor_name), count(distinct agent_name)/count(distinct supervisor_name) as 'Average_Agents_Per_Supervisor'
FROM evaluations
GROUP BY agency_name, program;

SELECT agency_name, supervisor_name, (SUM(defects)/SUM(opportunities)) AS 'Defect_Rate'
FROM evaluations
WHERE program = 'OS'
GROUP BY agency_name, supervisor_name
ORDER BY (SUM(defects)/SUM(opportunities)) DESC;

SELECT agency_name, supervisor_name, (SUM(defects)/SUM(opportunities)) AS 'Defect_Rate', count(distinct agent_name)/count(distinct supervisor_name) as 'Average_Agents_Per_Supervisor'
FROM evaluations
WHERE program = 'OS'
GROUP BY agency_name, supervisor_name
ORDER BY (SUM(defects)/SUM(opportunities)) DESC;

SELECT agency_name, supervisor_name, avg(agent_tenure_days_calls) as 'Average_Agent_Tenure'
FROM evaluations
WHERE program = 'OS'
GROUP BY agency_name, supervisor_name;

SELECT agency_name, supervisor_name, (SUM(defects)/SUM(opportunities)) AS 'Defect_Rate', count(distinct agent_name)/count(distinct supervisor_name) as 'Average_Agents_Per_Supervisor', avg(agent_tenure_days_calls) as 'Average_Agent_Tenure_On_Phone'
FROM evaluations
WHERE program = 'OS'
GROUP BY agency_name, supervisor_name
ORDER BY agency_name, (SUM(defects)/SUM(opportunities)) DESC;

/*
Note: To use alias in order-by clause, have to remove quotes in order for it to sort.
Cf. http://stackoverflow.com/questions/3360169/order-by-not-working-in-mysql-5-1
*/

SELECT agency_name, supervisor_name, (SUM(defects)/SUM(opportunities)) AS 'Defect_Rate', 
count(distinct agent_name)/count(distinct supervisor_name) as 'Average_Agents_Per_Supervisor', 
avg(agent_tenure_days_calls) as 'Average_Agent_Tenure_On_Phone'
FROM evaluations
WHERE program = 'OS'
GROUP BY agency_name, supervisor_name
ORDER BY agency_name, Defect_Rate DESC;

SELECT agency_name, supervisor_name, (SUM(defects)/SUM(opportunities)) AS 'Defect_Rate', 
count(distinct agent_name)/count(distinct supervisor_name) as 'Average_Agents_Per_Supervisor', 
avg(agent_tenure_days_calls) as 'Average_Agent_Tenure_On_Phone'
FROM evaluations
WHERE program = 'OS'
GROUP BY agency_name, supervisor_name
ORDER BY agency_name, (SUM(defects)/SUM(opportunities)) DESC;

SELECT AGENCY_NAME, SUPERVISOR_NAME, SUM(DEFECTS)/SUM(OPPORTUNITIES)
FROM evaluations
WHERE PROGRAM = 'OS'
GROUP BY AGENCY_NAME, SUPERVISOR_NAME
ORDER BY AGENCY_NAME, SUM(DEFECTS)/SUM(OPPORTUNITIES) DESC;

SELECT * FROM 
(SELECT AGENCY_NAME, SUPERVISOR_NAME, SUM(DEFECTS)/SUM(OPPORTUNITIES)
FROM evaluations
WHERE PROGRAM = 'OS'
GROUP BY AGENCY_NAME, SUPERVISOR_NAME
ORDER BY AGENCY_NAME, SUM(DEFECTS)/SUM(OPPORTUNITIES) DESC) AS a
LIMIT 5;

(SELECT AGENCY_NAME, SUPERVISOR_NAME, SUM(DEFECTS)/SUM(OPPORTUNITIES)
FROM evaluations
WHERE PROGRAM = 'OS' AND AGENCY_NAME = 'CGS Romania'
GROUP BY AGENCY_NAME, SUPERVISOR_NAME
ORDER BY SUM(DEFECTS)/SUM(OPPORTUNITIES) DESC
LIMIT 5)

UNION ALL

(SELECT AGENCY_NAME, SUPERVISOR_NAME, SUM(DEFECTS)/SUM(OPPORTUNITIES)
FROM evaluations
WHERE PROGRAM = 'OS' AND AGENCY_NAME = 'CGS Tampa'
GROUP BY AGENCY_NAME, SUPERVISOR_NAME
ORDER BY SUM(DEFECTS)/SUM(OPPORTUNITIES) DESC
LIMIT 5)

UNION ALL

(SELECT AGENCY_NAME, SUPERVISOR_NAME, SUM(DEFECTS)/SUM(OPPORTUNITIES)
FROM evaluations
WHERE PROGRAM = 'OS' AND AGENCY_NAME = 'Convergys Phoenix'
GROUP BY AGENCY_NAME, SUPERVISOR_NAME
ORDER BY SUM(DEFECTS)/SUM(OPPORTUNITIES) DESC
LIMIT 5)
;

SELECT AGENCY_NAME, SUPERVISOR_NAME, SUM(DEFECTS)/SUM(OPPORTUNITIES)
FROM evaluations
WHERE PROGRAM = 'OS' AND AGENCY_NAME = 'CGS Romania'
GROUP BY SUPERVISOR_NAME
HAVING SUM(DEFECTS)/SUM(OPPORTUNITIES) > .17;
/* Required to use "having" instead of "where" here; having happens after the aggregation.
The aggregation is done, then the 'having' clause filters out what you need from those aggregated values.
Note that the 'having' clause has to be after any 'group by' clause.
*/
