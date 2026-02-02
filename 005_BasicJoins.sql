-- ===================================================
-- SQL Joins Demo: Customers and Orders Tables
-- ===================================================

USE MyDatabase;

-- ===================================================
-- Table Data
-- ===================================================

-- Customers Table
-- id | first_name | country | score
-- 1  | Maria      | Germany | 350
-- 2  | John       | USA     | 900
-- 3  | Georg      | UK      | 750
-- 4  | Martin     | Germany | 500
-- 5  | Peter      | USA     | 0
-- 6  | Anna       | USA     | 0

-- Orders Table
-- order_id | customer_id | order_date  | sales
-- 1001     | 1           | 2021-01-11  | 35
-- 1002     | 2           | 2021-04-05  | 15
-- 1003     | 3           | 2021-06-18  | 20
-- 1004     | 6           | 2021-08-31  | 10

-- ===================================================
-- 1. NO JOIN: Display tables separately
-- ===================================================

-- Show all customers
SELECT * FROM customers;

-- Show all orders
SELECT * FROM orders;

-- ===================================================
-- 2. INNER JOIN
-- ===================================================

-- INNER JOIN: Returns only rows with matching keys in both tables
-- Question: List customers who have placed orders, along with order details
SELECT id, first_name, sales, score
FROM customers
INNER JOIN orders
ON id = customer_id;

-- Output:
-- id | first_name | sales | score
-- 1  | Maria      | 35    | 350
-- 2  | John       | 15    | 900
-- 3  | Georg      | 20    | 750
-- 6  | Anna       | 10    | 0

-- Inner join with aliases and renamed columns
SELECT 
    customers.id AS CID,
    first_name,
    orders.order_id AS OID,
    sales,
    score
FROM customers
INNER JOIN orders
ON customer_id = id;

-- Output:
-- CID | first_name | OID  | sales | score
-- 1   | Maria      | 1001 | 35    | 350
-- 2   | John       | 1002 | 15    | 900
-- 3   | Georg      | 1003 | 20    | 750
-- 6   | Anna       | 1004 | 10    | 0

-- ===================================================
-- 3. LEFT JOIN
-- ===================================================

-- LEFT JOIN: Returns all rows from left table (customers),
-- including matching rows from right table (orders). If no match, right table columns are NULL.
SELECT 
    c.id AS CID,
    first_name,
    o.order_id AS OID,
    sales,
    score
FROM customers AS c
LEFT JOIN orders AS o
ON customer_id = id;

-- Output:
-- CID | first_name | OID   | sales | score
-- 1   | Maria      | 1001  | 35    | 350
-- 2   | John       | 1002  | 15    | 900
-- 3   | Georg      | 1003  | 20    | 750
-- 4   | Martin     | NULL  | NULL  | 500
-- 5   | Peter      | NULL  | NULL  | 0
-- 6   | Anna       | 1004  | 10    | 0

-- ===================================================
-- 4. RIGHT JOIN
-- ===================================================

-- RIGHT JOIN: Returns all rows from right table (orders),
-- including matching rows from left table (customers). If no match, left table columns are NULL.
SELECT 
    c.id AS CID,
    first_name,
    o.order_id AS OID,
    sales,
    score
FROM customers AS c
RIGHT JOIN orders AS o
ON customer_id = id;

-- Output:
-- CID | first_name | OID   | sales | score
-- 1   | Maria      | 1001  | 35    | 350
-- 2   | John       | 1002  | 15    | 900
-- 3   | Georg      | 1003  | 20    | 750
-- 6   | Anna       | 1004  | 10    | 0

-- ===================================================
-- 5. FULL OUTER JOIN
-- ===================================================

-- FULL JOIN: Returns all rows from both tables. 
-- Where there is no match, columns from the table with no match are NULL.
SELECT 
    c.id AS CID,
    first_name,
    o.order_id AS OID,
    sales,
    score
FROM customers AS c
FULL JOIN orders AS o
ON customer_id = id;

-- Output:
-- CID | first_name | OID   | sales | score
-- 1   | Maria      | 1001  | 35    | 350
-- 2   | John       | 1002  | 15    | 900
-- 3   | Georg      | 1003  | 20    | 750
-- 4   | Martin     | NULL  | NULL  | 500
-- 5   | Peter      | NULL  | NULL  | 0
-- 6   | Anna       | 1004  | 10    | 0
