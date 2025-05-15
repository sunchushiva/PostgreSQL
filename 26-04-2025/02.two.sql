CREATE TABLE libraries (
    library_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    library_name VARCHAR(100) NOT NULL UNIQUE CHECK (LENGTH (library_name) >= 5),
    library_city VARCHAR(100) NOT NULL CHECK (LENGTH (library_city) >= 3)
);

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    book_title VARCHAR(200) NOT NULL UNIQUE CHECK (LENGTH(book_title) >= 5),
    book_author VARCHAR(100) NOT NULL CHECK (LENGTH(book_author) >= 5),
    library_id INTEGER NOT NULL REFERENCES libraries(library_id) ON DELETE CASCADE,
    book_published_year SMALLINT NOT NULL CHECK (book_published_year BETWEEN 1800 AND EXTRACT(YEAR FROM CURRENT_DATE))
);

CREATE TABLE members (
    member_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    member_name VARCHAR(100) NOT NULL CHECK (LENGTH(member_name) >= 3),
    member_join_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE borrowings (
    borrowing_id INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    member_id INTEGER NOT NULL REFERENCES members(member_id),
    book_id INTEGER NOT NULL REFERENCES books(book_id),
    borrowed_date DATE NOT NULL DEFAULT CURRENT_DATE CHECK (borrowed_date <= CURRENT_DATE),
    return_date DATE CHECK (return_date > borrowed_date),
    UNIQUE (member_id, book_id, return_date)
);