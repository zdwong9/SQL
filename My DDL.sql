drop table company;
create table service (
sid int not null primary key,
normal boolean not null
);

create table company(
sid int not null ,
Company varchar(20) not null,
constraint company_pk primary key(sid,company),
constraint company_fk foreign key(sid) references service(sid)
);

drop table company;
describe company;
show create table company;
select * from company;

create table express(
sid int not null Primary Key,
AvailableWeekend boolean not null,
AvailablePH boolean not null,
constraint express_fk foreign key(sid) references service(sid)
);

create table normal(
sid int not null Primary Key,
WeekdayFreq int not null,
WeekendFreq int not null,
constraint normal_fk foreign key(sid) references service(sid)
);

create table bus(
Plateno char(8) not null Primary Key,
Fueltype varchar(10) not null,
Capacity int not null
);

create table driver(
DID int not null Primary Key,
NRIC char(9) not null,
name varchar(50) not null,
DoB date not null,
Gender char(1) not null
);

drop table bustrip;

create table bustrip(
SID int not null,
tdate date not null,
starttime time not null,
endtime time not null,
plateno char(8) not null,
DID int not null,
constraint bustrip_pk primary key(sid,TDate,starttime),
constraint bustrip_fk1 foreign key(PlateNo) references bus(plateno),
constraint bustrip_fk2 foreign key(DID) references driver(did)
);
Alter table bustrip add constraint bustrip_fk3 foreign key(SID) references service(sid);
select * from information_schema.table_constraints where table_name = 'bustrip' ;
describe bustrip;
show create table bustrip;

drop table officer;
create table officer(
officerid int not null primary key,
name varchar(50) not null,
yearsemp int not null
);

drop table offence;


create table cardtype(
type varchar(10) not null Primary Key,
discount float not null,
mintopamount int not null,
description varchar(200) not null
);

create table citylink(
cardid int not null primary key,
balance float not null,
expiry date not null,
type varchar(10) not null,
oldcardid int,
constraint citylink_fk1 foreign key(oldcardid) references citylink(cardid),
constraint citylink_fk2 foreign key(type) references cardtype(type)
);
ALTER TABLE citylink MODIFY oldcardid int default null;
describe citylink;

drop table offence;
create table offence(
ID int not null Primary kEy,
NRIC char(9) not null,
time time not null,
penalty float not null,
paycard int,
sid int not null,
sdate date not null,
stime time not null,
oid int not null,
constraint offence_fk1 foreign key(sid,sdate,stime) references bustrip(sid,TDate,starttime),
constraint offence_fk2 foreign key(oid) references officer(officerid),
constraint offence_fk3 foreign key(paycard) references citylink(cardid)
);

create table stop(
stopid int not null primary key,
locationdes varchar(50) not null,
address varchar(50) not null
);

create table stoppair(
FromStop int not null,
ToStop int not null,
BaseFee float not null,
constraint stoppair_pk primary key (fromstop,tostop),
constraint stoppair_fk1 foreign key(fromstop) references stop(stopid),
constraint stoppair_fk2 foreign key(tostop) references stop(stopid)
);

create table stoprank(
stopid int not null,
sid int not null,
rankorder int not null,
constraint stoprank_pk primary key(stopid,sid),
constraint stoprank_fk1 foreign key(stopid) references stop(stopid),
constraint stoprank_fk2 foreign key(sid) references service(sid)
);

drop table ride;
create table ride(
cardid int not null,
rdate date not null,
usephone boolean not null,
boardstop int not null,
sid int not null,
alightstop int ,
boardtime time not null,
alighttime time ,
constraint ride_pk primary key(cardid,rdate,boardtime),
constraint ride_fk1 foreign key (alightstop) references stop(stopid),
constraint ride_fk2 foreign key(boardstop,sid) references stoprank(stopid,sid)
);
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS where table_schema="g2t10";

