/*
	q3
	Create a trigger that fires when a customer requests to close his / her account.
	This trigger will run whenever there is a delete action on account table.
	The trigger has to
	a. Delete all transaction records from transactions table of the account to be closed.
	b. Insert a copy of the deleted account record to an audit table 'deleted_accounts'. The
	column 'closed_date' in 'deleted_accounts' must have the value of the system date time
	related to the time when the account is closed (i.e. account deleted from ACCOUNT
	table).
	Hint: make use of the function now() to get the current datetime
*/

delimiter $$
create trigger before_account_delete before delete on account
for each row
		begin
        declare oldAccType char(2);
        declare oldCusName varchar(45);
        declare oldBalance decimal(10,2);

        insert into deleted_accounts values (old.acc_num,old.Acc_Type,old.Cus_Name,old.Balance,now());
        delete from transactions where acc_num=old.acc_num;

		end $$;
delimiter ;


INSERT INTO ACCOUNT VALUES ('ZZ', 'FD', 'DUMMY', 200);
INSERT INTO TRANSACTIONS(ACC_NUM, AMOUNT, TRANS_TYPE)
VALUES('ZZ', 888.88, 'D');
DELETE FROM ACCOUNT WHERE ACC_NUM = 'ZZ';
select * from account;
select * from deleted_accounts;



delete from account where acc_num ='';