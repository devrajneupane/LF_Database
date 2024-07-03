-- Create assignement1 schema
CREATE SCHEMA IF NOT EXISTS online_bookstore AUTHORIZATION postgres;

-- Publisher table
CREATE TABLE IF NOT EXISTS online_bookstore.publishers (
  publisher_id SERIAL PRIMARY KEY,
  publisher_name VARCHAR(100),
  country VARCHAR(50)
);

-- Books table
CREATE TABLE IF NOT EXISTS online_bookstore.books (
  book_id SERIAL PRIMARY KEY,
  title VARCHAR(200),
  author VARCHAR(100),
  genre VARCHAR(50),
  publisher_id INT REFERENCES online_bookstore.publishers (publisher_id),
  publication_year DATE
);

-- Author table
CREATE TABLE online_bookstore.authors (
  author_id SERIAL PRIMARY KEY,
  author_name VARCHAR(100),
  birth_date DATE,
  nationality VARCHAR(100)
);

-- Customer table
CREATE TABLE online_bookstore.customers (
  customer_id SERIAL PRIMARY KEY,
  customer_name VARCHAR(60) NOT NULL,
  email VARCHAR(50) NOT NULL,
  address VARCHAR(100) NOT NULL
);

-- Order table
CREATE TABLE online_bookstore.orders (
  order_id SERIAL PRIMARY KEY,
  order_date DATE DEFAULT CURRENT_DATE,
  customer_id INT REFERENCES online_bookstore.customers (customer_id),
  total_amount NUMERIC(10, 2)
);

-- BookAuthor table
CREATE TABLE online_bookstore.book_authors (
  book_id INT,
  author_id INT,
  PRIMARY KEY (book_id, author_id),
  FOREIGN KEY (book_id) REFERENCES online_bookstore.books (book_id),
  FOREIGN KEY (author_id) REFERENCES online_bookstore.authors (author_id)
);

-- OrderItems table
CREATE TABLE online_bookstore.order_items (
  order_id INT,
  book_id INT,
  quantity INT,
  PRIMARY KEY (order_id, book_id),
  FOREIGN KEY (order_id) REFERENCES online_bookstore.orders (order_id),
  FOREIGN KEY (book_id) REFERENCES online_bookstore.books (book_id)
);
