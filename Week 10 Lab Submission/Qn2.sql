/*
	Qn2
    Create a trigger that fires when a customer makes a transaction i.e. deposits or withdraws
	amount. The trigger should update the balance column for the corresponding account
	(acc_num).
	When an amount is deposited into an account, the balance of the corresponding account
	number should increase by that amount in the Account table.
	Similarly, when an amount is withdrawn, the balance of the corresponding account number
	should decrease by the withdrawal amount
*/

delimiter $$
create trigger after_transactions_insert after insert on transactions
for each row
	begin
        declare newBalance decimal(10,2);
        declare updateBalance decimal(10,2);
        
        set newBalance = (select balance from account where acc_num=new.acc_num and acc_type='SA');
        
		if new.trans_type ='D' then 
			set newBalance = newBalance + new.amount;
        else 
			set newBalance = newBalance - new.amount;
        end if; 
        
        update account set balance=newBalance where acc_num= new.acc_num and acc_type='SA'; 
    end $$;
	
delimiter ;

drop trigger after_transactions_insert;

INSERT INTO TRANSACTIONS(ACC_NUM, AMOUNT, TRANS_TYPE)
VALUES ('A1',200, 'D');
INSERT INTO TRANSACTIONS(ACC_NUM, AMOUNT, TRANS_TYPE)
VALUES ('A1',100, 'W');

select * from account a;
select * from transactions where acc_num = 'A1';