/*
### 📦 Problem Statement #1: *E-Learning Platform*

An e-learning platform allows instructors to create and publish courses. Each course contains multiple lessons. Students can register on the platform, enroll in courses, and track their progress. 

- Instructors must have a valid email and a short bio.
- Courses should have a title, description, price (non-zero), and a publish status (`Draft`, `Published`, `Archived`).
- A course cannot be published unless it contains at least one lesson.
- Lessons should have a title and a minimum duration of 1 minute.
- Students can enroll in multiple courses, but **cannot enroll in the same course more than once**.
- Students should not be allowed to mark lessons as completed unless they’re enrolled in the course that lesson belongs to.
- Course price is stored at the time of enrollment (for history, even if course price changes).
- All users (students or instructors) must have unique emails and strong passwords (at least 8 characters).
- The platform records timestamps when students enroll and when they complete a lesson.

*/

CREATE TABLE instructors (
    instructor_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    instructor_name VARCHAR(30) NOT NULL CHECK (LENGTH(instructor_name) >= 3),
    instructor_email VARCHAR(30) NOT NULL UNIQUE CHECK (POSITION('@' IN instructor_email) > 0),
    instructor_bio TEXT NOT NULL,
    instructor_password VARCHAR(16) NOT NULL CHECK (
        instructor_password ~ '^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,16}$'  
    )
);

CREATE TYPE course_status_enum AS ENUM('Draft', 'Published', 'Archived');

CREATE TABLE courses (
    course_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    instructor_id INTEGER REFERENCES instructors(instructor_id) ON DELETE NULL,
    course_title VARCHAR(50) NOT NULL CHECK (LENGTH(course_title) >= 5),
    course_description TEXT NOT NULL CHECK (LENGTH(course_description) >= 10),
    course_price SMALLINT NOT NULL CHECK (course_price > 0),
    course_status course_status_enum NOT NULL
);

CREATE TABLE lessons (
    lesson_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lesson_title VARCHAR(50) NOT NULL CHECK (LENGTH(lesson_title) >= 5),
    course_id INTEGER NOT NULL REFERENCES courses(course_id) ON DELETE CASCADE,
    lesson_duration SMALLINT NOT NULL CHECK (lesson_duration >= 1)
); 

CREATE TABLE students (
    student_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    student_name VARCHAR(30) NOT NULL CHECK (LENGTH(student_name) >= 3),
    student_email VARCHAR(30) NOT NULL UNIQUE CHECK (POSITION('@' IN student_email) > 0),
    student_password VARCHAR(16) NOT NULL CHECK (
        student_password ~ '^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{8,16}$'  
    )
);

CREATE TABLE enrollments (
    enrollment_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    student_id INTEGER NOT NULL REFERENCES students(student_id),
    course_id INTEGER NOT NULL REFERENCES courses(course_id),
    course_price SMALLINT NOT NULL CHECK (course_price > 0),
    enrolled_date DATE NOT NULL DEFAULT CURRENT_DATE,
    UNIQUE (student_id, course_id)
);

CREATE TABLE lesson_completions (
    student_id INTEGER NOT NULL REFERENCES students(student_id),
    lesson_id INTEGER NOT NULL REFERENCES lessons(lesson_id) ON DELETE CASCADE,
    completed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (student_id, lesson_id)
)
