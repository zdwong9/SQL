#a)For each student registered in Semester 'I-2001', list the SID, sname of 
#the student, and the CID of the corresponding course.
select s.sid, sname, cid
from student s, registration r
where s.sid = r.sid and semester = 'I-2001';

#or
select s.sid, sname , cid from student s inner join registration r
on s.sid = r.sid 
where semester = 'I-2001';


#b)Return the FID, FNAME of all the faculty members who were qualified 
#to teach course in year 1995.
select distinct fid, fname from faculty f, qualification q
where f.fid = q.fid and extract(year from date_qualified) = 1995;

#or 
select distinct f.fid, fname 
from faculty f inner join qualification q on f.fid = q.fid
where extract(year from date_qualified) = 1995;

#or
select distinct fid, fname from qualification q, faculty f where f.fid = q.fid and year(date_qualified) = 1995;


#c)Display CNAME and CID of all the courses for which Professor 
#Ama has been qualified. Display the results based on descending order of CID
select cname, q.cid from qualification q, faculty f, course c
where q.fid = f.fid and c.cid = q.cid and fname = 'Ama'
order by cid desc;

#or 
select cname, q.cid 
from qualification q inner join faculty f on q.fid = f.fid
inner join  course c on c.cid = q.cid
where fname = 'Ama'
order by cid desc;


#d)For each faculty in QUALIFICATION table, return the FID and 
# FNAME of the faculty. Display the results based on ascending order of FNAME.
select distinct f.fid, fname from faculty f, qualification q
where f.fid=q.fid
order by fname;

#or
select distinct f.fid, fname 
from faculty f inner join qualification q on f.fid=q.fid
order by fname;


# e)Return the SID of those students who are enrolled in 
#‘Syst Analysis’ during semester I-2001.
select sid from registration r, course c 
where r.cid=c.cid and semester = 'I-2001'
and cname = 'Syst Analysis';

#or
select sid from registration r inner join course c 
on r.cid=c.cid 
where semester = 'I-2001' and cname = 'Syst Analysis';


#f)Return the SID and SNAME of those students who are enrolled 
#into course ‘Syst Analysis’ during semester I-2001.
select s.sid, sname from student s, registration r, course c 
where r.cid=c.cid and s.sid=r.sid
and semester = 'I-2001' and cname = 'Syst Analysis';

#or
select s.sid, sname 
from registration r inner join course c on r.cid=c.cid
inner join student s on s.sid = r.sid 
where semester = 'I-2001' and cname = 'Syst Analysis';


#g)Return the CName and CID of all the courses those students 
#whose names start with character ‘a’ registered. Return the SNAME of the students as well. 
select cname, c.cid, s.sname from course c, student s, registration r
where c.cid = r.cid and r.sid = s.sid
and sname like 'A%';

#or
select cname, c.cid , s.sname
from course c inner join registration r on c.cid = r.cid
inner join student s on r.sid = s.sid
where sname like 'A%';


#h)Return the SID and SNAME of those students who are enrolled 
#into at least one course that professor Berry can teach.
select distinct s.sid, sname 
from student s, faculty f, qualification q, registration r
where s.sid = r.sid  and f.fid = q.fid 
and q.cid = r.cid
and fname = 'Berry';

#or
select distinct s.sid, sname
from student s inner join registration r on s.sid=r.sid
inner join qualification q on q.cid = r.cid
inner join faculty f on f.fid = q.fid
where fname = 'Berry';

#or
select distinct s.sid, sname
from student s inner join registration r on s.sid=r.sid
inner join course c on c.cid = r.cid 
inner join qualification q on q.cid = r.cid
inner join faculty f on f.fid = q.fid and fname = 'Berry';


#i)Return the FID and FNAME for all the faculty in FACULTY table. 
#If a faculty can teach, return the CID of all the courses he/she 
#can teach as well.
select f.fid, fname, cid
from faculty f left outer join qualification q on f.fid = q.fid;


#j)Return the FID and FNAME for all the faculty in FACULTY table. 
#If a faculty can teach, return the CNAME of all the courses 
#he/she can teach as well.
select f.fid, fname, cname
from faculty f left outer join qualification q on f.fid = q.fid
left outer join course c on c.cid = q.cid;


#k)Return the FID and FNAME for all the faculty in FACULTY table. 
#If a faculty can teach, return the number of courses he/she can teach.
select f.fid, fname, count(distinct cid) as CoursesCanTeach
from faculty f left outer join qualification q on f.fid = q.fid
group by f.fid, fname;

#or
select f.fid, fname, count(distinct cid)
from qualification q right outer join faculty f  on f.fid = q.fid
group by f.fid, fname;


#l)Return the SID and SNAME of all the students in STUDENT table. 
#In addition, display the total number of courses each student 
#registers in semester I-2002 as well and ZERO is expected for those who do not registered any course in semester I-2002.
select s.sid, sname, count(distinct cid) as CoursesTaken
from student s left outer join registration r 
on r.sid=s.sid and semester = 'I-2002'
group by s.sid, sname;

#or
select s.sid, sname, count(distinct cid)
from registration r right outer join student s 
on r.sid=s.sid and semester = 'I-2002'
group by s.sid, sname;


#m) Return the CID and CNAME of all the courses in COURSE table.
#In addition, display the number of students registered during semester 
#I-2002 per course as well.
select c.cid, cname, count(sid) StudentsCount
from course c left outer join registration r
on c.cid = r.cid and semester = 'I-2002'
group by c.cid, cname;

#or
select c.cid, cname, count(sid) as StudentsCount
from  registration r right outer join course c
on c.cid = r.cid and semester = 'I-2002'
group by c.cid, cname;


#n)	Find all the pairs of student and faculty with same name. 
#The result is in the format of (SID, FID, NAME).
select sid, fid, sname
from student s, faculty f
where s.sname = f.fname;

#or
select sid, fid, sname
from student s inner join faculty f on s.sname = f.fname;


#o)Find all the pairs of student and faculty with different names.
#The result is in the format of (SID, SNAME, FID, FNAME). 
select sid, sname, fid, fname
from student s, faculty f
where s.sname <> f.fname;

#or
select sid, sname, fid, fname
from student s inner join faculty f on s.sname <> f.fname;


#p)Based on the content of PERFORMANCE table, show the final 
#mark per student per course. The result is in the format of 
#(CID, SID, FINALMARK). The FINALMARK is the accumulated 
#mark of student’s performance on various assessments.  
select cid, sid, sum(weight*mark)
from assessment a, performance p
where a.aid = p.aid 
group by cid, sid;


#q)Return the SID of students who are enrolled in BOTH 'Database' AND 'Networking'.
select sid from  registration r, course c
where c.cid = r.cid
and cname in ('Database', 'Networking')
group by sid 
having count(distinct c.cid) = 2;

#or
select sid 
from registration r inner join course c on c.cid = r.cid
where cname in ('Database', 'Networking')
group by sid 
having count(distinct c.cid) = 2;


#r)Return the FID of faculty who can teach either 'Syst Analysis'
#OR 'Syst Design', but not both.
select fid from course c, qualification q
where c.cid = q.cid
and cname in ('Syst Analysis', 'Syst Design')
group by fid
having count(distinct cname) = 1;

#or
select fid 
from qualification q inner join course c on  c.cid = q.cid 
and cname in ('Syst Analysis', 'Syst Design')
group by fid
having count(distinct cname) = 1;


#s)Find all the pair of faculty members who can teach the same 
#course. The output is in (FID1, FID2, CNAME) format and there should not be any duplication.
select q1.fid, q2.fid, cname
from qualification q1, qualification q2, course c
where q1.cid = q2.cid and q1.cid = c.cid
and q1.fid < q2.fid;

#or
select q1.fid, q2.fid, cname
from qualification q1 inner join qualification q2 on q1.cid = q2.cid and q1.fid < q2.fid
inner join course c on q1.cid = c.cid;


#t)Find the pair of rooms with same type and same capacity. The 
#output is in the format of (RID1, RID2, TYPE, CAPACITY) format 
#and there should not be any duplication.
select r1.rid, r2.rid, r1.type, r1.capacity
from room r1, room r2
where r1.rid < r2.rid and r1.capacity = r2.capacity
and r1.type = r2.type;

#or
select r1.rid, r2.rid, r1.type, r1.capacity
from room r1 inner join room r2
on r1.rid < r2.rid and r1.capacity = r2.capacity
and r1.type = r2.type;


#u)	Find the pair of students who register the same course in the 
#same semester. The output is in (SNAME1, SNAME2, CNAME, SEMESTER) 
#format and there should not be any duplication.
select s1.sname, s2.sname, cname, r1.semester
from student s1, student s2, registration r1, registration r2, course c
where s1.sid = r1.sid and s2.sid = r2.sid 
and r1.cid = r2.cid and r1.semester = r2.semester 
and r1.cid = c.cid and s1.sid < s2.sid;

#or 
select s1.sname, s2.sname, cname, r1.semester
from student s1 inner join registration r1 on s1.sid = r1.sid
inner join registration r2 on r1.cid = r2.cid and r1.semester = r2.semester 
inner join student s2 on r2.sid = s2.sid and s1.sid < s2.sid
inner join course c on r1.cid = c.cid;