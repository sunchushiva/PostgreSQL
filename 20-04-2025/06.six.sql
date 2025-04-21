-- 2. Hotel Booking System
-- Entities: hotels, rooms, customers, bookings

-- Requirements:

-- hotels: hotel_id, hotel_name (unique), location (not null), rating (1 to 5)

-- rooms: room_id, hotel_id (FK), room_type (ENUM: 'Standard', 'Deluxe', 'Suite'), price_per_night (> 0)

-- customers: customer_id, full_name, email (must have @), phone (10 digits)

-- bookings: booking_id, customer_id (FK), room_id (FK), checkin_date, checkout_date

-- 🧠 Constraints:

-- checkin_date < checkout_date

-- No room can be double-booked between dates (challenge: can be handled in advanced constraints/triggers later)

CREATE TABLE hotels (
    hotel_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    hotel_name VARCHAR(100) NOT NULL UNIQUE CHECK (LENGTH(hotel_name) >= 5),
    hotel_location VARCHAR(100) NOT NULL CHECK (LENGTH(hotel_location) >= 5),
    rating SMALLINT DEFAULT 1 CHECK (rating BETWEEN 1 AND 5)
);

CREATE TYPE room_type_enum as ENUM('Standard', 'Deluxe', 'Suite');

CREATE TABLE rooms (
    room_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    hotel_id INTEGER NOT NULL REFERENCES hotels(hotel_id),
    room_type room_type_enum NOT NULL,
    price_per_night NUMERIC(10, 2) NOT NULL CHECK (price_per_night > 0)
);

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    full_name VARCHAR(100) NOT NULL CHECK (LENGTH(full_name) >= 3),
    email VARCHAR(35) NOT NULL UNIQUE CHECK (POSITION('@' IN email) > 0),
    phone CHAR(10) NOT NULL UNIQUE CHECK (
        phone ~ '^[6-9][0-9]{9}$'
    )
);

CREATE TABLE bookings (
    booking_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    room_id INTEGER NOT NULL REFERENCES rooms(room_id),
    checkin_date DATE NOT NULL,
    checkout_date DATE NOT NULL CHECK (
        checkout_date::DATE > checkin_date::DATE
    )
)