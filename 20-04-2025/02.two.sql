-- Create a courses table and a students table.

-- Each student belongs to a course.

-- Delete all students when a course is deleted.

CREATE TABLE courses (
    course_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    course_name VARCHAR(50) NOT NULL UNIQUE
)

CREATE TABLE students (
    student_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    student_name VARCHAR(20) NOT NULL,
    course_id INTEGER REFERENCES courses(course_id) ON DELETE CASCADE
)


-- Create a table vehicles with:

-- type as ENUM ('Car', 'Bike', 'Truck')

-- registration number (unique, cannot be null)

-- owner_name

CREATE TYPE vehicle_type_enum AS ENUM('Car', 'Bike', 'Truck');

CREATE TABLE vehicles (
    vehicle_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    registeration_number VARCHAR(10) NOT NULL UNIQUE CHECK (
        LENGTH(registeration_number) BETWEEN 6 AND 10
    ),
    registered_date DATE DEFAULT CURRENT_DATE,
    vehicle_type vehicle_type_enum NOT NULL,
    owner_name VARCHAR(20) NOT NULL
);

-- Create a posts and comments structure where:

-- Each comment belongs to a post

-- Post title must be unique

-- Comments must have a non-null content


CREATE TABLE posts (
    post_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    post_title TEXT UNIQUE NOT NULL,
    post_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comments (
    comment_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    comment_title TEXT NOT NULL,
    comment_content TEXT NOT NULL CHECK (LENGTH(comment_content) >= 1),
    comment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    post_id INTEGER NOT NULL REFERENCES posts(post_id) ON DELETE CASCADE
);


-- Create a table flight_bookings:

-- Composite primary key of (flight_id, passenger_id)

-- seat_number (must be unique within a flight)

CREATE TABLE flights (
    flight_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    flight_name TEXT NOT NULL CHECK (LENGTH(flight_name) >= 5),
    flight_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE passengers (
    passenger_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    passenger_name TEXT NOT NULL CHECK (LENGTH(passenger_name) >= 5)
);

CREATE TABLE flight_bookings (
    flight_bookings_id INTEGER UNIQUE GENERATED ALWAYS AS IDENTITY,
    seat_number INTEGER NOT NULL UNIQUE
    flight_id INTEGER REFERENCES flights(flight_id) ON DELETE CASCADE,
    passenger_id INTEGER REFERENCES passengers(passenger_id) ON DELETE CASCADE,
    PRIMARY KEY (flight_id, passenger_id), 
    UNIQUE (flight_id, passenger_id)
);