create schema airbnb;
set schema 'airbnb';

create table host(
	host_id int primary key
);

create table region(
	id smallserial primary key,
	city varchar(20),
	country varchar(20)
);

create table location(
	id smallserial primary key,
	region_id smallint,
	neighbourhood varchar(30),
	constraint fk_region_location foreign key (region_id) references region(id)
);

create table room(
	room_id int primary key,
	name varchar(150),
	room_type varchar(30),
	room_price int,
	minimum_nights int,
	availability int,
	location_id smallint,
	longitud varchar(50),
	latitud varchar(50),
	host_id int,
	constraint fk_location_room foreign key (location_id) references location(id),
	constraint fk_host_room foreign key (host_id) references host(host_id)
);

create table review(
	room_id int primary key,
	n_reviews int,
	n_reviews_month float,
	last_review date,
	constraint fk_room_review foreign key (room_id) references room(room_id)
);

insert into host(host_id)
select distinct ta."Host ID" 
from air_bnb_listings ta;

insert into region(city, country)
select distinct ta."City", ta."Country" 
from air_bnb_listings ta;

insert into location(region_id, neighbourhood)
select distinct r.id , ta."Neighbourhood" 
from air_bnb_listings ta
left join region r on ta."City" = r.city and ta."Country" = r.country ;

insert into room(room_id, name, room_type, room_price, minimum_nights, availability, location_id, latitud, longitud, host_id)
select ta."Room ID" , ta."Name" , ta."Room type" , ta."Room Price" , ta."Minimum nights" , ta."Availibility", l.id, 
split_part(ta."Coordinates" , ', ', 1), 
split_part(ta."Coordinates" , ', ', 2), ta."Host ID" 
from air_bnb_listings ta
left join "location" l on ta."Neighbourhood" = l.neighbourhood ;

insert into review(room_id, n_reviews, n_reviews_month, last_review)
select ta."Room ID" , ta."Number of reviews" , ta."Number of reviews per month" , ta."Date last review" 
from air_bnb_listings ta;




