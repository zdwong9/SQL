#a)Return the SNAME of those students who are enrolled in ISM 3113
# during semester I-2001.
select sname from student 
where sid in 
	(select sid from registration where cid='ISM 3113' and semester='I-2001');

#or using join
select sname from student s, registration r
where s.sid = r.sid and cid='ISM 3113' and semester='I-2001';

#b)Display the FNAME and FID of those faculty members who are 
#qualified to teach at least two courses.
select fname, fid from faculty 
where fid in 
	(select fid from qualification group by fid
	 having count(distinct cid) >= 2);

#or using join
select fname, f.fid from faculty f, qualification q
where f.fid=q.fid 
group by fname, f.fid
having count(distinct cid)>=2;

#or using excluding 
#the second condition is necessary to make sure the returned fid can teach
select fname, fid from faculty 
where fid not in 
	(select fid from qualification group by fid
	 having count(distinct cid) < 2)
and fid in
	(select fid from qualification);


#c)List the FID and FNAME of the faculty members who are qualified to teach 
#at least two courses OR who are qualified to teach some 
#course after year 1990 (exclusive 1990).
select fid, fname from faculty 
where fid in 
	(select fid from qualification 
	 group by fid having count(distinct cid)>=2)
or fid in 
	(select fid from qualification 
	 where extract(year from date_qualified)>1990);

#d)Display the SID and SNAME of those students who take both 
#‘Database’ and ‘Networking’.
select sid, sname from student
where sid in (select sid from registration r, course c
			  where r.cid=c.cid and cname='Database')
and sid in (select sid from registration r, course c
			where r.cid=c.cid and cname='Networking');

#or
select sid, sname from student  where sid in 
	(select sid from registration r, course c
			where r.cid=c.cid and cname in ('Database', 'Networking') group by sid 
			having count(*) = 2
	);
			
#e)Return the SID, SNAME of students who have registered  for either 'Syst Analysis' 
#OR 'Syst Design'.
select sid, sname from student
where sid in (select sid from registration r, course c
			  where r.cid=c.cid and cname='Syst Analysis')
or sid in (select sid from registration r, course c
			where r.cid=c.cid and cname='Syst Design');

#solution 2
select sid, sname from student
where sid in
	(select sid from registration r, course c
	 where r.cid=c.cid and cname in ('Syst Analysis','Syst Design'));

#f)Return the SID, SNAME of students who have registered for either 'Syst Analysis' 
#OR 'Syst Design', but not both.
select sid, sname from student
where sid in #this subquery is to ensure the returned students do take at least one of 'Syst Analysis' and 'Syst Design'
	(select sid from registration r, course c
	 where r.cid=c.cid and cname in ('Syst Analysis','Syst Design'))
and sid not in #this subquery is to ensure the returned students do not take both courses
	(select sid from registration r, course c
     where r.cid=c.cid and cname in ('Syst Analysis','Syst Design')
	 group by sid having count(distinct r.cid)=2);

#g)Return the SNAME and SID of those students who have ONLY registered for 
#the course ‘Database’.
select sname, sid from student 
where sid in	#this subquery is to ensure the returned students take database
	(select sid from registration r, course c
     where c.cid = r.cid and cname = 'database')
and sid not in #this subquery is to ensure the returned students not among those taking non-database
	(select sid from registration r, course c
     where c.cid = r.cid and cname <> 'database');

#or
select sname, sid from student 
where sid in #this subquery is to ensure the returned students take database
	(select sid from registration r, course c
     where c.cid = r.cid and cname = 'database')
and sid in #this subquery is to ensure the returned students only take ONE course
	(select sid from registration group by sid having count(distinct cid)=1);

#h)Return the FID and FNAME of those faculty members who are ONLY 
#qualified to teach the course ‘Syst Design’.
select fid, fname from faculty 
where fid in #this subquery is to ensure the returned faculty members do teach 'Syst Design'
	(select fid from qualification q, course c
	 where q.cid=c.cid and cname='Syst Design')
and fid not in #this subquery is to ensure the returned faculty members are not among those who can teach something other than 'Syst Design'
	(select fid from qualification q, course c
	 where q.cid = c.cid and cname <> 'Syst Design');

#or 
select fid, fname from faculty 
where fid in #this subquery is to ensure the returned faculty members do teach 'Syst Design'
	(select fid from qualification q, course c
	 where q.cid=c.cid and cname='Syst Design')
and fid in #this subquery is to ensure the returned faculty members only teach one course
	(select fid from qualification group by fid having count(distinct cid)=1);

#i)Return the CID and CNAME of those courses ONLY student Bob has registered.
select cid, cname from course 
where cid in #this subquery is to ensure the returned courses are taken by Bob
	(select cid from registration r, student s 
	 where r.sid=s.sid and sname='Bob')
and cid not in #this subquery is to ensure the returned courses are not among those taked by students other than Bob
	(select cid from registration r, student s
     where r.sid=s.sid and sname<>'Bob');

#solution 2
select cid, cname from course 
where cid in #this subquery is to ensure the returned courses are taken by Bob
	(select cid from registration r, student s 
	 where r.sid=s.sid and sname='Bob')
and cid in #this subquery is to ensure the returned courses are only taken by one student
	(select cid from registration r group by cid having count(distinct sid)=1);

#j)Return the FID, FNAME of faculty who can teach ONLY 
#'Syst Analysis' AND  'Syst Design'.
select fid, fname from faculty 
where fid in #this subquery is to make sure the returned faculty members can teach both 'Syst Analysis' and 'Syst Design')
	(select fid from qualification q, course c 
	 where q.cid=c.cid and cname in('Syst Analysis', 'Syst Design')
     group by fid having count(distinct c.cid)=2)
and fid in #this subquery is to make sure the returned faculty members only teach two courses
	(select fid from qualification q, course c 
	 where q.cid=c.cid group by fid having count(distinct c.cid)=2);

#solution 2
select fid, fname from faculty
where fid in #this subquery is to ensure the returned faculty can teach 'Syst Design'
	(select fid from qualification q, course c
	 where q.cid=c.cid and cname='Syst Design')
and fid in #this subquery is to ensure the returned faculty can teach 'Syst Design'
	(select fid from qualification q, course c
	 where q.cid=c.cid and cname='Syst Analysis')
and fid not in #this subquer is to ensure the returned faculty members are not among those who can teach courses other than 'Syst Design' and 'Syst Analysis'
	(select fid from qualification q, course c
	 where q.cid=c.cid and cname not in ('Syst Design','Syst Analysis'));
	 

#k)Return the SNAME and SID of students who have registered for ALL the 
# courses available
select sname, sid from student 
where sid in 
	(select sid from registration group by sid 
	 having count(distinct cid) = 
		(select count(distinct cid) from course));

#l)Return the RID and CAPACITY of the rooms that can be used as 
#the venue for ALL the courses offered in semester I-2001.
select rid, capacity from room
where capacity >=
	(select max(enrollment) from 
		(select cid, count(distinct sid) as enrollment from registration 
		 where semester='I-2001' group by cid) as temp);

#m)Return the FNAME and FID of those faculty members who can teach
# ALL the courses that Prof. Berry can teach.
select fname, fid from faculty 
where fid in 
	(select fid from qualification 
	 where cid in (select cid from qualification q, faculty f
				   where q.fid=f.fid and fname='Berry')
	 group by fid
     having count(distinct cid) = 
			(select count(distinct cid) from qualification q, faculty f
			 where q.fid=f.fid and fname='Berry'))
and fname<>'Berry';

#n)Return the RID and CAPACITY of the rooms that can be used as 
#the venue for ALL the courses Bob has registered in semester 'I-2001'.
select rid, capacity from room 
where capacity >=
	(select max(enrollment) from
		(select cid, count(*) as enrollment from registration r
         where semester='I-2001' 
         and cid in (select cid from registration r, student s
         where r.sid=s.sid and sname='Bob' and semester='I-2001')
         group by cid
		) as temp);

#o)For all the courses offered in semester I-2001, return the CID 
#of all the courses whose enrollment is bigger than that of ‘Networking’ course.
select cid from registration where semester = 'I-2001'
group by cid
having count(*) > #the following subquery is to return the enrollment for Networking course in semester I-2001
	(select count(*) from registration r, course c
	 where c.cid=r.cid and semester='I-2001' and cname='Networking');

#p)Return the CNAME of the course that has maximal enrollment in 
#semester ‘I-2001’
select cname from course 
where cid in
	(select cid from registration where semester = 'I-2001'
	 group by cid
     having count(*) = #the following subquery is to return the maximal enrollment of a course offered in semester I-2001
		(select max(enrollment) from 
			(select cid, count(*) as enrollment from registration 
			 where semester = 'I-2001'
			 group by cid) as temp));

#solution 2
select cname from course 
where cid in
	(select cid from registration where semester = 'I-2001'
	 group by cid
     having count(*) =
#the following subquery is to find the maximal enrollment
#limit is provided by Mysql to return the first line in the results
		(select count(*) as enrollment from registration 
		where semester = 'I-2001'
		group by cid
		order by enrollment desc
		limit 1));

#q)For each course offered in semester I-2001, 
#return CID and the maximum finalmark.
select cid, max(finalmark)
from 
	(select p.cid, p.sid, sum(weight*mark) as finalmark
	from registration r, performance p, assessment a
	where r.cid=p.cid and r.sid=p.sid and semester='I-2001'
	and a.aid=p.aid
	group by p.cid, p.sid) as temp
group by cid;


#r.For each course offered in semester I-2001, return CID, 
#and SID of the student who performs the best in that course, 
#together with the corresponding Finalmark. 
select r.cid, r.sid, sum(weight*mark) as finalmark
from registration r, performance p, assessment a
where r.sid=p.sid and r.cid=p.cid and semester='I-2001'
and a.aid=p.aid 
group by r.cid, r.sid
having (r.cid, finalmark) in 
#The following subquery returns the MaxMark, that is the maximum 
#FinalMark per course that is offered in semester I-2001 
	(select cid, max(finalmark) as MaxMark
	from 
#the temp table T1 is to find the FinalMark for each student each course
		(select p.cid, p.sid, sum(weight*mark) as finalmark
		from registration r, performance p, assessment a
		where r.cid=p.cid and r.sid=p.sid and semester='I-2001'
		and a.aid=p.aid
		group by p.cid, p.sid) as T1
	group by cid);


#s)Return the FNAME and FID of the faculty who is qualified to 
#teach most courses. Return the NUMBER of courses he is qualified to teach as well.
select fname, f.fid, count(distinct cid) as CoursesCanTeach
from qualification q, faculty f
where q.fid = f.fid 
group by fname, f.fid
having CoursesCanTeach =
#the following subquery is to return the maximum number of courses 
#a faculty can teach based on MAX function
	(select max(CoursesCanTeach) from 
		(select fid, count(distinct cid) as CoursesCanTeach
		 from qualification group by fid) as temp);

#solution 2
select fname, f.fid, count(distinct cid) as CoursesCanTeach
from qualification q, faculty f
where q.fid = f.fid 
group by fname, f.fid
having CoursesCanTeach =
#the following subquery is to return the maximum number of courses 
#a faculty can teach based on LIMIT function provided by MySQL
	(select count(distinct cid) as CoursesCanTeach
     from qualification group by fid 
	 order by CoursesCanTeach desc
	 limit 1);
     
#solution 3
select fname, f.fid, count(distinct cid) as CoursesCanTeach
from qualification q, faculty f
where q.fid = f.fid 
group by fname, f.fid
having CoursesCanTeach >=
all	(select count(distinct cid) as CoursesCanTeach
     from qualification group by fid);

#t)Return the SNAME and SID of the students who has registered for 
#most courses within one semester.
select sname, s.sid from student s, registration r
where s.sid = r.sid 
group by sname, s.sid, semester
having count(distinct cid) = 
#the following subquery is to return the maximum number of courses a student takes within one semester
	(select max(CoursesTaken)
	 from (select sid, semester, count(distinct cid) as CoursesTaken
		   from registration
		   group by sid, semester
			) as temp);

#solution 2
select sname, s.sid from student s, registration r
where s.sid = r.sid 
group by sname, s.sid, semester
having count(distinct cid) = 
#the following subquery is to return the maximum number of courses a student takes within one semester
	(select count(distinct cid) as CoursesTaken from registration
	 group by sid, semester
	 order by CoursesTaken desc
	 limit 1);

#solution 3
select sname, s.sid from student s, registration r
where s.sid = r.sid 
group by sname, s.sid, semester
having count(distinct cid) >=
all (select count(distinct cid) from registration group by sid, semester);

#u)Among those faculty members who can teach, return the FID and 
#FNAME of the faculty member(s) who can teach the minimum number of courses.
select f.fid, fname from faculty f, qualification q
where f.fid = q.fid 
group by f.fid, fname
having count(distinct cid) = 
#the following subquery is to return the minimum number of course a faculty can teach
	(select min(CoursesCanTeach) from
		(select fid, count(distinct cid) as CoursesCanTeach
		 from qualification group by fid) as temp
	);
    
#solution 2
select f.fid, fname from faculty f, qualification q
where f.fid = q.fid 
group by f.fid, fname
having count(distinct cid) = 
#the following subquery is to return the minimum number of course a faculty can teach
	(select count(distinct cid) as CoursesCanTeach
	 from qualification group by fid 
	 order by CoursesCanTeach asc
     limit 1);

#solution 3:
select f.fid, fname from faculty f, qualification q
where f.fid = q.fid 
group by f.fid, fname
having count(distinct cid) <= 
    all (select count(distinct cid) as CoursesCanTeach
		 from qualification group by fid) ;

#v)Return the CID and CNAME for all the courses. If a course is 
#registered by student Dave, display the semester when Dave takes 
#the course.
select c.cid, c.cname, semester 
from course c left outer join  
	(select cid, semester from registration r, student s
	where r.sid=s.sid and sname='Dave') as temp
on c.cid = temp.cid;

#w)Find the pair of courses that share the same number of students 
#within the same semester. The returned result is in 
#(CID1, CID2, SEMESTER, STUDENT_NO) format.
select t1.cid, t2.cid, t1.semester, t1.student_no
from
	(select cid, semester, count(distinct sid) as student_no 
	from registration group by cid, semester) as t1,
	(select cid, semester, count(distinct sid) as student_no
	from registration group by cid, semester) as t2
where t1.cid<t2.cid and t1.semester=t2.semester
and t1.student_no=t2.student_no;

#x)	Find the pair of students that take the exact same set of 
#courses within the same semester. The return result is in (SID1, SID2, SEMESTER) format.
select r1.sid as sid1, r2.sid as sid2, r1.semester, count(distinct r1.cid) as num1 from registration r1, registration r2
where r1.sid < r2.sid and r1.cid = r2.cid and r1.semester=r2.semester
group by r1.sid, r2.sid, semester;
select t1.sid1, t1.sid2, t1.semester from 
#gets the number of common courses shared by pair of students
(select r1.sid as sid1, r2.sid as sid2, r1.semester, count(distinct r1.cid) as num1 from registration r1, registration r2
where r1.sid < r2.sid and r1.cid = r2.cid and r1.semester=r2.semester
group by r1.sid, r2.sid, semester) as t1, 
#gets the number of courses  student sid1 takes
(select sid, semester, count(cid) as num2 from registration group by sid, semester) as t2,
#gets the number of courses  student sid2 takes
(select sid, semester, count(cid) as num2 from registration group by sid, semester) as t3
where t1.sid1 = t2.sid and t1.num1=t2.num2 and t1.semester=t2.semester and 
t1.sid2=t3.sid and t1.num1=t3.num2 and t1.semester=t3.semester;