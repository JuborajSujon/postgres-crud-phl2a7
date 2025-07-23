-- Active: 1745817905197@@127.0.0.1@5432@bookstore_db
-- create database 
CREATE DATABASE bookstore_db;

-- create book table 
CREATE TABLE books (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    price NUMERIC(10, 2) CHECK (price >= 0),
    stock INTEGER DEFAULT 0,
    published_year INTEGER
);

-- create customer table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    joined_date DATE DEFAULT CURRENT_DATE
);

-- create order table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
    book_id INTEGER NOT NULL REFERENCES books(id) ON DELETE CASCADE,
    quantity INTEGER CHECK (quantity > 0),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- data insert into books
INSERT INTO books (id, title, author, price, stock, published_year) VALUES
(1, 'The Pragmatic Programmer', 'Andrew Hunt', 40.00, 10, 1999),
(2, 'Clean Code', 'Robert C. Martin', 35.00, 5, 2008),
(3, 'You Don''t Know JS', 'Kyle Simpson', 30.00, 8, 2014),
(4, 'Refactoring', 'Martin Fowler', 50.00, 3, 1999),
(5, 'Database Design Principles', 'Jane Smith', 20.00, 0, 2018);

-- data insert into customers
INSERT INTO customers (id, name, email, joined_date) VALUES
(1, 'Alice', 'alice@email.com', '2023-01-10'),
(2, 'Bob', 'bob@email.com', '2022-05-15'),
(3, 'Charlie', 'charlie@email.com', '2023-06-20');


-- data insert into orders
INSERT INTO orders (id, customer_id, book_id, quantity, order_date) VALUES
(1, 1, 2, 1, '2024-03-10'),
(2, 2, 1, 1, '2024-02-20'),
(3, 1, 3, 2, '2024-03-05');

-- select all books 
SELECT * FROM books;

-- select all customers
SELECT * FROM customers;

-- select all orders
SELECT * FROM orders;

-- Find books that are out of stock.
SELECT title FROM books WHERE stock = 0;

-- Retrive the most expensive book.
SELECT * FROM books ORDER BY price DESC LIMIT 1;

-- Find the total number of orders placed by each customer.
SELECT c.name, COUNT(o.id) AS total_orders
FROM customers c
JOIN orders o ON c.id = o.customer_id    
GROUP BY c.name;

-- Calculate the total revenue generated from book sales
SELECT SUM(b.price * o.quantity) AS total_revenue
FROM books b
JOIN orders o ON b.id = o.book_id;

-- List all customers who havve placed more than one order
SELECT c.name, COUNT(o.id) AS order_count
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.name
HAVING COUNT(o.id) > 1;

-- Find the average price of books in the store
SELECT AVG(price) AS avg_book_price FROM books;


-- increase the price of all books published before 2000 by 10%

UPDATE books
SET price = price * 1.10
WHERE published_year < 2000;

SELECT * FROM books ORDER BY id;

-- Delete customers  who haven't placed any orders 
DELETE FROM customers
WHERE id NOT IN (SELECT DISTINCT customer_id FROM orders);

SELECT * FROM customers;