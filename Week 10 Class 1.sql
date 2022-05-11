delimiter $$
	create procedure getSex()
	begin
		#DECLARING VARIABLES
        declare cnt int;	#local variables
        declare test=char;
        
        declare @total int; #user defined
        
        set cnt=1;
        set cnt=(select count(*) from student);
        
        -- select (count*) into cnt from
-- 		Multiple SQL statement;
		
	End $$
delimiter ;


create procedure getAccount()
    select * from account;
;
drop procedure getCourse;

## Call Stored Procedure
Call getAccount();

# Create Store Procedure with input and output
create procedure getBalance(in cACCNUM varchar(8))
	select balance into @Total from account where ACC_NUM = cACCNUM;
drop procedure getBalance;

call getBalance('A1');
select @Total;


















