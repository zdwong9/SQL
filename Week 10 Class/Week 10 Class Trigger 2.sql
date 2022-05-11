/*
	Trigger 
		Create a trigger to validate insertion data of Performance record,
        such that total assessment weightage taken by the student for that particular course
        does not exceed 100%
*/
delimiter $$
	create trigger before_performance_insert 
	before insert on performance for each row
		begin
			declare mrk int;
            declare weightage int;
            declare msgTxt varchar(100);
            
            set mrk= (select sum(mark*weight) from assessment a,performance p where p.aid=a.aid and p.sid = new.sid and p.cid = new.cid group by sid,cid);
            
            set weightage = (select weight from assessment a where a.aid=new.aid) * mrk;
            
            set mrk = weightage+mrk;
            
            if mrk>100 then
				set msgTxt = concat('Trigger Error: Invalid Insertion, weightage would exceed 100% of the New Value',mrk);
				
				signal sqlstate '45000'
                set message_text='Trigger Error: Total Weightage is more than 100';
            end if;
		
		
		end $$
        
delimiter ;

drop trigger before_performance_insert;

insert into assessment values (4,'Quiz1',0.15),(5,'Quiz2',0.15);
Insert into assessment values (4, 'Quiz1', 0.15);
Insert into assessment values (5, 'Quiz2', 0.15);



select * from performance where sid = 54907 and cid = 'ISM 4212';
insert into performance values (54907,'ISM 4212',4,86);
insert into performance values (54907,'ISM 4212',5,81);
select * from performance;
Insert into performance values (54907, 'ISM 4212', 4, 86);
Insert into performance values (54907, 'ISM 4212', 5, 81);












