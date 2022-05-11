# Create tables
create table service (
SID int not null,
Normal boolean not null,
constraint service_pk primary key(sid)
);
# select * from service;

create table company (
SID int not null,
Company varchar(20) not null,
constraint company_pk primary key(SID, Company),
constraint company_fk foreign key(SID) references service(SID)
);
# select * from company;

create table normal (
SID int not null,
WeekdayFreq int not null,
WeekendFreq int not null,
constraint normal_pk primary key(SID),
constraint normal_fk foreign key(SID) references service(SID)
);
# select * from normal;

create table express (
SID int not null,
AvailableWeekend boolean not null,
AvailablePH boolean not null,
constraint express_pk primary key(SID),
constraint express_fk foreign key(SID) references service(SID)
);
# select * from express;

create table bus (
PlateNo char(8) not null,
FuelType varchar(10) not null,
Capacity int not null,
constraint bus_pk primary key(PlateNo)
);
# select * from bus;

create table driver (
DID int not null,
NRIC char(9) not null,
Name varchar(50) not null,
DoB date not null,
Gender char(1) not null,
constraint driver_pk primary key(DID)
);
# select * from driver;

create table bustrip (
SID int not null,
TDate date not null,
StartTime time not null,
EndTime time not null,
PlateNo char(8) not null,
DID int not null,
constraint bustrip_pk primary key(SID, TDate, StartTime),
constraint bustrip_fk1 foreign key(PlateNo) references bus(PlateNo),
constraint bustrip_fk2 foreign key(DID) references driver(DID)
);
# select * from bustrip;

create table officer (
OfficerID int not null,
Name varchar(50) not null,
YearsEmp int not null,
constraint officer_pk primary key(OfficerID)
);
# select * from officer;

create table cardtype (
Type varchar(10) not null,
Discount float not null,
MinTopAmount int not null,
Description varchar(200) not null,
constraint cardType_pk primary key(Type)
);
# select * from cardtype;

create table citylink (
CardID int not null,
Balance float not null,
Expiry date not null,
Type varchar(10) not null,
OldCardID int null,
constraint citylink_pk primary key(CardID),
constraint citylink_fk1 foreign key(OldCardID) references citylink(cardID),
constraint citylink_fk2 foreign key(Type) references cardtype(Type)
);
# select * from citylink;

create table offence (
ID int not null,
NRIC char(9) not null,
Time time not null,
Penalty float not null,
PayCard int not null,
SID int not null,
SDate date not null,
STime time not null,
OID int not null,
constraint offence_pk primary key(ID),
constraint offence_fk1 foreign key(SID, SDate, STime) references bustrip(SID, TDate, StartTime),
constraint offence_fk2 foreign key(OID) references officer(OfficerID)
);
# select * from offence;

create table stop (
StopID int not null,
LocationDes varchar(50) not null,
Address varchar(50) not null,
constraint stop_pk primary key(StopID)
);
# select * from stop;

create table stoprank (
StopID int not null,
SID int not null,
RankOrder int not null,
constraint stoprank_pk primary key(StopID, SID),
constraint stoprank_fk foreign key(SID) references service(SID)
);
# select * from stoprank;

create table ride (
CardID int not null,
RDate date not null,
UsePhone boolean not null,
BoardStop int not null,
SID int not null,
AlightStop int, #
BoardTime time not null,
AlightTime time, #
constraint ride_pk primary key(CardID, RDate, BoardTime),
constraint ride_fk1 foreign key(BoardStop, SID) references stoprank(StopID, SID),
constraint ride_fk2 foreign key(AlightStop) references stop(StopID)
);
# select * from ride;

create table stoppair (
FromStop int not null,
ToStop int not null,
BaseFee float not null,
constraint stoppair_pk primary key(FromStop, ToStop),
constraint stoppair_fk1 foreign key(FromStop) references stop(StopID),
constraint stoppair_fk2 foreign key(ToStop) references stop(StopID)
);