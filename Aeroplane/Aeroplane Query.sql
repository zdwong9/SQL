/*
	qn1
*/

alter table employee modify column speaircraft int;

insert into employee(eid,ename,salary,speaircraft) values 
(5,'Daniel',85000,null);

select*from employee;

update employee set ename='Jacob' where ename='jacob';

alter table employee add constraint employee_fk foreign key(speaircraft) references aircraft(aid);

/*
	q2
*/

select eid from certified where aid =1 or extract(year from certdate) = 2003;
select * from certified;

/*
	q3
*/
### answer
select fly_to as destination from flight order by destination desc;
select * from flight;

/*
	q4
*/
## answer
select eid from employee where salary>= 70000 and salary <=100000;
select * from employee;

/*
	q5
*/

select max(cruisingrange) from aircraft;
select min(cruisingrange) from aircraft;

### answer
select * from (select max(cruisingrange) from aircraft) as t1,(select min(cruisingrange) from aircraft) as t2;

/*
	q6
*/

### select pilot
select * from certified;


## answer
select e.eid,e.salary,c.aid from employee e left outer join certified c on c.eid=e.eid;

/*
	q7
*/

select * from flight;

### answer
select f.fly_from,f.fly_to,min(f.price) from flight f group by fly_from,fly_to;

/*
	q8
*/

select * from employee;
select aid from aircraft where cruisingrange>1000;

select avg(salary) from employee where eid in (select distinct eid from certified where aid in
(select aid from aircraft where cruisingrange>1000));

### answer
select e.ename,e.salary from employee e where e.eid not in (select distinct eid from certified) and 
e.salary> 
(select avg(salary) from employee where eid in (select distinct eid from certified where aid in
(select aid from aircraft where cruisingrange>1000)));

/*
	q9
*/

select eid,count(distinct aid) as numberOfAeroplane from certified group by eid having numberOfAeroplane>=2 ;

select eid,min(cruisingrange) from certified c,aircraft a where c.eid in (select eid from certified group by eid having count(distinct aid) >=2 ) and 
c.aid=a.aid 
group by eid;

/*
	q10
*/

select c.eid from aircraft a,certified c where a.aid=c.aid and aname like '%b%';

select e.ename,a.aname,c.certdate from (aircraft a inner join certified c on a.aid=c.aid and aname like '%b%')
inner join employee e on e.eid=c.eid;

/*
	q11
*/

select min(price) from flight f where fly_from='LA' and fly_to='SF';

select e.ename from employee e where e.salary< (select min(price) from flight f where fly_from='LA' and fly_to='SF');

/*
	q12
*/

select eid from employee e where ename ='jacob';

select aid from certified c where eid = (select eid from employee e where ename ='jacob')
group by aid having count(distinct eid) =1;

/*
	q13
*/

select distinct(c.eid) from certified c,employee e where c.eid=e.eid and e.salary >=60000 and e.salary<=85000;

select count(*) from (select distinct(c.eid) from certified c,employee e where c.eid=e.eid 
and e.salary >=60000 and e.salary<=85000) as t1;

select c.aid from certified c 
where c.eid in (select distinct(c.eid) from certified c,employee e where 
c.eid=e.eid and e.salary >=60000 and e.salary<=85000)
group by aid
having count(distinct c.eid)= (select count(*) from (select distinct(c.eid) from certified c,employee e 
where c.eid=e.eid and e.salary >=60000 and e.salary<=85000) as t1)
;

##### answer
select aname from aircraft where aid in (select c.aid from certified c 
where c.eid in (select distinct(c.eid) from certified c,employee e where 
c.eid=e.eid and e.salary >=60000 and e.salary<=85000)
group by aid
having count(distinct c.eid)= (select count(*) from (select distinct(c.eid) from certified c,employee e 
where c.eid=e.eid and e.salary >=60000 and e.salary<=85000) as t1));

/*
	q14
*/

select e.salary,e.ename from employee e where e.salary>70000;

select distiance from flight f where flno=3;

select aid from aircraft a where a.cruisingrange > 
(select distiance from flight f where flno=3);

select * from certified c,aircraft a where a.aid in (select aid from aircraft a where a.cruisingrange > 
(select distiance from flight f where flno=3)) and c.aid = a.aid;

select distinct(c.eid) from certified c where aid in(select aid from aircraft a where a.cruisingrange > 
(select distiance from flight f where flno=3)) 
and 
eid in (select distinct(c.eid) from certified c,aircraft a where a.aid in (select aid from aircraft a where a.cruisingrange > 
(select distiance from flight f where flno=3)) and c.aid = a.aid);


select e.eid,e.ename from employee e where 
eid in 
(select distinct(c.eid) from certified c where aid in(select aid from aircraft a where a.cruisingrange > 
(select distiance from flight f where flno=3)) 
and 
eid in (select distinct(c.eid) from certified c,aircraft a where a.aid in (select aid from aircraft a where a.cruisingrange > 
(select distiance from flight f where flno=3)) and c.aid = a.aid))
;

/*
	q15
*/

select aid from aircraft a where aname like'%b%';

select aid from aircraft a where aid not in (select aid from aircraft a where aname like'%b%')
and cruisingrange>1000
;

select distinct(ename) from employee e, aircraft a,certified c where 
c.eid=e.eid and a.aid=c.aid
and
a.aid in (select aid from aircraft a where aid not in (select aid from aircraft a where aname like'%b%')
and cruisingrange>1000);

/*
	q16
*/

select certdate from certified c where extract(year from certdate)>0;

select extract(year from certdate) as theYear,count(*) as numberOfCert from certified c group by theYear;

select extract(year from certdate) as theYear,count(*) as numberOfCert from certified c group by extract(year from certdate)
having numberOfCert = 
(select max(numberOfCert) from 
(select count(*) as numberOfCert from certified c group by extract(year from certdate)) as t1)
;

/*
	q17
*/

select flno,aid from flight f,aircraft a  where a.CRUISINGRANGE>=f.Distiance ;

select flno,e.ename as hisName ,e.eid as hisID ,min(salary) as theirSalary from (certified c inner join ((select flno,aid from flight f,aircraft a  
where a.CRUISINGRANGE>=f.Distiance order by flno asc)
)  as t1 on t1.aid=c.aid) inner join 
(employee e) on e.eid=c.eid group by flno,e.eid,e.ename order by flno;

select flno,min(salary) as theirSalary from (certified c inner join ((select flno,aid from flight f,aircraft a  
where a.CRUISINGRANGE>=f.Distiance order by flno asc)
)  as t1 on t1.aid=c.aid) inner join 
(employee e) on e.eid=c.eid group by flno order by flno;

select t2.flno,t2.theirSalary,t2.hisName from (select flno,e.ename as hisName ,e.eid as hisID ,min(salary) as theirSalary from (certified c inner join ((select flno,aid from flight f,aircraft a  
where a.CRUISINGRANGE>=f.Distiance order by flno asc)
)  as t1 on t1.aid=c.aid) inner join 
(employee e) on e.eid=c.eid group by flno,e.eid,e.ename order by flno) as t2 inner join employee e on t2.hisID=e.eid
and (t2.flno,t2.theirSalary) in 
(select flno,min(salary) as theirSalary from (certified c inner join ((select flno,aid from flight f,aircraft a  
where a.CRUISINGRANGE>=f.Distiance order by flno asc)
)  as t1 on t1.aid=c.aid) inner join 
(employee e) on e.eid=c.eid group by flno order by flno);




/*
	q18
*/

select flno,min(cruisingrange) as minRange from flight f,aircraft a  where a.CRUISINGRANGE>=f.Distiance group by flno
order by flno;

select flno,aid,min(cruisingrange) as minRange from flight f,aircraft a  where a.CRUISINGRANGE>=f.Distiance 
group by flno,aid
order by flno;

select flno,t2.aid as AicraftID from (select flno,aid,min(cruisingrange) as minRange from flight f,aircraft a  where a.CRUISINGRANGE>=f.Distiance 
group by flno,aid
order by flno) as t2 where (flno,minRange)
in
(select flno,min(cruisingrange) as minRange from flight f,aircraft a  where a.CRUISINGRANGE>=f.Distiance group by flno
order by flno);

select * from certified c;

select aid,count(distinct eid) as certifiedCount from certified c group by aid;

select flno,t3.AicraftID,certifiedCount from ((select flno,t2.aid as AicraftID from 
(select flno,aid,min(cruisingrange) as minRange from flight f,aircraft a  where a.CRUISINGRANGE>=f.Distiance 
group by flno,aid
order by flno) as t2 where (flno,minRange)
in
(select flno,min(cruisingrange) as minRange from flight f,aircraft a  where 
a.CRUISINGRANGE>=f.Distiance group by flno
order by flno)) as t3 left outer join (select aid,count(distinct eid) as certifiedCount 
from certified c group by aid)
 as t4 on t4.aid=t3.AicraftID);

################################
/*
	q19
*/

delimiter $$
create trigger after_update_certified after update on certified 
for each row
	begin
		declare newSalary int;
        declare aircraftRange int;
        
        set aircraftRange = (select cruisingrange from aircraft where aid=old.aid);
        if aircraftRange>1200 then  
        set newSalary = (select salary from employee e where 
							e.eid=old.eid) + 200;
        update employee set salary=newSalary where eid=old.eid;
        end if;
    end$$;
    
delimiter ;

drop trigger after_update_certified;

################################
/*
	q20
*/
select eid,min(salary) as theSalary from employee e 
where eid in(select distinct eid from certified where aid=1)
group by eid ;
select min(theSalary) from (select eid,min(salary) as theSalary from employee e 
where eid in (select distinct eid from certified where aid=iAircraftAid)
group by eid ) as t1;

##### Answer
create procedure sp_Aircraft_Pilots (in iAircraftAid int,out total int)
		select eid,ename from employee e where eid in (select distinct eid from certified where aid=iAircraftAid) and salary =
        (select min(theSalary) from (select eid,min(salary) as theSalary from employee e 
where eid in (select distinct eid from certified where aid=iAircraftAid)
group by eid ) as t1);
        
call sp_Aircraft_Pilots(1,@total);
