CREATE database CASE4DB;

CREATE TABLE LOCALITIES
(ID int,
AREA VARCHAR(100),
CITY_ID INT,
ZONE_ID INT
);

CREATE TABLE INFO
(pickup_date varchar(100),	
pickup_time varchar(100),
pickup_datetime	varchar(100),
Pickup_Area	varchar(100),
Drop_Area varchar(100),
Booking_id varchar(100),
Booking_type varchar(100),
Booking_mode varchar(100),
Driver_number INT,
Service_status varchar(100),	
I_Status INT,
Fare INT,
Distance INT,	
Confirmed_at varchar(100)
);

update INFO
SET Pickup_area = null
where pickup_area = "";

update info
SET Drop_area = null
where drop_area = "";

update info
set confirmed_at = null
where confirmed_at like "%null%";

alter table info
add column newpickupdate date;

alter table info
add column newpickuptime time, add column newpickupdatetime datetime, add column newconfirmedat datetime;

update info
set newpickupdate = str_to_date(pickup_date, '%d-%m-%Y');

update info
set newpickuptime = str_to_date(pickup_time, '%H:%i:%s');

update info
set newpickupdatetime = str_to_date(pickup_datetime, '%d-%m-%Y %H:%i'); 

update info
set newconfirmedat = str_to_date(confirmed_at, '%d-%m-%Y %H:%i');

/*Make a table with count of bookings with booking_type = p2p catgorized by booking mode as 'phone', 'online','app',etc*/
select count(*) as countofbookings, Booking_type, Booking_mode
from info
where booking_type = "p2p"
group by Booking_mode;



/*Find top 5 drop zones in terms of average revenue*/
select Drop_Area, avg(fare) as avgrevenue
from info
group by Drop_Area
order by avg(fare) desc
limit 5;

/*Find all unique driver numbers grouped by top 5 pickzones*/
select distinct ZONE_ID, Driver_number
from info as i inner join localities as l on i.pickup_area = l.area
where ZONE_ID IN (select ZONE_ID from (select ZONE_ID, row_number() over (order by avg(fare) desc) as rn
from info as i inner join localities as l on i.pickup_area = l.area
group by ZONE_ID) as temp
where temp.rn < 6)
order by ZONE_ID desc;

/*top 5 pickzones*/
select ZONE_ID
from info as i inner join localities as l on i.pickup_area = l.area
group by ZONE_ID
order by avg(fare) desc;

select * from (select ZONE_ID, row_number() over (order by avg(fare) desc) as rn
from info as i inner join localities as l on i.pickup_area = l.area
group by ZONE_ID) as temp
where temp.rn < 6;



/*Make a hourwise table of bookings for week between Nov01-Nov-07 and highlight the hours with more than average no.of bookings day wise*/
select date(newconfirmedat), count(*) as numberofbookings, hour(newconfirmedat) 
from info
where date(newconfirmedat) between '2013-11-01' and '2013-11-07'
group by hour(newconfirmedat)
having count(*) > (select avg(bookings)
from
(select date(newconfirmedat), count(*) as bookings
from info 
where date(newconfirmedat) between '2013-11-01' and '2013-11-07'
group by day(newconfirmedat)) as temptable);

/*AVG number of bookings day wise*/
select avg(bookings)
from
(select date(newconfirmedat), count(*) as bookings
from info 
where date(newconfirmedat) between '2013-11-01' and '2013-11-07'
group by day(newconfirmedat)) as temptable;

/*hourwise countofbookings*/
select date(newconfirmedat), count(*) as numberofbookings, hour(newconfirmedat) 
from info
where date(newconfirmedat) between '2013-11-01' and '2013-11-07'
group by hour(newconfirmedat);

select avg(bookings)
from
(select date(newconfirmedat), count(*) as bookings
from info 
where date(newconfirmedat) between '2013-11-01' and '2013-11-07'
group by day(newconfirmedat)) as temptable;