create schema Aeroplane;

create table Aircraft(
AID int primary key,
ANAME varchar(20),
CRUISINGRANGE int
);
create table Employee(
EID INT Primary key,
ENAME varchar(20) ,
Salary int 
);
create table Certified(
EID int ,
AID int,
CERTDATE date,
constraint certified_pk primary key(eid,aid),
constraint certified_fk1 foreign key(aid) references Aircraft(aid),
constraint certified_fk2 foreign key(eid) references Employee(eid)
);



create table Flight(
FLNO int primary key,
fly_from varchar(20),
fly_to varchar(20),
Distiance int,
price int
);

insert into Employee values (1,'jacob',85000) ;
insert into Employee values (2,'Michael',55000) ;
insert into Employee values (3,'Emily',80000) ;
insert into Employee values (4,'Ashley',110000) ;
insert into Employee values (5,'Olivia',70000) ;

insert into aircraft values (1,'a1',800) ;
insert into aircraft values (2,'a2b',700) ;
insert into aircraft values (3,'a3',1000) ;
insert into aircraft values (4,'a4b',1100) ;
insert into aircraft values (5,'a5',1200) ;

insert into certified values (1,1,'2005-01-01') ;
insert into certified values (1,2,'2001-01-01') ;
insert into certified values (1,3,'2000-01-01') ;
insert into certified values (1,5,'2000-01-01') ;
insert into certified values (2,3,'2002-01-01') ;
insert into certified values (2,2,'2003-01-01') ;
insert into certified values (3,3,'2003-01-01') ;
insert into certified values (3,5,'2004-01-01') ;

insert into flight values (1,'LA','SF',600,65000),
(2,'LA','SF',700,70000),
(3,'LA','SF',800,90000),
(4,'LA','NY',1000,85000),
(5,'NY','LA',1100,95000);

drop table employee;




