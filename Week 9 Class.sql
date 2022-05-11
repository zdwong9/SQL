use ice4;

#Week 9
# Find sid of students who takke database and networking subquery
# Find intersection
select * from student where sid in L1 and sid in L2;
select * from student where sid in (select sid from registration r ,course c where r.cid = c.cid and cname ='database' ) and sid in (select sid from registration r, course c where r.cid=c.cid and cname='networking');

# Find in A but not in B
# Find SID of students who take database but NOT networking
select * from student where sid in L1 and sid not in L2;


# Find those students who database or networking but not both
# Find students that take only databse or only networking but not both
select * from student where sid in L1 xor sid in L2;

# Find students who neither take database nnor networking
select * from student where sid not in L1 and sid not in L2;

# slide 8
select distinct q.fid from qualification q ,course c where q.cid=c.cid and cname in('Syst design','syst analysis');
select * from qualification q;

#slide 8 based on subqueries
select fid from faculty where fid in (select fid from qualification q, course c where q.cid=c.cid and cname ='Syst Design') or
fid in (select fid from qualification q, course c where q.cid=c.cid and cname='Syst Analysis');

#slide 9
select f.fid from faculty f,course c,qualification q where f.fid=q.fid and c.cid=q.cid and cname in('Syst Analysis','Syst Design') group by f.fid having count(*) = 1;

#slide 9 based on subqueries
select fid from faculty where fid in (select fid from qualification q, course c where q.cid=c.cid and cname ='Syst Analysis') 
xor fid in (select fid from qualification q, course c where q.cid=c.cid and cname ='Syst Design');

#slide 10 --- 


#slide 11
# L1 refer to SID of students who take 'database'
# L2 refer to SID of students whose total number of courses taken is one
# L3 refer to SID of students who take any number of non-database course(s)

# First logic -> Find intersection of L1 and L2
# select * from student where sid in L1 and sid in L2

#Second Logic -> Find those in L1 but not in L3
# select * from student where sid in L1 and sid not in L3

#L1 -> 
select sid from registration, course where registration.cid=course.cid and cname ='database';

#L2 -> 
select sid from registration r group by r.sid having count(*) = 1;

#L3 
select sid from registration r ,course c where r.cid=c.cid and cname != 'Database';

## Different qn
# Find students who take only 'database' and 'networking'
# L1: SID of students who take 'database'
# L2: SID of students who take 'networking'
# L3: SID of students whose total number of courses taken is two
# L4 : SID of students whose take at least one course that is not database and not networking

#Logic 1 -> L1 intersect L2 intersect L3
select * from student where sid in L1 and sid in L2 and sid in L3;

#Logic2 -> (L1 intersect L2) but not in L4
select * from student where sid in l1 and sid in l2 and sid not in l4;

#L1: SID of students who take 'database'
select sid from registration r, course c where r.cid=c.cid and cname ='database';

#L2 SID of students who take networking
select sid from registration r, course c where r.cid=c.cid and cname ='networking';

# L3 SID of students whose total number of courses taken is two
select sid from registration r group by sid having count(*) = 2;

#L4 SID of students who take at least one course that is not database and not networking
select sid from registration r, course c where r.cid=c.cid and cname <> 'database' and cname <> 'networking';

#slide 12
#logic 1?

select f.fid, fname from faculty f where fid in (select fid from qualification q, course c where q.cid=c.cid and cname ='Syst Design') and fid not in (select fid from qualification q, course c
where c.cid=q.cid and cname not in ('Syst Design')) ;


# slide 13
# Find total number of courses
select count(*) from course;

# Find SID of students who register 4 courses
select sid from registration group by sid having count(*) = (select count(*) from course);

# slide 14
# step 1:
select count(*) from qualification q , faculty f 
where f.fid=q.fid and f.fname='berry';

#step 2:
select fid from qualification q where f.fid=q.fid and f.fname <> 'Berry' group by q.fid having count(distinct cid) = 
(select count(*) from qualification q , faculty f 
where f.fid=q.fid and f.fname='berry')  and fid not in (select fid from faculty where fname='Berry');

# slide 16
#step 1: form a temp table(cid,semester) to capture the courses Dave takes
select cid,semester from registration r, student s where r.sid=s.sid and sname = 'Dave';

#step 2: course left outer join temp
select c.cid,cname,ifnull(semester,'Not Yet Taken') as semester from course c 
left outer join  (select cid,semester from registration r, student s 
where r.sid=s.sid and sname = 'Dave') as temp on c.cid=temp.cid;

# slide 17
select cid,semester,count(distinct sid) from registration group by cid,semester;

# slide 18
select cid,semester,count(*) as student_no from registration group by cid,semester;

#step2: self-join T1, look for pair of courses sharing same student_no in the same semester
#logic 
select T1.cid,T2.cid,T1.semester,T1.student_no
from (select cid,semester,count(*) as student_no from registration group by cid,semester as T1),
(select cid,semester,count(*) as student_no from registration group by cid,semester as T2) 
 where T1.cid<T2.cid and T1.semester = T2.semester and T1.student_no=T2.student_no;

#slide 21
#step 1: form a temp table (sid,semester,coursesTaken) such that we can apply max
select sid,semester,count(*) as coursesTaken from registration group by sid,semester;

#step 2:apply max function on column courses taken to find max_count
select max(coursesTaken) as max_count from (select sid,semester,count(*) as coursesTaken from 
registration group by sid,semester)
as temp;

#step 3: find students who take max_count courses in a sem
select sid,semester,count(*) as coursesTaken from registration group by sid,semester having count(*) =
(select max(coursesTaken) as max_count from (select sid,semester,count(*) as coursesTaken from registration group by sid,semester)
as temp);


## New qn
# For each course, find the sid of student(s) who score the highest
# output -> cid,sid, score

# Step 1: form temp table (cid,sid,finalscore) T1 group by

# Step2 : invoke max function on final score column of T1 for each course to form a second temp table T2 (cid,max_score)

# Step 3: for each record in T2, find the student who score max_score in the course

#implementation
select p.sid as SID,p.cid as CID,sum(p.mark*a.weight) as FINALMARK from 
(performance p inner join assessment a on p.aid=a.aid) group by p.sid,p.cid ;

#step2: for a table T2(cid,maxscore)
select cid,max(finalmark) from 
(select p.cid as SID,p.cid as CID,sum(p.mark*a.weight) as FINALMARK from 
(performance p inner join assessment a on p.aid=a.aid) group by p.sid,p.cid) as T1 group by cid;

#step 3
select t2.cid,t1.cid,t1.finalmark
from (select p.sid as SID,p.cid as CID,sum(p.mark*a.weight) as FINALMARK from 
(performance p inner join assessment a on p.aid=a.aid) group by p.sid,p.cid ) as  t1,
(select cid,max(finalmark) as finalmark from 
(select p.cid as SID,p.cid as CID,sum(p.mark*a.weight) as FINALMARK from 
(performance p inner join assessment a on p.aid=a.aid) group by p.sid,p.cid) as T1 group by cid) as  t2
where t1.cid=t2.cid and t1.finalmark=t2.finalmark;

select * from student;
select sid,sname from student where (sid,sname) in (select sid,max(sname) from student) 
or (sid,sname) in (select sid,min(sname) from student);

select sid,max(sname) from student;
select sname ,length(sname) from student where rownum =1  order by length(sname),sname UNION 
select sname ,length(sname) from student order by length(sname),sname desc limit 1;






