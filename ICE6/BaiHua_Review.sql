#a Return SNAME of those students who are enrolled in ISM 3113 during semester I-2001
# step 1 
select sid from registration r where
semester ='I-2001' and cid = 'ISM 3113';

#step 2
select SNAME from student where sid in (select sid from registration r where
semester ='I-2001' and cid = 'ISM 3113');
####################################################################33

#b Display FNAME and FID of faculty qualified to teach at least two courses
# step 1: Find those who are qualified to teach at least two courses using group by
select fid from qualification q group by fid having count(distinct cid) >=2;

# step 2 : query fname and fid from faculty whose fid is in the list
select fname,fid from faculty where fid in (select fid from qualification q group by fid having count(distinct cid) >=2);


##########################################################################


#c List FID of the faculty qualified to teach at least two courses OR qualified to teach some 
#   course(s) after year 1990 (exclusive 1990).

#step 1: Find those who are qualified to teach at least two courses -> Table 1
select fid from qualification q group by fid having count(distinct cid) >=2;

# step 2: find distinct fid who are qualified to teach courses after 1990 exclusive 1990 -> Table 2
select distinct fid from qualification q where year(date_qualified) > 1990;

# step 3: Table 1 or Table 2
select fid from faculty where fid in(select fid from qualification q group by fid having count(distinct cid) >=2)  or fid in 
(select distinct fid from qualification q where year(date_qualified) > 1990);

#below is the wrong answer
select distinct t2.fid from (select fid from qualification q group by fid having count(distinct cid) >=2) as t1,
(select distinct fid from qualification q where year(date_qualified) > 1990) as t2;

############################################################################################

# d :Display SID and SNAME of students who have registered for both ‘Database’ and
# ‘Networking'

# step 1 find those who have registered for both database and networking -> t1
select distinct sid from registration r where sid in (select sid from registration r where cid in
(select cid from course where cname in('Database'))) 
and sid in (select sid from registration r where cid in (select cid from course where cname in('Networking'))) 
;

select * from registration r;
 
#step 2 query for sid and sname from students where sid is in t1
select sid,sname from student where sid in (select distinct sid from registration r where sid in (select sid from registration r where cid in
(select cid from course where cname in('Database'))) 
and sid in (select sid from registration r where cid in (select cid from course where cname in('Networking')))) 
;

 #####################################################3
 
# e: Return SID and SNAME of students who have registered for either 'Syst Analysis' OR 'Syst
# 	 Design'.

#step 1: select sid from those who registered for syst analysis or sys design
select sid from registration r where cid in (select cid from course c where cname in ('Syst Analysis','Syst Design'))
group by sid;
#baihua: Why you include group by sid here? If you want to remove duplication, include distinct in front of sid (but you should not use group by).

# step 2: query for sid and sname from t1
select sid,sname from student where sid in (select sid from registration r where cid in (select cid from course c where cname in ('Syst Analysis','Syst Design'))
group by sid);
 
################################################################333

# f : Return SID and SNAME of students who have registered for either 'Syst Analysis' OR 'Syst
#   Design', but not both
# step 1: select those who are registered in syst analysis or sys design but not both
select sid from registration r where cid in (select cid from course c where cname in('Syst Analysis','Syst Design')) 
group by sid having count(*) =1;

#step 2: query for sid and sname from student where sid in t1
select sid,sname from student where sid in (select sid from registration r where cid in (select cid from course c where cname in('Syst Analysis','Syst Design')) 
group by sid having count(*) =1);

###############################################################################
# g :Return SNAME and SID of students who have ONLY registered for the course ‘Database’
#step 1: find those that have only registered for 1 course
select sid from registration r group by sid having count(sid) =1;

#step 2: find those who have registered for 'Database'
select sid from registration r where cid in (select cid from course c where cname ='Database');

#step 3: find those who have registered only for 'Database' and those that only registered for 1 course
select sid,sname from student where sid in (select sid from registration r group by sid having count(sid) =1)
and sid in (select sid from registration r where cid in (select cid from course c where cname ='Database'));

###########################################################3

# h: Return FID and FNAME of faculty who are ONLY qualified to teach ‘Syst Design’
#step 1: find those who are only qualified to teach Syst Design and those that qualified to teach only ONE course
select fid from qualification q where cid in (select cid from course c where cname ='Syst Design') 
and fid in (select fid from qualification q group by fid having count(fid) =1 );

# step 2 : query for fid and fname from t1
select fid,fname from faculty where fid in (select fid from qualification q where cid in (select cid from course c where cname ='Syst Design') 
and fid in (select fid from qualification q group by fid having count(fid) =1 ));

######################################################################################

# i : Return CID and CNAME of courses ONLY student Bob has registered.
#step 1: find sid of bob
select sid from student where sname ='bob';

#step 2: find courses where bob has registered
select cid from registration r where sid in (select sid from student where sname ='bob');

# step3:  find those courses which has only 1 registered student
select cid from registration r group by cid having count(sid) =1;

#step 4: find interesection of all step2 and step 3 tables
select cid,cname from course c where cid in 
(select cid from registration r where sid in (select sid from student where sname ='bob')) and 
cid in (select cid from registration r group by cid having count(sid) =1);

################################################################
# j: Return FID and FNAME of faculty who can teach ONLY 'Syst Analysis' AND 'Syst Design'.
# step 1 : find cid of syst analysis and syst design
select cid from course c where cname in ('Syst Analysis','Syst Design');

# step 2: find fid of those who can teach only 2 subjects
select fid from qualification q group by fid having count(fid) =2;

# step3 : find intersection of the 2 table
select fid, fname from faculty f where fid in 
(select fid from qualification q group by fid having count(fid) =2) and 
fid in (select fid from qualification q where cid in (select cid from course c where cname in ('Syst Design'))) 
and
fid in (select fid from qualification q where cid in (select cid from course c where cname in ('Syst Analysis'))) ;
###########################################################

#k : Return SNAME and SID of the student who have registered for ALL the courses available
#step 1: count how many total courses avaiilable;
select count(*) from course;

#step 2: group by sid having count = max courses
select sid from registration r group by sid having count(sid) = (select count(*) from course);

#step 3: select sname and sid from student
select sid,sname from student where sid in 
(select sid from registration r group by sid having count(sid) = 
(select count(*) from course));
#####################################################

# l : Return RID and CAPACITY of the rooms that can be used as the venue for ALL the courses
# offered in semester I-2001. We assume a room can be used to conduct a course if the
# capacity of the room is not smaller than the enrollment of the course.

#step 1 : count number of students for each course in sem i-2001
select max(count(sid)) from registration r where semester='i-2001' group by cid;

#step 2: get the maximum number of students for all the courses in sem i-2001
select max(t1.count) from (select count(sid) as count from registration r where semester='i-2001' group by cid) as t1;

# step 3: find rid and capacity where capacity> count
select rid,capacity from room where capacity > (select max(t1.count) from 
(select count(sid) as count from registration r where semester='i-2001' group by cid) as t1)
;
#baihua: you should use '>=' instead of '>' in Line 164.

########################################################

#m: Return FNAME and FID of those faculty members who can teach ALL the courses that Prof.
# 	Berry can teach. 

# step 1: find all the courses that berry can teach
select cid from qualification q where fid = (select fid from faculty where fname='berry');

# step 2: find those teaches what berry can teach but there is a chance that they can only teach 1 of what berry can teach
select fid from qualification q where cid in (select cid from qualification q 
where 
fid = (select fid from faculty where fname='berry'))
and 
fid != (select fid from faculty where fname='berry');

#step 3: find from step 3 those that have the same count as how many berry can teach
select fid from qualification q where cid in (select cid from qualification q where fid = (select fid from faculty where fname='berry'))
and fid != (select fid from faculty where fname='berry') 
group by fid having count(*) =
(select count(*) from (select cid from qualification q where fid = (select fid from faculty where fname='berry')) as t1);

#step 4: query fid and fname from faculty on conditions set by step 4
select fid, fname from faculty where fid in(select fid from qualification q where cid in (select cid from qualification q where fid = (select fid from faculty where fname='berry'))
and fid != (select fid from faculty where fname='berry') group by fid having count(*) =
(select count(*) from (select cid from qualification q where fid = (select fid from faculty where fname='berry')) as t1));

##############################################################

#n : Return RID and CAPACITY of the rooms that can be used as the venue for ALL the courses
# 	 Clark has registered

#step 1: find all the courses and its respective semester that clark registered
select cid,semester from registration where sid in (select sid from student where sname ='clark');

# find number of students for each course and its respective semester that clark registered
select cid,semester,count(sid) from registration where (cid,semester) in (select cid,semester from registration where sid in (select sid from student where sname ='clark'))
group by cid,semester;

# find MAXIMUM number of students for each course and its respective semester that clark registered
select rid,capacity from room where capacity > (
select max(StudentCount) from (select cid,semester,count(sid) as StudentCount from registration where (cid,semester) in (select cid,semester from registration where sid in (select sid from student where sname ='clark'))
group by cid,semester) as t1);
#baihua: Again, we shall use '>=' instead of '>' in Line 208.

#################################################

# o: For all the courses offered in semester I-2001, return CID of all the courses whose
# enrollment is bigger than that of ‘Networking’ course.

# step 1: find courses offered in semester I-2001
select count(*) from registration r where semester ='i-2001' and cid not in (select cid from course where cname ='database') group by (cid);

#find enrolment of NEtworking course in i-2001
select count(*) from registration r where semester ='i-2001' and cid in (select cid from course where cname ='database');

# find courses where enrolment more than enrolment networking
select cid from registration where semester ='i-2001' 
and cid not in (select cid from course where cname ='database') group by (cid) having count(*)>
(select count(*) from registration r where semester ='i-2001' and cid in (select cid from course where cname ='database')
);
#baihua: not 'database' course but 'networking', :)

###################################################

#o: Return CNAME of the course that has maximal enrollment in semester I-2001
# find number of students for each course offered in sem i-2001
select count(*) from registration r where semester ='i-2001' group by (cid);

# find max of the number of students for each course in sem i-2001
select max(studentCount) from (select count(*) as studentCount from registration r where semester ='i-2001' group by (cid)) as t1;

# find that particular cid that has the max enrolment in i-2001
select cid from registration r where semester ='i-2001' group by (cid) having count(*) =
(select max(studentCount) from (select count(*) as studentCount from registration r where semester ='i-2001' 
group by (cid)) as t1
);
#############################################################3
# q: For each course offered in semester I-2001, return CID and the maximum Finalmark. Note,
# Finalmark of a student corresponding to a course refers to the accumulated mark of student’s
# performance in various assessments.

#step 1: get final mark
select sid,cid, sum(mark*weight) from performance p inner join assessment a on p.aid=a.aid
group by sid,cid;

#step 2:get cid and final mark for each course in sem I-2001
select sid,cid, sum(mark*weight) as finalmark from performance p inner join assessment a 
on p.aid=a.aid and (cid,sid) in (select cid,sid from registration where semester='I-2001')
group by sid,cid;
select * from performance p;
#baihua: the condition cin in () listed in Line 256 is not correct.
#you should use the condition: (cid, sid) in (select cid, sid from registration where semester='I-2001'). Why?

# step 3: get max final mark for each course
select cid,max(finalmark) from (select sid,cid, sum(mark*weight) as finalmark from performance p inner join assessment a 
on p.aid=a.aid and (sid,cid) in (select sid,cid from registration where semester='i-2001')
group by sid,cid) as t1 group by cid;
################################################################

# r : or each course offered in semester I-2001, return CID, and SID of the student who
# 	  performs the best in that course, together with the corresponding Finalmark

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


###################################################################

# s :Return FNAME and FID of the faculty who is qualified to teach most courses. Return the
#    NUMBER of courses she/he is qualified to teach as wel

#step 1 : Find faculty member who taught the most courses

select fid,max(numberOfCourses) from (select fid,count(distinct cid) as numberOfCourses from qualification 
group by fid) as t1 group by fid;
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

#### Below is wrong
select q.fid,cname,fname,number from (qualification q inner join course c on q.cid=c.cid) inner join faculty f on f.fid=q.fid 
inner join 
(select fid,max(numberOfCourses) as number from (select fid,count(distinct cid) as numberOfCourses from qualification 
group by fid) as t1) as t2 on t2.fid=q.fid;


select qualification.fid,qualification.cid,cname,number from ((qualification inner join course on course.cid=qualification.cid)
inner join 
(select fid,max(numberOfCourses) as number from (select fid,count(distinct cid) as numberOfCourses from qualification 
group by fid) as t1) as t2
on t2.fid=qualification.fid) ;

##########################################33
#t : Return SNAME and SID of the students who has registered for most courses within one
# 	 semester

# find sid with most courses
select sid,semester,count(*) as number from registration r group by r.sid,semester;

# select sid and and course count
select sid,semester,max(number) from (select sid,semester,count(*) as number from registration r group by r.sid,semester) as t1;
select sid from (select sid,semester,max(number) from (select sid,semester,count(*) as number from registration r group by r.sid,semester) as t1) as t2;
#baihua: statement in Line 330 is wrong, and it shares the same mistake as the code in Line 297.
#Your table t1 is in the form of (sid, semester, number). You can select sid, semester, max(number) from t1 without group by. You can only return max(number) but not sid, semester.
#redo this question.

##### Corrected
select sid,semester,number from (select sid,semester,count(*) as number from registration r group by r.sid,semester) as t2 
where number = (select max(number) from (select sid,semester,count(*) as number from registration r group by r.sid,semester) as t1);


# select sid and sname for that student
select s.sid,sname from (student s, (select sid,semester,number from (select sid,semester,count(*) as number from registration r group by r.sid,semester) as t2 
where number = (select max(number) from (select sid,semester,count(*) as number from registration r group by r.sid,semester) as t1)) as t3) where s.sid=t3.sid;

#############################################################################################3
#u:	Among those faculty members who can teach, return FID and FNAME of the faculty
#	member(s) who can teach the minimum number of courses

select fid from qualification q group by fid having count(*) = (select min(number) from (select fid,count(*) as number from qualification q group by fid) as t1);

select fid,fname from faculty f where fid in (select fid from qualification q group by fid having count(*) = (select min(number) from (select fid,count(*) as number from qualification q group by fid) as t1));



###############################################################################################

#v: Return CID and CNAME for all the courses. If a course is registered by student Dave,
# 	display the semester when Dave takes the course.

select sid from student s where s.sname='Dave';

select cid from registration r where sid in (select sid from student s where s.sname='Dave');

select c.cid,cname,semester from course c left outer join (select cid,semester from registration r where sid in (select sid from student s where s.sname='Dave')) as t2 on t2.cid=c.cid;
#baihua: We discussed this question in class. It requires outer join to make sure all the courses are returned (but not only the courses taken by Dave).

###########################################################################################

#w: Find the pair of courses that share the same number of students within the same semester.
# 	The returned result is in (CID1, CID2, SEMESTER, STUDENT_NO) format.

# count number of students 
select semester,cid,count(*) as students from registration r group by cid,semester;

select t1.semester,t1.cid,t2.semester,t2.cid,t1.students from (select semester,cid,count(*) as students from registration r group by cid,semester) as t1,
(select semester,cid,count(*) as students from registration r group by cid,semester) as t2
where t1.cid<> t2.cid and t1.semester= t2.semester and t1.students=t2.students and t1.cid<t2.cid;
#baihua: Since you include t1.cid<t2.cid condition, no need to include t1.cid<>t2.cid (as it is guaranteed by t1.cid<t2.cid).

############################################################################################

#x: Find the pair of students that take the exact same set of courses within the same semester.
# The return result is in (SID1, SID2, SEMESTER) format.

#step 1: count number of courses each student take in each semester
select sid,semester,count(*) as number from registration r group by sid,semester;

#step 2: inner join the step 1 twice on t1.sid<>t2.sid and t1.semester=t2.semester and t1.numberofCourses and t1.sid<t2.sid (to remove duplicates)
select t1.sid,t1.semester,t2.sid,t2.semester,t1.numberOfCourses from (select sid,semester,count(*) as numberOfCourses from registration r group by sid,semester) as t1 inner join 
(select sid,semester,count(*) as numberOfCourses from registration r group by sid,semester) as t2 on t1.sid<>t2.sid and t1.semester=t2.semester and t1.numberOfCourses=t2.numberOfCourses and t1.sid<t2.sid;
#baihua: Your statement returns pair of students who take the same number of courses in the same semester.
#However, this is different from what the question asks for.
#The question asks for pair of students who take the exact same set of courses. 
#Given two students A, B, if they both take 2 courses in I-2001, but A take ISM3112 and ISM3113, while B takes ISM4930/ISM3112.
#(A,B) will be returned by your statement, but (A,B) is not a qualified pair for this question (as the courses they take are different).
#Redo this question. 

##########################################
#Correct x)

select r1.sid as sid1,r2.sid as sid2,r1.semester as semester,count(distinct r1.cid) as numberOfCourses from registration r1,registration r2 where r1.sid < r2.sid and r1.cid=r2.cid and r1.semester=r2.semester group by
sid1,sid2,semester;


select t3.sid1,t3.sid2,t3.semester from (select r1.sid as sid1,r2.sid as sid2,r1.semester as semester, count(distinct r1.cid) as numberOfCourses from registration r1,registration r2 where r1.sid < r2.sid and r1.cid=r2.cid and r1.semester=r2.semester group by
sid1,sid2,semester)
                                        as t3 where (t3.sid1,t3.sid2,t3.semester) in 
                                        (select t1.sid,t2.sid,t1.semester from (select r1.sid,count(*) as numberOfCourses,semester from registration r1 group by sid,semester) as t1 
inner join (select r1.sid,count(*) as numberOfCourses,semester from registration r1 group by sid,semester) as t2 
where t1.sid<>t2.sid and t1.numberOfCourses=t2.numberOfCourses and t1.semester=t2.semester);









