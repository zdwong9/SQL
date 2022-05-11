#create a stored procedure that returns the sum of top X unique marks of a particular course, where X is an integer;

##### Not completed

create procedure getSum(IN iNum int,IN iCID,Out )
	select t1.marks from (select sid,cid,sum(mark*weight) as marks from performance p,assessment a where a.aid=p.aid group by sid,cid order by marks desc) as t1
	order by t1.marks desc limit iNUM  ;
	 
drop procedure getSum;
select * from performance p, assessment a where a.aid=p.aid;


call getSum(5);   

select sid,cid,sum(mark*weight) as marks from performance p,assessment a where a.aid=p.aid group by sid,cid order by marks desc;