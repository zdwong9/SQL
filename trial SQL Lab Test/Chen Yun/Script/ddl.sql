create schema lib;
use lib;

# Item
create table item
(
ISBN varchar(25) not null primary key,
Title varchar(150) not null,
Publisher_Name varchar(50) not null,
Classification_code varchar(10) not null,
Format_Type char(2) not null
);

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data' into table lib.item fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\item.txt' INTO TABLE item FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;



# copy
create table copy
(
ISBN varchar(25) not null,
Copy_ID int not null,
Acquired_Date date not null,
Constraint copy_pk primary key (ISBN, Copy_ID),
Constraint copy_fk foreign key (ISBN) references item(ISBN)
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\copy.txt' INTO TABLE copy FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/copy.txt' into table G2T11.copy fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# author
create table author
(
ISBN varchar(25) not null,
Author varchar(100) not null,
Constraint author_pk primary key (ISBN, Author),
Constraint author_fk foreign key (ISBN) references item(ISBN)
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\author.txt' INTO TABLE author FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/author.txt' into table G2T11.author fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# Electronic item
create table electronic_item
(
ISBN varchar(25) not null,
URL varchar(100) not null,
Constraint electronic_item_pk primary key (ISBN),
Constraint electronic_item_fk foreign key (ISBN) references item(ISBN)
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\electronic_item.txt' INTO TABLE electronic_item FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/electronic_item.txt' into table G2T11.electronic_item fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# membership
create table membership
(
Member_Type varchar(20) not null primary key,
Loan_Period int not null,
Item_limit int not null,
Annual_fee double not null,
Admin_discount int not null,
Penalty_Rate double not null
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\membership.txt' INTO TABLE membership FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/membership.txt' into table G2T11.membership fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# user
create table user
(
User_ID varchar(25) not null primary key,
User_Name varchar(100) not null,
Member_type varchar(20) not null,
Total_Accrued_Fine double not null,
Is_faculty char(1) not null,
Is_student char(1) not null,
Is_admin char(1) not null,
Constraint user_fk foreign key (Member_type) references membership(Member_Type)
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\user.txt' INTO TABLE user FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/user.txt' into table G2T11.user fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# student
create table student
(
User_ID varchar(25) not null primary key,
Enrolment_year int not null,
Expected_graduation_year int not null,
Constraint student_fk foreign key (User_ID) references user(User_ID)
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\student.txt' INTO TABLE student FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/student.txt' into table G2T11.student fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# faculty
create table faculty
(
User_ID varchar(25) not null primary key,
Office_address varchar(100) not null,
Main_research varchar(100) not null,
Constraint faculty_fk foreign key (User_ID) references user(User_ID)
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\faculty.txt' INTO TABLE faculty FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/faculty.txt' into table G2T11.faculty fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# school
create table school
(
Name varchar(100) not null primary key,
Address varchar(100) not null,
URL varchar(100) not null
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\school.txt' INTO TABLE school FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/school.txt' into table G2T11.school fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# admin
create table admin_staff
(
User_ID varchar(25) not null primary key,
School varchar(100) not null,
Is_Chief char(1) not null,
Constraint admin_staff_fk1 foreign key (User_ID) references user(User_ID),
Constraint admin_staff_fk2 foreign key (School) references school(Name)
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\admin_staff.txt' INTO TABLE admin_staff FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/Admin_staff.txt' into table G2T11.Admin_staff fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# item request
create table item_request
(
Faculty varchar(25) not null,
Description varchar(100) not null,
Admin_staff varchar(25) not null,
School varchar(100) not null,
ISBN varchar(25),
Is_Procured char(1) not null,
Constraint item_request_pk primary key (Faculty, Description),
Constraint item_request_fk1 foreign key (Faculty) references faculty(User_ID),
Constraint item_request_fk2 foreign key (Admin_staff) references admin_staff(User_ID),
Constraint item_request_fk3 foreign key (School) references school(Name),
Constraint item_request_fk4 foreign key (ISBN) references item(ISBN)
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\item_request.txt' INTO TABLE item_request FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/item_request.txt' into table G2T11.item_request fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# room
create table room
(
Room_ID varchar(10) not null primary key,
Floor_number int not null,
Has_Space char(1)
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\room.txt' INTO TABLE room FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/room.txt' into table G2T11.room fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# shelf
create table shelf
(
Room_ID varchar(10) not null,
SID varchar(10) not null,
For_DVD char(1) not null,
Capacity int not null,
Constraint shelf_pk primary key (Room_ID, SID),
Constraint shelf_fk foreign key (Room_ID) references room(Room_ID)
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\shelf.txt' INTO TABLE shelf FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;
load data infile '/Users/NPStudent/Desktop/G2T11/Data/shelf.txt' into table G2T11.shelf fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# physical item
create table physical_item
(
ISBN varchar(25) not null primary key,
Room_ID varchar(10) not null,
Shelf_ID varchar(10) not null,
Type varchar(10) not null,
Constraint physical_item_fk1 foreign key (ISBN) references item(ISBN),
Constraint physical_item_fk2 foreign key (Room_ID, Shelf_ID) references shelf(Room_ID, SID)
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\physical_item.txt' INTO TABLE physical_item FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/Physical_Item.txt' into table G2T11.physical_item fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# borrow
create table borrow
(
ISBN varchar(25) not null,
Copy_ID int not null,
User_ID varchar(25) not null,
Borrowed_datetime datetime not null,
Returned_datetime datetime,
Constraint borrow_pk primary key (ISBN, Copy_ID, User_ID, Borrowed_datetime),
Constraint borrow_fk1 foreign key (ISBN, Copy_ID) references copy(ISBN, Copy_ID),
Constraint borrow_fk2 foreign key (User_ID) references user(User_ID)
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\borrow.txt' INTO TABLE borrow FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/borrow.txt' into table G2T11.borrow fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# comment
create table comment
(
User_ID varchar(25) not null,
Electronic_item varchar(25) not null,
Date_Time datetime not null,
Text varchar(100) not null,
Constraint comment_pk primary key (User_ID, Electronic_item, Date_Time),
Constraint comment_fk1 foreign key (User_ID) references user(User_ID),
Constraint comment_fk2 foreign key (Electronic_item) references electronic_item(ISBN)
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\comment.txt' INTO TABLE comment FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/comment.txt' into table G2T11.comment fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;

# comment rating
create table comment_rating
(
Rating_User_ID varchar(25) not null,
Comment_User_ID varchar(25) not null,
Electronic_item varchar(25) not null,
Date_Time datetime not null,
Stars int not null,
Constraint comment_rating_pk primary key (Rating_User_ID, Comment_User_ID, Electronic_item, Date_Time),
Constraint comment_rating_fk1 foreign key (Rating_User_ID) references user(User_ID),
Constraint comment_rating_fk2 foreign key (Comment_User_ID, Electronic_item, Date_Time) references comment(User_ID, Electronic_item, Date_Time)
);
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\chen yun\\Data\\comment_rating.txt' INTO TABLE comment_rating FIELDS TERMINATED BY '\t' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

load data infile '/Users/NPStudent/Desktop/G2T11/Data/comment_rating.txt' into table G2T11.comment_rating fields terminated by '\t'  
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;