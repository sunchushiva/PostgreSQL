-- Create a table employees with:

-- id (auto-incremented primary key)

-- name (not null)

-- department (nullable)

-- joining_date (default to current date)


CREATE TABLE employees (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    employee_name TEXT NOT NULL,
    department TEXT DEFAULT NULL,
    joining_date DATE DEFAULT CURRENT_DATE
);

-- Create a table products with:

-- id

-- name

-- price (should be > 0)

-- quantity (default 0)

CREATE TABLE products (
    id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    price INTEGER CHECK (price > 0),
    quantity INTEGER DEFAULT 0
);


-- Create a table customers with:

-- customer_id

-- email (unique and must contain @)

-- phone (should be exactly 10 digits)

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    email VARCHAR(50) NOT NULL UNIQUE CHECK (POSITION('@' IN email) > 0),
    phone CHAR(10) NOT NULL UNIQUE CHECK (LENGTH(phone) = 10)
)

-- Create a table books with:

-- title

-- author

-- published_year (must be between 1800 and current year)

CREATE TABLE books (
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    published_year INTEGER NOT NULL CHECK (
        published_year BETWEEN (1800 AND EXTRACT(YEAR FROM CURRENT_DATE))
    )
)