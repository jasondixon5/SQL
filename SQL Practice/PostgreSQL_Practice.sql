/* Exercises from the website:
https://pgexercises.com/questions/
*/

/* How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.*/

--Original Answer
SELECT starttime as start, name FROM cd.facilities as fac
LEFT JOIN
cd.bookings
ON fac.facid = cd.bookings.facid
WHERE name LIKE 'Tennis%' AND starttime > '2012-09-21' AND starttime < '2012-09-22'
ORDER BY start;

--Second fresh attempt
--Note that facid's for Tennis Courts are 0 and 1

select starttime as start, name
FROM cd.bookings
INNER JOIN cd.facilities fac
ON bookings.facid = fac.facid
WHERE 
fac.facid IN (0, 1) AND 
bookings.starttime >= '2012-09-21' AND 
bookings.starttime < '2012-09-22'
ORDER BY starttime;

/*How can you output a list of all members who have recommended another member? Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).*/

--Original answer
SELECT DISTINCT a.firstname as firstname, a.surname as surname FROM cd.members as a
INNER JOIN
cd.members as b
ON b.recommendedby = a.memid
ORDER BY a.surname, a.firstname;

--Second fresh attempt
SELECT DISTINCT m1.firstname, m1.surname FROM cd.members m1
INNER JOIN cd.members m2
ON m1.memid = m2.recommendedby
ORDER BY m1.surname, m1.firstname

/*How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).*/

--Original answer
SELECT a.firstname as memfname, a.surname as memsname,
b.firstname as recfname, b.surname as recsname
FROM cd.members as a
LEFT OUTER JOIN cd.members as b
ON
a.recommendedby = b.memid
ORDER BY a.surname, a.firstname;

--Second answer
SELECT m1.firstname, m1.surname, m2.firstname rec_firstname, m2.surname rec_surname
FROM cd.members m1
LEFT JOIN cd.members m2
ON m1.recommendedby = m2.memid
ORDER BY m1.surname, m1.firstname;

/*How can you produce a list of all members who have used a tennis court? Include in your output the name of the court, and the name of the member formatted as a single column. Ensure no duplicate data, and order by the member name.*/

--Original answer
SELECT DISTINCT concat_ws(' ',firstname, surname) as member, cd.facilities.name as facility
FROM cd.bookings
LEFT OUTER JOIN cd.members ON cd.bookings.memid = cd.members.memid
LEFT OUTER JOIN cd.facilities ON cd.bookings.facid = cd.facilities.facid
WHERE cd.facilities.name LIKE 'Tennis%'
ORDER BY member, cd.facilities.name DESC;


--Second answer
SELECT DISTINCT CONCAT_WS(' ',m.firstname, m.surname) member, f.name facility
FROM cd.bookings b
LEFT JOIN cd.members m
ON b.memid = m.memid
JOIN cd.facilities f
ON b.facid = f.facid
WHERE b.facid IN (0, 1)
ORDER BY member;

/*How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user is always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. Order by descending cost, and do not use any subqueries.*/

--First exercise that I hadn't already answered
SELECT CONCAT_WS(' ',m.firstname, m.surname) member_name, f.name facility,
	CASE 
	WHEN b.memid = 0 THEN f.guestcost * b.slots
	ELSE f.membercost * b.slots
	END AS cost
FROM cd.bookings b
LEFT JOIN cd.members m 
ON b.memid = m.memid
LEFT JOIN cd.facilities f
ON b.facid = f.facid
WHERE 
	b.starttime >= '2012-09-14' AND
	b.starttime < '2012-09-15' AND
	((m.memid = 0 AND b.slots * f.guestcost > 30) OR
	(m.memid != 0 AND b.slots * f.membercost > 30))
ORDER BY cost DESC;

/*How can you output a list of all members, including the individual who recommended them (if any), without using any joins? Ensure that there are no duplicates in the list, and that each firstname + surname pairing is formatted as a column and ordered.*/

SELECT DISTINCT CONCAT_WS(' ',m.firstname, m.surname) member_name, 
(SELECT CONCAT_WS(' ',r.firstname, r.surname) 
	FROM cd.members r
	WHERE m.recommendedby = r.memid) recommended_by
FROM cd.members m
ORDER BY member_name;

/* The Produce a list of costly bookings exercise contained some messy logic: we had to calculate the booking cost in both the WHERE clause and the CASE statement. Try to simplify this calculation using subqueries. For reference, the question was:

How can you produce a list of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30? Remember that guests have different costs to members (the listed costs are per half-hour 'slot'), and the guest user is always ID 0. Include in your output the name of the facility, the name of the member formatted as a single column, and the cost. Order by descending cost. */

--Looked at answer/help
SELECT member_name, facility_name, cost
FROM 
(SELECT CONCAT_WS(' ',m.firstname, m.surname) member_name, f.name facility_name,
	CASE 
	WHEN b.memid = 0 THEN f.guestcost * b.slots
	ELSE f.membercost * b.slots
	END AS cost
FROM cd.bookings b
LEFT JOIN cd.members m 
ON b.memid = m.memid
LEFT JOIN cd.facilities f
ON b.facid = f.facid
WHERE 
	b.starttime >= '2012-09-14' AND
	b.starttime < '2012-09-15'
) t1
WHERE cost > 30 
ORDER BY cost DESC;

--Begin exercise set on aggregates

/*For our first foray into aggregates, we're going to stick to something simple. We want to know how many facilities exist - simply produce a total count.*/

SELECT COUNT(facilities.facid) FROM cd.facilities;

/*Produce a count of the number of facilities that have a cost to guests of 10 or more.*/
SELECT COUNT(facilities.facid) FROM cd.facilities
WHERE guestcost > 10;

/*Produce a count of the number of recommendations each member has made. Order by member ID.*/

SELECT  recommendedby, count(surname) FROM cd.members
WHERE recommendedby NOTNULL
GROUP BY recommendedby
ORDER BY recommendedby;

/*Produce a list of the total number of slots booked per facility. For now, just produce an output table consisting of facility id and slots, sorted by facility id.*/

SELECT facid, sum(slots) FROM cd.bookings
GROUP BY facid
ORDER BY facid
;

/*Produce a list of the total number of slots booked per facility in the month of September 2012. Produce an output table consisting of facility id and slots, sorted by the number of slots. */

SELECT facid, sum(slots) as total_slots FROM cd.bookings
WHERE starttime >='2012-09-01' AND
starttime < '2012-10-01'
GROUP BY facid
ORDER BY sum(slots)
;

