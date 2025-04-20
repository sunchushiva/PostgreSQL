-- ### **1. University Course Enrollment System**
-- **Entities:** departments, professors, courses, students, enrollments

-- **Requirements:**
-- - **departments:** `dept_id`, `dept_name` (unique, min 4 chars)
-- - **professors:** `prof_id`, `prof_name` (not null), `dept_id` (FK), `email` (must contain '@')
-- - **courses:** `course_id`, `course_name` (unique), `prof_id` (FK), `credits` (between 1–6)
-- - **students:** `student_id`, `student_name`, `dob` (must be < current date), `email` (unique), `phone` (starts with 6–9)
-- - **enrollments:** `student_id`, `course_id`, `enrollment_date` (default today), `grade` (nullable), composite PK on (`student_id`, `course_id`)

-- > 🎯 Bonus: Add a `CHECK` on `grade` to only allow values like 'A', 'B', 'C', 'D', 'F' or NULL

CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    dept_name VARCHAR(50) NOT NULL UNIQUE CHECK (LENGTH(dept_name) >= 3)
);

CREATE TABLE professors (
    prof_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    prof_name VARCHAR(30) NOT NULL CHECK (LENGTH(prof_name) >= 3),
    dept_id INTEGER NOT NULL REFERENCES departments(dept_id),
    email VARCHAR(50) NOT NULL UNIQUE CHECK (POSITION('@' IN email) > 0)
);

CREATE TABLE courses (
    course_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    course_name VARCHAR(70) NOT NULL UNIQUE,
    prof_id INTEGER NOT NULL REFERENCES professors(prof_id),
    credits SMALLINT NOT NULL CHECK (credits BETWEEN 1 AND 6)
);

CREATE TABLE students (
    student_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    student_name VARCHAR(30) NOT NULL CHECK (LENGTH(student_name) >= 3),
    date_of_birth DATE NOT NULL CHECK (date_of_birth::DATE < CURRENT_DATE),
    email VARCHAR(50) NOT NULL UNIQUE CHECK (POSITION('@' IN email) > 0),
    phone CHAR(10) NOT NULL UNIQUE CHECK (
        phone ~ '^[6-9][0-9]{9}$'
    )
);

CREATE TYPE grade_enum AS ENUM('A', 'B', 'C', 'D', 'F');

CREATE TABLE enrollments (
    student_id INTEGER NOT NULL REFERENCES students(student_id) ON DELETE CASCADE,
    course_id INTEGER NOT NULL REFERENCES courses(course_id) ON DELETE CASCADE,
    enrollment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    grade grade_enum DEFAULT NULL,
    PRIMARY KEY (student_id, course_id)
);