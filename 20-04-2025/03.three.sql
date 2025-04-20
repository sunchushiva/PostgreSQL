-- 1. Table: departments
-- Create a table for company departments with:

-- dept_id: auto-generated PK

-- dept_name: unique, not null, min 3 characters

-- created_at: defaults to current timestamp


CREATE TABLE departments (
    department_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    department_name VARCHAR(30) UNIQUE NOT NULL CHECK (LENGTH(department_name) >= 3),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 2. Table: cities
-- Store valid city records with:

-- city_id: PK

-- city_name: not null

-- pincode: must be 6 digits and not start with 0 and not be like 111111, 222222, etc.

CREATE TABLE cities (
    city_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    city_name VARCHAR(50) NOT NULL UNIQUE,
    pincode CHAR(6) UNIQUE NOT NULL CHECK (
        pincode ~ '^[1-9][0-9]{5}$' AND
        pincode <> REPEAT(SUBSTRING(pincode FROM 1 FOR 1), 6)
    )
);

-- 3. Table: users
-- Create a users table with:

-- user_id: PK

-- username: not null, unique

-- email: must contain @, unique

-- phone: must be 10 digits, start with 6-9


CREATE TABLE users (
    user_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    username VARCHAR(25) NOT NULL UNIQUE,
    email VARCHAR(50) NOT NULL UNIQUE CHECK (
        email ~ '^[^@]+@[^@]+\.[^@]+$'
    ),
    phone CHAR(10) NOT NULL UNIQUE CHECK (
        phone ~ '^[6-9][0-9]{9}$'
    )
);


-- 4. Table: employees_basic
-- Make a simplified employee table with:

-- emp_id: PK

-- name: not null, length > 3

-- age: between 18 and 65

-- gender: ENUM ('Male', 'Female', 'Others')

CREATE TYPE gender_enum AS ENUM('Male', 'Female', 'Others');

CREATE TABLE employees_basic (
    emp_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    emp_name VARCHAR(30) NOT NULL CHECK (LENGTH(emp_name) > 3),
    age SMALLINT NOT NULL CHECK (age BETWEEN 18 AND 65),
    gender gender_enum NOT NULL
);