 
 delimiter $$
 create procedure normalEXORexpress()
	begin
		#select distinct(NormalBusPlateNo) as PlateNo from (select bt.PlateNo as NormalBusPlateNo from (select n.sid from normal n) as t1 inner join bustrip bt on t1.sid = bt.sid) as t3, (select bt.PlateNo as ExpressBusPlateNo from (select e.sid from express e) as t2 inner join bustrip bt on t2.sid = bt.sid) as t4 where t3.NormalBusPlateNo=t4.ExpressBusPlateNo;
		
    end $$ 
 delimiter ;

call normalexorexpress;

#select distinct(PlateNo) from (select bt.PlateNo as PlateNo from (select e.sid from express e) as t2 inner join bustrip bt on t2.sid = bt.sid union all select bt.PlateNo as PlateNo from (select n.sid from normal n ) as t1 inner join bustrip bt on t1.sid = bt.sid) as t3 where t3.PlateNo not in (select distinct(NormalBusPlateNo) as PlateNo from (select bt.PlateNo as NormalBusPlateNo from (select n.sid from normal n) as t1 inner join bustrip bt on t1.sid = bt.sid) as t3, (select bt.PlateNo as ExpressBusPlateNo from (select e.sid from express e) as t2 inner join bustrip bt on t2.sid = bt.sid) as t4 where t3.NormalBusPlateNo=t4.ExpressBusPlateNo);

 delimiter $$
 create procedure normalORexpress()
	begin
		#select distinct(PlateNo) from (select bt.PlateNo as PlateNo from (select e.sid from express e) as t2 inner join bustrip bt on t2.sid = bt.sid union all select bt.PlateNo as PlateNo from (select n.sid from normal n ) as t1 inner join bustrip bt on t1.sid = bt.sid) as t3 where t3.PlateNo not in (select distinct(NormalBusPlateNo) as PlateNo from (select bt.PlateNo as NormalBusPlateNo from (select n.sid from normal n) as t1 inner join bustrip bt on t1.sid = bt.sid) as t3, (select bt.PlateNo as ExpressBusPlateNo from (select e.sid from express e) as t2 inner join bustrip bt on t2.sid = bt.sid) as t4 where t3.NormalBusPlateNo=t4.ExpressBusPlateNo);
		
    end $$ 
 delimiter ;
 
delimiter $$
 create procedure noOfOffencesEachOfficer()
	begin
		#select oid,o.name,count(*) from offence,officer o where o.officerid=offence.oid group by oid,o.name;
		
    end $$ 
 delimiter ;
 
delimiter $$
 create procedure connectedBuses()
	begin
			#select sr1.sid,sr2.sid,count(*) as connectedStops from stoprank sr1,stoprank sr2 where sr1.stopid=sr2.stopid and sr1.sid<sr2.sid group by sr1.sid,sr2.sid having count(*)>5;
		
    end $$ 
 delimiter ;
select sr1.sid,sr2.sid,count(*) as connectedStops from stoprank sr1,stoprank sr2 where sr1.stopid=sr2.stopid and sr1.sid<sr2.sid group by sr1.sid,sr2.sid having count(*)>5;

select * from stoprank sr1,stoprank sr2 where sr1.sid = 16 and sr2.sid= 77 and sr1.stopid=sr2.stopid order by sr1.rankorder,sr2.rankorder;

delimiter $$
 create procedure currentAdultPreviousStudent()
	begin
		#select * from citylink c where oldcardid in (select cardid as OldCard from citylink c where cardid in (select oldcardid from citylink c where oldcardid is not null and c.type ='Adult') and c.type='Student');
		
    end $$ 
 delimiter ;
 
 delimiter $$
 create procedure availabilityDateTime()
	begin
		#select * from bustrip where month(tdate)=6 and year(tdate)=2020 and hour(starttime)>=0 and hour(starttime)<=7;
		
    end $$ ;
 delimiter ;

 delimiter $$
create procedure noOfPassengers()
	begin
		#select b.sid,tdate,starttime,count(*) as passengers from ride r,bustrip b where boardtime>=b.starttime and alighttime <= b.endtime and rdate=b.tdate group by b.sid,tdate,starttime;
		
    end $$ ;
delimiter ;

delimiter $$

create procedure expiredNotReplaced()
	begin
		#select * from citylink where expiry < now() and cardid not in (select oldcardid from citylink where oldcardid is not null);
		
    end $$ ;
delimiter ;

delimiter $$
create procedure currentUsersByType()
	begin
		#select type,count(*) from citylink where expiry >= now() and cardid not in (select oldcardid from citylink where oldcardid is not null) group by type;
    end $$ ;
delimiter ;


delimiter $$
create procedure oldCardNewCardBalances()
	begin
		#select t1.cardid as currentCardID,t1.balance as currentBalance,c.balance as oldBalance,c.cardid as oldCardID from citylink c inner join (select cardid,balance,oldcardid from citylink where oldcardid is not null) as t1 on c.cardid=t1.oldcardid;
    end $$ ;
delimiter ;


delimiter $$
create procedure noOfPassengersForEachRideAndDate()
	begin
		#select b.sid,rdate,starttime,endtime,count(*) as passengers from ride r,bustrip b where boardtime>=b.starttime and alighttime <= b.endtime and rdate=b.tdate and r.sid=b.sid group by b.sid,rdate,starttime,endtime order by passengers desc;

    end $$ ;
delimiter ;

delimiter $$
create procedure popularBusService()
	begin
		#select b.sid,count(*) as passengers from ride r,bustrip b where boardtime>=b.starttime and alighttime <= b.endtime and rdate=b.tdate and r.sid=b.sid group by b.sid order by passengers desc;

    end $$ ;
delimiter ;

delimiter $$
create procedure givenPriceShowStop()
	begin
		#select * from stoppair sp,stop s1,stop s2 where s1.stopid=sp.fromstop and s2.stopid=sp.tostop and basefee>1.2 and (fromstop,tostop) in (select sr1.stopid,sr2.stopid from stoprank sr1,stoprank sr2 where sr1.sid = 124 and sr2.sid=124 and sr1.rankorder<sr2.rankorder order by sr1.RankOrder,sr2.rankorder);
    end $$ ;
delimiter ;


delimiter $$
create procedure busDriverAndOfficer()
	begin
		#select b.did,o2.officerid,d.name as DriverName,o2.name as OfficerName,count(*) as timesEncountered from offence o,bustrip b,driver d,officer o2 where b.tdate=o.SDate and b.sid=o.sid and b.starttime=o.stime and d.did=b.did and o2.officerid=o.oid group by o2.officerid,b.did,d.name,o2.Name having count(*)>1;
    end $$ ;
delimiter ;

delimiter $$
create procedure sameDaySamePersonDifferentCarDifferentService()
	begin
		#select * from bustrip b1,bustrip b2 where b1.tdate=b2.tdate and b1.plateno<b2.plateno and b1.sid<b2.sid and b1.StartTime<> b2.starttime and b1.did=b2.did;
    end $$ ;
delimiter ;

delimiter $$
create procedure sameDaySamePersonSameCarDifferentService()
	begin
		#select * from bustrip b1,bustrip b2 where b1.tdate=b2.tdate and b1.plateno=b2.plateno and b1.sid<b2.sid and b1.StartTime<> b2.starttime and b1.did=b2.did;
    end $$ ;
delimiter ;

delimiter $$
create procedure sameDayDifferentPersonSameCarDifferentService()
	begin
		#select b1.sid,b2.sid,b1.tdate,b1.PlateNo from bustrip b1,bustrip b2 where b1.plateno=b2.plateno and b1.sid<b2.sid and b1.tdate=b2.tdate and b1.starttime <> b2.starttime group by b1.sid,b2.sid,b1.tdate,b1.PlateNo;
    end $$ ;
delimiter ;

delimiter $$
create procedure mostRevenue()
	begin
		-- select company,max(total) from (select company,sum(earned) as total from (select c.sid as sid1,company from company c,bustrip b where c.sid=b.sid group by c.sid,company) as t1,
		-- (select sid,sum(BaseFee) as earned from ride r,stoppair s where r.alightstop=s.tostop and r.boardstop=s.fromstop group by sid) as t2 where t1.sid1=t2.sid group by company) 
		-- as t4 
		-- where t4.total=(select max(total) from (select company,sum(earned) as total from (select c.sid as sid1,company from company c,bustrip b where c.sid=b.sid group by c.sid,company) as t1,
		-- (select sid,sum(BaseFee) as earned from ride r,stoppair s where r.alightstop=s.tostop and r.boardstop=s.fromstop group by sid) as t2 where t1.sid1=t2.sid group by company) as t3);
    end $$ ;
delimiter ;

delimiter $$
create procedure driverMostDriven()
	begin
		#select did,timedriven from (select did,sum(TIMEDIFF(endtime,starttime)) as timedriven from bustrip group by did) as t1 where timedriven= (select max(timedriven) from (select sum(TIMEDIFF(endtime,starttime)) as timedriven from bustrip group by did) as t2);

    end $$ ;
delimiter ;

delimiter $$
create procedure companyMostLongTrip()
	begin
		-- select company from stoprank sr1,company c where rankorder >15 and c.sid=sr1.sid group by company having count(*)=
		-- (select max(services) from (select count(*) as services from stoprank sr1,company c where rankorder >15 and c.sid=sr1.sid group by company) as t1);
    end $$ ;
delimiter ;

delimiter $$
create procedure companyMostAffectedByCrime()
	begin
		-- select company from company c, (select sid,count(*) as noOfOffence from offence group by sid) as t1 where t1.sid=c.sid group by Company having count(*)=
		-- (select max(offence) from (select count(*) offence from company c, (select sid,count(*) as noOfOffence from offence group by sid) as t1 where t1.sid=c.sid group by Company) as t2);
    end $$ ;
delimiter ;

delimiter $$
create procedure companyMostElectric()
	begin
		#select company,totalelectric from (select Company,count(distinct bus.plateno) as totalElectric from bus,company c,bustrip b where fueltype='electric' and b.sid=c.sid and bus.plateno=b.plateno group by company) as t1 where totalelectric = (select max(totalElectric) from (select count(distinct bus.plateno) as totalElectric from bus,company c,bustrip b where fueltype='electric' and bus.plateno=b.plateno and b.sid=c.sid group by company) as t2);

    end $$ ;
delimiter ;

delimiter $$
create procedure totalDiscountsStudent()
	begin
#select (select discount from cardtype where type='Student')*sum(basefee) from citylink c1,ride r,stoppair sp1 where r.cardid=c1.cardid and c1.type='Student' and sp1.fromstop=r.boardstop and sp1.tostop = r.alightstop ;
	end $$
delimiter ;

delimiter $$
create procedure trigger_insuffiencentCardBalance ()
	begin
		-- 		delimiter $$
		-- 		create trigger before_insert_ride before insert on ride for each row
		-- 			begin
		-- 				declare price decimal(5,2);
		-- 				declare newBalance decimal(5,2);
		-- 				
		-- 				set price = (select basefee from stoppair s1 where s1.fromstop = new.boardstop and s1.tostop=new.alightstop);
		-- 				set @total=price;
		-- 				set newBalance = (select balance from citylink c where c.cardid=new.cardid);
		-- 				set @total2=newBalance;
		-- 				if ( (price> newBalance))then
		-- 					SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'You have insufficient card balance';
		-- 				else 
		-- 							SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ok';

		-- 				end if;
		-- 				
		-- 			end $$
		-- 		delimiter ;
	end $$
delimiter ;

delimiter $$
create procedure trigger_onetrip_at_a_time()
	begin
		-- DELIMITER $$
-- 			CREATE TRIGGER trigger_ONE_TRIP_AT_A_TIME BEFORE INSERT ON BUSTRIP FOR EACH ROW
-- 			BEGIN
-- 				declare finalEndTime time;
-- 				declare finalStarttime time;
-- 				
-- 				set finalEndTime = (SELECT MAX(ENDTIME) FROM BUSTRIP WHERE TDATE = NEW.TDATE AND DID = NEW.DID and bustrip.did=new.did); 
-- 				set finalstarttime = (select starttime from bustrip where TDATE = NEW.TDATE AND DID = NEW.DID and bustrip.did=new.did and endtime=finalEndTime);
-- 				
-- 				IF (( NEW.STARTTIME < finalEndTime ) and (new.starttime>finalstarttime)) or ((new.endtime>finalstarttime) and (new.endtime<finalEndTime)) THEN 
-- 				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DRIVER STILL HAS ONGOING BUSTRIP';
-- 				END IF;
-- 			END$$
-- 		DELIMITER ;
    end $$
delimiter ;

delimiter $$
create procedure trigger_UpdateBalance()
	begin
-- 		delimiter $$
-- 		create trigger after_insert_ride after insert on ride for each row
-- 			begin
-- 				declare fee float;
-- 				
-- 				set fee= (select basefee from stoppair sp1 where sp1.fromstop=new.boardstop and sp1.tostop=new.alightstop);
-- 				
-- 				update citylink set balance = balance - fee where cardid=new.cardid;
-- 			end $$

-- 		delimiter ;
	end $$
delimiter ;

delimiter $$
create procedure trigger_transferOldBalance()
	begin
-- 		delimiter $$
-- 		create trigger before_citylink_insert before insert on citylink for each row
-- 			begin
-- 				declare oldbalance float;
-- 				
-- 					if new.oldcardid is not null then 
-- 						set oldbalance = (select balance from citylink c where c.cardid = new.oldcardid);
-- 						set new.balance = new.balance + oldbalance;

-- 						#update citylink c set balance=new.balance+oldbalance where c.cardid=new.cardid ;
-- 					end if;
-- 			end $$
-- 		delimiter ;
	end $$
delimiter ;
drop trigger after_citylink_insert;

delimiter $$
create procedure sp_deductfine()
begin
-- 	create procedure sp_DeductFine()
-- 		begin
-- 			declare count int;
-- 			declare currentId int;
-- 			declare n int;
-- 			declare currentPenalty float;
-- 			
-- 			set  count = (select count(*) from offence where paycard is not null);
-- 			set n = 0;
-- 			
-- 			while count<>0 do
-- 				set currentId = (select sid from offence where paycard is not null limit 1 offset n);
-- 				set currentPenalty= (select penalty from offence where paycard is not null limit 1 offset n);
-- 				
-- 				update citylink set balance = balance-currentpenalty where cardid = currentId;
-- 				
-- 				set count = count -1;
-- 				set n = n+1;
-- 			end while;
-- 			
-- 			
-- 		end $$   

-- 	delimiter ;
    end $$
DELIMITER $$