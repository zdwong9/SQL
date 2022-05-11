#a)	Add a student with SID = 65798 and SNAME = 'Lopez' into STUDENT table.
insert into student values (65798, 'Lopez');

#b)Remove student with SID = 65798  
# from the STUDENT table.
delete from student where sid = 65798;

#c)Change the name of the faculty with FID = 4756 from 
#'Coke' to 'Collin'. 
update faculty set fname = 'Collin' where fid = 4756;

#d)Return ANAME of assessments with WEIGHT>0.3.
select aname from assessment where weight>0.3;

#e)Return SID and SNAME of students having SID less than 50000 
select SID, SNAME from student where sid < 50000;

#OR
select * from student where sid < 50000;

#f)Return FNAME of the faculty member whose FID is 4756
select fname from faculty where fid = 4756;

#g)Find the faculty members who have qualified to teach certain 
#course(s) since year 1993 inclusive. List FID, CID and DATE_QUALIFIED. 
select fid, cid, date_qualified from qualification
where extract(year from date_qualified) >= 1993;

#or
select fid, cid, date_qualified from qualification
where year(date_qualified) >= 1993;

#or
select fid, cid, date_qualified from qualification
where date_qualified >= '1993-01-01';

#h)Return FNAME of all the faculty members with name 
#containing the character ‘a’ (hint: use wildcard ‘%’).
select fname from faculty where fname like '%a%';

#i)Display CID and CNAME for all courses with an ‘ISM’ prefix 
#in the CID (hint: use wildcard ‘%’).
select cid, cname from course
where cid like 'ism%';

#j)Display the lowest assessment mark of student having SID =54907  (hint: use function MIN()).
select min(mark) from performance where sid=54907;

#k)Return the number of students who are enrolled in course 
#‘ISM 4212’ in the semester ‘I-2001’ (hint: use function count())  
select count(*) from registration 
where cid = 'ISM 4212' and semester = 'I-2001';

#l)Return the total number of students who registered in semester 
#I-2001 (hint: use function count(distinct sid) to get the student number).
select count(distinct sid) as TotalNumber from registration
where semester='I-2001';

#m)List FID of those faculty members who are qualified to 
#teach either ISM 3112 or ISM 3113 with the corresponding 
#qualified date falling in the month September. List CID, DATE_QUALIFIED as well (hint: use function extract(month from date_qualified) to get the month).
select fid, cid, date_qualified from qualification 
where (cid = 'ISM 3112' or cid ='ISM 3113') and extract(month from date_qualified)=9;

#alternatively, using 'in' instead of 'or'
select fid, cid, date_qualified from qualification 
where cid in ('ISM 3112', 'ISM 3113') and extract(month from date_qualified)=9;

#another solution
select * from qualification where month(date_qualified) = 9 and cid in ('ISM 3112', 'ISM 3113');


#n)Display CID of the courses offered in the semester I-2001 
#List each course only once (hint: use ‘distinct’ to avoid duplication).
select distinct CID from registration where semester = 'I-2001';

#o)List SID and SNAME of all students in alphabetical order by SNAME. 
select * from student order by sname;

#OR
select * from student order by sname asc;

#p)For each student in PERFORMANCE table, return SID and the best performance in an assessment 
#(that means the highest mark in any assessment).
select sid, max(mark) as 'Best Performance' from performance 
group by sid; 


#q)For each type in ROOM table, return TYPE and the total number of rooms belonging to that type.
select type, count(*) from room group by type; 

#r)For each course in QUALIFICATION table, return CID of the course and the number of faculty 
# members who are qualified to teach the course.
select cid, count(*) from qualification group by cid; 

#s)For each student in REGISTRATION table, return SID of the 
#student and the number of courses that student registers.
select sid, count(*) as NumberOfCourses from registration
group by sid;

#t)For each assessment corresponding to course with CID = ‘ISM 4212’ in PERFORMANCE table, 
#return AID, the minimal mark, the maximal mark, and the average mark.
select aid, min(mark), max(mark), avg(mark) from performance 
where cid = 'ISM 4212' group by aid; 

#u)For each course in PERFORMANCE table, return AID of each assessment of that course, 
#together with the minimal mark, the maximal mark, and the average mark.
select cid, aid, min(mark), max(mark), avg(mark) from performance group by cid, aid;


#v)For each course in PERFORMANCE table with CID different from ‘ISM 4212’, return CID of that course, AID of 
#each assessment of that course, together with the minimal mark, the maximal mark, and the average mark.
select cid, aid, min(mark), max(mark), avg(mark)
from performance
where cid <> 'ISM 4212'
group by cid, aid; 

#or
select cid, aid, min(mark), max(mark), avg(mark)
from performance
group by cid, aid
having cid!='ISM 4212';


#w)Display CID of the course as well as the total number of 
#qualified teaching faculty members for all the courses that can 
#be taught by at least two faculty members.
select cid, count(*) as QualifiedFacultyCount 
from qualification
group by cid
having QualifiedFacultyCount>=2;

