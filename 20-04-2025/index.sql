-- CREATE TABLE Students (
--     studentid INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
--     sname VARCHAR(15) NOT NULL,
--     age SMALLINT NOT NULL CHECK (age > 12 AND age <= 90),
--     email VARCHAR(20) NULL CHECK (POSITION ('@' IN email) > 0),
--     phone CHAR(10) NULL CHECK (LENGTH(phone) = 10)
-- );

CREATE TYPE gender_enum AS ENUM('Male', 'Female', 'Others');

CREATE TABLE schools (
    school_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    school_name VARCHAR(50) NOT NULL,
    pincode CHAR(6) NOT NULL CHECK (
        pincode ~ '^[1-9][0-9]{5}$' AND
        pincode <> REPEAT(SUBSTRING(pincode FROM 1 FOR 1), 6)
    )
);

CREATE TABLE Students (
    school_id INTEGER REFERENCES schools(school_id) ON DELETE CASCADE,
    student_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    student_name VARCHAR(15) NOT NULL,
    age SMALLINT NOT NULL CHECK (age >= 6 AND age <= 16),
    gender gender_enum NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE CHECK (POSITION('@' IN email) > 0),
    phone CHAR(10) NULL CHECK (phone ~ '^[6-9][0-9]{9}$')
);
