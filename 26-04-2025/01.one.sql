CREATE TABLE hospitals (
    hospital_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    hospital_name VARCHAR(200) UNIQUE NOT NULL CHECK (LENGTH(hospital_name) >= 5),
    hospital_city VARCHAR(100) NOT NULL CHECK (LENGTH(hospital_city) >= 3)
);

CREATE TYPE doctor_specialization_enum AS ENUM ('Orthopedics', 'Internal Medicine', 'Gynecology', 'Dermatology');

CREATE TABLE doctors (
    doctor_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    doctor_name VARCHAR(30) NOT NULL CHECK (LENGTH(doctor_name) >= 3),
    doctor_specialization doctor_specialization_enum NOT NULL,
    hospital_id INTEGER NOT NULL REFERENCES hospitals(hospital_id)
);

CREATE TYPE gender_enum AS ENUM ('Male', 'Female', 'Other');

CREATE TABLE patients (
    patient_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    patient_name VARCHAR(100) NOT NULL CHECK (LENGTH(patient_name) >= 3),
    patient_date_of_birth DATE NOT NULL CHECK (patient_date_of_birth < CURRENT_DATE),
    patient_gender gender_enum NOT NULL
);

CREATE TYPE appointment_status_enum AS ENUM ('Scheduled', 'Completed', 'Cancelled');

CREATE TABLE appointments (
    appointment_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    patient_id INTEGER NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
    doctor_id INTEGER NOT NULL REFERENCES doctors(doctor_id) ON DELETE CASCADE,
    appointment_date DATE NOT NULL DEFAULT CURRENT_DATE CHECK (appointment_date >= CURRENT_DATE),
    appointment_status appointment_status_enum NOT NULL,
    UNIQUE (patient_id, appointment_date, doctor_id)
);