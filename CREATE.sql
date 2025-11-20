CREATE TABLE IF NOT EXISTS Room_Class
(
	room_class_id serial PRIMARY KEY, 
	class_name VARCHAR(15), 
	cost_per_night integer
);


CREATE TABLE IF NOT EXISTS Staff
( 
	staff_id serial PRIMARY KEY, 
	job VARCHAR(15),
	name VARCHAR(15),
	surname VARCHAR(20),
	gender VARCHAR(10) check(gender = 'мужчина' or gender = 'женщина')
);


CREATE TABLE IF NOT EXISTS Services
(
	service_id serial PRIMARY KEY,
	service_name VARCHAR(40) unique, 
	service_cost integer
); 


CREATE TABLE IF NOT EXISTS Guests
( 
	guest_id serial PRIMARY KEY, 
	guest_name VARCHAR(15),
	guest_surname VARCHAR(20),
	phone_number VARCHAR(15), 
	email VARCHAR(40), 
	birth_date DATE,
        gender VARCHAR(15) check(gender = 'мужчина' or gender = 'женщина')

); 


CREATE TABLE IF NOT EXISTS Discounts
( 
	discount_id serial PRIMARY KEY, 
	count_days integer, 
	discount integer
); 


CREATE TABLE IF NOT EXISTS Staff_Services
(
	staff_services_id serial PRIMARY KEY,
        staff_id integer REFERENCES Staff (staff_id) ON DELETE CASCADE, 
	service_id integer REFERENCES Services (service_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Rooms
(
	room_id serial PRIMARY KEY, 
	room_class_id integer REFERENCES Room_Class (room_class_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Service_Bookings
(
	service_booking_id serial PRIMARY KEY, 
	date DATE, 
	place VARCHAR(30), 
	service_status VARCHAR(30),
	guest_id integer REFERENCES Guests (guest_id) ON DELETE CASCADE, 
	service_id integer REFERENCES Services (service_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Room_Bookings
( 
	room_booking_id serial PRIMARY KEY, 
	check_in_date DATE, 
	check_out_date DATE, 
	room_status VARCHAR(30),
	guest_id integer REFERENCES Guests (guest_id) ON DELETE CASCADE,
	room_id integer REFERENCES Rooms (room_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS Review
(
	review_id serial PRIMARY KEY, 
	grade integer check(grade >= 0 and grade <= 5), 
	review_date DATE,
	guest_id integer REFERENCES Guests (guest_id) ON DELETE CASCADE, 
	room_id integer REFERENCES Rooms (room_id) ON DELETE CASCADE
);
