create schema quiz2;

create table test3(
pid int primary key,
birthday date not null  );

create table test2(
sid int primary key,
pid int,
constraint x foreign key(pid) references   test(pid));

insert into test3 values (200,'ok');
select * from test3;
ALTER TABLE test2 DROP FOREIGN KEY x;
select * from test2;

insert into test2(pid,sid) value(3,3);
select * from test2 order by pid desc;


alter table update ;

drop table test;