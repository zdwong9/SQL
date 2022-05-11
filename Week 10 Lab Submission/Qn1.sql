/*
	Qn1 

*/


delimiter $$
create procedure sp_count_accounts(in iCustName varchar(8),out iSavingAcct int ,out iFixedDeposit int)
		begin
            set iSavingAcct = (select count(*) from account a where a.cus_name = iCustName and acc_type = 'SA');
            
            set iFixedDeposit = (select count(*) from account a where a.cus_name = iCustName and acc_type = 'FD');
            
        end $$


delimiter ;


drop procedure sp_count_accounts;

call sp_count_accounts('Alex',@SA,@FD);
select @SA as savings, @fd as 'Fix Deposit';