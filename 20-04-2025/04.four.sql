-- 1. Table: companies & jobs
-- Create a job portal structure:

-- companies: company_id, company_name (unique), website (must contain .com)

-- jobs: job_id, job_title (not null), salary (between 30k–200k), company_id (FK, cascade on delete)


CREATE TABLE companies (
    company_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    company_name VARCHAR(70) NOT NULL UNIQUE,
    website VARCHAR(40) NOT NULL UNIQUE CHECK (
        POSITION('.com' IN website) > 1
    )
);

CREATE TABLE jobs (
    job_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    job_title VARCHAR(100) NOT NULL,
    salary INTEGER NOT NULL CHECK (salary BETWEEN 30000 AND 200000),
    company_id INTEGER REFERENCES companies(company_id) ON DELETE CASCADE
);

-- 2. Table: students & results
-- Build a student test result system:

-- students: student_id, name, roll_number (unique), dob (before current date)

-- results: composite key of student_id + subject, marks (0-100), pass if marks ≥ 35

CREATE TYPE result_enum AS ENUM('Pass', 'Fail');

CREATE TABLE students (
    student_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    student_name VARCHAR(50) NOT NULL CHECK (LENGTH(student_name) > 3),
    roll_number INTEGER NOT NULL UNIQUE CHECK (roll_number > 0),
    date_of_birth DATE NOT NULL CHECK (date_of_birth < CURRENT_DATE)
);

CREATE TABLE subjects (
    subject_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    subject_name VARCHAR(40) NOT NULL UNIQUE
);

CREATE TABLE results (
    result_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    student_id INTEGER REFERENCES students(student_id) ON DELETE CASCADE,
    subject_id INTEGER REFERENCES subject(subject_id) ON DELETE CASCADE,
    marks SMALLINT NOT NULL CHECK (marks BETWEEN 0 AND 100),
    result result_enum NOT NULL GENERATED ALWAYS AS (
    CASE WHEN marks >= 35 THEN 'Pass' ELSE 'Fail' END
  ) STORED
);


-- 3. Table: orders & order_items
-- Create an order and items structure:

-- orders: order_id, order_date, customer_name

-- order_items: composite PK (order_id, product_id), quantity (1-100), price_per_unit (> 0)

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    customer_name VARCHAR(30) NOT NULL CHECK (LENGTH(customer_name) >= 3),
    age SMALLINT NOT NULL CHECK (age BETWEEN 18 AND 125),
    city VARCHAR(50) NOT NULL CHECK (LENGTH(city) >= 3)
);

CREATE TABLE products (
    product_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    product_name VARCHAR(30) NOT NULL CHECK (LENGTH(product_name) >= 3),
    price INTEGER NOT NULL,
    quantity SMALLINT NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    order_date DATE DEFAULT CURRENT_DATE,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    order_id INTEGER NOT NULL REFERENCES orders(order_id),
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity SMALLINT NOT NULL CHECK (quantity BETWEEN 1 AND 100),
    price_per_unit INTEGER NOT NULL CHECK (price_per_unit > 0)
);


-- 4. Table: train_routes & stations
-- Design railway routes:

-- routes: route_id, route_name (not null, unique)

-- stations: station_id, station_name, route_id (FK), station_order (must be > 0 and unique per route)


CREATE TABLE routes (
    route_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    route_name VARCHAR(200) NOT NULL UNIQUE CHECK (LENGTH(route_name) >= 3)
);

CREATE TABLE stations (
    station_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    station_name VARCHAR(200) NOT NULL UNIQUE CHECK (LENGTH(station_name) >= 3),
    route_id INTEGER NOT NULL REFERENCES routes(route_id),
    station_order SMALLINT NOT NULL CHECK (station_order > 0),
    UNIQUE (route_id, station_order)
);