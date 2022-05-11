/*
	#x)	Find the pair of students that take the exact same set of 
	#courses within the same semester. The return result is in (SID1, SID2, SEMESTER) format.
*/


##### select students who take the same course 
select r1.sid as sid1,r2.sid as sid2,r1.cid as cid2 from registration r1,registration r2 where r1.sid < r2.sid and r1.cid=r2.cid and r1.semester=r2.semester;

##### select students who takes the same number of course in a semester
select t1.sid,t2.sid,t1.semester from (select r1.sid,count(*) as numberOfCourses,semester from registration r1 group by sid,semester) as t1 
inner join (select r1.sid,count(*) as numberOfCourses,semester from registration r1 group by sid,semester) as t2 
where t1.sid<>t2.sid and t1.numberOfCourses=t2.numberOfCourses and t1.semester=t2.semester;

#### Choosing those who take the same courses and those who take the same number of course in a semester
select t3.sid1,t3.sid2,t3.semester from (select r1.sid as sid1,r2.sid as sid2,r1.cid as cid2,r1.semester from registration r1,registration r2 
										where r1.sid < r2.sid and r1.cid=r2.cid and r1.semester=r2.semester) 
                                        as t3 where (t3.sid1,t3.sid2,t3.semester) in (select t1.sid,t2.sid,t1.semester from (select r1.sid,count(*) as numberOfCourses,semester from registration r1 group by sid,semester) as t1 
inner join (select r1.sid,count(*) as numberOfCourses,semester from registration r1 group by sid,semester) as t2 
where t1.sid<>t2.sid and t1.numberOfCourses=t2.numberOfCourses and t1.semester=t2.semester);