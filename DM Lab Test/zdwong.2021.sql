# Name: Wong Zheng Da (ID: zdwong.2021)


#q1

select nric,name,dob from driver order by name desc;

#q2

select cardid,balance,expiry from citylink where year(expiry) = 2021;

#q3

select * from stoppair where basefee >3;

#q4
select stopid,address from stop where address like '%rd';

#q5


select * from citylink where (type='Student' or type ='Senior') and oldcardid is null ;

#q6
select company,count(*) from company group by company having count(*) > 4;

#q7#################################

select d.did,name,plateno from driver d left outer join bustrip b1 on b1.did=d.did;

#q8##############################3

select count(*) from stoppair sp3 where (sp3.fromstop,sp3.tostop) not in 
(select sp1.fromstop as thisStop, sp1.toStop as thatStop from stoppair sp1,stoppair sp2 where sp1.fromstop=sp2.tostop and sp1.tostop=sp2.fromstop);

#q9

select did,count(distinct oid) as OffenceCount from offence o,bustrip b1 where b1.sid=o.sid and b1.tdate=o.sdate and b1.starttime=o.stime group by did having OffenceCount =
(select max(offencecount) from (select did,count(distinct oid) as OffenceCount from offence o,bustrip b1 where b1.sid=o.sid and b1.tdate=o.sdate and b1.starttime=o.stime group by did) as t1)
;

#10
select c.cardid,count(oid) as OffenceCount,count(*) as RideCount from citylink c left outer join offence o on c.cardid=o.paycard left outer join ride r on r.cardid=c.cardid group by c.cardid;

#q11

select * from (select stopid,count(sid) as ServiceCount from stoprank sr1 group by stopid having ServiceCount>=2) as t1 where 
(stopid,servicecount) in 
	(
		select sr1.stopid,count(distinct company) from (select stopid from stoprank sr1 group by stopid having count(*)>=2) as t2, stoprank sr1,company c where t2.stopid=sr1.stopid and c.sid=sr1.sid group by sr1.stopid
	)
;






#q12

select r.cardid,round(sum(basefee-(basefee*discount)),2) as totalFare from (ride r left outer join (select sid,stopid as updatedStop from stoprank sr1 where (sid,rankorder) in (select sid,max(rankorder) from stoprank group by sid)) as t2 on t2.sid=r.sid) ,
stoppair sp1,citylink c,cardtype ct where r.cardid=c.cardid and ifnull(alightstop,updatedstop) and alightstop=sp1.tostop and boardstop=sp1.fromstop and ct.type = c.type 
and r.cardid in(select c.cardid from citylink c,ride r where r.cardid=c.cardid group by c.cardid having count(*) >=1 ) 
group by cardid
;

#q13

delimiter $$
create trigger afterUpdatePayCard after update on offence for each row
	begin
		declare leftover float;
        declare msg_txt varchar(100);
        
        set leftover= (select balance from citylink where cardid=new.paycard);
        
		if leftover< new.penalty then 
			signal sqlstate '45000' set message_text ='insufficient balance to cover the penalty';
            
		elseif old.paycard is not null then
			set msg_txt= concat('Offence has already been paid with Cardid ',old,paycard); 
				signal sqlstate '45000' set message_text = msg_txt;
				
                
        end if;
        
    end $$
delimiter ;


#q14

delimiter $$
create procedure checkDirectService(in stopA int , in stopB int,out NumOfDirectService int, out ExpressServiceExist char(3))
	begin
		
        declare NumofExpressService int;
        
		set NumOfDirectService = (select count(*) from stoprank sr1,stoprank sr2 where sr1.stopid=stopa and sr2.stopid=stopb and sr1.sid=sr2.sid );
        
        set NumofExpressService = (select count(*) from (select sr1.stopid as stopid1,sr2.stopid as stopid2,sr1.sid from stoprank sr1,stoprank sr2 where sr1.stopid=3011 and sr2.stopid=13021 and sr1.sid=sr2.sid) as t1,express e where e.sid = t1.sid);

		if NumofExpressService>= 1 then
			set ExpressServiceExist='Yes';
        else 
			set ExpressServiceExist='No';
		end if;
	end $$
delimiter ;



call checkDirectService(3011,13021,@Number,@ExpressExist);

