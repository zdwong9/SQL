/*
Trigger Name:
Before_TableName_Insert

CREATE TRIGGER trigger_name trigger_time  trigger_event  
ON table_name FOR EACH ROW 
trigger_body

1. Trigger Time: Before/After -> Before
2. Trigger Event: Insert/Update/Delete -> Insert
3. Whcih table? Registration

 
*/
delimiter $$
	create trigger before_registration_insert 
	before insert on registration for each row
		begin
			declare cnt int;
            
            set cnt= (select count(*) from registration 
            where sid = new.sid and semester =new.semester);
            
            if cnt=5 then
				signal sqlstate '45000'
                set message_text='Trigger Error: Student has taken 5 courses';
            end if;
		
		
		end $$
        
delimiter ;

select * from registration;
select * from course;
insert into course  values ('ISM-1111','Test Course ');
insert into course  values ('ISM-1112','Test Course ');
insert into registration values (54907,'ISM-1111','I-2001');
insert into registration values (54907,'ISM-1112','I-2001');















