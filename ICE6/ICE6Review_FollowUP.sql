##### Below are my corrected queries for qn Q,R, S,T

###############################################################3
# q: For each course offered in semester I-2001, return CID and the maximum Finalmark. Note,
# Finalmark of a student corresponding to a course refers to the accumulated mark of student’s
# performance in various assessments.

#step 1: get final mark
select sid,cid, sum(mark*weight) from performance p inner join assessment a on p.aid=a.aid
group by sid,cid;

#step 2:get cid and final mark for each course in sem I-2001
select sid,cid, sum(mark*weight) as finalmark from performance p inner join assessment a 
on p.aid=a.aid and cid in (select cid from registration where semester='i-2001')
group by sid,cid;
select * from performance p;
#baihua: the condition cin in () listed in Line 256 is not correct.
#you should use the condition: (cid, sid) in (select cid, sid from registration where semester='I-2001'). Why?

#######Corrected
#step 2:get cid and final mark for each course in sem I-2001
select sid,cid, sum(mark*weight) as finalmark from performance p inner join assessment a 
on p.aid=a.aid and (cid,sid) in (select cid,sid from registration where semester='i-2001')
group by sid,cid;
select * from performance p;


# step 3: get max final mark for each course
select cid,max(finalmark) from (select sid,cid, sum(mark*weight) as finalmark from performance p inner join assessment a 
on p.aid=a.aid and (sid,cid) in (select sid,cid from registration where semester='i-2001')
group by sid,cid) as t1 group by cid;



################################################################
# r : or each course offered in semester I-2001, return CID, and SID of the student who
# 	  performs the best in that course, together with the corresponding Finalmark

# step 1: cid and max mark of each course offered in sem I-2001
select cid,max(finalmark) as MaxMark from (select sid,cid, sum(mark*weight) as finalmark from performance p inner join assessment a 
on p.aid=a.aid and cid in (select cid from registration where semester='i-2001')
group by sid,cid) as t1 group by cid;
#baihua: Same issue as your statement to q. Redo this question pls.

#corrected
# step 1: cid and max mark of each course offered in sem I-2001
select cid,max(finalmark) as MaxMark from (select sid,cid, sum(mark*weight) as finalmark from performance p inner join assessment a 
on p.aid=a.aid and (sid,cid) in (select sid,cid from registration where semester='i-2001')
group by sid,cid) as t1 group by cid;
#baihua: Same issue as your statement to q. Redo this question pls.

#step 2 :sid,cid,mark of each student for each course offered in sem I-2001
select sid,cid, sum(mark*weight) as finalmark from performance p inner join assessment a 
on p.aid=a.aid and (sid,cid) in (select sid,cid from registration where semester='i-2001')
group by sid,cid;

#step 3: select sid,cid,finalmark from step 2 where cid and max mark must be from step 1

select sid,cid, finalmark from (select sid,cid, sum(mark*weight) as finalmark from performance p inner join assessment a 
on p.aid=a.aid and cid in (select distinct cid from registration where semester='i-2001')
group by sid,cid) as t1 where (t1.cid,t1.finalmark) in (select cid,max(finalmark) as 
MaxMark from (select sid,cid, sum(mark*weight) as finalmark from performance p inner join assessment a 
on p.aid=a.aid and (sid,cid) in (select sid,cid from registration where semester='i-2001')
group by sid,cid) as t1 group by cid) ;

#############################################################################33

# s :Return FNAME and FID of the faculty who is qualified to teach most courses. Return the
#    NUMBER of courses she/he is qualified to teach as wel

#step 1 : Find faculty member who taught the most courses

select fid,max(numberOfCourses) from (select fid,count(distinct cid) as numberOfCourses from qualification 
group by fid) as t1;
#baihua: The above statement is wrong. Table t1 is in the form of (fid, numberofCourses). 
#You then select fid, max(numberOfCourses) without using group by. This is INVALID. Redo this question.

######Corrected
select fid,numberOfCourses from (select fid,count(distinct cid) as numberOfCourses from qualification 
group by fid) as t1 group by fid having numberOfCourses = (select max(numberOfCourses) from (select fid,count(distinct cid) as numberOfCourses from qualification 
group by fid) as t2);


#step 2: Find the courses that he took
select fid,cid from qualification where fid in (select fid from (select fid,numberOfCourses from (select fid,count(distinct cid) as numberOfCourses from qualification 
group by fid) as t1 group by fid having numberOfCourses = (select max(numberOfCourses) from (select fid,count(distinct cid) as numberOfCourses from qualification 
group by fid) as t2)) as t3);

# Map cid to the course he taught
###### Corrected
select q.fid,fname,numberOfCourses from faculty f,qualification q, (select fid,numberOfCourses from (select fid,count(distinct cid) as numberOfCourses from qualification 
group by fid) as t1 group by fid having numberOfCourses = (select max(numberOfCourses) from (select fid,count(distinct cid) as numberOfCourses from qualification 
group by fid) as t2))
as t4 where q.fid=f.fid and t4.fid = q.fid and (q.fid,q.cid) in (select fid,cid from qualification where fid in (select fid from (select fid,numberOfCourses from (select fid,count(distinct cid) as numberOfCourses from qualification 
group by fid) as t1 group by fid having numberOfCourses = (select max(numberOfCourses) from (select fid,count(distinct cid) as numberOfCourses from qualification 
group by fid) as t2)) as t3));

######



##########################################33
#t : Return SNAME and SID of the students who has registered for most courses within one
# 	 semester

# find sid with most courses
select sid,semester,count(*) as number from registration r group by r.sid,semester;

##### Corrected
select sid,semester,number from (select sid,semester,count(*) as number from registration r group by r.sid,semester) as t2 
group by sid,semester having number = (select max(number) from (select sid,semester,count(*) as number from registration r group by r.sid,semester) as t1);

# select sid and and course count
select sid,semester,max(number) from (select sid,semester,count(*) as number from registration r group by r.sid,semester) as t1;
select sid from (select sid,semester,max(number) from (select sid,semester,count(*) as number from registration r group by r.sid,semester) as t1) as t2;
#baihua: statement in Line 330 is wrong, and it shares the same mistake as the code in Line 297.
#Your table t1 is in the form of (sid, semester, number). You can select sid, semester, max(number) from t1 without group by. You can only return max(number) but not sid, semester.
#redo this question.

####Corrected

# select sid and sname for that student
select s.sid,sname from (student s, (select sid,semester,number from (select sid,semester,count(*) as number from registration r group by r.sid,semester) as t2 
where number = (select max(number) from (select sid,semester,count(*) as number from registration r group by r.sid,semester) as t1)) as t3) where s.sid=t3.sid;