use ice4;

select * from course,qualification;

select cid from course,qualification;

select course.cid from course,qualification ;

select * from course c ,qualification q where c.cid=q.cid;
select * from course c join qualification q where c.cid=q.cid;

select s.sid,r.cid,r.semester from registration r, student s where r.sid=s.sid and semester = 'I-2001';
select s.sid,cid,semester from registration r inner join student s on r.sid=s.sid and semester = 'I-2001';

select distinct fname from faculty f,qualification q where extract(year from date_qualified)=1995 and f.fid=q.fid;
select distinct fname from faculty f inner join qualification q on extract(year from date_qualified)=1995 and f.fid=q.fid ;

select cname,q.cid from faculty f, course c,qualification q where q.fid = f.fid and fname = 'Ama' and q.cid = c.cid order by cid desc;
select * from faculty f, course c,qualification q where q.fid = f.fid and fname = 'Ama' and q.cid = c.cid ;
select c.cid,cname from (faculty f inner join qualification q on f.fid=q.fid and fname='Ama')  inner join course c on c.cid=q.cid;


select distinct f.fid,fname from qualification q left outer join faculty f on q.fid=f.fid;
select distinct f.fid,fname from qualification q inner join faculty f on q.fid=f.fid;

select c.cname,c.cid,sname from course c, student s, registration r where r.sid=s.sid and c.cid=r.cid and sname like 'a%';



select f.fid,f.fname,cid from faculty f left outer join qualification q on f.fid=q.fid;
#vs
select q.fid,f.fname,cid from faculty f left outer join qualification q on f.fid=q.fid; # this returns null because q.cid is a composite primary key
select * from faculty;
select * from qualification;

#slide 19
select f.fid,f.fname,cname from (faculty f left outer join qualification q on f.fid=q.fid) left outer join course c on q.cid =c.cid;
select f.fid,f.fname,cname from (faculty f left outer join qualification q on f.fid=q.fid), course c where q.cid =c.cid;
select f.fid,f.fname,cname from (qualification q right outer join faculty f on f.fid=q.fid) left outer join course c on q.cid =c.cid;
select f.fid,fname,cname from faculty f left outer join (qualification q inner join course c on q.cid=c.cid) on f.fid=q.fid;

select f.fid,f.fname,cname from (faculty f right outer join qualification q on q.fid = f.fid) left outer join course c on q.cid =c.cid;
select * from faculty f left outer join qualification q on q.fid=f.fid;
select * from faculty f right outer join qualification q on q.fid=f.fid;

#########################
select f.fid,f.fname,count(q.cid) from faculty f left outer join qualification q on q.fid=f.fid group by f.fid,f.fname;

select s.sid,s.sname,count(cid) from student s left outer join registration r on s.sid = r.sid and semester = 'I-2002' group by s.sid,s.sname;

select c.cid,c.cname,count(sid) from course c left outer join registration r on c.cid=r.cid and semester ='I-2002' group by cid,cname;

#slide 23 -> Tricky
select * from course c,registration r where c.cid=r.cid and (cname ='Database' or cname ='Networking');
select r.sid from (registration r inner join course q on r.cid = q.cid and q.cname ='Database') inner join (registration r2 inner join course c on r2.cid = c.cid and c.cname ='Networking') on r.sid=r2.sid ;
select sid from  registration r, course c
where c.cid = r.cid
and cname in ('Database', 'Networking')
group by sid
having count(distinct c.cid) = 2;

select * from qualification;
select * from course;

#slide 24 -> Tricky
select fid from qualification q, course c where q.cid=c.cid and cname in ('syst design', 'syst analysis') group by fid having count(*) = 1;

select r1.sid,r1.cid as cid1, c1.cname as cname1,r2.cid as cid2,c2.cname as cname2 from registration r1 , registration r2,course c1,course c2 where r1.sid = r2.sid and r1.cid < r2.cid 
and c1.cid=r1.cid and c2.cid=r2.cid
and ((c1.cname='database' and c2.cname='networking') or (c1.cname ='networking' and c2.cname='database')); # displays a duplicated order

select q1.fid,q2.fid,c.cname from qualification q1,qualification q2,course c where q1.fid <q2.fid and q1.cid =q2.cid and q1.cid=c.cid and q2.cid = c.cid;

#slide 25 
select q1.fid as fid1, q2.fid as fid2, c.cname as cname from (qualification q1 inner join qualification q2 on q1.cid=q2.cid and q1.fid < q2.fid) inner join course c on q1.cid=c.cid ;
select * from qualification q1 inner join qualification q2 on q1.cid=q2.cid and q1.fid <> q2.fid;


select q1.fid, q2.fid, cname 
	from qualification q1, qualification q2, course c
    where q1.fid < q2.fid and q1.cid = q2.cid and q1.cid=c.cid;