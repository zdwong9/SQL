alter table REGISTRATION add final_mark decimal(5,2);

insert into COURSE values ('ISM 5555', 'Course 5');
insert into COURSE values ('ISM 6666', 'Course 6');
/*
signal sqlstate '45000'
                set message_text='Trigger Error: Student has taken 5 courses';
*/
###### 

#a)
select * from performance p, assessment a where a.aid=p.aid;

select sid,p.cid, sum(weight*mark) as totalMark from performance p,assessment a where a.aid=p.aid group by sid,cid;

delimiter $$
create procedure sp_get_SCfinalmarks(in studsid int, in regcid char(8),out finalmarks decimal(5,2) )
	begin
		set finalmarks = (select totalMark from (select sid,p.cid, sum(weight*mark) as totalMark from performance p,assessment a 
		where a.aid=p.aid group by sid,cid)
		as t1 where t1.sid = studsid and t1.cid=regcid);
	end $$ 
delimiter ;

drop procedure sp_populate_finalmarks;

call sp_get_SCfinalmarks(54907,'ISM 4930',@total);
select @total as marks;
#########################################################

select * from registration r limit 0;
(select cid from performance p,assessment a 
						where a.aid=p.aid group by sid,cid limit 1);
(select cid from ( select * from ((select cid from performance p,assessment a 
						where a.aid=p.aid group by sid,cid limit 5)) as t1) as t2 where t2.cid not in (select * from (
                        (select cid from performance p,assessment a 
						where a.aid=p.aid group by sid,cid limit 4
                        )
                        ) as t2)
            );
#b)
delimiter $$
create procedure sp_populate_finalmarks()
	begin
		declare currentMark decimal(5,2);
        declare iterator int;
        declare currentIterator int;
        declare currentSid int;
        declare currentCid char(8);
        declare previousIterator int;
        
        set currentIterator=1;
        set iterator= (select count(*) from (select sid,p.cid, sum(weight*mark) as totalMark from performance p,assessment a 
						where a.aid=p.aid group by sid,cid) as t1 );
                        
        while currentIterator <> iterator do
        
            SELECT SID, CID INTO currentSid, currentCid FROM REGISTRATION LIMIT 1 OFFSET currentIterator;
			call sp_get_SCfinalmarks(currentSid,currentCid,currentMark);

            update registration r set final_mark = currentMark where (r.sid=currentSid and r.cid=currentCid);
			#update registration r set final_mark = currentMark where (r.sid,r.cid) = (currentSid,currentCid);
                
            set currentIterator = currentIterator +1;
        end while;
        
    end $$
    
delimiter ;    

update registration r set final_mark = null where r.sid = 38214;
select * from registration;

drop procedure jingkai_sp_populate_finalmarks;
call jingkai_sp_populate_finalmarks();
select sid,p.cid, sum(weight*mark) as totalMark from performance p,assessment a 
						where a.aid=p.aid group by sid,cid;
 select * from registration r; 
 

 #####################################################
 
 /*
 3) Write a trigger ‘after_performance_update’ that executes after there is an update of marks on
performance table. When the marks of a student for a course in performance table is updated, the
final_mark should be updated for the corresponding student in REGISTRATION table. Use stored
procedure sp_get_SCfinalmarks in your trigger.
 */
 delimiter $$
create trigger after_performance_update after update on performance for each row
	begin
    declare newMark decimal(5,2);
    
	set newMark=(select totalMark from (select sid,p.cid, sum(weight*mark) as totalMark from performance p,assessment a 
						where a.aid=p.aid and p.sid=old.sid and p.cid=old.cid group by sid,cid) as t1);
	update registration r set final_mark=newMark  where sid=old.sid and cid=old.cid;
    end $$

delimiter ;

drop trigger after_performance_update;
select * from registration;
select * from performance;
select sid,p.cid, sum(weight*mark) as totalMark from performance p,assessment a 
						where a.aid=p.aid group by sid,cid;
select * from performance where sid=54907 and cid='ISM-1111';
select * from registration;
update performance set mark =5 where sid = 54907 and aid = 2 and cid='ISM-1111';
select totalMark from (select sid,p.cid, sum(weight*mark) as totalMark from performance p,assessment a 
						where a.aid=p.aid and p.sid=54907 and p.cid='ISM-1111' and p.aid=1 group by sid,cid) as t1;    
    
    
###################################
/*
Write a trigger ‘after_performance_delete’ that executes after a record is deleted from performance
table. Update the REGISTRATION table’s final_mark for the student and the course. Use
sp_get_SCfinalmarks in your trigger.
*/

delimiter $$    
create trigger after_performance_delete after delete on performance for each row
	begin
		declare newMark decimal(5,2);
    
		set newMark=(select totalMark from (select sid,p.cid, sum(weight*mark) as totalMark from performance p,assessment a 
						where a.aid=p.aid and p.sid=old.sid and p.cid=old.cid group by sid,cid) as t1);
	update registration r set final_mark=newMark  where sid=old.sid and cid=old.cid;
    end $$
    
delimiter ;

drop trigger after_performance_delete;
select * from registration;
select * from performance;
delete from performance where sid = 38214 and aid = 2 and cid='ISM 4212';
update performance set mark=0 where sid=38214 and cid='ISM 4212' and aid=1;
(select sid,p.cid, sum(weight*mark) as totalMark from performance p,assessment a 
						where a.aid=p.aid and sid =38214 and cid='ISM 4212'  group by sid,cid);
 (select sid,p.cid, sum(weight*mark) as totalMark from performance p,assessment a 
						where a.aid=p.aid group by sid,cid);                       
                        
######################################

/*
Write a trigger ‘after_performance_insert’ that executes after a new record inserted into performance
table. Update the REGISTRATION table’s final_mark for the student and the course for the new
assessment marks. Use sp_get_SCfinalmarks in your trigger
*/

delimiter $$    
create trigger after_performance_insert after insert on performance for each row
	begin
		declare newMark decimal(5,2);
    
		call sp_get_SCfinalmarks(new.sid,new.cid,newMark);
	update registration r set final_mark=newMark  where sid=new.sid and cid=new.cid;
    end $$
    
delimiter ;


insert into performance values (54907,'ISM-1111',1,1);
select * from performance;
select * from registration;

######################################

/*
Write a trigger ‘before_registration_insert’ that executes before a record is inserted into registration
table. Stop the insertion of the registration record if the student has already registered more than 5
courses for the semester. Display the error message “Insertion fail: Student has already registered for 5
courses for the semester”.
*/

delimiter $$    
create trigger before_registration_insert before insert on registration for each row
	begin
		declare myCount int;
        set myCount = (select count(*) as courseCount from registration r where r.sid = new.sid and  r.semester = new.semester group by sid,semester);
        
        if myCount>4 then
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT
					= 'Insertion fail: Student has already registered for 5
			courses for the semester';
        end if;
    end $$
    
delimiter ;
drop trigger before_registration_insert;
select * from registration;
select count(*) as courseCount from registration r  group by sid,semester;
insert into registration values(54907,'ISM-1112','I-2001',null);
delete from registration where (sid,cid,semester) = (54907,'ISM-1112','I-2001') ;

/*
Write a stored procedure that takes in an integer say n. The stored procedure should list all the faculty
whose qualification is more than n years old. The stored procedure is expected to list the FID, FName,
CID, number of years since the "qualification certificate" was obtained (ignoring the actual month the
qualification was obtained in).
*/
delimiter $$
create procedure list_n (in nYear int)                        
	begin
select f.fid,fname,cid,(extract(year from now()) - extract(year from date_qualified)) as year from faculty f, qualification q where f.fid=q.fid and extract(year from date_qualified)<extract(year from now()) - nYear;                        
    end $$
    
delimiter ;
                        
select * from faculty f, qualification q where f.fid=q.fid;
select f.fid,fname,cid,(extract(year from now()) - extract(year from date_qualified)) as year from faculty f, qualification q where f.fid=q.fid and extract(year from date_qualified)<extract(year from now()) - 5;                        
select * from faculty f, qualification q where f.fid=q.fid and extract(year from date_qualified)<extract(year from now()) - 22;                        

call list_n(22);
                        
 /*
 Given CID, semester and an integer say n as input parameters, write a stored procedure that lists the
students’ SID and their corresponding final mark for the top n ranked final mark in the descending
order of their final mark for the given course CID. Students with the same marks are ranked at the
same position. If there are more than one student with the same minimum final mark at position n (or
better, n-1 to 1), these students’ SID are to be returned (Hint: Use clause limit offset)
 */
 delimiter $$
 create procedure query_N(in iCid char(8),in cSemester char(6), in n int)
	begin
		declare minMark decimal(5,2);
        declare nDec int;
        
        set nDec= n -1;
        set minMark =  (select distinct(final_mark) from  registration r where semester=cSemester and cid=iCid order by final_mark  
						 desc limit 1 offset nDec);
         select sid,final_mark from registration r where cid=iCid and semester=cSemester and final_mark>=minMark order by final_mark desc;         
    end $$
 delimiter ;
 
 
 
 
 drop procedure query_n;
 call query_N('ISM 3112','I-2001',2);
 select distinct(final_mark) from  registration r where semester='I-2001' and cid='ISM 3112' order by final_mark  
						 desc limit 1 offset 0;
                         select * from registration r where semester='I-2001' and cid='ISM 3112';
select * from registration;
insert into registration values (38214,'ISM 3112','I-2001',69.9);
 select sid,final_mark from registration r where cid in (select cid from (select cid, max(final_mark) as maxMark from registration r
         where semester='I-2001' and cid='ISM 3112' group by cid) as t1 where final_mark>minMark 
         ) and final_mark>=minMark;  
 select * from ( select cid, max(final_mark) as maxMark from registration r where semester='I-2001' and cid='ISM 4212' group by cid ) as t1 where maxMark>=10;
 select cid, max(final_mark) as maxMark from registration r where semester='I-2001' and cid='ISM 4212' group by cid ;
 select * from registration r;
 select sid,cid, sum(weight*mark) as final from performance p,assessment a where p.aid=a.aid and cid='ISM 3113' group by sid,cid order by final desc limit 1;
  select cid, max(final_mark) as maxMark from registration r group by cid ;
 
 select distinct(maxMark) from (select cid, max(final_mark) as maxMark from registration r where semester=cSemester and cid = iCid group by cid) as t1 order by maxMark desc limit 1 offset 3;
 
 /*
 Write a stored procedure that lists the student(s) SID who has scored the best (mark) for the given
input parameters: semester, course CID and assessment AID. If the input parameter for AID has the
value -1, the stored procedure is expected to list the student(s) SID with the best final mark which is
based on all assessments of the given course. List the best student(s) SID and his best assessment mark
(or best final mark). If there are more than one student with the best assessment mark (or best final
mark), all these students’ SID are to be returned.
 */
 delimiter $$
 create procedure query_Best(in iSem char(6),in iCid char(8),in iAid int)
	begin
    declare minMark decimal(5,2);
		if iAid = -1 then
            call query_N(iCid,iSem,1);
		else 
            set minMark =  (select distinct(mark) from  performance p,registration r where p.sid=r.sid and p.cid=r.cid and semester=iSem and p.cid=iCid and p.aid=iAid order by mark  
						 desc limit 1 offset 0);
			select p.sid,mark from performance p,registration r where p.sid=r.sid and r.cid=p.cid and p.aid=iAid and mark = minMark;
        end if;
    
    end$$
 
 delimiter ;
 drop procedure query_best;
 call query_Best('I-2001','ISM 3112',2);
 select * from registration r;
 select * from performance p,registration r where p.sid=r.sid and r.cid=p.cid;
 
 /*
Given a semester as input parameter, write a stored that lists all faculty who are qualified to teach at
least 2 courses for which there are registrations in that semester. The stored procedure is expected to
list FID and the number of courses (2 or more) he is qualified to teach in the given semester. The
stored procedure should also return the number of faculty members who are not qualified to tea ch a
minimum of 2 courses in that semester (as an out parameter).	
 */
 delimiter $$
 create procedure listFaculty(in iSem char(6),out Total int)
	begin
    declare totalFaculty int;
    
    set totalFaculty=(select count(*) from faculty f);
		
 select fid,count(distinct r.cid) as courseCanTeach from registration r,qualification q where q.cid=r.cid and semester= iSem group by fid having count(distinct r.cid) > 1;
	set Total = totalFaculty - (select count(*) from (select fid,count(distinct r.cid) as courseCanTeach from registration r,qualification q where q.cid=r.cid and semester= iSem group by fid having count(distinct r.cid) > 1) as t1);
    end $$
 
 delimiter ;

drop procedure listFaculty;
(select count(*) from faculty f);
 call listFaculty('I-2001',@total);
 select @total;
select * from registration r,qualification q where q.cid=r.cid order by fid,semester;
 select fid,count(distinct r.cid) from registration r,qualification q where q.cid=r.cid and semester= 'I-2001' group by fid having count(distinct r.cid) > 1;
 select r.cid from registration r,qualification q where q.cid=r.cid and semester= 'I-2001' group by r.cid,fid having count(distinct r.cid)>1;
 select fid,semester,q.cid from qualification q,registration r where q.cid=r.cid order by fid,semester;
 select fid,semester,count(distinct q.cid) from registration r,qualification q where q.cid=r.cid group by fid,semester;
 select * from registration r;
 select r.cid from registration r,qualification q where q.cid=r.cid and semester= 'I-2001' group by fid having count(*)>1;
 
 select fid from qualification q where cid in ( select r.cid from registration r,qualification q where q.cid=r.cid and semester= 'I-2001' group by r.semester,r.cid having count(distinct fid)>1 ) group by fid having count(*)>1;
 
 
 
 
 