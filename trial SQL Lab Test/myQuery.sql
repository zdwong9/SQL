select * from bus;

/*
Return buses that are connected by more than 5 stops
*/
select * from stop;
select * from stoppair;

##answer 
select sr1.sid,sr2.sid,count(*) as connectedStops from stoprank sr1,stoprank sr2 where sr1.stopid=sr2.stopid and sr1.sid<sr2.sid group by sr1.sid,sr2.sid having count(*)>5;

select sr1.sid,sr2.sid,count(distinct sr1.stopid) as numberOfStops from stoprank sr1,stoprank sr2 where sr1.sid<sr2.sid and sr1.stopid=sr2.stopid group by sr1.sid,sr2.sid having numberofstops>5;

/*
Return bus services whose stops are identical
*/



## count must be the same
## stops must be the same
# group by sid1,sid2 the count must be the same
select sr1.sid as sid1,sr2.sid as sid2,count(*) as noOfStops from stoprank sr1,stoprank sr2 
where sr1.stopid=sr2.stopid and sr1.sid<sr2.sid group by sr1.sid,sr2.sid;

select sid,count(*) as stops from stoprank sr1 group by sid;

select sr1.sid as sid1,sr2.sid as sid2,count(*) as noOfStops from stoprank sr1,stoprank sr2 
where sr1.stopid=sr2.stopid and sr1.sid<sr2.sid group by sr1.sid,sr2.sid;


select t1.sid1,t1.sid2,noOfStops from (select sr1.sid as sid1,sr2.sid as sid2,count(*) as noOfStops from stoprank sr1,stoprank sr2 
where sr1.stopid=sr2.stopid and sr1.sid<sr2.sid group by sr1.sid,sr2.sid) as t1,
(select sid,count(*) as stops from stoprank sr1 group by sid) as t2,
(select sid,count(*) as stops from stoprank sr1 group by sid) as t3
where t2.sid<t3.sid and 
((t2.sid=t1.sid1 and t3.sid = t1.sid2) or (t3.sid=t1.sid1 and t2.sid =t1.sid2)) 
and t1.noOfStops=t2.stops and t2.stops=t3.stops;

######
/*
Return buses (not services) that operates both express and normal services
*/
select * from service;
select * from express;
select * from normal;

#### two solutions


select bt.PlateNo as NormalBusPlateNo from (select n.sid from normal n 
) as t1 inner join bustrip bt on t1.sid = bt.sid;

select bt.PlateNo as ExpressBusPlateNo from (select e.sid from express e) as t2 
inner join bustrip bt on t2.sid = bt.sid;

select distinct(NormalBusPlateNo) as PlateNo from (select bt.PlateNo as NormalBusPlateNo from (select n.sid from normal n 
) as t1 inner join bustrip bt on t1.sid = bt.sid) as t3,
 (select bt.PlateNo as ExpressBusPlateNo from (select e.sid from express e) as t2 
inner join bustrip bt on t2.sid = bt.sid) as t4 
 where t3.NormalBusPlateNo=t4.ExpressBusPlateNo;


###################

/*
Return buses (not services) that are operates only express services or only normal services
*/

select count(*) from express e,bustrip b where b.sid=e.sid;
select count(*) from normal n,bustrip b where b.sid=n.sid;
select bt.PlateNo as PlateNo from (select e.sid from express e) as t2 
inner join bustrip bt on t2.sid = bt.sid union all
select bt.PlateNo as PlateNo from (select n.sid from normal n 
) as t1 inner join bustrip bt on t1.sid = bt.sid;

	


select distinct(PlateNo) from (select bt.PlateNo as PlateNo from (select e.sid from express e) as t2 
inner join bustrip bt on t2.sid = bt.sid union
select bt.PlateNo as PlateNo from (select n.sid from normal n 
) as t1 inner join bustrip bt on t1.sid = bt.sid) as t3 
where t3.PlateNo not in (select distinct(NormalBusPlateNo) as PlateNo from (select bt.PlateNo as NormalBusPlateNo from (select n.sid from normal n 
) as t1 inner join bustrip bt on t1.sid = bt.sid) as t3,
 (select bt.PlateNo as ExpressBusPlateNo from (select e.sid from express e) as t2 
inner join bustrip bt on t2.sid = bt.sid) as t4 
 where t3.NormalBusPlateNo=t4.ExpressBusPlateNo);
 
select * from bustrip where plateno ='SHR5663L';
 

#########################3

/*
Return citylink cards which got replaced as an adult card and was previously an student card.
*/	


##two solutions
select * from citylink c where oldcardid in (select cardid as OldCard from citylink c where cardid in (select oldcardid from citylink c where oldcardid is not null and c.type ='Adult') and c.type='Student');
### OR
select cl.CardID from (select cardid from citylink where type = 'Adult') as ta , citylink cl where type = 'Senior' and cl.oldcardid = ta.cardid ;


/*
Return the number of offences each officers dished out.
*/

select oid,o.name,count(*) from offence,officer o where o.officerid=offence.oid group by oid,o.name;


/*
List the available buses that is available in June 2020 and service after 12 midnight and before 7am.
*/

select * from bustrip where month(tdate)=6 and year(tdate)=2020 and hour(starttime)>=0 and hour(starttime)<=7;

/*
List the instances where each bus trip had no passengers boarding it
*/


select b.sid,rdate,starttime,count(*) as passengers from ride r,bustrip b where boardtime>=b.starttime and alighttime <= b.endtime and rdate=b.tdate and r.sid=b.sid group by b.sid,rdate,starttime order by passengers desc;



/*
List out the amount of current users of each card type
*/

select oldcardid from citylink where oldcardid is not null;
### Answer
select type,count(*) from citylink where expiry >= now() and cardid not in (select oldcardid from citylink where oldcardid is not null) group by type;



/*
Expired cards but not replaced
*/
select * from citylink where expiry < now() and cardid not in (select oldcardid from citylink where oldcardid is not null);


/*
List out cardIDs and its previously replaced card ID along with its balance before it was replaced.
*/


select t1.cardid as currentCardID,t1.balance as currentBalance,c.balance as oldBalance,c.cardid as oldCardID from citylink c inner join (select cardid,balance,oldcardid from citylink where oldcardid is not null) as t1 on c.cardid=t1.oldcardid;

select t1.cardid, oldcardid , balance from (select cardid, oldcardid from citylink where oldcardid <> 'null') as t1 , 
(select cardid, balance from citylink) as t2 where t1.oldcardid = t2.cardid;

/*
List the buses that are most frequently taken 
*/

select b.sid,count(*) as passengers from ride r,bustrip b where boardtime>=b.starttime and alighttime <= b.endtime and rdate=b.tdate and r.sid=b.sid group by b.sid order by passengers desc;

select * from ride;
select * from bustrip;

/*
List the buses that are has the most offences committed on
*/

select * from offence;
select id, count(*) from offence group by sid order by count(*) desc;

select plateno, count(distinct o.id) from bustrip b, offence o where b.sid=o.sid and b.starttime = o.stime and b.tdate = o.SDate group by plateno order by count(o.id) desc limit 1;

select plateno , count(oid) as NumOfOffence from bustrip bt, offence o where bt.sid = o.sid and bt.tdate=o.sdate and bt.starttime=o.stime group by plateno HAVING NUMOFOFFENCE = (SELECT MAX(NUMOFOFFENCE) FROM (select plateno , count(id) as NumOfOffence from bustrip bt, offence o where bt.sid = o.sid and bt.tdate=o.sdate and bt.starttime=o.stime group by plateno)AS TEMP);

/*
Query buses that switch drivers from within a day.
(e.g. maybe a bus driver drives bus 83 at 10am on a day but another bus driver takes over at 6pm on the same day)
*/

select * from bustrip b1,bustrip b2 where b1.sid=b2.sid and b1.tdate=b2.tdate and b1.starttime<b2.starttime and b1.plateno=b2.plateno and b1.did<b2.did;

select did, tdate,count(distinct sid) as ServiceDroveOntheSameDay from bustrip
group by did,tdate
having ServiceDroveOntheSameDay > 1;

select * from bustrip;

/*
List bus trips that did not end
*/

select * from bustrip where endtime is null;

/*
List bus which start and end on the same station
*/

select sid,max(rankorder) from stoprank sr1 group by sid;
select sid,min(rankorder) from stoprank sr1 group by sid;

select * from stoprank sr1,stoprank sr2 where
(
	(sr1.sid,sr1.rankorder) in (select sid,max(rankorder) from stoprank sr1 group by sid) 
or
	(sr1.sid,sr1.rankorder) in (select sid,min(rankorder) from stoprank sr1 group by sid) 
)
and
(
	(sr2.sid,sr2.rankorder) in (select sid,max(rankorder) from stoprank sr1 group by sid) 
or
	(sr2.sid,sr2.rankorder) in (select sid,min(rankorder) from stoprank sr1 group by sid) 
)
and sr1.sid=sr2.sid and sr1.stopid=sr2.stopid and sr1.rankorder < sr2.RankOrder
order by sr1.sid,sr1.rankorder;

select * from stoprank sr1 order by sid,rankorder;

/*
List rides where prices > $1.20 and bus number 124 and list out the address from where it departs and alights
*/

select * from stoppair sp,stop s1,stop s2 where s1.stopid=sp.fromstop and s2.stopid=sp.tostop and basefee>1.2 and 
(fromstop,tostop) in (select sr1.stopid,sr2.stopid from stoprank sr1,stoprank sr2 where sr1.sid = 124 and sr2.sid=124 and sr1.rankorder<sr2.rankorder order by sr1.RankOrder,sr2.rankorder
);


select * from stoprank;

select * from stoppair;
select * from stoprank;
select * from stoprank sr,stoppair s where sid = 124 and s.fromstop=sr.stopid;


/*
List bus services provided by SBStransit
*/

select * from service s,company c where c.sid=s.sid and company = 'SBS Transit';

/*
List the offences recorded by officers which are children of J.Navin.
*/

select * from offence o1,officer o2 where o1.oid=o2.officerid and 
o2.name like '%_/o J. Navin%';

/*
List bus drivers which are involved in offences where they have met the same officer more than once.
*/

select b.did,o2.officerid,d.name as DriverName,o2.name as OfficerName,count(*) as timesEncountered from offence o,bustrip b,driver d,officer o2 
where b.tdate=o.SDate and b.sid=o.sid and b.starttime=o.stime and d.did=b.did and o2.officerid=o.oid 
group by o2.officerid,b.did,d.name,o2.Name having count(*)>1;

select * from offence;

/*
Query drivers that that switch buses within a day.
(e.g. maybe a bus driver drives bus 83 at 10am on a day and he drives another bus on the same day)
*/

select * from bustrip b1,bustrip b2 where b1.tdate=b2.tdate and b1.plateno<b2.plateno and b1.sid<b2.sid and b1.StartTime<> b2.starttime and b1.did=b2.did;

select did, tdate,count(distinct sid) as ServiceDroveOntheSameDay, 
count(distinct plateno) as NumberOfBusesDrove from bustrip
group by did,tdate
having ServiceDroveOntheSameDay > 1
and NumberOfBusesDrove > 1;


/*
Query buses which switch service within a day (e.g. maybe in the morning the bus services as 83 but later in the day services as 109)
*/

select b1.sid,b2.sid,b1.tdate,b1.PlateNo from bustrip b1,bustrip b2 where b1.plateno=b2.plateno and b1.sid<b2.sid and b1.tdate=b2.tdate and b1.starttime<>b2.starttime group by b1.sid,b2.sid,b1.tdate,b1.PlateNo;



/*
Query buses where the driver stays on the same bus but drives for a different number all of which is on the same day 
(e.g. maybe in the morning the bus driver drives on the same bus as service 83 but later in the day he drives on the same bus as service 109)
*/

select b1.sid,b2.sid,b1.tdate from bustrip b1,bustrip b2 where b1.tdate=b2.tdate and b1.StartTime <> b2.StartTime and b1.plateno=b2.plateno and b1.sid<b2.sid and b1.did = b2.did group by b1.sid,b2.sid,b1.tdate;

select * from bustrip where month(tdate)=6 and year(tdate)=2020 and hour(starttime)>=0 and hour(starttime)<=7;



/*
List all electric buses
*/

## answer
select distinct(b.plateno) from bus b,bustrip bt where b.plateno=bt.plateno and fueltype = 'electric' ;

/*
List the minimum top up amount of citylink for adults.
*/

select * from cardtype;

/*
List all the buses that are available in punggol
*/

select * from stop where address like '%punggol%';

/*
Query the minimum fee to go from anywhere in Punggol to SMU (theres a location desc that’s SMU)
*/
##### Question cant be solved
select stopid from stop where locationdes like '%SMU%';
select stopid from stop where Address like '%punggol%';

select * from stoppair where fromstop in(select stopid from stop where Address like '%punggol%') or tostop in (select stopid from stop where locationdes like '%SMU%');

select * from (select * from stoppair where fromstop in(select stopid from stop where Address like '%punggol%') or tostop in (select stopid from stop where locationdes like '%SMU%')) as t1,
(select * from stoppair where fromstop in(select stopid from stop where Address like '%punggol%') or tostop in (select stopid from stop where locationdes like '%SMU%')) as t2 
where t1.tostop=t2.fromstop and t2.tostop in (select stopid from stop where Address like '%punggol%') and t1.fromstop in (select stopid from stop where locationdes like '%SMU%');

select * from stoprank sr1 where stopid in (select stopid from stop where locationdes like '%SMU%');
select * from stoprank sr1 where stopid in (select stopid from stop where Address like '%punggol%');

/*
List all NRIC who commited more than one offence.
*/

select nric,count(*) from offence group by nric having count(*) > 1;

/*
29. List the bus services required to reach YMCA 116 Orchard Rd from S'pore Poly 305 Dover Ave and their respective price.
    1. On weekdays
    2. On weekends
*/

select stopid from stop where locationdes = 'S''pore Poly' and address='305 Dover Ave';

select stopid from stop where locationdes='YMCA' and address='116 Orchard Rd';

select min(round(sp.basefee+sp2.basefee,2)) as fare from stoppair sp,stop s1,stop s2,stoppair sp2 where s1.stopid=sp.fromstop and s2.stopid=sp2.tostop and sp.fromstop=19089 and sp2.tostop=40129 and sp.tostop=sp2.fromstop;

select * from stop where stopid=19089;

select * from stoppair ;


select * from stop where stop.locationdes='ymca';
select * from stoppair sp1,stop s1,stop s2,stoppair sp2,stoppair sp3,stoppair sp4,stoppair sp5,stoppair sp6,stoppair sp7,stoppair sp8,stoppair sp9 where s2.LocationDes='YMCA' and s2.stopid=sp9.tostop and
sp8.tostop=sp9.fromstop and
sp7.ToStop=sp8.fromstop and
sp6.tostop=sp7.FromStop and
sp5.tostop=sp6.fromstop and 
sp4.tostop=sp5.fromstop and
sp3.tostop=sp4.fromstop and 
sp2.ToStop=sp3.fromstop and
sp2.fromstop=sp1.tostop and
s1.stopid=sp1.fromstop and s1.locationdes= 'S''pore Poly' and s1.address='305 Dover Ave';

select * from stoppair s1,stoppair s2,stoppair s3,stoppair s4 where s1.fromstop = (select stopid from stop where locationdes = 'S''pore Poly' and address='305 Dover Ave') and 
s3.tostop = (select stopid from stop where locationdes='YMCA' and address='116 Orchard Rd');

/*
38) Which bus company earns the most revenue.
*/

select c.sid as sid1,company from company c,bustrip b where c.sid=b.sid group by c.sid,company;
select sid,sum(BaseFee) as earned from ride r,stoppair s where r.alightstop=s.tostop and r.boardstop=s.fromstop group by sid;

select company,sum(earned) as total from (select c.sid as sid1,company from company c,bustrip b where c.sid=b.sid group by c.sid,company) as t1,
(select sid,sum(BaseFee) as earned from ride r,stoppair s where r.alightstop=s.tostop and r.boardstop=s.fromstop group by sid) as t2 where t1.sid1=t2.sid group by company having
total = (select max(total) from (select company,sum(earned) as total from (select c.sid as sid1,company from company c,bustrip b where c.sid=b.sid group by c.sid,company) as t1,
(select sid,sum(BaseFee) as earned from ride r,stoppair s where r.alightstop=s.tostop and r.boardstop=s.fromstop group by sid) as t2 where t1.sid1=t2.sid group by company) as t3) ;



### answer
select company,max(total) from (select company,sum(earned) as total from (select c.sid as sid1,company from company c,bustrip b where c.sid=b.sid group by c.sid,company) as t1,
(select sid,sum(BaseFee) as earned from ride r,stoppair s where r.alightstop=s.tostop and r.boardstop=s.fromstop group by sid) as t2 where t1.sid1=t2.sid group by company) 
as t4 
where t4.total=(select max(total) from (select company,sum(earned) as total from (select c.sid as sid1,company from company c,bustrip b where c.sid=b.sid group by c.sid,company) as t1,
(select sid,sum(BaseFee) as earned from ride r,stoppair s where r.alightstop=s.tostop and r.boardstop=s.fromstop group by sid) as t2 where t1.sid1=t2.sid group by company) as t3);


/*
Which bus company is most affected by the most number of crimes. 
*/

select sid,count(*) as noOfOffence from offence group by sid;

select company,count(*) from company c, (select sid,count(*) as noOfOffence from offence group by sid) as t1 where t1.sid=c.sid group by Company having count(*)=
(select max(offence) from (select count(*) offence from company c, (select sid,count(*) as noOfOffence from offence group by sid) as t1 where t1.sid=c.sid group by Company) as t2)
;



/*
Which company provides the most trips that have more than 15 stops per service.
*/

select company from stoprank sr1,company c where rankorder >15 and c.sid=sr1.sid group by company having count(*)=
(select max(services) from (select count(*) as services from stoprank sr1,company c where rankorder >15 and c.sid=sr1.sid group by company) as t1)
;


/*
Which driver drives the longest hours.
*/

select did,sum(TIMEDIFF(endtime,starttime)) as timedriven from bustrip group by did;
select max(timedriven) from (select sum(TIMEDIFF(endtime,starttime)) as timedriven from bustrip group by did) as t2;

select did,timedriven from (select did,sum(TIMEDIFF(endtime,starttime)) as timedriven from bustrip group by did) as t1 
where timedriven= (select max(timedriven) from (select sum(TIMEDIFF(endtime,starttime)) as timedriven from bustrip group by did) as t2);


/*
Which company has the most electric buses
*/

select Company,count(distinct bus.plateno) as totalElectric from bus,company c,bustrip b where fueltype='electric' and bus.plateno=b.plateno and b.sid=c.sid group by company;

select company,totalelectric from (select Company,count(distinct bus.plateno) as totalElectric from bus,company c,bustrip b where fueltype='electric' and b.sid=c.sid and bus.plateno=b.plateno group by company) as t1 where totalelectric = (select max(totalElectric) from (select count(distinct bus.plateno) as totalElectric from bus,company c,bustrip b where fueltype='electric' and bus.plateno=b.plateno and b.sid=c.sid group by company) as t2);

/*
What is the total discount given to students. 
*/

select (select discount from cardtype where type='Student')*sum(basefee) from citylink c1,ride r,stoppair sp1 where r.cardid=c1.cardid and c1.type='Student' and sp1.fromstop=r.boardstop and sp1.tostop = r.alightstop ;


select max(fare) as maxFare from 
(select c1.cardid,max(basefee) as fare from citylink c1,ride r,stoppair sp1 where r.cardid=c1.cardid and c1.type='Student' and sp1.fromstop=r.boardstop and sp1.tostop = r.alightstop group by c1.cardid) as t2;

select * from cardtype;

select t1.cardid1,fare*(select discount from cardtype where type='Student') from ((select c1.cardid as cardid1,max(basefee) as fare from citylink c1,ride r,stoppair sp1 where r.cardid=c1.cardid and c1.type='Student' and sp1.fromstop=r.boardstop and sp1.tostop = r.alightstop group by c1.cardid))
 as t1 where fare = (select max(fare) as maxFare from 
(select c1.cardid,max(basefee) as fare from citylink c1,ride r,stoppair sp1 where r.cardid=c1.cardid and c1.type='Student' and sp1.fromstop=r.boardstop and sp1.tostop = r.alightstop group by c1.cardid) as t2);

select * from ride r;


/*
32) List all rides that end at Itnl Plaza 1 Anson Rd that services for less than 45 minutes.
*/

select sid  from bustrip where endtime-starttime <= 004500;
#### Answer 


select * from ride r, bustrip b1 where timediff(endtime,starttime) <=004500 and r.sid=b1.sid and r.rdate=b1.tdate and r.alighttime<=b1.endtime and r.boardtime>=b1.starttime
and r.sid in (select distinct sid from stoprank sr1 where stopid = (select stopid from stop where (locationdes,address) = ('Itnl Plaza', '1 Anson Rd')) and (sid,rankorder) in
(select sid,max(rankorder) from stoprank group by sid))
;



/*
List bus drivers who moonlight (work for different companies)
*/



select did,count(*) as noOfCompaniesWorkedFor from (select did,company from bustrip b,company c where c.sid=b.sid group by company,did) as t1 group by t1.did having count(*) >1;


/*
Create a trigger which transfers the balance of the replaced card into its replacement
*/
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


INSERT INTO CITYLINK VALUES(501,50.30,"2022-09-15","Adult",NULL);
select * from citylink where cardid=501;

INSERT INTO CITYLINK VALUES(502,50.30,"2022-09-15","Adult",501);

select * from citylink where cardid = 502;

/*
Create a procedure to reverts all citylink cards whose balance is negative and is not expired to have a 0 balance.
*/

delimiter $$
create procedure sp_RevertCardBalance()
	begin
		declare count int;
        declare n int;
        declare currentId int;
        
        set count = (select count(*) from citylink where balance <0 and expiry>now() and OldCardID is not null);
               
        set n = 0;
        
        while count<> 0 do
			set currentId= (select cardid from citylink where balance <0 limit 1 offset n);
            update citylink set balance=0 where cardid = currentId;
            
            set count = count-1;
            set n = n+1;
        end while;
    end $$
delimiter ;
drop procedure sp_RevertCardBalance;
call sp_RevertCardBalance;
select count(*) from citylink where balance <0;

/*
Create a procedure which shows how much a given cardID owes as fines to CityLink and then deduct them accordingly from his current City Link card
*/ 

select count(*) from offence where paycard is not null;

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






drop procedure sp_deductfine;

CREATE PROCEDURE DEDUCTFINE(IN IN_CARDID INT)
	BEGIN
		DECLARE FINE FLOAT;
		SELECT ROUND(SUM(PENALTY), 2) INTO FINE FROM OFFENCE WHERE PAYCARD = IN_CARDID;
		SELECT FINE;
		UPDATE CITYLINK SET BALANCE = (BALANCE - FINE) WHERE CARDID = IN_CARDID;
	END$$
DELIMITER ;

CALL DEDUCTFINE(458);
select * from citylink where cardid = 458;

select * from citylink where cardid=469;
CALL DEDUCTFINE(469);
select * from offence;



/*
Company that operates the most trips in year 2020
*/


select company,count(*) from bustrip bt1,company c where year(tdate)=2020 and c.sid=bt1.sid group by company;

select * from bustrip bt1,company c where year(tdate)=2020 and c.sid=bt1.sid order by company;


/*
Which company operates the most electric buses
*/
select sid,count(*) from company group by sid;

select distinct(company) from company;
select * from bus where fueltype='electric';

select company,count(distinct b1.plateno) as noOfBus from bustrip bt1,company c,bus b1 where c.sid=bt1.sid and b1.plateno=bt1.plateno and fueltype='electric' group by company order by noOfBus desc; 

select company,count(distinct b1.plateno) from bustrip bt1,company c,bus b1 where c.sid=bt1.sid and b1.plateno=bt1.plateno and fueltype='electric' group by company; 

select * from bustrip bt1,company c,bus b1 where c.sid=bt1.sid and b1.plateno=bt1.plateno and fueltype='electric' ; 

select * from bus where plateno= 'SHE1541L';


/*
Which company has the largest seating capcity.
*/
select capacity from bus b order by capacity desc limit 1;
select * from company c, bustrip bt1,bus b1 where c.sid=bt1.sid and b1.plateno=bt1.plateno and capacity=(select capacity from bus b order by capacity desc limit 1);



/*
Buses that are in reverse direction
*/
select sr1.sid as sid1 ,sr2.sid as sid2,count(sr1.stopid) as connectedStops from stoprank sr1, stoprank sr2 where sr1.sid<sr2.sid and sr1.stopid=sr2.stopid group by sr1.sid,sr2.sid;

select sid,count(*) as noOfStops from stoprank sr3 group by sid;

### Answer
select * from (select sr1.sid as sid1 ,sr2.sid as sid2,count(sr1.stopid) as connectedStops from stoprank sr1, stoprank sr2 where sr1.sid<sr2.sid and sr1.stopid=sr2.stopid group by sr1.sid,sr2.sid) as t1 
where 
(t1.sid1,connectedstops) in (select sid,count(*) as noOfStops from stoprank sr3 group by sid) and (t1.sid2,connectedstops) in (select sid,count(*) as noOfStops from stoprank sr3 group by sid);


/*
Which group of people caused the most offence.
*/

select type,count(*) from offence o,citylink c where c.cardid=o.paycard group by type;


/*
Create a trigger that updates the card balance after a ride
*/
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

/*
Create a trigger such that a bus driver can only be on a single trip till he ends the trip.
*/
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


drop TRIGGER trigger_ONE_TRIP_AT_A_TIME;
select * from bustrip order by sid,tdate;
insert into bustrip values(7,'2019-01-03','16:55:00','17:40:00','SKD1243J',58027);

/*
Create a trigger which forbids user from riding the bus if card balance is insufficient for the ride
*/

select * from ride;
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

drop trigger after_insert_ride;
drop trigger before_insert_ride;

SELECT balance FROM CITYLINK WHERE CARDID = 502;
SELECT BASEFEE FROM STOPPAIR WHERE FROMSTOP = 50211 AND TOSTOP = 50991;
select @total;
select @total2;
INSERT INTO RIDE VALUES(502,"2021-01-01",0,50211,190,50991,"21:35:00","21:45:00");
delete from ride where cardid = 502 and rdate = '2021-01-01' and boardtime ='21:35:00';


select * from ride;


show create table ride;


