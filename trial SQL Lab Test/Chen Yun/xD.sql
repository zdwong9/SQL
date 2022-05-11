# Q1
select isbn, title from item order by title;

# Q2
select isbn, user_id, borrowed_datetime from borrow where extract(month from borrowed_datetime) = 2;
select isbn, user_id, borrowed_datetime from borrow where month  (borrowed_datetime) = 2;

select * from borrow;

# Q3
select user_id, user_name from user where total_accrued_fine > 25.00;

# Q4
select user_id, text from comment where text like '%love%';

# Q5
select user_id, user_name from user u, membership m
where (m.member_type = 'Basic' or m.member_type = 'Premium')
and u.member_type = m.member_type
and user_name not like '%ma%';

# Q6

select isbn, count(*) as 'Number of comments' from comment c, electronic_item ei 
where ei.isbn = c.Electronic_item group by isbn;

# Q7

select u.user_id, user_name, text, date_time from user u
left outer join comment c
on u.user_id = c.user_id;

# Q8
select u.user_id, user_name, count(date_time) as CCount from user u
left outer join comment c
on u.user_id = c.user_id
group by u.user_id, user_name;

# Q9
select * from item_request;
select school as SchoolName, count(*) as RequestCount from item_request
group by school having RequestCount = (
	select max(RequestCount) as max_count from 
    (
		select school as SchoolName, count(*) as RequestCount from item_request 
        group by school
	) as tmp
);

# Q10

select c.isbn, c.copy_id, count(*) as copy_borrow from copy c
	inner join borrow b
	where c.isbn = b.isbn and c.copy_id = b.copy_id
	group by c.isbn, c.copy_id;

# Redo
select c.isbn, count(c.copy_id) as Copies, sum(copy_borrow) as BorrowCount from copy c
inner join physical_item pi
on c.isbn = pi.isbn
inner join (select c.isbn, c.copy_id, count(*) as copy_borrow from copy c
	inner join borrow b
	where c.isbn = b.isbn and c.copy_id = b.copy_id
	group by c.isbn, c.copy_id) as tmp
on c.isbn = tmp.isbn
group by c.isbn;

# Q11 
select u.user_id, c.electronic_item, avg(stars) from user u
inner join comment c
on u.is_admin = 'Y' and c.user_id = c.user_id
inner join comment_rating cr
on c.user_id = cr.comment_user_id and c.electronic_item = cr.electronic_item and c.date_time = cr.date_time
group by u.user_id, electronic_item having count(u.user_id) > 2;


# Q12
select r.room_id, count(s.sid) as ShelfCount, sum(Capacity) as TotalCapacity, sum(each_used) as UsedCapacity from room r
inner join shelf s
on r.room_id = s.room_id
inner join (select s.room_id, s.sid, count(distinct pi.isbn) as each_used from shelf s, physical_item pi
where s.sid = pi.shelf_id
group by s.room_id, s.sid) as tmp1
on r.room_id = tmp1.room_id
group by r.room_id;

select s.room_id, s.sid, count(distinct pi.isbn) as each_used from shelf s, physical_item pi
where s.sid = pi.shelf_id
group by s.room_id, s.sid;

	
 select * from copy;
# Q13
select tmp1.Month, tmp1.Year, CommentCount, ifnull(AcquiredCount, 0) as AcquiredCount from
	(
		select extract(month from date_time) as Month, extract(year from date_time) as Year, count(*) as CommentCount from comment
		group by Month, Year
    ) as tmp1
    left outer join
    (
		select extract(month from acquired_date) as Month, extract(year from acquired_date) as Year, count(*) as AcquiredCount from copy
		group by Month, Year
	) as tmp2
    on tmp1.Month = tmp2.Month and tmp1.Year = tmp2.Year;
    
# Q14
delimiter $$
create trigger afterBorrow_updateFine after update
	on Borrow for each row
		begin
			declare max_loan int;
            declare rate double;
            declare loan_day int;
            declare o_fine double;
            declare new_fine double;
            
            set loan_day = datediff(new.Borrowed_datetime, new.Returned_datetime);
            set max_loan = (select loan_period from user u, membership m 
				where u.user_id = new.user_id and u.member_type = m.member_type);
			if new.returned_datetime != null and loan_day > max_loan then
				set rate = (select penalty_rate from user u, membership m 
					where u.user_id = new.user_id and u.member_type = m.member_type);
                set o_fine = (select total_accrued_fine from user where user_id = new.user_id);
				set new_fine = o_fine + (loan_day - max_loan) * rate;
				update user set total_accrued_fine = new_fine where user_id = new.user_id;
            end if;
        end $$
delimiter ;

# Q15
delimiter $$
create procedure sp_checkLimit(in in_uid varchar(25), out CurrentBorrowed int, out ReachedLimit char(3))
	begin
		declare max_count int;
        
        set max_count = (select item_limit from user u, membership m 
			where user_id = in_uid and u.member_type = m.member_type);
            
		select count(*) into CurrentBorrowed from borrow where user_id = in_uid and Returned_datetime is null;
        if CurrentBorrowed >= max_count then
			set ReachedLimit = 'Yes';
		else
			set ReachedLimit = 'No';
        end if;
    end $$
delimiter ;

call sp_checkLimit('87501001', @count, @is_limit);
select @count, @is_limit;