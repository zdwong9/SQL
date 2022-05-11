use ice4;

insert into student(sid,sname) values(65798,'Lopez');
select * from student;

delete from student where sid =65798;

update faculty set fname='Collin' where FID = 4756;
select * from faculty;

select aname from assessment where weight >0.3;

select sid,sname from student where sid <50000;

select fname from faculty where fid=4756;

select fid,cid,date_qualified from qualification where extract(year from date_qualified) >=1993;

select fname from faculty where fname like '%a%';

select cid,cname from course where cid like 'ISM%';

select sid,min(mark) from performance where sid = 54907;

#k)
select count(distinct sid) from registration where cid = 'ISM 4212';

#l)
select count(*) from registration where semester = 'i-2002';

#m)
select fid from qualification where cid in ('ISM 3112','ISM 3113') and extract(month from date_qualified)=9;
select * from qualification;

#n)
select distinct cid from registration where semester = 'I-2001';

#o)
select sid,sname from student order by sname asc;

#p)
select sid,max(mark) as 'Maximum Mark' from performance group by sid;

#q)
select type, count(rid) as 'Number of Rooms as type' from room group by type;
select * from room order by type;

#r)
select cid,count(fid) as 'Number of People that teaches' from qualification group by cid;
select * from qualification order by cid;

#s)
select sid,count(cid) as 'Number of courses taken' from registration group by sid;
select sid,cid from registration order by sid;

#t)
select aid, min(mark) as 'Minimum Mark',max(mark) as 'Maximum Mark',avg(mark) as 'Average Mark' from performance where cid = 'ISM 4212' group by aid;
select * from performance where cid = 'ISM 4212' order by aid;

#u)
select cid,aid,min(mark) as 'Minimum Mark',max(mark) as 'Maximum Mark',avg(mark) as 'Average Mark' from performance
group by cid,aid;

#v) 
select cid,aid,min(mark) as 'Minimum Mark',max(mark) as 'Maximum Mark',avg(mark) as 'Average Mark' from performance
group by cid,aid having cid !='ISM 4212';
select cid,aid,min(mark) as 'Minimum Mark',max(mark) as 'Maximum Mark',avg(mark) as 'Average Mark' from performance
where cid !='ISM 4212' group by cid,aid ;

#w)
select cid, count(distinct fid) as People_that_teaches from qualification group by cid having People_that_teaches>=2; 
select * from qualification order by cid;
