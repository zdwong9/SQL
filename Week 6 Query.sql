use ice4;

select * from student where sid <50000;

# selecting qualifications where date_qualified > 1995 
select * from qualification where date_qualified > '1995-00-00';
select * from qualification where extract(year from date_qualified )>= 1995;
select * from qualification where date_qualified like '1995-__-__%';

###select from faculty where those whose name contains a 
select fname from faculty where fname like '%a%';

### select FID and date_qualified from qualifications where those who are qualified to teach ISM 3112 or 3113 with the corresponding qualified data falling in september
select fid,date_qualified from qualification where (cid = 'ISM 3112' or cid ='ISM 3113') and date_qualified like '%____-09-__%';
select fid,date_qualified from qualification where cid in ('ISM 3112','ISM 3113') and date_qualified like '%____-09-__%';

select count(*) as 'number of students' from registration where cid ='ISM 4212' and semester = 'i-2001';

select count(distinct sid) as 'TotalNumber' from registration where semester='I-2001';

select fid, count(distinct cid) as 'CoursesCanTeach' from qualification group by fid;
select sid, count(distinct cid) as 'CoursesTaken' from registration group by sid;
select sid,semester, count(distinct cid) as 'CoursesTaken' from registration group by sid,semester;

select extract(year from date_qualified) as Year,count(*) from qualification group by year ;

select type,count(*) as 'TotalCount' from room group by type;

# Return those room types with at least 2 rooms
select type, min(capacity),max(capacity) from room group by type;

