create database ticket_booking_system;

create table venue(
     venue_id int primary key,
	 venue_names varchar(20) not null,
	 address varchar(20) not null
);

create table event(
     event_id int primary key,
	 event_name varchar(20) not null,
	 event_date date not null,
	 event_time time not null,
	 venue_id int,
	 total_seats int not null,
	 constraint chk_seat check(total_seats>0),
	 available_seats int,
	 constraint chk_avalSeat check(available_seats >0 and available_seats<=total_seats),
	 ticket_price decimal(8,4) not null,
	 event_type varchar(10),
	 booking_id int,
	 constraint chk_type check (event_type in ('Movie', 'Sport', 'Concert')),
	 constraint fk_event_venue foreign key (venue_id)
	 references venue(venue_id)
);

create table customer(
     customer_id int primary key,
	 customer_name varchar(20) not null,
	 email varchar(30),
	 phone_number varchar(12),
	 booking_id int
);

create table booking(
     booking_id int primary key,
	 customer_id int,
	 event_id int,
	 num_tickets int,
	 constraint chk_tkts check(num_tickets>0),
	 total_cost decimal(20,4),
	 booking_date date
	 constraint fk_booking_customer foreign key (customer_id)
	 references customer(customer_id),
	 constraint fk_booking_event foreign key (event_id)
	 references event(event_id)
);

alter table event 
add constraint fk_event_booking foreign key (booking_id)
references booking(booking_id);

alter table customer
add constraint fk_customer_booking foreign key (booking_id)
references booking(booking_id);

--updating the foreign keys, so as to manage on delete and on updating the contents of the table
--first we need to drop the existing foreign keys

alter table event drop constraint fk_event_venue;
alter table event drop constraint fk_event_booking;

alter table customer drop constraint fk_customer_booking;

alter table booking drop constraint fk_booking_customer;
alter table booking drop constraint fk_booking_event;

--now re declare the foreign keys
alter table event
add constraint fk_event_venue foreign key (venue_id)
references venue(venue_id)
on update cascade
on delete no action;

alter table event
add constraint fk_event_booking foreign key (booking_id)
references booking(booking_id)
on update no action
on delete no action;

alter table customer
add constraint fk_customer_booking foreign key (booking_id)
references booking(booking_id)
on update no action
on delete no action;

alter table booking
add constraint fk_booking_customer foreign key (customer_id)
references customer(customer_id)
on update no action
on delete cascade;

alter table booking
add constraint fk_booking_event foreign key (event_id)
references event(event_id)
on update no action
on delete cascade;


--inserting data

insert into venue (venue_id, venue_names, address) values 
(1, 'nehru stadium', '123 m.g. road'),
(2, 'pvr cinema', '456 connaught place'),
(3, 'sardar patel stadium', '789 marine drive'),
(4, 'kamani auditorium', '101 rajpath'),
(5, 'india habitat center', '202 lodi road'),
(6, 'eden gardens', '303 howrah bridge'),
(7, 'inox cinema', '404 juhu beach'),
(8, 'mahalaxmi racecourse', '505 queens road'),
(9, 'mohanlal stadium', '606 nehru place'),
(10, 'sirifort auditorium', '707 south extension');

select * from venue;

insert into customer (customer_id, customer_name, email, phone_number, booking_id) values
(1, 'rahul sharma', 'rahulsharma@example.com', '9876543210', null),
(2, 'priya singh', 'priyasingh@example.com', '8765432109', null),
(3, 'arjun patel', 'arjunpatel@example.com', '7654321098', null),
(4, 'swati verma', 'swativerma@example.com', '6543210987', null),
(5, 'ravi kumar', 'ravikumar@example.com', '5432109876', null),
(6, 'neha agrawal', 'nehaagrawal@example.com', '4321098765', null),
(7, 'ankit gupta', 'ankitgupta@example.com', '3210987654', null),
(8, 'pooja rao', 'poojarao@example.com', '2109876543', null),
(9, 'vivek yadav', 'vivekyadav@example.com', '1098765432', null),
(10, 'deepika naik', 'deepikanaik@example.com', '0987654321', null);

select * from customer;

insert into event (event_id, event_name, event_date, event_time, venue_id, total_seats, available_seats, ticket_price, event_type, booking_id) values
(1, 'bollywood night', '2024-09-30', '19:30:00', 1, 5000, 2500, 500.00, 'concert', null),
(2, 'cricket match', '2024-10-05', '15:00:00', 2, 80000, 75000, 1500.00, 'sport', null),
(3, 'movie premiere', '2024-10-10', '18:00:00', 3, 300, 250, 500.00, 'movie', null),
(4, 'kabaddi match', '2024-09-25', '17:00:00', 4, 15000, 12000, 750.00, 'sport', null),
(5, 'rock concert', '2024-11-01', '20:00:00', 5, 2000, 1500, 999.99, 'concert', null),
(6, 'movie screening', '2024-09-27', '21:00:00', 6, 200, 180, 500.00, 'movie', null),
(7, 'stand-up comedy show', '2024-09-26', '18:30:00', 7, 5000, 4700, 600.00, 'concert', null),
(8, 'tennis tournament', '2024-10-12', '13:00:00', 8, 10000, 9200, 2000.00, 'sport', null),
(9, 'theater play', '2024-10-02', '16:00:00', 9, 3000, 2500, 600.00, 'movie', null),
(10, 'sufi music night', '2024-10-15', '19:00:00', 10, 1000, 900, 800.00, 'concert', null);

select * from event;

insert into booking (booking_id, customer_id, event_id, num_tickets, total_cost, booking_date) values
(1, 1, 1, 2, 1000.00, '2024-09-25'),  
(2, 2, 2, 5, 7500.00, '2024-09-26'),  
(3, 3, 3, 1, 500.00, '2024-09-27'),   
(4, 4, 4, 3, 2250.00, '2024-09-28'),  
(5, 5, 5, 2, 1999.98, '2024-09-29'), 
(6, 6, 6, 4, 2000.00, '2024-09-29'),  
(7, 7, 7, 2, 1200.00, '2024-09-29'),  
(8, 8, 8, 1, 2000.00, '2024-09-30'), 
(10, 10, 10, 1, 800.00, '2024-10-01'); 

select * from booking;

update event set booking_id = 1 where event_id = 1;
update event set booking_id = 2 where event_id = 2;
update event set booking_id = 3 where event_id = 3;
update event set booking_id = 4 where event_id = 4;
update event set booking_id = 5 where event_id = 5;
update event set booking_id = 6 where event_id = 6;
update event set booking_id = 7 where event_id = 7;
update event set booking_id = 8 where event_id = 8;
update event set booking_id = 9 where event_id = 9;
update event set booking_id = 10 where event_id = 10;

update customer set booking_id = 1 where customer_id = 1;
update customer set booking_id = 2 where customer_id = 2;
update customer set booking_id = 3 where customer_id = 3;
update customer set booking_id = 4 where customer_id = 4;
update customer set booking_id = 5 where customer_id = 5;
update customer set booking_id = 6 where customer_id = 6;
update customer set booking_id = 7 where customer_id = 7;
update customer set booking_id = 8 where customer_id = 8;
update customer set booking_id = 9 where customer_id = 9;
update customer set booking_id = 10 where customer_id = 10;


select event_id, event_name, event_date from event;

-- Write a SQL query to select events with available tickets

select event_name, available_seats from event;

--Write a SQL query to select events name partial match with ‘match’.

select event_name from event where event_name like '%match%';

--Write a SQL query to select events with ticket price range is between 1000 to 2500.

select event_name, ticket_price from event where ticket_price between 1000 and 2500;

--Write a SQL query to retrieve events with dates falling within a specific range.

select event_name, event_date, event_type from event
where event_date between '2024-10-01' and '2024-12-01';

-- Write a SQL query to retrieve events with available tickets that also have "Concert" in their name.

select event_name, event_type, available_seats from event 
where available_seats >0 and event_name like '%Concert%';

--Write a SQL query to retrieve users in batches of 5, starting from the 6th user.

select customer_id, customer_name, email from customer
order by customer_id
offset 5 rows
fetch next 5 rows only;

--Write a SQL query to retrieve bookings details contains booked no of ticket more than 4.

select c.customer_name, e.event_name, e.event_date, b.num_tickets 
from customer c, event e, booking b
where b.num_tickets>4 and (c.booking_id = b.booking_id and e.booking_id = b.booking_id);

--Write a SQL query to retrieve customer information whose phone number end with ‘321’

select * from customer 
where phone_number like '%321'; 

--Write a SQL query to retrieve the events in order whose seat capacity more than 15000.

select * from event
where total_seats>15000;

--Write a SQL query to select events name not start with ‘x’, ‘y’, ‘z’

select * from event
where event_name not like 'x%'
      and event_name not like 'y%'
	  and event_name not like 'z%';


--Write a SQL query to List Events and Their Average Ticket Prices.

select event_name, avg(ticket_price) as avg_ticket_price 
from event 
group by event_name;

--Write a SQL query to Calculate the Total Revenue Generated by Events.

select sum(total_cost) as total_revenue
from booking;

--Write a SQL query to find the event with the highest ticket sales.

select top 1 e.event_name, sum(b.num_tickets) as tickets_sold from booking b
inner join event e on e.event_id = b.event_id
group by e.event_name
order by tickets_sold desc;

--Write a SQL query to Calculate the Total Number of Tickets Sold for Each Event.

select e.event_name, sum(b.num_tickets) as total_tickets
from event e 
join booking b 
on e.event_id = b.event_id 
group by e.event_name;


--Write a SQL query to Find Events with No Ticket Sales.

select e.event_name, e.event_type
from event e
inner join booking b on b.event_id = e.event_id
where b.num_tickets=0;

--Write a SQL query to Find the User Who Has Booked the Most Tickets.

select top 1 c.customer_name, c.phone_number, b.customer_id, b.num_tickets
from booking b
inner join customer c on b.customer_id = c.customer_id
order by num_tickets desc;

--Write a SQL query to List Events and the total number of tickets sold for each month.

select e.event_name, month(b.booking_date) as booking_month, sum(b.num_tickets) as tickets_booked
from event e
inner join booking b on  e.event_id = b.event_id
group by e.event_name, month(b.booking_date)
order by booking_month;

--Write a SQL query to calculate the average Ticket Price for Events in Each Venue.

select v.venue_names, avg(e.ticket_price) as avg_ticekt_price
from event e
inner join venue v on e.venue_id = v.venue_id
group by v.venue_names;

--Write a SQL query to calculate the total Number of Tickets Sold for Each Event Type.

select e.event_type, sum(b.num_tickets) as total_tickets
from event e
inner join booking b on e.event_id = b.event_id
group by e.event_type;

--Write a SQL query to calculate the total Revenue Generated by Events in Each Year.

select year(b.booking_date) as booking_year, sum(e.ticket_price * b.num_tickets)
from event e
inner join booking b on e.event_id = b.event_id
group by year(b.booking_date);

--. Write a SQL query to list users who have booked tickets for multiple events.

select c.customer_id, c.customer_name 
from customer c
join booking b 
on c.customer_id = b.customer_id
group by c.customer_id, c.customer_name
having count(b.booking_id) > 1;

--Write a SQL query to calculate the Total Revenue Generated by Events for Each User.

select c.customer_name, sum(b.total_cost) as total_revenue
from booking b
inner join customer c on c.customer_id = b.customer_id
group by c.customer_name;

--Write a SQL query to calculate the Average Ticket Price for Events in Each Category and Venue.

select e.event_type, v.venue_names, avg(e.ticket_price) as avg_ticket_price
from event e
inner join venue v on e.venue_id = v.venue_id
group by e.event_type, v.venue_names
order by avg_ticket_price;

--Write a SQL query to list Users and the Total Number of Tickets They've Purchased in the Last 30 Days.

select c.customer_name, sum(b.num_tickets) as total_ticket_purchase
from customer c
join booking b
on c.customer_id = b.customer_id
where b.booking_date between dateadd(day, -30, getdate()) AND getdate()
group by c.customer_name;



--Calculate the Average Ticket Price for Events in Each Venue Using a Subquery.

select v.venue_names, 
(select avg(e.ticket_price) 
 from event e 
 where e.venue_id = v.venue_id
) as avg_ticket_price
from venue v;

--Find Events with More Than 50% of Tickets Sold using subquery.

select e.event_type, e.event_name, e.total_seats, e.available_seats,
(select sum(b.num_tickets) 
 from booking b
 where e.event_id = b.event_id) as Ticket_sold
from event e
where (select sum(b.num_tickets) 
       from booking b
       where e.event_id = b.event_id) >(e.available_seats*0.5);

 --Calculate the Total Number of Tickets Sold for Each Event.

select event_name, sum(tickets) as total_tickets from( 
select e.event_name, e.event_id,
 (select sum(num_tickets) 
  from booking b 
  where b.event_id = e.event_id) as tickets
from event e) query_data
group by event_name;

--Find Users Who Have Not Booked Any Tickets Using a NOT EXISTS Subquery.

select customer_id, customer_name
from customer
where not exists 
      (select booking_id from booking 
	   where customer.customer_id = booking.customer_id);

--List Events with No Ticket Sales Using a NOT IN Subquery.

select event_name, event_type
from event
where event_id not in
      (select b.event_id
	   from booking b);

--Calculate the Total Number of Tickets Sold for Each Event Type Using a Subquery in the FROM Clause.

select event_type, sum(tickets) as total_tickets from
(select e.event_id, e.event_type,
(select sum(b.num_tickets) 
 from booking b
 where b.event_id = e.event_id) as tickets
 from event e) event_data
group by event_type;

--Find Events with Ticket Prices Higher Than the Average Ticket Price Using a Subquery in the WHERE Clause.

select event_name, event_type, ticket_price
from event
where ticket_price > (
      select avg(ticket_price)
	  from event);

--Calculate the Total Revenue Generated by Events for Each User Using a Correlated Subquery.

select customer_name, 
(select sum(total_cost)
 from booking b
 where b.customer_id = c.customer_id
) as revenue_generated
from customer c;

select * from venue;
--List Users Who Have Booked Tickets for Events in a Given Venue Using a Subquery in the WHERE Clause.

select c.customer_id, c.customer_name
from customer c
where c.customer_id in 
(select b.customer_id
 from booking b
 where b.event_id in
 (select e.event_id from event e where e.venue_id = 
 (select v.venue_id from venue v 
  where v.venue_names = 'inox cinema')));

--Calculate the Total Number of Tickets Sold for Each Event Category Using a Subquery with GROUP BY.

select event_type, sum(tickets) as total_tickets from
( select event_type, event_id, 
  ( select sum(num_tickets) from booking b
    where e.event_id = b.event_id) as tickets
  from event e) query_data
group by event_type;

--Find Users Who Have Booked Tickets for Events in each Month Using a Subquery with DATE_FORMAT.

select customer_name, email, phone_number,
       (select format(b.booking_date, 'MMMM yyyy')
        from booking b
        where b.customer_id = c.customer_id
        ) as booking_month
from customer c
where exists (
    select 1
    from booking b
    where b.customer_id = c.customer_id
)
order by booking_month;

--Calculate the Average Ticket Price for Events in Each Venue Using a Subquery

select v.venue_names,
       (select avg(ticket_price)
        from event e
        where e.venue_id = v.venue_id) as avg_ticket_price
from venue v;
