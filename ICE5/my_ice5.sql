###### NON DUPLICATE EXERCISE QUERIES

#exe e
select r.sid from registration r,course c where c.cid=r.cid and c.cname='Syst Analysis' and r.semester='I-2001';

#exe f -> not sure
select r.sid,s.sname from registration r,course c, student s 
where r.sid=s.sid and c.cid=r.cid and  c.cname='Syst analysis' and semester='i-2001';


#exe h -> not sure
select distinct r.sid,s.sname from registration r, qualification q,student s,faculty f 
where r.cid=q.cid and f.fid =q.fid and f.fname="berry" and r.sid=s.sid;

#exe i
select f.fid,f.fname,q.cid from faculty f left outer join qualification q on q.fid=f.fid;

#exe j
select f.fid,f.fname,c.cname from (faculty f left outer join qualification q on q.fid=f.fid) 
inner join course c on c.cid=q.cid;

#exe k 
select f.fid,f.fname,count(distinct cid) from 
(faculty f left outer join qualification q on q.fid=f.fid) group by f.fid,f.fname;

# exe l
#l)Return the SID and SNAME of all the students in STUDENT table. 
#In addition, display the total number of courses each student 
#registers in semester I-2002 as well and ZERO is expected for those who do not 
#registered any course in semester I-2002.

select s.sid,s.sname,count(distinct r.cid) from student s left outer join registration r  on r.sid=s.sid and r.semester ='i-2002'
group by s.sid,s.sname;

#exe m
#m) Return the CID and CNAME of all the courses in COURSE table.
#In addition, display the number of students registered during semester 
#I-2002 per course as well.
select c.cid,c.cname,count(sid) from course c left outer join registration r 
on c.cid=r.cid and r.semester='I-2002' group by c.cid,c.cname;


#exe n
select s.sid,f.fid,fname as name from  faculty f, student s where f.fname=s.sname;

#exe o
select s.sid,s.sname,f.fid,f.fname from faculty f, student s where s.sname<>f.fname;

#exe p 
select p.sid as SID,p.cid as CID,sum(p.mark*a.weight) as FINALMARK from 
(performance p inner join assessment a on p.aid=a.aid) group by p.sid,p.cid;
select * from performance p inner join assessment a on p.aid=a.aid order by p.sid,p.cid;
select * from assessment;

#exe r
select r1.sid from (registration r1 inner join course c1 on r1.cid=c1.cid and c1.cname='Database') 
inner join (registration r2 inner join course c2 on r2.cid=c2.cid and c2.cname in ('Networking'))  
on r1.sid=r2.sid; 

select sid from  registration r, course c
where c.cid = r.cid
and cname in ('Database', 'Networking')
group by sid
having count(distinct c.cid) = 2;

#exe r
select f.fid,count(*) from faculty f,qualification q,course c 
where q.fid=f.fid and q.cid=c.cid and c.cname in ('syst analysis','syst design') 
group by f.fid having count(*)=1;

#exe s 
select f1.fid as FID1, f2.fid as FID2, c.cname as CNAME from qualification f1,qualification f2, course c where f1.cid=f2.cid and f1.fid < f2.fid and f1.cid=c.cid;
select f1.fid as FID1, f2.fid as FID2, c.cname as CNAME from (qualification f1 inner join qualification f2 on f1.cid=f2.cid and f1.fid < f2.fid) inner join course c where  f1.cid=c.cid;

#exe t 
select r1.rid as RID1,r2.rid as RID2,r1.type,r1.capacity from room r1, room r2 
where r1.rid < r2.rid and r1.type=r2.type and r1.capacity=r2.capacity;
select * from room;

#exe u
select s1.sname as SNAME1,s2.sname as SNAME2,c.cname as CNAME, r1.semester as SEMESTER 
from ((registration r1 inner join student s1 on r1.sid=s1.sid) inner join 
(registration r2 inner join student s2 on r2.sid=s2.sid) 
on r1.sid<r2.sid and r1.cid =r2.cid and r1.semester=r2.semester)  
inner join course c on r1.cid=c.cid;